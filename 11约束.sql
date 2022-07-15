#约束：对表中字段的限制

#约束的分类：

#角度1：约束的字段个数
#	单列约束 vs 多列约束

#角度2：约束的作用范围
#	列级约束：将此约束声明在对应字段的后面
# 表级约束：在表中所有字段都声明完，在所有字段的后面声明的约束

#角度3：约束的作用
# NOT NULL（非空约束）
#	UNIQUE（唯一性约束）
# PRIMARY KEY（主键约束）
# FOREIGN KEY（外键约束）
# CHECK（检查约束）
#	DEFAULT（默认值约束）

#添加/删除约束
# CREATE TABLE 时添加约束
# ALTER TABLE 时增加约束、删除约束

#查看表中约束
SELECT * 
FROM information_schema.table_constraints
WHERE TABLE_NAME = 'test1';

# NOT NULL（非空约束），只能用列级约束
#在创建表时添加约束
CREATE DATABASE dbtest13;
USE dbtest13;

CREATE TABLE test1(
	id INT NOT NULL,
	last_name VARCHAR(15) NOT NULL,
	email VARCHAR(25),
	salary DECIMAL(10,2)
);

DESC test1;

INSERT INTO test1(id,last_name,email,salary) VALUES
(1, 'Tom', 'tom@126.com', 3400);

/*
Column 'last_name' cannot be null
INSERT INTO test1(id,last_name,email,salary) VALUES
(2, NULL, 'tom@126.com', 3400);
*/

/*
Column 'id' cannot be null
INSERT INTO test1(id,last_name,email,salary) VALUES
(NULL, 'Jerry', 'jerry@126.com', 3400);
*/

/*
Field 'last_name' doesn't have a default value
INSERT INTO test1(id,email) VALUES
(2, 'abc@126.com');
*/

UPDATE test1
SET email = NULL
WHERE id = 1;

/*
Column 'last_name' cannot be null
UPDATE test1
SET last_name = NULL
WHERE id = 1;
*/

#在修改表时添加约束
SELECT * FROM test1;

DESC test1;

/*
nvalid use of NULL value
ALTER TABLE test1
MODIFY email VARCHAR(25) NOT NULL; 
*/

UPDATE test1
SET email = 'Tom@126.com'
WHERE id = 1;

ALTER TABLE test1
MODIFY email VARCHAR(25) NOT NULL; 

DESC test1;

#在修改表时删除约束
ALTER TABLE test1
MODIFY email VARCHAR(25) NULL; 

DESC test1;


#	UNIQUE（唯一性约束）
#在创建表时添加约束
CREATE TABLE test2(
	id INT UNIQUE,	#列级约束
	last_name VARCHAR(15) ,
	email VARCHAR(25),
	salary DECIMAL(10,2),
	
	#表级约束
	CONSTRAINT uk_test2_email UNIQUE(email)	#或UNIQUE(email)
);

DESC test2;

#在创建唯一约束的时候，如果不给唯一约束命名，就默认和列名相同
SELECT * 
FROM information_schema.table_constraints
WHERE table_name = 'test2';

INSERT INTO test2(id,last_name,email,salary) VALUES
(1, 'Tom', 'tom@126.com', 4600);

SELECT * FROM test2;

/*
Duplicate entry '1' for key 'id'
INSERT INTO test2(id,last_name,email,salary) VALUES
(1, 'Tom1', 'tom1@126.com', 4600);
INSERT INTO test2(id,last_name,email,salary) VALUES
(2, 'Tom2', 'tom@126.com', 4600);
*/

#可以向声明为UNIQUE的字段上添加NULL值，而且可以多次添加
INSERT INTO test2(id,last_name,email,salary) VALUES
(2, 'Tom2', NULL, 4600);

INSERT INTO test2(id,last_name,email,salary) VALUES
(3, 'Tom3', NULL, 4600);

SELECT * FROM test2;

#在修改表时添加约束
DESC test2;

#方式1：
/*
报错，已经有2个salary相同
ALTER TABLE test2 
ADD CONSTRAINT uk_test2_sal UNIQUE(salary);
*/

UPDATE test2
SET salary = 5200
WHERE id = 2;

ALTER TABLE test2 
ADD CONSTRAINT uk_test2_sal UNIQUE(salary);

#方式2：
ALTER TABLE test2 
MODIFY last_name VARCHAR(15) UNIQUE;

SELECT * 
FROM information_schema.table_constraints
WHERE table_name = 'test2';

#复合的唯一性约束
CREATE TABLE user(
	id INT,
	name VARCHAR(15),
	password VARCHAR(25),
	
	#表级约束
	CONSTRAINT uk_user_name_pwd UNIQUE(name,password)
);

INSERT INTO user VALUES
(1, 'Tom', 'abc');

INSERT INTO user VALUES
(1, 'Tom1', 'abc');

