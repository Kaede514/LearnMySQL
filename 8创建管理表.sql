#创建数据库
#方式1：
CREATE DATABASE mytest1;	#创建的此数据库使用的是默认字符集

SHOW DATABASES;

SHOW CREATE DATABASE mytest1;

#方式2：
CREATE DATABASE mytest2 CHARACTER SET 'gbk';

SHOW CREATE DATABASE mytest2;

#方式3：（推荐）如果要创建的数据库已经存在，则不会创建
#也推荐加上CHARCTER SET
CREATE DATABASE IF NOT EXISTS mytest2 CHARACTER SET 'utf8';

SHOW CREATE DATABASE mytest2;	#仍为'gbk'

#如果要创建的数据库不存在，则创建成功
CREATE DATABASE IF NOT EXISTS mytest3 CHARACTER SET 'utf8';

SHOW DATABASES;

#管理数据库
#查看当前连接中的数据库有哪些
SHOW DATABASES;

#切换数据库
USE atguigudb;

#查看当前数据库中保存的数据表
SHOW TABLES;

#查看当前使用的数据库
SELECT DATABASE() FROM DUAL;

#查看指定数据库下保存的数据表
SHOW TABLES FROM mysql;

#修改数据库
#更改数据库字符集
SHOW CREATE DATABASE mytest2;

ALTER DATABASE mytest2 CHARACTER SET 'utf8';

#删除数据库
#方式1：如果是删除的数据库存在，则删除成功，否则报错
DROP DATABASE mytest1;

SHOW DATABASES;

#方式2：推荐。如果是删除的数据库存在，则删除成功，若不存在，则默默结束，不会报错
DROP DATABASE IF EXISTS mytest1;

DROP DATABASE IF EXISTS mytest2;

SHOW DATABASES;


#创建数据表
USE atguigudb;

SHOW CREATE DATABASE atguigudb;

SHOW TABLES;

#方式1：
CREATE TABLE IF NOT EXISTS myemp1(	#需要用户具备创建表的权限
	id INT,
	emp_name VARCHAR(15),	#使用VARCHAR来定义字符串，必须在使用VARCHAR时指明其长度
	hire_data DATE
);

#查看表结构
DESC myemp1;

#如果创建表时没有指明使用的字符集，则默认使用表所在数据库的字符集
SHOW CREATE TABLE myemp1;

#查看表数据
SELECT * FROM myemp1;

#方式2：基于现有的表，同时导入数据
CREATE TABLE myemp2
AS
SELECT employee_id, last_name, salary
FROM employees;

DESC myemp2;
DESC employees;

SELECT * FROM myemp2;

#查询语句中字段的别名可以作为新创建的表的字段的名称
#此时的查询语句可以结构比较丰富，使用前面章节讲过的各种SELECT
CREATE TABLE myemp3
AS
SELECT employee_id emp_id, last_name lname, department_name
FROM employees e JOIN departments d
	ON e.department_id = d.department_id;

SELECT * FROM myemp3;

DESC myemp3;

#创建一个表employees_copy，实现对employees表的复制，包括表数据
CREATE TABLE employees_copy
AS
SELECT * 
FROM employees;

SELECT * FROM employees_copy;

#创建一个表employees_blank，实现对employees表的复制，不包括表数据
CREATE TABLE employees_blank
AS
SELECT * 
FROM employees
WHERE FALSE;

SELECT * FROM employees_blank;

DROP TABLE employees_blank;

#修改表 --> ALTER TABLE
DESC myemp1;

#添加一个字段
ALTER TABLE myemp1
ADD salary DOUBLE(10, 2);	#默认添加到表中的最后一个字段位置

ALTER TABLE myemp1
ADD phone_number VARCHAR(20) FIRST;

ALTER TABLE myemp1
ADD email VARCHAR(45) AFTER emp_name;

#修改一个字段：数据类型、长度、默认值
ALTER TABLE myemp1
MODIFY emp_name VARCHAR(25);

ALTER TABLE myemp1
MODIFY emp_name VARCHAR(25) DEFAULT 'aaa';

#重命名字段
ALTER TABLE myemp1
CHANGE salary monthly_salary DOUBLE(10, 2);

ALTER TABLE myemp1
CHANGE email my_email VARCHAR(50);

#删除字段
ALTER TABLE myemp1
DROP COLUMN my_email;

#重命名表
#方式1：（建议）
RENAME TABLE myemp1
TO myemp11;

DESC myemp11;

#方式2：
ALTER TABLE myemp2
RENAME TO myemp12;

DESC myemp12;

#删除表
#不光将表结构删除，同时表中的数据也删除，释放表空间
DROP TABLE IF EXISTS myemp2;

DROP TABLE IF EXISTS myemp12;

#清空表
#清空表中的所有数据，但是表结构保留
SELECT * FROM employees_copy;

TRUNCATE TABLE employees_copy;

SELECT * FROM employees_copy;

DESC employees_copy;

#DCL中的 ONMMIT 和 ROLLBACK
#COMMIT：提交数据，一旦执行COMMIT，则数据就被永久地保存在数据库中，数据不可以回滚
#ROLLBACK：一旦执行ROLLBACK，则可以实现数据的回滚，回滚到最近的一次COMMIT后

#对比 TRUNCATE TABLE 和 DELETE FROM
#相同点：都可以实现对表中所有数据的删除，同时保留表结构
#不同点：
#	TRUNCATE TABLE：一旦执行此操作，表数据全部清楚，同时数据不可以回滚
# DELETE FROM：一旦执行此操作，表数据可以全部清楚（不带WHERE时），同时时数据可以实现回滚

/*
DDL 和 DML 的说明
DDL的操作一旦执行就不可回滚，指令SET autocommit = FLASE对DDL无效
DML的操作默认情况下一旦执行也是不可回滚的，但是如果在执行DML之前执行了
SET autocommit = FLASE，则执行的DML操作就可以实现回滚
*/

DROP TABLE myemp3;

CREATE TABLE myemp3
AS
SELECT *
FROM employees;

#演示DELETE FROM
#1)
COMMIT;
#2)
SELECT * 
FROM myemp3;
#3)
SET autocommit = FALSE;
#4)
DELETE FROM myemp3;
#5)
SELECT * 
FROM myemp3;
#6)
ROLLBACK;
#7)
SELECT * 
FROM myemp3;

#演示TRUNCATE TABLE
#1)
COMMIT;
#2)
SELECT * 
FROM myemp3;
#3)
SET autocommit = FALSE;
#4)
TRUNCATE TABLE myemp3;
#5)
SELECT * 
FROM myemp3;
#6)
ROLLBACK;
#7)
SELECT * 
FROM myemp3;

