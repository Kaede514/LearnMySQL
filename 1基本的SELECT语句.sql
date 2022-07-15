#USE dbtest1;

#SELECT * FROM employees;

#字符串、日期时间类型的变量需要使用一对''括起来

USE atguigudb;

#最基本的SELECT语句：SELECT 字段1,字段2... FROM 表名 
SELECT 1 + 2, 3 * 4;  

SELECT 1 + 2, 3 * 4 FROM DUAL;	#DUAL伪表

SELECT * FROM employees;

SELECT employee_id,last_name,salary
FROM employees;

#列的别名
#列的别名可以使用一对双引号""括起来
SELECT employee_id emp_id,last_name AS lname,salary * 12 "year salary"
FROM employees;

#去除重复行
SELECT DISTINCT department_id 
FROM employees;

SELECT salary, department_id 
FROM employees;

#报错
/*
SELECT salary,DISTINCT department_id 
FROM employees;
*/

#去重，两项都相同才算重复
SELECT DISTINCT salary, department_id 
FROM employees;

#空值参与运算，结果一定为空
#空值：NULL，不等同于0，''，'NULL'
SELECT employee_id,salary "月工资",salary * (1+commission_pct) * 12 "年工资",commission_pct
FROM employees;

SELECT employee_id,salary "月工资",salary * (1+IFNULL(commission_pct,0)) * 12 "年工资",commission_pct
FROM employees;

#着重号``  关键字重名
SELECT * FROM `order`;

#查询常数
SELECT '枫',123,employee_id,last_name
FROM employees;

#显示表结构：DESCRIBE/DESC
DESC employees;	#显示表中字段的详细信息

#过滤数据
#查询90号部门的员工信息
SELECT * 
FROM employees
#过滤条件
WHERE department_id = 90;

SELECT * 
FROM employees
WHERE last_name = "King";










