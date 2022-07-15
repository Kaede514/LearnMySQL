USE atguigudb;

#查询员工名为'Abel'的人在哪个城市工作
SELECT * 
FROM employees
WHERE last_name = 'Abel';

SELECT * 
FROM departments
WHERE department_id = 80;

SELECT * 
FROM locations
WHERE location_id = 2500;

#错误的实现方式，每个员工与每个部门都匹配的一遍
#出现笛卡尔积的错误
#错误的原因：缺少了多表的连接条件
SELECT employee_id, department_name
FROM employees, departments; #查询出107 * 27 = 2889条记录
#等同FROM employees CROSS JOIN department

#多表查询的正确方式：需要有连接条件
SELECT employee_id, department_name
FROM employees, departments 
#两个表的连接条件
WHERE employees.department_id = departments.department_id;

#如果查询语句中出现多个表中都存在的字段，则必须指明此字段所在的表
SELECT employee_id, department_name, employees.department_id
FROM employees, departments 
WHERE employees.department_id = departments.department_id;

#从SQL优化的角度，建议多表查询时，每个字段前都指明其所在的表

#可以给表起别名，在SELECT和WHILE语句中使用表的别名
SELECT emp.employee_id, dept.department_name, emp.department_id
FROM employees emp, departments dept 
WHERE emp.department_id = dept.department_id;

#如果给表起了别名，一旦在SELECT或WHERE中使用了表的别名
#的话，则必须使用表的别名，不能使用表的原名
#报错
/*
SELECT emp.employee_id, departments.department_name, emp.department_id
FROM employees emp, departments dept 
WHERE emp.department_id = dept.department_id;
*/

#如果有n个表实现多表的查询，则需要n-1个连接条件
#查询员工的employee_id, last_name, department_name, city
SELECT emp.employee_id, emp.last_name, dept.department_id, lct.city
FROM	employees emp, departments dept, locations lct
WHERE	emp.department_id = dept.department_id
	AND dept.location_id = lct.location_id;

#多表查询的分类
/*
角度一：等值连接 vs 非等值连接

角度二：自连接 vs 非自连接

角度三：内连接 vs 外连接
*/

#等值连接 vs 非等值连接
#非等值连接的例子
SELECT * FROM job_grades;

SELECT emp.last_name, emp.salary, jg.grade_level
FROM employees emp, job_grades jg
WHERE emp.salary BETWEEN jg.lowest_sal AND jg.highest_sal;
#WHERE emp.salary >= jg.lowest_sal AND emp.salary <= jg.highest_sal;

#自连接 vs 非自连接
SELECT * FROM employees;
#自连接的例子
#查询员工id，员工姓名及其管理者的id和姓名
SELECT emp.employee_id, emp.last_name, mgr.employee_id, mgr.last_name
FROM employees emp, employees mgr
WHERE emp.manager_id = mgr.employee_id;

#内连接 vs 外连接

#内连接：合并具有同一列的两个以上的表的行，结果不包含一个表与另一个表
#				 不匹配的行
SELECT emp.employee_id, emp.last_name, mgr.employee_id, mgr.last_name
FROM employees emp, employees mgr
WHERE emp.manager_id = mgr.employee_id;

#外连接：合并具有同一列的两个以上的表的行，结果除了包含一个表与另一个表
#				 匹配的行之外，还查询到了左表和右表中不匹配的行

#外连接的分类：左外连接、右外连接、满外连接

#SQL92实现内连接：如上
#SQL92实现外连接：使用+		MySQL不支持SQL92语法中外连接的写法！
/*
SELECT emp.employee_id, emp.last_name, mgr.employee_id, mgr.last_name
FROM employees emp, employees mgr
WHERE emp.manager_id = mgr.employee_id(+); 	#左外连接，因不支持报错
*/

#SQL99中使用JOIN...ON...的方式实现多表的查询

#SQL99语法实现内连接
SELECT emp.employee_id, emp.last_name, mgr.employee_id, mgr.last_name
FROM employees emp JOIN employees mgr	#INNER JOIN 可简写为	 JOIN
	ON emp.manager_id = mgr.employee_id;

