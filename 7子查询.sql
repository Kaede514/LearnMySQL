USE atguigudb;

#谁的工资比Able高？
#方式1：
SELECT last_name, salary
FROM employees
WHERE last_name = 'Abel';

SELECT last_name, salary
FROM employees
WHERE salary > 11000;

#方式2：自连接
SELECT e2.last_name, e2.salary
FROM employees e1, employees e2
WHERE e2.salary > e1.salary
	AND e1.last_name = 'Abel';

#方式3：子查询
SELECT last_name, salary
FROM employees
WHERE salary > (
				SELECT salary
				FROM employees
				WHERE last_name = 'Abel'
);

#称谓的规范：外查询（或主查询）、内查询（或子查询）

/*
-子查询在主查询之前一次执行完成
-子查询的结果被主查询使用
-注意事项
	-子查询要包含在括号内
	-将子查询放在比较条件的右侧（可读性比较好）
	-单行操作符对应单行子查询，多行操作符对象多行子查询
*/

#子查询的分类
#角度1：从内查询返回的结果的条目数
#				单行子查询 vs 多行子查询
#角度2：内查询是否被执行多次
#				相关子查询 vs 不相关子查询

#单行子查询
#子查询编写步骤：1、从里往外写
#								 2、从外往里写

#查询工资大于149号员工工资的员工的信息
SELECT employee_id, last_name, salary
FROM employees
WHERE salary> (
				SELECT salary
				FROM employees
				WHERE employee_id = 149
);

#返回job_id与141号员工相同，salary比143号员工多的员工姓名，job_id和工资
#先
SELECT job_id
FROM employees
WHERE employee_id = 141
#在
SELECT salary
FROM employees
WHERE employee_id = 143
#最后
SELECT last_name, job_id, salary
FROM employees
WHERE job_id = (
				SELECT job_id
				FROM employees
				WHERE employee_id = 141
)
	AND salary > (
					SELECT salary
					FROM employees
					WHERE employee_id = 143
);

#返回公司工资最少的员工的last_name,job_id和salary
SELECT last_name, job_id, salary
FROM employees
WHERE salary = (
				SELECT MIN(salary)
				FROM employees
);

#查询与141号员工的manager_id和department_id相同的其他
#员工的employee_id,manager_id,department_id
#方式1
SELECT employee_id, manager_id, department_id
FROM employees
WHERE manager_id = (
				SELECT manager_id
				FROM employees
				WHERE employee_id =141
)
	AND salary > (
					SELECT department_id
					FROM employees
					WHERE employee_id = 141
)
	AND employee_id <> 141;

#方式2（了解即可，局限性比较大）
SELECT employee_id, manager_id, department_id
FROM employees
WHERE (manager_id, department_id) = (
				SELECT manager_id, department_id
				FROM employees
				WHERE employee_id =141
)
	AND employee_id <> 141;

#查询最低工资大于50号部门最低工资和部门id和其最低工资
SELECT department_id, MIN(salary)
FROM employees
GROUP BY department_id
HAVING MIN(salary) > (
				SELECT MIN(salary)
				FROM employees
				WHERE department_id = 50
);

#显示员工的employee_id,last_name和location,其中，若员工department_id与
#location_id为1800的department_id相同，则location为'Canada'，其余为'USA'
SELECT employee_id, last_name,
		CASE department_id WHEN(
				SELECT department_id FROM departments WHERE location_id = 1800)	THEN 'Canada'
											 ELSE 'USA' END "location"
FROM employees;

#多行子查询：IN ANY ALL SOME(等同于ANY)
# IN 
SELECT employee_id, last_name
FROM employees
WHERE salary IN (
				SELECT MIN(salary)
				FROM employees
				GROUP BY department_id
);

#ANY / ALLA
#返回其他job_id中比job_id为'IT_PROG'部门任一工资低的员工的
#员工号、姓名、job_id以及salary
SELECT employee_id, last_name, job_id, salary
FROM employees
WHERE job_id <> 'IT_PROG'
	AND salary < ANY (
					SELECT salary
					FROM employees
					WHERE job_id = 'IT_PROG'
);

#查询平均工资最低的部门id
#MySQL中聚合函数不能嵌套使用，以下报错
/*
SELECT MIN(AVG(salary))
FROM employees
GROUP BY department_id;
*/

