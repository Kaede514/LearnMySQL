#关于属性：charcter set NAME
#创建数据库时指定字符集
CREATE DATABASE IF NOT EXISTS dbtest12 CHARACTER SET 'utf8';

SHOW CREATE DATABASE dbtest12;

#创建表的时候指明表的字符集
CREATE TABLE temp ( id INT ) CHARACTER SET 'utf8';

SHOW CREATE TABLE temp;

#创建表，指明表中的字段时，可以指定字段的字符集
CREATE TABLE temp1 ( id INT, NAME VARCHAR ( 15 ) CHARACTER SET 'gbk' );

SHOW CREATE TABLE temp1;

#整形数据类型
USE dbtest12;

CREATE TABLE test_int1 (
	f1 TINYINT, #1字节
	f2 SMALLINT, #2字节
	f3 MEDIUMINT, #3字节
	f4 INT, #INTEGER也可		#4字节
	f5 BIGINT #8字节
);

DESC test_int1;

INSERT INTO test_int1(f1) VALUES
(12),(-12),(-128),(127);

SELECT * FROM test_int1;

/*超出范围，报错
INSERT INTO test_int1(f1)
VALUES(128);
*/

CREATE TABLE test_int2(
	f1 INT,
	f2 INT ( 5 ), 
	f3 INT ( 5 ) ZEROFILL #显示宽度为5，当insert的值不足5位时，使用0填充
);

#当使用ZEROFILL时，自动会添加UNSIGNED
INSERT INTO test_int2 ( f1, f2, f3 ) VALUES
(123,123,123),(123456,123456,123456);

/*报错
INSERT INTO test_int2(f3) VALUES
(-123);
*/

SELECT * 
FROM test_int2;

SHOW CREATE TABLE test_int2;

CREATE TABLE test_int3(
	f1 INT UNSIGNED 
);

DESC test_int3;

INSERT INTO test_int3 (f1) VALUES
(241231);

INSERT INTO test_int3(f1) VALUES
(4294967295);

SELECT * 
FROM test_int3;

#浮点类型
CREATE TABLE test_double1(
	f1 FLOAT, 
	f2 FLOAT(5,2), 
	f3 DOUBLE, 
	f4 DOUBLE(5,2)
);

DESC test_double1;

INSERT INTO test_double1(f1,f2) VALUES
(123.45,123.45);

SELECT * 
FROM test_double1;

#存在四舍五入
INSERT INTO test_double1(f3,f4) VALUES
(123.45,123.456);

/*
Out of range value for column 'f4' at row 1
INSERT INTO test_double1(f3,f4)
VALUES(123.45,1234.456);
*/

/*
Out of range value for column 'f4' at row 1
INSERT INTO test_double1(f3,f4)
VALUES(123.45,999.995);
*/

#测试FLOAT和DOUBLE的精度问题
CREATE TABLE test_double2( 
	f1 DOUBLE
);
	
INSERT INTO test_double2 VALUES
(0.47),(0.44),(0.19);

SELECT SUM(f1) 
FROM test_double2;
	
SELECT SUM(f1) = 1.1, 1.1 = 1.1 
FROM test_double2;
	
#定点数类型
CREATE TABLE test_decimal1( 
	f1 DECIMAL, 
	f2 DECIMAL(5, 2) 
);

DESC test_decimal1;

INSERT INTO test_decimal1(f1) VALUES
(123),(123.456);
	
SELECT * 
FROM test_decimal1;
	
INSERT INTO test_decimal1(f2) VALUES
(999.99);
	
#存在四舍五入
INSERT INTO test_decimal1(f2) VALUES
(67.567);
	
/*
Out of range value for column 'f2' at row 1
INSERT INTO test_decimal1(f2)
VALUES(1267.567);	
*/

/*
Out of range value for column 'f2' at row 1
INSERT INTO test_decimal1(f2)
VALUES(999.995);	
*/

ALTER TABLE test_double2 
MODIFY f1 DECIMAL(5, 2);

DESC test_double2;

SELECT SUM(f1) 
FROM test_double2;

SELECT SUM(f1) = 1.1, 1.1 = 1.1 
FROM test_double2;
	
#位类型
CREATE TABLE test_bit1( 
	f1 BIT, 
	f2 BIT(5), 
	f3 BIT(64)
);

DESC test_bit1;

INSERT INTO test_bit1(f1) VALUES
(0),(1);
	
SELECT * 
FROM test_bit1;