SELECT emp.employee_id, emp.last_name, dept.department_id, lct.city
FROM employees emp JOIN departments dept
	ON emp.department_id = dept.department_id
	JOIN locations lct
	ON dept.location_id = lct.location_id;

#SQL99语法实现外连接
SELECT emp.employee_id, emp.last_name, mgr.employee_id, mgr.last_name
FROM employees emp LEFT JOIN employees mgr	#LEFT OUTER JOIN 可简写为 LEFT JOIN
	ON emp.manager_id = mgr.employee_id;

SELECT emp.employee_id, emp.last_name, mgr.employee_id, mgr.last_name
FROM employees emp RIGHT OUTER JOIN employees mgr	#RIGHT OUTER JOIN 可简写为 RIGHT JOIN
	ON emp.manager_id = mgr.employee_id;

#满外连接：MySQL不支持FULL OUTER JOIN
/*
SELECT emp.employee_id, emp.last_name, mgr.employee_id, mgr.last_name
FROM employees emp FULL OUTER JOIN employees mgr	
	ON emp.manager_id = mgr.employee_id;
*/

#UNION 和 UNION ALL 的使用
#UNION会执行去重的操作，UNION　ALL不会执行去重操作
#如果明确知道合并数据后的结果不存在重复数据，或者不需要去除重复的
#数据，则尽量使用UNION ALL语句，以提高数据查询的效率

#7种JOIN的实现
# _O_图：内连接
SELECT e.employee_id, d.department_name 
FROM employees e JOIN departments d
	ON e.department_id = d.department_id;

# OO_图：左外连接
SELECT e.employee_id, d.department_name 
FROM employees e LEFT JOIN departments d
	ON e.department_id = d.department_id;

# _OO图：右外连接
SELECT e.employee_id, d.department_name 
FROM employees e RIGHT JOIN departments d
	ON e.department_id = d.department_id;

# O__图：
SELECT e.employee_id, d.department_name 
FROM employees e LEFT JOIN departments d
	ON e.department_id = d.department_id
WHERE e.department_id IS NULL;	#d.department_id IS NULL也行

# __O图：
SELECT e.employee_id, d.department_name 
FROM employees e RIGHT JOIN departments d
	ON e.department_id = d.department_id
WHERE e.department_id IS NULL;	#d.department_id IS NULL也行

# OOO图：满外连接
#way1：OO_ UNION ALL __O
SELECT e.employee_id, d.department_name 
FROM employees e LEFT JOIN departments d
	ON e.department_id = d.department_id	#注意这里没有;
UNION ALL
SELECT e.employee_id, d.department_name 
FROM employees e RIGHT JOIN departments d
	ON e.department_id = d.department_id
WHERE e.department_id IS NULL;

#way2：O__ UNION ALL _OO
SELECT e.employee_id, d.department_name 
FROM employees e LEFT JOIN departments d
	ON e.department_id = d.department_id
WHERE e.department_id IS NULL
UNION ALL
SELECT e.employee_id, d.department_name 
FROM employees e RIGHT JOIN departments d
	ON e.department_id = d.department_id;

# O_O图：
SELECT e.employee_id, d.department_name 
FROM employees e LEFT JOIN departments d
	ON e.department_id = d.department_id
WHERE e.department_id IS NULL
UNION ALL
SELECT e.employee_id, d.department_name 
FROM employees e RIGHT JOIN departments d
	ON e.department_id = d.department_id
WHERE e.department_id IS NULL;

#SQL99语法新特性1：自然连接
SELECT e.employee_id, e.last_name, d.department_name
FROM employees e JOIN departments d
	ON e.department_id = d.department_id
	AND e.manager_id = d.manager_id;

#NATURAL JOIN：自动查询两张连接表中所有相同的字段，然后进行等值连接
SELECT e.employee_id, e.last_name, d.department_name
FROM employees e NATURAL JOIN departments d;


#SQL99语法新特性2：USING
SELECT e.employee_id, e.last_name, d.department_name
FROM employees e JOIN departments d
	ON e.department_id = d.department_id;

SELECT e.employee_id, e.last_name, d.department_name
FROM employees e JOIN departments d
	USING (department_id);

#表条件的约束方式可以有三种：WHERE、ON、USING，后面两种必须和
#JOIN一起用，优先用ON、WHERE
