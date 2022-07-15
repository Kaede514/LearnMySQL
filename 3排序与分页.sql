#排序与分页

USE atguigudb;

#排序
#如果没有使用排序操作，默认情况下查询返回的数据
#按照添加数据的顺序显示
SELECT * FROM employees;

#使用ORDER BY对查询到的数据进行排序操作
#升序：ASC(ascend)，默认情况下为升序
#降序：DESC(descend)

SELECT employee_id, last_name, salary
FROM employees
ORDER BY salary;

SELECT employee_id, last_name, salary
FROM employees
ORDER BY salary DESC;

#可以使用列的别名进行排序
#列的别名只能在ORDER BY中使用，不能在WHERE中使用
#	WHERE需要声明在FROM之后，ORDER BY之前
SELECT employee_id, last_name, salary * 12 annual_sal, department_id
FROM employees
WHERE department_id in (50, 60, 70)
ORDER BY annual_sal ASC;

#二级排序
#显示员工信息，按department_id降序排序，salary升序排序
SELECT employee_id, last_name, salary, department_id
FROM employees
ORDER BY department_id DESC, salary ASC;

#分页
#每页显示20条记录，此时显示第一页
SELECT employee_id, last_name, salary
FROM employees
LIMIT 0, 20;

#每页显示20条记录，此时显示第二页
SELECT employee_id, last_name, salary
FROM employees
LIMIT 20, 20;

#每页显示pageSize条记录，此时显示第pageNo页
#LIMIT (pageNo - 1) * pageSize, pageSize
SELECT employee_id, last_name, salary
FROM employees
WHERE salary > 6000
ORDER BY salary ASC
LIMIT 0, 10		#等价于LIMIT 10

#显示表中第32、33条数据
SELECT employee_id, last_name
FROM employees
LIMIT 31, 2;

#查询员工表中工资最高的员工信息
SELECT employee_id, last_name, salary
FROM employees
ORDER BY salary DESC
LIMIT 0, 1;