SELECT *
FROM user;

#删除唯一性约束
#-添加唯一性约束的列上也会自动创建唯一索引
#-删除唯一约束只能通过删除唯一索引的方式删除
#-删除时需要指定唯一索引名，唯一索引名就和唯一约束名一样
#-如果创建唯一约束时为指定名称，如果是单列，就默认和列明相同；
#-如果是组合列，那么默认和()中排在第一个的列名相同，也可以自定义唯一性约束名

SELECT * 
FROM information_schema.table_constraints
WHERE table_name = 'test2';

DESC test2;

ALTER TABLE test2
DROP INDEX last_name;

ALTER TABLE test2
DROP INDEX uk_test2_email;

DESC test2;

SELECT * 
FROM information_schema.table_constraints
WHERE table_name = 'user';

DESC user;

ALTER TABLE user
DROP INDEX uk_user_name_pwd;

DESC user;


# PRIMARY KEY（主键约束）
#在创建表时添加主键约束
/*
Multiple primary key defined
CREATE TABLE test3(
	id INT PRIMARY KEY,	#列级约束
	name VARCHAR(15) PRIMARY KEY,
	salary DECIMAL(10,2)
);
*/

#主键的约束特征：非空且唯一，用于唯一的标识表中的一条记录
CREATE TABLE test4(
	id INT PRIMARY KEY,	#列级约束
	name VARCHAR(15),
	salary DECIMAL(10,2),
	email VARCHAR(25)
);

#MySQL的主键名总是PRIMARY，就算自己命名了主键约束名也没用
CREATE TABLE test5(
	id INT,	
	name VARCHAR(15),
	salary DECIMAL(10,2),
	email VARCHAR(25),
	#表级约束
	CONSTRAINT pk_test5_id PRIMARY KEY(id)	#没必要起名字
);

SELECT * 
FROM information_schema.table_constraints
WHERE table_name = 'test5';

INSERT INTO test4(id,name,salary,email) VALUES
(1, 'Tom', 4500, 'tom@126.com');

/*
Duplicate entry '1' for key 'PRIMARY'
INSERT INTO test4(id,name,salary,email) VALUES
(1, 'Tom', 4500, 'tom@126.com');
*/

/*
Column 'id' cannot be null
INSERT INTO test4(id,name,salary,email) VALUES
(NULL, 'Tom', 4500, 'tom@126.com');
*/

SELECT * FROM test4;

#如果是多列组合的复合主键约束，那么这些列都不允许为空值，并且组合的值不允许重复
CREATE TABLE user2(
	id INT,
	name VARCHAR(15),
	password VARCHAR(25),
	PRIMARY KEY(name,password)
);

INSERT INTO user2 VALUES
(1, 'Tom', 'abc');

INSERT INTO user2 VALUES
(1, 'Tom1', 'abc');

/*
Column 'name' cannot be null
INSERT INTO user2 VALUES
(1, NULL, 'abc');
*/

SELECT * FROM user2;

#在修改表时添加主键约束
CREATE TABLE test6(
	id INT,
	name VARCHAR(15),
	salary DECIMAL(10,2),
	email VARCHAR(25)
);

DESC test6;

ALTER TABLE test6
ADD PRIMARY KEY(id);

ALTER TABLE test6
MODIFY id INT PRIMARY KEY;

#删除主键约束（在实际开发中，不会去删除主键约束！）
ALTER TABLE test6
DROP INDEX PRIMARY KEY;

DESC test6;


#AUTO_INCREMENT（自增列）
#自增长列约束的列必须是主键列或唯一键列，且数据类型为整数
#在创建表时添加
CREATE TABLE test7(
	id INT PRIMARY KEY AUTO_INCREMENT,	#可以组合添加，也可以单独添加
	name VARCHAR(15)
);

#开发中，一旦主键作用的字段上声明有AUTO_INCREMENT，则在添加数据时，
#就不要给主键对应的字段去赋值了
INSERT INTO test7(name) VALUES
('Tom');

SELECT * FROM test7;

#当向zhu'jian（含AUTO_INCREMENT）的字段上添加0或NULL时，实际上会自动的往上
#添加指定的字段的数值

INSERT INTO test7(id,name) VALUES
(0,'Tom');

INSERT INTO test7(id,name) VALUES
(NULL,'Tom');

INSERT INTO test7(id,name) VALUES
(10,'Tom');

INSERT INTO test7(id,name) VALUES
(-10,'Tom');

SELECT * FROM test7;

#在修改表时添加
CREATE TABLE test8(
	id INT PRIMARY KEY,
	name VARCHAR(15)
);

DESC test8;

ALTER TABLE test8
MODIFY id INT AUTO_INCREMENT;

#在修改表时删除
ALTER TABLE test8
MODIFY id INT;

DESC test8;