/*
Data too long for column 'f1' at row 1
INSERT INTO test_bit1(f1)
VALUES(2);
*/

INSERT INTO test_bit1(f2) VALUES
(31);

/*
Data too long for column 'f1' at row 1
INSERT INTO test_bit1(f2)
VALUES(32);
*/

SELECT BIN(f1), BIN(f2), HEX(f1), HEX(f2) 
FROM test_bit1;
	
#此时+0以后，可以以十进制的方式来显示数据
SELECT f1 + 0, f2 + 0 
FROM test_bit1;
	
#YEAR类型(1901-2155)
CREATE TABLE test_year( 
	f1 YEAR, 
	f2 YEAR(4)
);

DESC test_year;

INSERT INTO test_year(f1) VALUES
('2021'),(2022);
	
SELECT * 
FROM test_year;
	
INSERT INTO test_year (f1) VALUES
('2155');

/*
Out of range value for column 'f1' at row 1
INSERT INTO test_year(f1)
VALUES('2156');
*/

INSERT INTO test_year (f1) VALUES
('69'),('70');
	
INSERT INTO test_year(f1) VALUES
(0),('00');
	
#DATE类型
CREATE TABLE test_date1(
	f1 DATE 
);

DESC test_date1;

INSERT INTO test_date1 VALUES
('2020-10-01'),('20201001'),(20201001);
	
INSERT INTO test_date1 VALUES
('00-01-01'),('000101'),('69-10-01'),('691001'),('70-10-01'),('701001');
	
INSERT INTO test_date1 VALUES
(000301),(690301),(700301),(990301);	#存在隐式转换

SELECT * 
FROM test_date1;

#TIME类型
#'D HH:MM:SS','HH:MM:SS','D HH:MM','HH:MM",'D HH','SS','HHMMSS',HHMMSS
CREATE TABLE test_time1(
	f1 TIME
);

DESC test_time1;

INSERT INTO test_time1 VALUES
('2 12:30:29'),('12:35:29'),('2 12:40'),('12:40'),('1 05'),('45');
	
INSERT INTO test_time1 VALUES
('123520'),(124011),(1210);
	
INSERT INTO test_time1 VALUES
(NOW()),(CURRENT_TIME()),(CURTIME());
	
SELECT * 
FROM test_time1;
	
#DATETIME类型
CREATE TABLE test_datetime1(
	dt DATETIME
);

DESC test_datetime1;

INSERT INTO test_datetime1 VALUES
('2021-01-01 00:00:00'),('20210101065030');
	
INSERT INTO test_datetime1 VALUES
('99-01-01 00:00:00'),('990101000000'),('20-01-01 00:00:00'),('20010100000');
	
INSERT INTO test_datetime1 VALUES
(20200101000000),(200101000000),(19990101000000),(990101000000);
	
INSERT INTO test_datetime1 VALUES
(NOW()),(CURRENT_TIMESTAMP());
	
SELECT * 
FROM test_datetime1;
	
#TIMESTAMP类型
CREATE TABLE test_timestamp1(
	dt TIMESTAMP
);

DESC test_timestamp1;

INSERT INTO test_timestamp1 VALUES
('2021-01-01 00:00:00'),('20210101065030');
	
INSERT INTO test_timestamp1 VALUES
('99-01-01 00:00:00'),('990101000000'),('20-01-01 00:00:00'),('20010100000');
	
INSERT INTO test_timestamp1 VALUES
(20200101000000),(200101000000),(19990101000000),(990101000000);
	
INSERT INTO test_timestamp1 VALUES
(NOW()),(CURRENT_TIMESTAMP());

/*
Incorrect datetime value
INSERT INTO test_timestamp1 VALUES
('2038-01-20 00:00:00');
*/

SELECT * 
FROM test_timestamp1;
	
#对比DATETIME和TIMESTAMP
CREATE TABLE temp_time( 
	d1 DATETIME, 
	d2 TIMESTAMP 
);

INSERT INTO temp_time VALUES
('2021-9-2 14:45:52', '2021-9-2 14:45:52');
	
INSERT INTO temp_time VALUES
(NOW(),NOW());

SELECT * 
FROM temp_time;
	
#修改当前的时区
SET time_zone = '+9:00';

SELECT * 
FROM temp_time;
	
#CHAR类型，()后面为字符个数，默认为1
CREATE TABLE test_char1( 
	c1 CHAR, 
	c2 CHAR(5)
);

DESC test_char1;

