USE atguigudb;

#流程控制函数
#IF(VALUE, VALUE1, VALUE2)
SELECT last_name, salary, IF(salary >= 6000,'高工资', '低工资')
FROM employees;

SELECT last_name, commission_pct, IF(commission_pct IS NOT NULL, commission_pct, 0) "datails",
salary * 12 * (1 + IF(commission_pct IS NOT NULL, commission_pct, 0)) "annual_sal"
FROM employees;

#IFNULL(VALUE1, VALUE2)：看作是IF(VALUE, VALUE1, VALUE2)的特殊情况
SELECT last_name, commission_pct, IFNULL(commission_pct, 0) "datails",
salary * 12 * (1 + IFNULL(commission_pct, 0)) "annual_sal"
FROM employees;

#CASE WHEN... THEN... WHEN... THEN... ELSE... END
SELECT last_name, salary,
	CASE WHEN salary >= 15000 THEN 'rich'
			 WHEN salary >= 10000 THEN 'common'
			 WHEN salary >= 8000 THEN 'poor'
			 ELSE '...' END "details", department_id
FROM employees;

#CASE... WHEN... THEN... WHEN... THEN... ELSE... END
/*查询部门号为10，20，30的员工信息，
若部门号为10，则打印其工资的1.1倍，
若部门号为20，则打印其工资的1.2倍，
若部门号为30，则打印其工资的1.3倍，
其他部门，则打印其工资的1.4倍*/
SELECT employee_id, last_name, department_id,
	CASE department_id WHEN 10 THEN salary * 1.1
										 WHEN 20 THEN salary * 1.2
										 WHEN 30 THEN salary * 1.3
										 ELSE salary * 1.4 END "details"
FROM employees;

/*查询部门号为10，20，30的员工信息，
若部门号为10，则打印其工资的1.1倍，
若部门号为20，则打印其工资的1.2倍，
若部门号为30，则打印其工资的1.3倍*/
SELECT employee_id, last_name, department_id,
	CASE department_id WHEN 10 THEN salary * 1.1
										 WHEN 20 THEN salary * 1.2
										 WHEN 30 THEN salary * 1.3
										 END "details"
FROM employees
WHERE department_id in (10, 20, 30);

#加密与解密函数
#PASSWORD()在MySQL8.0中弃用
SELECT PASSWORD('mysql'), SHA('mysql')
FROM DUAL;

SELECT ENCODE('atguigu','mysql'), DECODE(ENCODE('atguigu','mysql'),'mysql')
FROM DUAL;

#MySQL信息函数
SELECT VERSION(), CONNECTION_ID(), DATABASE(),
	USER(), CHARSET('枫'), COLLATION('枫')
FROM DUAL;

#其他函数
#n的值小于或者等于0，则只保留整数部分
#FORMAT(VALUE,n), CONV(VALUE,frop-m,to)
SELECT FORMAT(123.125,2), FORMAT(123.125,0), FORMAT(123.125,-1)
FROM DUAL;

SELECT CONV(16,10,2), CONV(16,8,16), CONV(NULL,10,2)
FROM DUAL;

#BENCHMARK()用于测试表达式的执行时间
SELECT BENCHMARK(1000,MD5('mysql'))
FROM DUAL;

SELECT BENCHMARK(100000,MD5('mysql'))
FROM DUAL;

#CONVERT()：可以实现字符集的转换	
SELECT CHARSET('枫'), CONVERT('枫' USING 'utf8mb4'), CHARSET(CONVERT('枫' USING 'utf8mb3'))
FROM DUAL;










