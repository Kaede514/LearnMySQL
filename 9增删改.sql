#储备工作
USE atguigudb;

CREATE TABLE IF NOT EXISTS emp1(
	id INT,
	`name` VARCHAR(15),
	hire_date DATE,
	salary DOUBLE(10, 2)
);

DESC emp1;

SELECT * 
FROM emp1;

#添加数据
#方式1：一条一条地添加数据
#注意：一定要按声明的字段的先后顺序添加
#没有指明添加的字段
INSERT INTO emp1
VALUES(1,'solar','2000-12-21',3400);

#指明要添加的字段（推荐）
INSERT INTO emp1(id,hire_date,salary,name)
VALUES(2,'2000-12-21',3600,'lunar');

#没有进行赋值的字段值为NULL
INSERT INTO emp1(id,salary,name)
VALUES(3,3600,'kaede');

INSERT INTO emp1(id,salary,name)
VALUES 
(4,1000,'Tom'),
(5,1200,'Jerry');	

#方式2：将查询结果插入到表中
SELECT * 
FROM emp1;

INSERT INTO emp1(id,hire_date,salary,name)
#查询语句：查询的字段一定要与添加到的表的字段一一对应
SELECT employee_id,hire_date,salary,last_name
FROM employees
WHERE department_id IN (60, 70);

DESC emp1;
DESC employees;

#emp1表中要添加数据的字段的长度不能低于employees表中查询的字段的长度。如果emp1表中
#要添加数据的字段长度低于employees表中查询的字段的长度，就有添加不成功的风险

#更新数据
#UPDATE... SET... WHERE...
#可实现单个或批量的修改

UPDATE emp1
SET hire_data = NOW(), salary = 6000 
WHERE id = 4;

SELECT * FROM emp1;

UPDATE emp1
SET salary = salary * 1.2
WHERE name LIKE '%a%';

#修改数据时可能存在不成功的情况，可能是由于约束的影响造成的
/*
UPDATE employees
SET department_id = 1000
WHERE employee_id = 102;
*/

#删除数据
#DELETE FROM... WHERE...

DELETE FROM emp1
WHERE id = 1;

/*
在删除数据时也有可能因为约束的影响导致删除失败
DELETE FROM departments
WHERE department_id = 50;
*/

#DML默认操作的情况下，执行完以后都会自动提交数据
#如果希望执行完以后不自动提交数据，则需要使用 SET AUTOCOMMIT = FALSE


