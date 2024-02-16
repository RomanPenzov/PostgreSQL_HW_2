drop table customer_20240101;
drop table transaction_20240101;

-- создание таблиц customer_20240101 и transaction_20240101

create table customer_20240101 (
	customer_id int4
	,first_name varchar(50)
	,last_name varchar(50)
	,gender varchar(30)
	,dob varchar(50)
	,job_title varchar(50)
	,job_industry_category varchar(50)
	,wealth_segment varchar(50)
	,deceased_indicator varchar(50)
	,owns_car varchar(30)
	,address varchar(50)
	,postcode varchar(30)
	,state varchar(30)
	,country varchar(30)
	,property_valuation int4
);

create table transaction_20240101 (
	transaction_id int4
	,product_id int4
	,customer_id int4
	,transaction_date varchar(30)
	,online_order varchar(30)
	,order_status varchar(30)
	,brand varchar(30)
	,product_line varchar(30)
	,product_class varchar(30)
	,product_size varchar(30)
	,list_price float4
	,standard_cost float4
);

-- Вывести все уникальные бренды, у которых стандартная стоимость выше 1500 долларов.

SELECT DISTINCT brand
FROM transaction_20240101
WHERE standard_cost > 1500;

-- Вывести все подтвержденные транзакции за период '2017-04-01' по '2017-04-09' включительно.

SELECT *
FROM transaction_20240101
WHERE TO_DATE(transaction_date, 'DD-MM-YYYY') >= '2017-04-01' 
  AND TO_DATE(transaction_date, 'DD-MM-YYYY') <= '2017-04-09' 
  AND order_status = 'Approved';
  
-- Вывести все профессии у клиентов из сферы IT или Financial Services, которые начинаются с фразы 'Senior'.
 
SELECT DISTINCT job_title
FROM customer_20240101
WHERE job_industry_category IN ('IT', 'Financial Services')
  AND job_title LIKE 'Senior%';
  
-- Вывести все бренды, которые закупают клиенты, работающие в сфере Financial Services
 
SELECT DISTINCT t.brand
FROM customer_20240101 c
JOIN transaction_20240101 t ON c.customer_id = t.customer_id
WHERE c.job_industry_category = 'Financial Services';

-- Вывести 10 клиентов, которые оформили онлайн-заказ продукции из брендов 'Giant Bicycles', 'Norco Bicycles', 'Trek Bicycles'.

SELECT DISTINCT c.customer_id, c.first_name, c.last_name
FROM customer_20240101 c
JOIN transaction_20240101 t ON c.customer_id = t.customer_id
WHERE t.online_order = 'True'
  AND t.brand IN ('Giant Bicycles', 'Norco Bicycles', 'Trek Bicycles')
LIMIT 10;

-- Вывести всех клиентов, у которых нет транзакций.

SELECT *
FROM customer_20240101 c
LEFT JOIN transaction_20240101 t ON c.customer_id = t.customer_id
WHERE t.customer_id IS NULL;

-- Вывести всех клиентов из IT, у которых транзакции с максимальной стандартной стоимостью.

SELECT c.*
FROM customer_20240101 c
JOIN transaction_20240101 t ON c.customer_id = t.customer_id
WHERE c.job_industry_category = 'IT'
  AND t.standard_cost = (
    SELECT MAX(standard_cost)
    FROM transaction_20240101
  );
 
-- Вывести всех клиентов из сферы IT и Health, у которых есть подтвержденные транзакции за период '2017-07-07' по '2017-07-17'.
 
SELECT DISTINCT c.*
FROM customer_20240101 c
JOIN transaction_20240101 t ON c.customer_id = t.customer_id
WHERE c.job_industry_category IN ('IT', 'Health')
  AND t.order_status = 'Approved'
  AND TO_DATE(t.transaction_date, 'DD-MM-YYYY') >= '2017-07-07'
  AND TO_DATE(t.transaction_date, 'DD-MM-YYYY') <= '2017-07-17';