INSERT INTO test_char1(c1) VALUES
('a');
	
INSERT INTO test_char1(c2) VALUES
('ab'),('hello');
	
INSERT INTO test_char1 (c2) VALUES
('月亮'),('月亮和太阳');

/*
Data too long
INSERT INTO test_char1(c2) VALUES
('月亮太阳星星');
*/

SELECT * 
FROM test_char1;
	
SELECT CONCAT(c2, '***') 
FROM test_char1;
	
INSERT INTO test_char1 (c2) VALUES
('ab   ');
	
SELECT CHAR_LENGTH(c2) 
FROM test_char1;	#VARCHAR类型，()后为字节个数，无默认，必须指定

/*
CREATE TABLE test_varchar1(
	name VARCHAR	#报错
);
/*

/*
Column length too big for column 'name' (max = 21845); use BLOB or TEXT instead
CREATE TABLE test_varchar2(
	name VARCHAR(65535) #一个汉字占3个字节
);
*/

CREATE TABLE test_varchar3( 
	NAME VARCHAR(5)
);

INSERT INTO test_varchar3(NAME) VALUES
('月亮'),('月亮和太阳');

/*
Data too long
INSERT INTO test_varchar3(name) VALUES
('月亮太阳星星');
*/

SELECT * 
FROM test_varchar3;
	
#TEST类型
CREATE TABLE test_text( 
	tx TEXT
);

INSERT INTO test_text VALUES
('atguigu   ');
	
SELECT CHAR_LENGTH( tx ) 
FROM test_text;
	
#ENUM类型
CREATE TABLE test_enum( 
	season ENUM ('春', '夏', '秋', '冬', 'unknow')
);

SELECT * 
FROM test_enum;
	
INSERT INTO test_enum VALUES
('春'),('秋');
	
/*
Data truncated for column 'season' at row 1
INSERT INTO test_enum	VALUES
('季');
*/

/*
Column count doesn't match value count at row 1
INSERT INTO test_enum	VALUES
('春','秋');
*/

INSERT INTO test_enum VALUES
('unknow');
	
#忽略大小写的
INSERT INTO test_enum VALUES
('UNKNOW');
	
#可以使用索引进行枚举元素的调用
INSERT INTO test_enum VALUES
(1),('3');
	
#没有限制非空的情况下，可以添加NULL值
INSERT INTO test_enum VALUES
(NULL);

SELECT * 
FROM test_enum;
	
#SET类型
CREATE TABLE test_set( 
	s SET('A', 'B', 'C')
);

INSERT INTO test_set (s) VALUES
('A'),('A,B');
	
#插入重复的SET成员时，MySQL会自动删除重复的元素
INSERT INTO test_set(s) VALUES
('A,B,C,A');

/*
#向SET类型的字段插入SET成员中不存在的值时，MySQL会报错
INSERT INTO test_set(s) VALUES
('A,B,C,D');
*/

SELECT * 
FROM test_set;

CREATE TABLE temp_mul( 
	gender ENUM('男', '女'), 
	hobby SET('玩游戏', '睡觉', '写代码'));

INSERT INTO temp_mul VALUES
('男', '睡觉,玩游戏');

SELECT * 
FROM temp_mul;
	
#BINARY和VARBINARY类型
CREATE TABLE test_binary( 
	f1 BINARY, 
	f2 BINARY(3), 
	#f3 VARBINARY,
	f4 VARBINARY(10)
);

DESC test_binary;

INSERT INTO test_binary(f1, f2) VALUES
('a', 'abc');
	
SELECT * 
FROM test_binary;
	
/*
Data too long
INSERT INTO test_binary(f1) VALUES
('ab');
*/

INSERT INTO test_binary(f2, f4) VALUES
('ab', 'ab');

SELECT LENGTH(f2), LENGTH(f4) 
FROM test_binary;
	
#BLOB类型
CREATE TABLE test_blob1( 
	id INT, 
	img MEDIUMBLOB
);

INSERT INTO test_blob1 (id) VALUES
(1001);

SELECT * 
FROM test_blob1； 

#JSON类型
CREATE TABLE test_json( 
	js JSON
);

INSERT INTO test_json VALUES
('{"name":"songhk","age":18,"address":{"province":"beijing","city":"beijing"}}');

SELECT * 
FROM test_json;

SELECT
	js -> '$.name' AS NAME,
	js -> '$.age' AS age,
	js -> '$.address.province' AS province,
	js -> '$.address.city' AS city 
FROM test_json;
	
