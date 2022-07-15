#变量：系统变量（全局系统变量、会话系统变量） vs 用户自定义变量

#查看系统变量
#查询全局系统变量
SHOW GLOBAL VARIABLES;

#查询会话系统变量
SHOW SESSION VARIABLES;

#默认查询的是会话系统变量
SHOW VARIABLES;

#查询部分系统变量
SHOW GLOBAL VARIABLES LIKE 'admin_%';

SHOW VARIABLES LIKE 'character_%';

#查看指定系统变量
SELECT @@global.max_connections;

SELECT @@global.character_set_client;

#错误：
/*
SELECT @@global.pseudo_thread_id;
*/

#错误：
/*
SELECT @@session.max_connections;
*/

SELECT @@session.character_set_client;


SELECT @@session.pseudo_thread_id;

#优先查询会话系统变量，再查询全局系统变量
SELECT @@character_set_client;

#修改系统变量的值
#全局系统变量：
#方式1：
SET @@global.max_connections = 161;

#方式2：
SET GLOBAL max_connections = 151;

#全局系统变量，针对当前的数据库实例是有效的，一旦重启MySQL服务就失效了，会自动恢复为默认的

#会话系统变量：
#方式1：
SET @@session.character_set_client = 'gbk';

#方式2：
SET SESSION character_set_client = 'utf8mb4';

#针对当前会话是有效的，一旦结束会话，重新建立起新的会话就失效了，会自动恢复为默认的

#用户变量：会话用户变量 vs 局部变量
#会话用户变量：使用＂＠＂开头，作用域为当前会话
＃局部变量：只能在存储过程和存储函数中的

＃会话用户变量
/*
变量的声明和赋值
方式1："="或":="
SET @用户变量 = 值；
SET @用户变量 := 值；

方式2：":="或INTO关键字
SELECT @用户变量 := 表达式 [FROM 等子句]
SELECT 表达式 INTO @用户变量 [FROM 等子句]

使用
SELECT @变量名；
*/

#准备工作
CREATE DATABASE dbtest16;

USE dbtest16;

CREATE TABLE employees
AS
SELECT *
FROM atguigudb.employees;

CREATE TABLE departments
AS
SELECT *
FROM atguigudb.departments;

/*
DROP TABLE employees;
*/

#方式1：
SET @m1 = 1;
SET @m2 := 2;
SET @sum := @m1 + @m2;

SELECT @sum;

#方式2：
SELECT @count := COUNT(*) FROM employees;

SELECT @count;

SELECT AVG(salary) INTO @avg_sal FROM employees;

SELECT @avg_sal;


#局部变量
/*
局部变量必须使用DECLARE声明，声明使用在BEGIN... END中的首行

声明格式：
DECLARE 变量名 类型 [DEFAULT 值];	#如果没有DEFAULT子句，初始值为NULL

#赋值：
方式1：
SET 变量名 = 值；
SET 变量名 := 值；

方式2：":="或INTO关键字
SELECT 字段名或表达式 INTO 变量名 [FROM 等子句]

使用：
SELECT 局部变量名；
*/

DELIMITER $
CREATE PROCEDURE test_var()
BEGIN
		#声明局部变量
		DECLARE a INT DEFAULT 0;
		DECLARE b INT;
		#DECLARE a, b INT DEFAULT 0;
		DECLARE emp_name VARCHAR(25);
		
		#赋值
		SET a = 1;
		SET b := 2;
		SELECT last_name INTO emp_name
		FROM employees
		WHERE employee_id = 101;
		
		#使用
		SELECT a, b, emp_name;
END $
DELIMITER ;

CALL test_var();
DROP PROCEDURE test_var;

#声明两个变量，求和并打印（分别使用会话用户变量、局部变量的方式解决）
#方式1：使用会话用户变量
SET @v1 = 10;
SET @v2 = 20;
SET @result = @v1 + @v2;
SELECT @result;

#方式2：使用局部变量
DELIMITER $
CREATE PROCEDURE add_value()
BEGIN
		DECLARE value1, value2, sum_val INT;
		SET value1 = 10;
		SET value2 = 20;
		SET sum_val = value1 + value2;
		
		SELECT sum_val;	#SELECT value1 + value2;
END $
DELIMITER ;

CALL add_value();

#创建存储过程"different_salary"查询员工和他领导的薪资差距，并用IN参数emp_id接收
#员工id，用OUT参数dif_sal输出薪资差距结果
DELIMITER $
CREATE PROCEDURE different_salary(IN emp_id INT, OUT dif_sal DOUBLE)
BEGIN
		DECLARE emp_sal, mgr_sal DOUBLE DEFAULT 0;
		
		SELECT salary INTO emp_sal
		FROM employees
		WHERE employee_id = emp_id;
	
		SELECT salary INTO mgr_sal
		FROM employees
		WHERE employee_id = (
						SELECT manager_id
						FROM employees
						WHERE employee_id = emp_id
		);
		
		SET dif_sal = mgr_sal - emp_sal;
