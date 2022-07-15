USE atguigudb;

#算术运算符：+ - * / DIV % MOD
SELECT 100, 100 + 0, 100 - 1, 100 + 35.5, 100 - 35.5
FROM DUAL;

#在SQL中，+没有连接的作用，就表示加法运算
#此时会把字符串转换为数值（隐式转换）
SELECT 100 + '1' FROM DUAL;	

SELECT 100 + 'a' FROM DUAL;		#此时将'a'看作0处理

SELECT 100 + NULL FROM DUAL;	#NULL值参与运算，结果为NULL
SELECT 100 + 'NULL' FROM DUAL;

SELECT 100 * 1, 100 * 1.0, 100 / 1.0, 100 / 2, 
100 / 3, 100 DIV 3, 100% 3, 100 MOD 3
FROM DUAL;

#取模运算，结果符号和被膜数相同
SELECT 12 % 3, 12 % 5, 12 % -5, -12 % 5, -12 % -5
FROM DUAL;

#查询员工id为偶数的员工信息
SELECT employee_id, last_name, salary
FROM employees
WHERE employee_id % 2 = 0;

#比较运算符
#= <=> <> != < <= > >=
#运算符两边都是字符串的话会按ANSI的比较规则进行比较
SELECT 1 = 2, 1 != 2, 0 = 'a', 1 != 'a', 'ab' = 'ab', 'a' = 'b'
FROM DUAL;

#只要有NULL参与运算，结果就为NULL
SELECT last_name, employee_id, salary
FROM employees
#WHERE salary = 6000
WHERE commission_pct = NULL;

#<=>，安全等于在两边都为NULL时返回1
SELECT last_name, employee_id, salary
FROM employees
#WHERE salary = 6000
WHERE commission_pct <=> NULL;

SELECT 3 <> 2, NULL = NULL, '4' <> NULL
FROM DUAL;

#NULL \ IS NOT NULL \ IS NULL
SELECT last_name, employee_id, salary
FROM employees
#WHERE commission_pct IS NULL;
WHERE commission_pct IS NOT NULL;

SELECT last_name, employee_id, salary
FROM employees
WHERE ISNULL(commission_pct);

SELECT last_name, employee_id, salary
FROM employees
#WHERE salary = 6000
WHERE NOT commission_pct <=> NULL;

SELECT LEAST('m','j','s','b'), GREATEST('e','b','t')
FROM DUAL;

SELECT LEAST(first_name,last_name),LEAST(LENGTH(first_name),LENGTH(last_name))
FROM employees;

#查询工资在6000到8000的员工信息
SELECT last_name, employee_id, salary
FROM employees
#WHERE salary >= 6000 && salary <=8000;
WHERE salary BETWEEN 6000 AND 8000;

#查询不到工资在8000到6000的员工信息
SELECT last_name, employee_id, salary
FROM employees
WHERE salary BETWEEN 8000 AND 6000;

#查询工资在6000到8000的员工信息
SELECT last_name, employee_id, salary
FROM employees
#WHERE salary < 6000 && salary > 8000;
#WHERE NOT salary BETWEEN 6000 AND 8000;
WHERE salary NOT BETWEEN 6000 AND 8000;

SELECT last_name, employee_id, salary, department_id
FROM employees
#WHERE department_id = 10 OR department_id = 20 OR department_id = 30;
WHERE department_id IN (10, 20, 30);

SELECT last_name, employee_id, salary, department_id
FROM employees
WHERE department_id NOT IN (10, 20, 30);

# LIKE：模糊查询
# %：代表不确定个数的字符（0个，1个或多个）
#查询last_name中包含字符'a'的员工信息
SELECT last_name
FROM employees
WHERE last_name LIKE '%a%';

#查询last_name中以字符'a'开头的员工信息
SELECT last_name
FROM employees
WHERE last_name LIKE 'a%';

#查询last_name中包含字符'a'和'e'的员工信息
SELECT last_name
FROM employees
WHERE last_name LIKE '%a%' AND last_name LIKE '%e%';
#或
SELECT last_name
FROM employees
WHERE last_name LIKE '%a%e%' OR last_name LIKE '%e%a%';

#_：代表一个不确定的字符
#查询第3个字符是'a'的员工信息
SELECT last_name
FROM employees
WHERE last_name LIKE '__a%';

#查询第2个字符是_第3个字符是'a'的员工信息
#需要用到转义字符：\
SELECT last_name
FROM employees
WHERE last_name LIKE '_\_a%';
#或者（了解）
SELECT last_name
FROM employees
WHERE last_name LIKE '_$_a%' ESCAPE '$';

#正则表达式
SELECT 'shkstart' REGEXP '^shk', 'shkstart' REGEXP 't$', 'shkstart' REGEXP 'hk'
FROM DUAL;

SELECT 'atguigu' REGEXP 'gu.gu', 'atguigu' REGEXP '[ab]'
FROM DUAL;

#逻辑运算符：AND && OR || NOT ! XOR
#AND的优先级高于OR
#XOR
SELECT last_name, department_id, salary
FROM employees
WHERE department_id = 50 XOR salary > 6000;

#位运算符：& | ^ ~ >> <<
SELECT 12 & 5, 12 | 5, ~1, 12 ^ 5, 7 >> 1, 3 << 2
FROM DUAL;