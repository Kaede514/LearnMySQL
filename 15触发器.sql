#准备工作

CREATE DATABASE dbtest17;

USE dbtest17;

#创建触发器

#创建数据表
CREATE TABLE test_trigger(
		id INT PRIMARY KEY AUTO_INCREMENT,
		t_note VARCHAR(30)
);

CREATE TABLE test_trigger_log(
		id INT PRIMARY KEY AUTO_INCREMENT,
		t_log VARCHAR(30)
);

SELECT * FROM test_trigger;

SELECT * FROM test_trigger_log;

#创建名称为before_insert_test_tri的触发器，向test_trigger数据表插入数据之前，
#向test_trigger_log数据表中插入before_insert的日志信息

DELIMITER $
CREATE TRIGGER before_insert_test_tri
BEFORE INSERT ON test_trigger
FOR EACH ROW
BEGIN
				INSERT INTO test_trigger_log(t_log) VALUES
				('before insert...');
END $
DELIMITER ;

INSERT INTO test_trigger(t_note) VALUES
('Tom...');

SELECT * FROM test_trigger;

SELECT * FROM test_trigger_log;

#创建名称为after_insert_test_tri的触发器，向test_trigger数据表插入数据之前，
#向test_trigger_log数据表中插入after_insert的日志信息

DELIMITER $
CREATE TRIGGER after_insert_test_tri
BEFORE INSERT ON test_trigger
FOR EACH ROW
BEGIN
				INSERT INTO test_trigger_log(t_log) VALUES
				('after insert...');
END $
DELIMITER ;

INSERT INTO test_trigger(t_note) VALUES
('Jerry...');

SELECT * FROM test_trigger;

SELECT * FROM test_trigger_log;

#定义触发器"salary_check_trigger"，基于员工表employees的INSERT事件，在
#INSERT之前检查将要添加的新员工薪资是否大于他领导的薪资，如果大于他领导
#薪资，则报sqlstate_value为'HY000'的错误，从而使得添加失败

CREATE TABLE employees
AS
SELECT * FROM atguigudb.employees;

CREATE TABLE departments
AS 
SELECT * FROM atguigudb.departments;

DESC employees;

DELIMITER $
CREATE TRIGGER salary_check_trigger
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
				DECLARE mgr_sal DOUBLE;
				
				SELECT salary INTO mgr_sal FROM employees
				WHERE employee_id = NEW.manager_id;
				
				IF NEW.salary > mgr_sal
						THEN SIGNAL SQLSTATE 'HY000' SET MESSAGE_TEXT = '薪资高于领导薪资错误';
				END IF;
END $
DELIMITER ;

#添加成功，依然触发了触发器salary_check_trigger的执行
INSERT INTO employees(employee_id,last_name,email,hire_date,job_id,salary,manager_id)
VALUES (300,'Tom','tom@126.com',NOW(),'',8000,103);

#添加失败
INSERT INTO employees(employee_id,last_name,email,hire_date,job_id,salary,manager_id)
VALUES (301,'Tom1','tom1@126.com',NOW(),'',10000,103);

SELECT * FROM employees;


#查看触发器
#查看当前数据库的所有触发器的定义
SHOW TRIGGER;

#查看当前数据库中某个触发器的定义
SHOW CREATE TRIGGER salary_check_trigger;

#从系统库information_schema的TRIGGERS表中查询salary_check_trigger触发器的信息
SELECT * FROM information_schema.TRIGGERS;


#删除触发器
DROP TRIGGER IF EXISTS after_insert_test_tri;