END $
DELIMITER ;

SET @emp_id = 102;
CALL different_salary(@emp_id, @dif_sal);
SELECT @dif_sal;

CALL different_salary(102, @sal);
SELECT @sal;


#流程控制
#分支结构之 IF
DELIMITER $
CREATE PROCEDURE test_if1()
BEGIN
				DECLARE stu_name VARCHAR(15);
				
				IF stu_name IS NULL 
						THEN SELECT 'stu_name is NULL';
				END IF;
END $
DELIMITER ;

CALL test_if1();

DELIMITER $
CREATE PROCEDURE test_if2()
BEGIN
				DECLARE email VARCHAR(25);
				
				IF email IS NULL 
						THEN SELECT 'email is NULL';
				ELSE
						SELECT 'email is not NULL';
				END IF;
END $
DELIMITER ;

CALL test_if2();

DELIMITER $
CREATE PROCEDURE test_if3()
BEGIN
				DECLARE age INT DEFAULT 20;
				
				IF age > 40 
						THEN SELECT '中老年';
				ELSEIF age > 30
						THEN SELECT '青壮年';
				ELSEIF age > 8
						THEN SELECT '青少年';
				ELSE
						SELECT '婴幼儿';
				END IF;
END $
DELIMITER ;

CALL test_if3();

#声明存储过程"update_salary_by_eid"，定义IN参数emp_id，输入员工编号，
#判断该员工薪资如果低于9000元，就更新为9000元；薪资如果大于等于9000元
#且低于10000元，但是奖金比例为NULL的，就更新奖金比例为0.01；其他的薪资涨100元
DELIMITER $
CREATE PROCEDURE update_salary_by_eid(IN emp_id INT)
BEGIN	
				#声明变量
				DECLARE emp_sal DOUBLE;
				DECLARE bonus DOUBLE;
				
				#赋值
				SELECT salary, commission_pct INTO emp_sal, bonus
				FROM employees 
				WHERE employee_id = emp_id;
				
				#判断
				IF emp_sal < 9000
						THEN UPDATE employees SET salary = 9000 WHERE employee_id = emp_id;
				ELSEIF emp_sal < 10000 AND bonus IS NULL
						THEN UPDATE employees SET commission_pct = 0.01 WHERE employee_id = emp_id;
				ELSE
						UPDATE employees SET salary = salary + 100 WHERE employee_id = emp_id;
				END IF;
END $
DELIMITER ;

SELECT * FROM employees;

CALL update_salary_by_eid(102);
CALL update_salary_by_eid(103);
CALL update_salary_by_eid(104);

SELECT employee_id, salary, commission_pct
FROM employees
WHERE employee_id IN (102, 103, 104);


#分支结构之 CASE
#CASE... WHEN... THEN... END CASE;
DELIMITER $
CREATE PROCEDURE test_case1()
BEGIN
				DECLARE var INT DEFAULT 2;
				
				CASE var WHEN 1 THEN SELECT 'var = 1';
								 WHEN 2 THEN SELECT 'var = 2';
								 WHEN 3 THEN SELECT 'var = 3';
								 ELSE SELECT 'other value';
			  END CASE;
END $
DELIMITER ;

CALL test_case1();

#CASE WHEN... THEN... END CASE;
DELIMITER $
CREATE PROCEDURE test_case2()
BEGIN
				DECLARE var INT DEFAULT 10;
				
				CASE  WHEN var >= 100 THEN SELECT '三位数';
						  WHEN var >= 10 THEN SELECT '二位数';
					  	ELSE SELECT '个位数';
			  END CASE;
END $
DELIMITER ;

CALL test_case2();

#声明存储过程"update_salary_by_eid1"，定义IN参数emp_id，输入员工编号，
#判断该员工薪资如果低于9000元，就更新为9000元；薪资如果大于等于9000元
#且低于10000元，但是奖金比例为NULL的，就更新奖金比例为0.01；其他的薪资涨100元
DELIMITER $
CREATE PROCEDURE update_salary_by_eid1(IN emp_id INT)
BEGIN
				DECLARE emp_sal DOUBLE;
				DECLARE bonus DOUBLE;
				
				SELECT salary, commission_pct INTO emp_sal, bonus
				FROM employees 
				WHERE employee_id = emp_id;
				
				CASE WHEN emp_sal < 9000 THEN UPDATE employees SET salary = 9000 WHERE employee_id = emp_id;
						 WHEN emp_sal < 10000 AND bonus IS NULL THEN UPDATE employees SET commission_pct = 0.01 WHERE employee_id = emp_id;
						 ELSE UPDATE employees SET salary = salary + 100 WHERE employee_id = emp_id;
			  END CASE;
