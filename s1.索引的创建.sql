#索引的创建

#CREATE TABLE
#隐式的方式创建索引：在声明有主键约束、唯一性约束、外键约束的字段
#上会自动的添加相关的索引

CREATE DATABASE dbtest2;

USE dbtest2;

CREATE TABLE dept(
		dept_id INT PRIMARY KEY AUTO_INCREMENT,
		dept_name VARCHAR(20)
);

CREATE TABLE emp(
		emp_id INT PRIMARY KEY AUTO_INCREMENT,
		emp_name VARCHAR(20) UNIQUE,
		dept_id INT,
		CONSTRAINT emp_dept_id_fk FOREIGN KEY(dept_id) REFERENCES dept(dept_id)
);

SHOW INDEX FROM dept;

SHOW INDEX FROM emp;


#显示的方式创建
#创建普通的索引：
CREATE TABLE book(
		book_id INT,
		book_name VARCHAR(100),
		authors VARCHAR(100),
		info VARCHAR(100),
		comment VARCHAR(100),
		year_publication YEAR,
		#声明索引
		INDEX idx_bname(book_name)
);

SHOW CREATE TABLE book;

SHOW INDEX FROM book;

#性能分析工具：EXPLAIN
EXPLAIN SELECT * FROM book WHERE book_name = '';

#创建唯一索引：
#声明有唯一性索引的字段，在添加数据时，要保证唯一性，但是可以添加NULL
CREATE TABLE book1(
		book_id INT,
		book_name VARCHAR(100),
		authors VARCHAR(100),
		info VARCHAR(100),
		comment VARCHAR(100),
		year_publication YEAR,
		#声明索引
		UNIQUE INDEX uk_idx_cmt(comment)
);

SHOW INDEX FROM book1;

#主键索引：
#通过定义主键约束的方式定义主键索引
CREATE TABLE book2(
		book_id INT PRIMARY KEY AUTO_INCREMENT,
		book_name VARCHAR(100),
		authors VARCHAR(100),
		info VARCHAR(100),
		comment VARCHAR(100),
		year_publication YEAR
);

SHOW INDEX FROM book2;

#通过删除主键约束的方式删除主键的索引
/*
删除失败，因为声明为AUTO_INCREMENT的字段必须有主键约束或唯一性约束
ALTER TABLE book2
DROP PRIMARY KEY;
*/

DROP TABLE book2;

CREATE TABLE book2(
		book_id INT PRIMARY KEY,
		book_name VARCHAR(100),
		authors VARCHAR(100),
		info VARCHAR(100),
		comment VARCHAR(100),
		year_publication YEAR
);

ALTER TABLE book2
DROP PRIMARY KEY;

#创建单列索引
CREATE TABLE book3(
		book_id INT,
		book_name VARCHAR(100),
		authors VARCHAR(100),
		info VARCHAR(100),
		comment VARCHAR(100),
		year_publication YEAR,
		#声明索引
		UNIQUE INDEX idx_bname(book_name)
);

SHOW INDEX FROM book3;

#创建联合索引
CREATE TABLE book4(
		book_id INT,
		book_name VARCHAR(100),
		authors VARCHAR(100),
		info VARCHAR(100),
		comment VARCHAR(100),
		year_publication YEAR,
		#声明索引
		INDEX mul_bid_bname_binfo(book_id,book_name,info)
);

SHOW INDEX FROM book4;

EXPLAIN SELECT * FROM book4 WHERE book_id = 1001 AND book_name = 'mysql';

EXPLAIN SELECT * FROM book4 WHERE book_name = 'mysql';

#创建全文索引（了解即可）
CREATE TABLE test4(
		id INT NOT NULL,
		name CHAR(30) NOT NULL,
		age INT NOT NULL,
		info VARCHAR(255),
		FULLTEXT INDEX futxt_idx_info(info(50))
);

SHOW INDEX FROM test4;


#在已经存在的表上创建索引
CREATE TABLE book5(
		book_id INT,
		book_name VARCHAR(100),
		authors VARCHAR(100),
		info VARCHAR(100),
		comment VARCHAR(100),
		year_publication YEAR
);

SHOW INDEX FROM book5;

#方式1：ALTER TABLE... ADD...
ALTER TABLE book5
ADD INDEX idx_cmt(comment);

ALTER TABLE book5
ADD UNIQUE uk_idx_bname(book_name);	#UNIQUE INDEX也可

ALTER TABLE book5
ADD INDEX mul_bid_bname_info(book_id,book_name,info);

SHOW INDEX FROM book5;

#方式2：CREATE INDEX... ON...
CREATE TABLE book6(
		book_id INT,
		book_name VARCHAR(100),
		authors VARCHAR(100),
		info VARCHAR(100),
		comment VARCHAR(100),
		year_publication YEAR
);

CREATE INDEX id_cmt ON book6(comment);

CREATE UNIQUE INDEX uk_idx_bname ON book6(book_name);

SHOW INDEX FROM book6;




