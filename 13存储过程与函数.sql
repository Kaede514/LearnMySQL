#阿里推荐禁止使用存储过程

#准备工作	 
CREATE DATABASE dbtest15;

USE dbtest15;

CREATE TABLE employees
AS
SELECT *
FROM atguigudb.employees;

CREATE TABLE departments
AS
SELECT * 
FROM atguigudb.departments;

SELECT * FROM employees;

SELECT * FROM departments;

#创建存储过程

#无参无返回值

#创建存储过程select_all_data()，查看employees表的所有数据

DELIMITER $
CREATE PROCEDURE select_all_data()
BEGIN
		SELECT * FROM employees;
END $
DELIMITER ;

#存储过程的调用
CALL select_all_data();

#创建存储过程avg_employee_salary()，返回所有员工的平均工资
DELIMITER $
CREATE PROCEDURE avg_employee_salary()
BEGIN
		SELECT AVG(salary) FROM employees;
END $
DELIMITER ;

CALL avg_employee_salary();

#创建存储过程show_max_salary()，用来查看employees表的最高薪资
DELIMITER //
CREATE PROCEDURE show_max_salary()
BEGIN
		SELECT MAX(salary) FROM employees;
END // 
DELIMITER ;

CALL show_max_salary();

#无参有返回值

#创建存储过程show_min_salary()，查看employees表中的最低薪资值，并将最低薪资
#通过OUT参数'ms'输出
DELIMITER $
CREATE PROCEDURE show_min_salary(OUT ms DOUBLE)
BEGIN
		SELECT MIN(salary) INTO ms
		FROM employees;
END $
DELIMITER ;

#调用
CALL show_min_salary(@ms);

#查看变量值
SELECT @ms;

#有参无返回值

DELIMITER $
CREATE PROCEDURE show_someone_salary(IN empname VARCHAR(20))
BEGIN
		SELECT salary
		FROM employees
		WHERE last_name = empname;
END $
DELIMITER ;

#调用方式1
CALL show_someone_salary('Abel');

#调用方式2
SET @empname = 'Abel';	#或者SET @empname := 'Abel';
CALL show_someone_salary(@empname);

#有参数有返回值（带IN和OUT）
DELIMITER $
CREATE PROCEDURE show_someone_salary2(IN empname VARCHAR(20), OUT empsalary DECIMAL(10,2))
BEGIN
		SELECT salary INTO empsalary
		FROM employees
		WHERE last_name = empname;
END $
DELIMITER ;

SET @empname = 'Abel';
CALL show_someone_salary2(@empname, @empsalary);

SELECT @empsalary;

#有参数有返回值（带INOUT）
#创建存储过程show_mgr_name()，查询某个员工领导的姓名，用INOUT参数输入员工姓名，输出领导姓名
DELIMITER $
CREATE PROCEDURE show_mgr_name(INOUT empname VARCHAR(25))
BEGIN
		SELECT last_name INTO empname
		FROM employees
		WHERE	employee_id = (
						SELECT manager_id
						FROM employees
						WHERE last_name = empname
		);
END $
DELIMITER ;

#调用
SET @empname := 'Abel';

CALL show_mgr_name(@empname);

SELECT @empname;

#存储函数

#创建存储函数，名称为email_by_name()，参数定义为空，该函数查询'Abel'的email,
#并返回，数据类型为字符串类型
DELIMITER $
CREATE FUNCTION email_by_name()
RETURNS VARCHAR(25)
				DETERMINISTIC
				CONTAINS SQL
				READS SQL DATA
BEGIN
		RETURN (SELECT email FROM employees WHERE last_name = 'Abel');
END $
DELIMITER ;

#调用
SELECT email_by_name();

/*
DETERMINISTIC
CONTAINS SQL
READS SQL DATA
执行如下就不用进行上述声明了：SET GLOBAL log_bin_trust_function_creators = 1;
*/

SET GLOBAL log_bin_trust_function_creators = 1;

DELIMITER $
CREATE FUNCTION email_by_id(emp_id INT)
RETURNS VARCHAR(25)
BEGIN
		RETURN (SELECT email FROM employees WHERE employee_id = emp_id); 
END $
DELIMITER ;

SELECT email_by_id(101);

SET @emp_id = 101;
SELECT email_by_id(@emp_id);

DELIMITER $
CREATE FUNCTION count_by_id(dept_id INT)
RETURNS INT
BEGIN
		RETURN (SELECT COUNT(*) FROM employees WHERE department_id = dept_id);
END $
DELIMITER ;

SET @dept_id := 50;SELECT count_by_id(@dept_id);

#存储过程、存储函数的查看情况

#方式1：使用SHOW CREATE语句查看存储过程和函数的创建信息
SHOW CREATE PROCEDURE show_mgr_name;

SHOW CREATE FUNCTION count_by_id;

#方式2：使用SHOW STATUS语句查看存储过程和函数的状态信息
#支持模糊查询，不确定过程或状态的名字时可以往里加%进行模糊查询
SHOW PROCEDURE STATUS;

SHOW PROCEDURE STATUS LIKE 'show_max_salary';

SHOW FUNCTION STATUS LIKE 'email_by_id';

#方式3：从information_schema.Routines表中查看存储过程和函数的信息
SELECT * 
FROM information_schema.Routines
WHERE ROUTINE_NAME = 'email_by_id';

SELECT * 
FROM information_schema.Routines
WHERE ROUTINE_NAME = 'email_by_id'
#当存储过程和存储函数重名时可以添加如下来区分
AND ROUTINE_TYPE = 'FUNCTION';

#存储过程和存储函数的修改
#只修改相关特性，不影响存储过程和存储函数的功能
ALTER PROCEDURE show_max_salary
SQL SECURITY INVOKER
COMMENT '查询最高工资';

SHOW PROCEDURE STATUS LIKE 'show_max_salary';

#存储过程、存储函数的删除
DROP FUNCTION IF EXISTS count_by_id;

DROP PROCEDURE IF EXISTS show_min_salary;