#先
SELECT AVG(salary)
FROM employees
GROUP BY department_id;
#再
SELECT MIN(avg_sal)
FROM (
				SELECT AVG(salary) avg_sal
				FROM employees
				GROUP BY department_id
) dept_avg_sal; #保留下来的表需要起别名，否则会报错
#然后合并
SELECT department_id
FROM employees
GROUP BY department_id
HAVING AVG(salary) = (
				SELECT MIN(avg_sal)
				FROM (
								SELECT AVG(salary) avg_sal
								FROM employees
								GROUP BY department_id
				) dept_avg_sal
);

#方式2：
SELECT department_id
FROM employees
GROUP BY department_id
HAVING AVG(salary) <= ALL(
				SELECT AVG(salary) avg_sal
				FROM employees
				GROUP BY department_id
);

#空值问题
SELECT last_name
FROM employees
WHERE employee_id IN (
				SELECT manager_id
				FROM employees
);

SELECT last_name
FROM employees
WHERE employee_id NOT IN (
				SELECT manager_id
				FROM employees
);

SELECT last_name
FROM employees
WHERE employee_id NOT IN (
				SELECT manager_id
				FROM employees
				WHERE manager_id IS NOT NULL
);

#IN中会和每个进行比较，当有一个为等于时就会取得
#NOT IN中会和每个进行比较，当全都不等于时会取得

#相关子查询，以上均为不相关子查询
#查询员工中工资大于公司平均工资的员工的last_name,salary和department_id
SELECT last_name, salary, department_id
FROM employees
WHERE salary > (
				SELECT AVG(salary)
				FROM employees
);

#查询员工中工资大于本部门平均工资的员工的last_name,salary和department_id
#方式1：使用相关子查询
SELECT last_name, salary, department_id
FROM employees e1
WHERE salary > (
				SELECT AVG(salary)
				FROM employees e2
				WHERE e1.department_id = e2.department_id
);

#方式2：在FROM中声明子查询
SELECT e.last_name, e.salary, e.department_id
FROM employees e, (
				SELECT department_id, AVG(salary) avg_sal
				FROM employees
				GROUP BY department_id) dept_avg_sal
WHERE e.department_id = dept_avg_sal.department_id
	AND e.salary > dept_avg_sal.avg_sal;

#查询员工的id,salary，按照department_name排序
SELECT employee_id, salary
FROM employees e
ORDER BY (
				SELECT department_name
				FROM departments d
				WHERE e.department_id = d.department_id
); 

#在SELECT中，除了GROUP BY和LIMIT之外，其他位置都可以声明子查询
/*
SELECT ..., ..., ...(存在聚合函数）	
FROM ... (LEFT / RIGHT)JOIN... ON... 多表的连接条件 
	(LEFT / RIGHT)JOIN... ON...
WHERE 不包含聚合函数的过滤条件		
GROUP BY ..., ...
HAVING 包含聚合函数的过滤条件
ORDER BY ..., ...(ASC / DESC)
LIMIT ..., ...
*/

#若employees表中employee_id与job_history表中employee_id相同的个数
#不小于2，输出这些相同id的员工的employee_id,last_name和job_id
SELECT employee_id, last_name, job_id
FROM employees e
WHERE 2 <= (
				SELECT COUNT(*)
				FROM job_history j
				WHERE e.employee_id = j.employee_id
);

#EXISTS 与 NOT EXISTS关键字
#查询公司管理者的employee_id,last_name,job_id,department_id信息
#方式1：自连接
SELECT DISTINCT mgr.employee_id, mgr.last_name, mgr.job_id, mgr.department_id
FROM employees emp JOIN employees mgr
	ON emp.manager_id = mgr.employee_id;

#方式2：子查询
SELECT DISTINCT employee_id, last_name, job_id, department_id
FROM employees
WHERE employee_id IN (
				SELECT DISTINCT manager_id
				FROM employees
);

#方式3：使用EXISTS
SELECT employee_id, last_name, job_id, department_id
FROM employees e1
WHERE EXISTS (	#找到一个为true时就停止，所以不用去重
				SELECT *
				FROM employees e2
				WHERE e1.employee_id = e2.manager_id
);

#查询departments表中，不存在于employees表中的部门的department_id和department_name
#方式1：
SELECT d.department_id, d.department_name
FROM employees e RIGHT JOIN departments d
	ON e.department_id = d.department_id
WHERE e.department_id IS NULL;

#方式2：
SELECT d.department_id, d.department_name
FROM departments d
WHERE NOT EXISTS (
				SELECT * 
				FROM employees e
				WHERE d.department_id = e.department_id
);