END $
DELIMITER ;

SELECT * FROM employees;

CALL update_salary_by_eid1(103);
CALL update_salary_by_eid1(104);
CALL update_salary_by_eid1(105);

SELECT employee_id, salary, commission_pct
FROM employees
WHERE employee_id IN (103, 104, 105);

#循环结构

#循环结构之 LOOP
/*
[loop_label:] LOOP
				循环执行的语句
END LOOP [loop_label]
*/

DELIMITER $
CREATE PROCEDURE test_loop()
BEGIN
				DECLARE num INT DEFAULT 1;
				
				loop_label1:LOOP
								SET num = num + 1;
								IF num >= 10 THEN LEAVE loop_label1;
								END IF;
				END LOOP loop_label1;
				
				SELECT num;
END $
DELIMITER ;

CALL test_loop();

#声明存储过程"update_salary_loop()"，声明OUT参数num，输出循环次数。存储过程中实现
#循环给大家涨薪，薪资涨为原来的1.1倍，直到全公司的平均薪资到达12000结束，并统计循
#环次数。
DELIMITER $
CREATE PROCEDURE update_salary_loop(OUT num INT)
BEGIN
				DECLARE avg_sal DOUBLE;
				DECLARE loop_count INT DEFAULT 0;
				
				SELECT AVG(salary) INTO avg_sal FROM employees;
				
				loop_lab:LOOP
								IF avg_sal > 12000 THEN LEAVE loop_lab;
								END IF;
								
								UPDATE employees SET salary = salary * 1.1;
								
								SET loop_count = loop_count + 1;
								
								SELECT AVG(salary) INTO avg_sal FROM employees;
				END LOOP loop_lab;
				
				SET num = loop_count;
END $
DELIMITER ;

SELECT AVG(salary) FROM employees;
 
SET @num = 10;
CALL update_salary_loop(@num);

SELECT @num;

SELECT AVG(salary) FROM employees;


#循环结构之 WHILE
/*
[while_label:]WHILE 循环条件 DO
				循环体
END WHILE [while_label];
*/

DELIMITER $
CREATE PROCEDURE test_while()
BEGIN
				DECLARE num INT DEFAULT 1;
				
				WHILE num <= 10 DO
								#循环体（略）
								
								#迭代条件
								SET num = num +1;
				END WHILE;
				
				SELECT num;
END $
DELIMITER ;

CALL test_while();

#声明存储过程"update_salary_while()"，声明OUT参数num，输出循环次数。存储过程中实现
#循环给大家降薪，薪资降为原来的0.9倍，直到全公司的平均薪资到达5000结束，并统计循
#环次数。
DELIMITER $
CREATE PROCEDURE update_salary_while(OUT num INT)
BEGIN
				DECLARE avg_sal DOUBLE;
				DECLARE while_count INT DEFAULT 0;
				
				SELECT AVG(salary) INTO avg_sal FROM employees;
				
				WHILE avg_sal > 5000 DO
								UPDATE employees SET salary = salary * 0.9;
								SET while_count = while_count + 1;
								SELECT AVG(salary) INTO avg_sal FROM employees;
				END WHILE;
				
				SET num = while_count;
END $
DELIMITER ;

SELECT AVG(salary) FROM employees;
 
SET @num = 10;
CALL update_salary_while(@num);

SELECT @num;

SELECT AVG(salary) FROM employees;


#循环结构之 REPEAT
/*
[repeat_label:]REPEAT
				循环体语句
UNTIL 结束循环表达式
END REPEAT [repeat_label];
*/

DELIMITER $
CREATE PROCEDURE test_repeat()
BEGIN
				DECLARE num INT DEFAULT 1;
				
				REPEAT
								#循环体（略）
								
								#迭代条件
								SET num = num +1;
				UNTIL num >= 10
				END REPEAT;
				
				SELECT num;
END $
DELIMITER ;

CALL test_repeat();

#声明存储过程"update_salary_repeat()"，声明OUT参数num，输出循环次数。存储过程中实现
#循环给大家涨薪，薪资涨为原来的1.15倍，直到全公司的平均薪资到达13000结束，并统计循
#环次数。
DELIMITER $
CREATE PROCEDURE update_salary_repeat(OUT num INT)
BEGIN
				DECLARE avg_sal DOUBLE;
				DECLARE repeat_count INT DEFAULT 0;
				
				SELECT AVG(salary) INTO avg_sal FROM employees;
				
				REPEAT
								UPDATE employees SET salary = salary * 1.15;
								SET repeat_count = repeat_count + 1;
								SELECT AVG(salary) INTO avg_sal FROM employees;
				UNTIL avg_sal > 13000
				END REPEAT;
				
				SET num = repeat_count;
END $
DELIMITER ;

