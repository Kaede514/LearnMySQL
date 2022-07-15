USE atguigudb;

#AVG、SUM
SELECT
	AVG(salary),
	SUM(salary),
	AVG(salary) * 107
FROM
	employees;

#以下操作没有意义
SELECT
	AVG(salary),
	SUM(last_name),
	SUM(hire_date)
FROM
	employees;

#MAX、MIN：适用于数值类型、字符串、日期类型的字段或变量
SELECT
	MAX(salary),
	MIN(salary)
FROM
	employees;

SELECT
	MAX(last_name),
	MIN(last_name),
	MAX(hire_date),
	MIN(hire_date)
FROM
	employees;

#COUNT
#计算指定字段在查询结构中出现的个数（不包含NULL值）
SELECT
	*
FROM
	employees;

SELECT
	COUNT(employee_id),
	COUNT(salary),
	COUNT(1),
	COUNT(*)
FROM
	employees;

#计算表中有多少条记录，实现方式如下
#方式1：COUNT(*)
#方式2：COUNT(1)
#方式3：COUNT(具体字段) （不一定对）
SELECT
	COUNT(commission_pct)
FROM
	employees;

#AVG = SUM / COUNT
#AVG和SUM在计算时会忽略NULL值
SELECT
	AVG(salary),
	SUM(salary) / COUNT(salary),
	AVG(commission_pct),
	SUM(commission_pct) / COUNT(commission_pct),
	SUM(commission_pct) / 107
FROM
	employees;

#查询公司中员工的平均奖金率
#错误的
SELECT
	AVG(commission_pct)
FROM
	employees;

#正确的，没有奖金率（即奖金率为NULL）的应当作为0算入
SELECT
	SUM(commission_pct) / COUNT(IFNULL(commission_pct, 0))
FROM
	employees;

#在MySQL中，统计表中记录的效率：
#	COUNT(*) = COUNT(1) > COUNT(字段)
#GROUP BY 的使用
#查询各个部门的平均工资、最高工资
SELECT
	department_id,
	AVG(salary),
	MAX(salary)
FROM
	employees
GROUP BY
	department_id;

#查询各个department_id,job_id的平均工资
SELECT
	department_id,
	job_id,
	AVG(salary)
FROM
	employees
GROUP BY
	department_id,
	job_id;

#或
SELECT
	department_id,
	job_id,
	AVG(salary)
FROM
	employees
GROUP BY
	job_id,
	department_id;

#错误的
/*
SELECT department_id, job_id, AVG(salary)
FROM employees
GROUP BY department_id;
*/
#SELECT中出现的非组函数的字段必须声明在GROUP BY中，
#反之，GROUP BY中声明的字段可以不再SELECT中
#从上到下的声明位置：
#SELELCT  FROM  WHERE  GROUP BY  ORDER BY LIMIT
#MySQL中GROUP BY 中使用WITH ROLLUP
#将总体再视为一个组加入一行数据
SELECT
	department_id,
	AVG(salary) avg_sal
FROM
	employees
GROUP BY
	department_id WITH ROLLUP;

SELECT
	department_id,
	AVG(salary) avg_sal
FROM
	employees
GROUP BY
	department_id
ORDER BY
	avg_sal ASC;

/*
报错,ORDER BY和WITH ROLLUP不能同时使用
SELECT department_id, AVG(salary) avg_sal
FROM employees
GROUP BY department_id WITH ROLLUP
ORDER BY avg_sal ASC;
*/
#HAVING的使用：用来过滤数据
#查询各个部门中最高工资比10000高的部门信息
/*
报错
SELECT department_id, MAX(salary)
FROM employees
WHERE MAX(salary) > 10000
GROUP BY department_id;
*/
#正确的写法
#如果过滤条件中使用了聚合函数，则必须使用HAVING来替代WHERE，
#且HAVING必须声明在GROUP BY的后面
SELECT
	department_id,
	MAX(salary)
FROM
	employees
GROUP BY
	department_id
HAVING
	MAX(salary) > 10000;

#这也正确，但意义不大，因为没有GROUP BY时把数据视为一组
SELECT
	department_id,
	MAX(salary)
FROM
	employees
HAVING
	MAX(salary) > 10000;

#在开发中，使用HAVING的前提是SQL中使用了GROUP BY
#查询部门id为10,20,30,40这4个部门中最高工资比10000高的部门信息
#方式1：推荐，执行效率高于方式2
SELECT
	department_id,
	MAX(salary)
FROM
	employees
WHERE
	department_id IN (10, 20, 30, 40)
GROUP BY
	department_id
HAVING
	MAX(salary) > 10000;

#方式2：
SELECT
	department_id,
	MAX(salary)
FROM
	employees
WHERE

GROUP BY
	department_id
HAVING
	MAX(salary) > 10000
AND department_id IN (10, 20, 30, 40);

#当过滤条件中有聚合函数时，则此过滤条件必须声明在HAVING中
#当过滤条件中没有聚合函数时，则此过滤条件声明在WHERE中或
#HAVING中都可以，但最好声明在WHERE中

#	SELECT的完整结构
/*
#sql92语法：
SELECT ..., ..., ...(存在聚合函数）
FROM ..., ..., ...
WHERE 多表的连接条件 AND 不包含聚合函数的过滤条件		
GROUP BY ..., ...
HAVING 包含聚合函数的过滤条件
ORDER BY ..., ...(ASC / DESC)
LIMIT ..., ...

#sql99语法：
SELECT ..., ..., ...(存在聚合函数）	
FROM ... (LEFT / RIGHT)JOIN... ON... 多表的连接条件 
	(LEFT / RIGHT)JOIN... ON...
WHERE 不包含聚合函数的过滤条件		
GROUP BY ..., ...
HAVING 包含聚合函数的过滤条件
ORDER BY ..., ...(ASC / DESC)
LIMIT ..., ...
*/

#SQL语句的执行过程
#FROM ..., ...(对导入的多个表进行笛卡尔积连接) ->
#ON(限制连接条件) ->
#(LEFT / RIGHT) JOIN ->
#WHERE ->
#GROUP BY ->
#HAVING ->
#SELECT ->
#DISTINCT ->
#ORDER BY ->
#LIMIT







