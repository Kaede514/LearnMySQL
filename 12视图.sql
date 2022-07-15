#视图的理解
/*
视图，可以看作是一个虚拟表，本身不存储数据，可以看做是存储
起来的SELECT语句

针对视图做DML操作，会影响到基表中的数据，反之亦然

视图的应用场景：针对大型项目，可以使用视图

优点：简化查询，控制数据的访问
*/

#创建视图
CREATE DATABASE dbtest14;

USE dbtest14;

CREATE TABLE emps
AS
SELECT *
FROM atguigudb.employees;

CREATE TABLE depts
AS
SELECT *
FROM atguigudb.departments;

SELECT * FROM emps;

SELECT * FROM depts;

#只复制了数据和非空约束，别的约束没有保存
DESC emps;

DESC atguigudb.employees;

#针对于单表
#情况1：视图中的字段于基表的字段有对应关系
CREATE VIEW vu_emp1
AS
SELECT employee_id, last_name, salary
FROM emps;

SELECT * FROM vu_emp1;

#确定视图中字段名的方式1：
CREATE VIEW vu_emp2
AS
#查询语句中字段的别名会作为视图中的名称出现
SELECT employee_id emp_id, last_name lname, salary	
FROM emps
WHERE salary > 8000;

SELECT * FROM vu_emp2;

#确定视图中字段名的方式2：
CREATE VIEW vu_emp3(emp_id, name, monthly_sal)
AS
#小括号内字段个数于SELECT中的字段个数相同
SELECT employee_id, last_name, salary
FROM emps
WHERE salary > 6000;

SELECT * FROM vu_emp3;

#情况2：视图中的字段在基表中可能没有对应的字段
CREATE VIEW vu_emp_sal
AS
SELECT department_id, AVG(salary) avg_sal
FROM emps
WHERE department_id IS NOT NULL
GROUP BY department_id;

SELECT * FROM vu_emp_sal;

#针对于多表
CREATE VIEW vu_emp_dept
AS
SELECT e.employee_id, e.department_id, d.department_name
FROM emps e JOIN depts d
	ON e.department_id = d.department_id;

SELECT * FROM vu_emp_dept;

#利用视图对数据进行格式化
CREATE VIEW vu_emp_dept1
AS
SELECT CONCAT(e.last_name, '(', d.department_name, ')') emp_info
FROM emps e JOIN depts d
	ON e.department_id = d.department_id;

SELECT * FROM vu_emp_dept1;

#基于视图创建视图
CREATE VIEW vu_emp4
AS
SELECT employee_id, last_name
FROM vu_emp1;

SELECT * FROM vu_emp4;

#查看视图
# 语法1：查看数据库的表对象、视图对象
SHOW TABLES;

# 语法2：查看视图的结构
DESCRIBE vu_emp1;

#语法3：查看视图的属性信息
SHOW TABLE STATUS LIKE 'vu_emp1';

SHOW TABLE STATUS;

#语法4：查看视图的详细定义信息
SHOW CREATE VIEW vu_emp1;

#更新视图中的数据（增删改）
#更新视图或基表中的数据，会导致视图和基表中的数据都被修改
SELECT * FROM vu_emp1;

SELECT employee_id, last_name, salary
FROM emps;

UPDATE vu_emp1
SET salary = 20000
WHERE employee_id = 101;

SELECT employee_id, last_name, salary
FROM emps;

UPDATE emps
SET salary = 10000
WHERE employee_id = 101;

SELECT * FROM vu_emp1;

DELETE FROM vu_emp1
WHERE employee_id = 101;

SELECT * FROM vu_emp1;

SELECT employee_id, last_name, salary
FROM emps;

#更新失败视图中的数据
#当视图中的字段在基本中没有对应的字段时会更新失败
SELECT * FROM vu_emp_sal;

/*
The target table vu_emp_sal of the UPDATE is not updatable
UPDATE vu_emp_sal
SET avg_sal = 5000
WHERE department_id = 30;
*/

/*
The target table vu_emp_sal of the DELETE is not updatable
DELETE FROM vu_emp_sal
WHERE department_id = 30;
*/

#修改视图
DESC vu_emp1;

#方式1：视图本身不存在则创建，本身存在的话则替换
CREATE OR REPLACE VIEW vu_emp1
AS
SELECT employee_id, last_name, salary, email
FROM emps
WHERE salary > 7000;

DESC vu_emp1;

#方式2：
ALTER VIEW vu_emp1
AS
SELECT employee_id, last_name, salary, email, hire_date
FROM emps;

DESC vu_emp1;

#删除视图
SHOW TABLES;

DROP VIEW vu_emp4;

SHOW TABLES;

DROP VIEW IF EXISTS vu_emp2, vu_emp3;

SHOW TABLES;

CREATE VIEW aa
AS
SELECT salary
FROM atguigudb.employees;

DESC atguigudb.employees;

ALTER TABLE atguigudb.employees
CHANGE salary sal double(8, 2);

#修改了基表中的字段名，视图中对应的字段名也要修改，不然会报错
SELECT * FROM aa;

ALTER TABLE atguigudb.employees
CHANGE sal salary double(8, 2);



