USE atguigudb;

#1、查询和Zlotkey相同部门的员工姓名和工资
SELECT last_name, salary
FROM employees
WHERE department_id = (
				SELECT department_id
				FROM employees
				WHERE last_name = 'Zlotkey'
);


#2、查询工资比公司平均工资高的员工的员工号、姓名和工资
SELECT employee_id, last_name, salary
FROM employees
WHERE salary > (
				SELECT AVG(salary)
				FROM employees
);


#3、选择工资大于所有job_id = 'SA_MAN'的员工的工资的员工的last_name,job_id,salary
SELECT last_name, job_id, salary
FROM employees
WHERE salary > ALL(
				SELECT salary
				FROM employees
				WHERE job_id = 'SA_MAN'
);


#4、查询和姓名中包含字母u的员工在相同部门的员工给员工号和工资
SELECT employee_id, salary
FROM employees
WHERE department_id IN (
				SELECT department_id
				FROM employees
				WHERE last_name LIKE '%u%'
);


#5、查询管理者为King的员工姓名和工资
#错误的，因为last_name为King的员工有2个
/*
SELECT last_name, salary
FROM employees
WHERE manager_id = (
				SELECT employee_id
				FROM employees
				WHERE last_name = 'King'
);
*/

SELECT last_name, salary
FROM employees
WHERE manager_id IN (
				SELECT employee_id
				FROM employees
				WHERE last_name = 'King'
);


#6、查询工资最低的员工信息
SELECT last_name, salary
FROM employees
WHERE salary = (
				SELECT MIN(salary)
				FROM employees
);


#7、查询平均工资最低的部门信息
#way1:
SELECT *
FROM departments
where department_id = (
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
				)
);

#way2:
SELECT *
FROM departments
where department_id = (
				SELECT department_id
				FROM employees
				GROUP BY department_id
				HAVING AVG(salary) <= ALL(
												SELECT AVG(salary) avg_sal
												FROM employees
												GROUP BY department_id
				)
);

#way3:
SELECT *
FROM departments
WHERE department_id = (
				SELECT department_id
				FROM employees
				GROUP BY department_id
				HAVING AVG(salary) = (
												SELECT AVG(salary) avg_sal
												FROM employees
												GROUP BY department_id
												ORDER BY avg_sal ASC
												LIMIT 0, 1
				)
);

#way4:
SELECT d.*
FROM departments d, (
				SELECT department_id, AVG(salary) avg_sal
				FROM employees
				GROUP BY department_id
				ORDER BY avg_sal ASC
				LIMIT 0, 1
) dept_avg_sal
WHERE d.department_id = dept_avg_sal.department_id;


#8、查询平均工资最低的部门信息和该部门的平均工资	
#way1:
SELECT d.*, (
				SELECT AVG(salary)
				FROM employees
				WHERE department_id = d.department_id
) avg_sal
FROM departments d
where department_id = (
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
				)
);

#way2:
SELECT d.*, (
				SELECT AVG(salary)
				FROM employees
				WHERE department_id = d.department_id
) avg_sal
FROM departments d
where department_id = (
				SELECT department_id
				FROM employees
				GROUP BY department_id
				HAVING AVG(salary) <= ALL(
												SELECT AVG(salary) avg_sal
												FROM employees
												GROUP BY department_id
				)
);

#way3:
SELECT d.*, (
				SELECT AVG(salary)
				FROM employees
				WHERE department_id = d.department_id
) avg_sal
FROM departments d
WHERE department_id = (
				SELECT department_id
				FROM employees
				GROUP BY department_id
				HAVING AVG(salary) = (
												SELECT AVG(salary) avg_sal
												FROM employees
												GROUP BY department_id
												ORDER BY avg_sal ASC
												LIMIT 0, 1
				)
);

#way4:
SELECT d.*, (
				SELECT AVG(salary)
				FROM employees
				WHERE department_id = d.department_id
) avg_sal
FROM departments d, (
				SELECT department_id, AVG(salary) avg_sal
				FROM employees
				GROUP BY department_id
				ORDER BY avg_sal ASC
				LIMIT 0, 1
) dept_avg_sal
WHERE d.department_id = dept_avg_sal.department_id;


#9、查询平均工资最高的job信息
#way1:
SELECT *
FROM jobs
WHERE job_id = (
				SELECT job_id
				FROM employees
				GROUP BY job_id
				HAVING AVG(salary) = (
								SELECT MAX(avg_sal)
								FROM(
												SELECT AVG(salary) avg_sal
												FROM employees
												GROUP BY job_id
								) emp_avg_sal
				)
);

#way2:
SELECT *
FROM jobs
WHERE job_id = (
				SELECT job_id
				FROM employees
				GROUP BY job_id
				HAVING AVG(salary) >= ALL(
												SELECT AVG(salary)
												FROM employees
												GROUP BY job_id
				)
);

#way3:
SELECT *
FROM jobs
WHERE job_id = (
				SELECT job_id
				FROM employees
				GROUP BY job_id
				HAVING AVG(salary) = (
												SELECT AVG(salary)
												FROM employees
												GROUP BY job_id
												ORDER BY AVG(salary) DESC
												LIMIT 0, 1
				)
);