SELECT AVG(salary) FROM employees;
 
SET @num = 10;
CALL update_salary_repeat(@num);

SELECT @num;

SELECT AVG(salary) FROM employees;


/*
凡是循环结构，一定具备四个要素：
1、初始化条件
2、循环条件
3、循环体（可略）
4、迭代条件
*/


#这三种循环都可以省略名称，但如果循环中添加了循环控制语句（LEAVE 或 ITERATE）
#则必须添加名称

#LOOP：一般用与实现简单的“死循环”（通过LEAVE跳出）
#WHILE：先判断后执行
#REPEAT：先执行后判断，无条件至少执行一次


#LEAVE的使用

#创建存储过程"leave_begin()"，声明INT类型的IN参数num。给BEGIN... END加标记名，并在
#BEGIN... END中使用IF语句判断num参数的值
#如果num<=0，则使用LEAVE语句退出BEGIN... END；
#如果num=1，则查询"employees"表的平均薪资；
#如果num=2，则查询"employees"表的最低薪资；
#如果num>=3，则查询"employees"表的最高薪资。
#IF语句结束后查询"employees"表的总人数。

DELIMITER $
CREATE PROCEDURE leave_begin(IN num INT)
begin_label:BEGIN
				IF num <= 0
						THEN LEAVE begin_label;
				ELSEIF num = 1
						THEN SELECT AVG(salary) FROM employees;
				ELSEIF num = 2
						THEN SELECT MIN(salary) FROM employees;
				ELSE
						SELECT MAX(salary) FROM employees;
				END IF;
				
				SELECT COUNT(*) FROM employees;
END $
DELIMITER ;

CALL leave_begin(0);
CALL leave_begin(1);
CALL leave_begin(2);
CALL leave_begin(3);

#声明存储过程"leave_while()"，声明OUT参数num，输出循环次数。存储过程中使用WHILE
#循环给大家降薪，薪资降为原来的0.9倍，直到全公司的平均薪资小于等于10000结束，并统计循
#环次数。
DELIMITER $
CREATE PROCEDURE leave_while(OUT num INT)
BEGIN
				DECLARE avg_sal DOUBLE;
				DECLARE while_count INT DEFAULT 0;
				
				SELECT AVG(salary) INTO avg_sal FROM employees;
				
				while_label:WHILE TRUE DO
								IF avg_sal <= 10000
										THEN LEAVE while_label;
								END IF;
									
								UPDATE employees SET salary = salary * 0.9;
								SET while_count = while_count + 1;
								
								SELECT AVG(salary) INTO avg_sal FROM employees;
				END WHILE;
				
				SET num = while_count;
END $
DELIMITER ;

CALL leave_while(@num);
SELECT @num;


#ITERATE的使用（只能使用在循环中）

#定义局部变量num，初始值为0，循环结构中执行num + 1操作
#如果num < 10，则继续执行循环
#如果num > 15，则退出循环结构

DELIMITER $
CREATE PROCEDURE test_iterate()
BEGIN 
				DECLARE num INT DEFAULT 0;
				
				loop_label:LOOP
								SET num = num + 1;
							  
								IF num < 10
										THEN ITERATE loop_label;
								ELSEIF num > 15
										THEN LEAVE loop_label;
								END if;
								
								SELECT 'LUNAR';
				END LOOP;
END $
DELIMITER ;

CALL test_iterate();


#游标的使用
/*
1、声明游标
2、打开游标
3、使用游标（从游标中获取数据）
4、关闭游标
*/

#创建存储过程"get_count_by_limit_total_salary()"，声明IN参数 limit_total_salary
#DOUBLE类型，声明OUT参数 total_count INT类型，函数的功能可以实现累加薪资最高的
#几个员工的薪资值，直到薪资总和达到limit_total_salary参数的值，返回累加的人数给
#total_count

DELIMITER $
CREATE PROCEDURE get_count_by_limit_total_salary(IN limit_total_salary DOUBLE, OUT total_count INT)
BEGIN
				DECLARE sum_sal DOUBLE DEFAULT 0;
				DECLARE emp_sal DOUBLE;
				DECLARE emp_count INT DEFAULT 0;
				
				#声明游标
				DECLARE emp_cursor CURSOR FOR SELECT salary 
				FROM employees ORDER BY salary DESC; 
				
				#打开游标
				OPEN emp_cursor;
				
				WHILE sum_sal < limit_total_salary DO
								#使用游标
								FETCH emp_cursor INTO emp_sal;
								
								SET sum_sal = sum_sal + emp_sal;
								SET emp_count = emp_count + 1;
				END WHILE;
				
				SET total_count = emp_count;
				#关闭游标
				CLOSE emp_cursor;
END $
DELIMITER ;

CALL get_count_by_limit_total_salary(200000, @total_count);
SELECT @total_count;