# FOREIGN KEY（外键约束）（阿里开发手册推荐禁止使用，在应用层解决）
#在创建时添加外键约束
#主表和从表：父表和子表

#先创建主表
CREATE TABLE dept1(
	dept_id INT,
	dept_name VARCHAR(15)
);

#再创建从表
/*
报错，因为主表中的dept_id没有添加主键约束或唯一性约束
CREATE TABLE emp1(
	emp_id INT PRIMARY KEY AUTO_INCREMENT,
	emp_name VARCHAR(15),
	d_id INT,
	#表级约束
	CONSTRAINT fk_emp1_dept1_id FOREIGN KEY(d_id) REFERENCES dept1(dept_id)
);
*/

ALTER TABLE dept1
ADD PRIMARY KEY(dept_id);

CREATE TABLE emp1(
	emp_id INT PRIMARY KEY AUTO_INCREMENT,
	emp_name VARCHAR(15),
	d_id INT,
	#表级约束
	CONSTRAINT fk_emp1_dept1_id FOREIGN KEY(d_id) REFERENCES dept1(dept_id)
);

#演示外键的效果
#添加失败
/*
INSERT INTO emp1 VALUES
(1001, 'Tom', 10);
*/

INSERT INTO dept1 VALUES
(10, 'IT');

#在主表dept1中添加10号部门以后，我们就可以在从表中添加10号部门的员工
INSERT INTO emp1 VALUES
(1001, 'Tom', 10);

#删除失败
/*
DELETE FROM dept1 
WHERE dept_id = 10;
*/

#更新失败
/*
UPDATE dept1
SET dept_id = 20
WHERE dept_id = 10;
*/

#在修改时添加外键约束

CREATE TABLE dept2(
	dept_id INT PRIMARY KEY,
	dept_name VARCHAR(15)
);

CREATE TABLE emp2(
	emp_id INT PRIMARY KEY AUTO_INCREMENT,
	emp_name VARCHAR(15),
	d_id INT
);

SELECT * 
FROM information_schema.table_constraints
WHERE table_name = 'emp2';

ALTER TABLE emp2
ADD CONSTRAINT fk_emp1_dept2_id FOREIGN KEY(d_id) REFERENCES dept2(dept_id);

#约束等级（以下用2个约束等级举例）
# CASCADE
# SET NULL
# ...

CREATE TABLE dept(
	dept_id INT PRIMARY KEY,
	dept_name VARCHAR(15)
);

CREATE TABLE emp(
	emp_id INT PRIMARY KEY AUTO_INCREMENT,
	emp_name VARCHAR(15),
	d_id INT,
	CONSTRAINT fk_emp1_dept_id FOREIGN KEY(d_id) REFERENCES dept(dept_id)
	ON UPDATE CASCADE ON DELETE SET NULL
);

INSERT INTO dept VALUES
(1001, 'A'),(1002, 'B'),(1003, 'C');

INSERT INTO emp(emp_name, d_id) VALUES
('solar', 1001),('lunar', 1001),('kaede', 1002);

UPDATE dept
SET dept_id = 1004
WHERE dept_id = 1002;

DELETE FROM dept
WHERE dept_id = 1004;

SELECT * FROM dept;

SELECT * FROM emp;

#对于外键约束，最好是采用 ON UPDATE CASCADE ON DELETE SET NULL 的方式

#删除外键约束
SELECT * 
FROM information_schema.table_constraints
WHERE table_name = 'emp1';

ALTER TABLE emp1
DROP FOREIGN KEY fk_emp1_dept1_id;

#再手动删除外键约束对应的普通索引
SHOW INDEX FROM emp1;

ALTER TABLE emp1
DROP INDEX fk_emp1_dept1_id;

SHOW INDEX FROM emp1;


# CHECK（检查约束）（MySQL5.7不支持）
CREATE TABLE test10(
	id INT,
	name VARCHAR(15),
	salary DECIMAL(10,2) CHECK(salary > 2000)
);

INSERT INTO test10 VALUES 
(1, 'Tom', 2500);

#无用，还是添加了
INSERT INTO test10 VALUES 
(2, 'Tom', 1500);

SELECT * FROM test10;


#	DEFAULT（默认值约束）
#在创建表时添加
CREATE TABLE test11(
	id INT,
	name VARCHAR(15),
	salary DECIMAL(10,2) DEFAULT 2000
);

DESC test11;

INSERT INTO test11(id,name,salary) VALUES
(1, 'Tom', 3000);

INSERT INTO test11(id,name) VALUES
(2, 'Jerry');

SELECT * FROM test11;

#在修改表时添加
CREATE TABLE test12(
	id INT,
	name VARCHAR(15),
	salary DECIMAL(8,2)
);

DESC test12;

ALTER TABLE test12
MODIFY salary DECIMAL(10,2) DEFAULT 2500;

#在修改表时删除
ALTER TABLE test12
MODIFY salary DECIMAL(10,2);


