#way4:
SELECT j.*
FROM jobs j, (
				SELECT job_id, AVG(salary)
				FROM employees
				GROUP BY job_id
				ORDER BY AVG(salary) DESC
				LIMIT 0, 1
) emp_avg_sal
WHERE j.job_id = emp_avg_sal.job_id;


#10、查询出公司中所有manager的详细信息
#方式1：自连接
SELECT DISTINCT mgr.*
FROM employees mgr JOIN employees emp
	ON mgr.employee_id = emp.manager_id

#方式2：子查询
SELECT *
FROM employees
WHERE employee_id IN (
				SELECT manager_id
				FROM employees
);

#使用EXISTS
SELECT e1.*
FROM employees e1
WHERE EXISTS (
				SELECT 1 #什么都行
				FROM employees e2
				WHERE e1.employee_id = e2.manager_id
);


#11、查询各个部门中最高工资中最低的那个部门的最低工资
#way1:
SELECT MIN(salary)
FROM employees
WHERE department_id = (
				SELECT department_id
				FROM employees
				GROUP BY department_id
				HAVING MAX(salary) = (
								SELECT MIN(max_sal)
								FROM (
												SELECT MAX(salary) max_sal
												FROM employees
												GROUP BY department_id
								) dept_max_sal
				)
);

#way2:
SELECT MIN(salary)
FROM employees
WHERE department_id = (
				SELECT department_id
				FROM employees
				GROUP BY department_id
				HAVING MAX(salary) <= ALL (
												SELECT MAX(salary)
												FROM employees
												GROUP BY department_id
				)
);

#way3:
SELECT MIN(salary)
FROM employees
WHERE department_id = (
				SELECT department_id
				FROM employees
				GROUP BY department_id
				HAVING MAX(salary) =  (
												SELECT MAX(salary)
												FROM employees
												GROUP BY department_id
												ORDER BY MAX(salary) ASC
												LIMIT 0, 1
				)
);

#way4:
SELECT MIN(salary)
FROM employees e1, (
				SELECT department_id, MAX(salary)
				FROM employees
				GROUP BY department_id
				ORDER BY MAX(salary) ASC
				LIMIT 0, 1 
) e2
WHERE e1.department_id = e2.department_id;


#12、查询平均工资最高的部门的manager的信息
#way1:
SELECT *
FROM employees
WHERE employee_id IN (
				SELECT manager_id
				FROM employees
				WHERE department_id = (
								SELECT department_id
								FROM employees
								GROUP BY department_id
								HAVING AVG(salary) = (
												SELECT MAX(avg_sal)
												FROM (
																SELECT AVG(salary) avg_sal
																FROM employees
																GROUP BY department_id
												) demp_avg_sal
								)
				)
);

#way2:
SELECT *
FROM employees
WHERE employee_id IN (
				SELECT manager_id
				FROM employees
				WHERE department_id = (
								SELECT department_id
								FROM employees
								GROUP BY department_id
								HAVING AVG(salary) >= ALL (
																SELECT AVG(salary)
																FROM employees
																GROUP BY department_id
								)
				)
);

#way3:
SELECT *
FROM employees
WHERE employee_id IN (
				SELECT manager_id
				FROM employees
				WHERE department_id = (
								SELECT department_id
								FROM employees
								GROUP BY department_id
								HAVING AVG(salary) = (
																SELECT AVG(salary)
																FROM employees
																GROUP BY department_id
																ORDER BY AVG(salary) DESC
																LIMIT 0, 1
								)
				)
);

#way4:
SELECT *
FROM employees
WHERE employee_id IN (
				SELECT e1.manager_id
				FROM employees e1, (
								SELECT department_id, AVG(salary)
								FROM employees
								GROUP BY department_id
								ORDER BY AVG(salary) DESC
								LIMIT 0, 1
				) e2
				WHERE e1.department_id = e2.department_id
);


#13、查询部门的部门号，其中不包括job_id是'ST_CLERK'的部门号
#方式1：
SELECT department_id
FROM departments
WHERE department_id NOT IN (
				SELECT DISTINCT department_id
				FROM employees
				WHERE job_id = 'ST_CLERK'
)

#方式2：
SELECT department_id
FROM departments d
WHERE NOT EXISTS (
				SELECT 1
				FROM employees e
				WHERE d.department_id = e.department_id
					AND e.job_id = 'ST_CLERK'
);


#14、查询员工中工资大于本部门平均工资的员工信息
#way1:
SELECT e1.*
FROM employees e1
WHERE salary > (
				SELECT AVG(salary)
				FROM employees e2
				WHERE e1.department_id = e2.department_id
);

#way2:
SELECT e.*
FROM employees e, (
				SELECT department_id, AVG(salary) avg_sal
				FROM employees 
				GROUP BY department_id
) dept_avg_sal
WHERE e.department_id = dept_avg_sal.department_id
	AND e.salary > dept_avg_sal.avg_sal;


#15、查询每个部门下的部门人数大于5的部门名称
SELECT department_name
FROM departments d
WHERE 5 < (
				SELECT COUNT(*)
				FROM employees e
				WHERE d.department_id = e.department_id
);


/*
子查询编写技巧：
1、如果子查询相对较简单，建议从外往里写，一旦子查询结构较复杂，建议从里往外写
2、如果是相关子查询，一般都是从外往里写
*/
