-- ex1:
SELECT NAME FROM CITY
WHERE POPULATION >120000 AND CountryCode = 'USA';

-- ex2:
SELECT * FROM CITY
WHERE COUNTRYCODE = 'JPN';

-- EX3:
SELECT CITY, STATE FROM STATION;

-- EX4:
SELECT DISTINCT CITY FROM STATION 
WHERE CITY LIKE 'a%' OR CITY LIKE 'e%' OR CITY LIKE 'i%' OR CITY LIKE 'o%' OR CITY LIKE 'u%';

-- EX5:
SELECT DISTINCT CITY FROM STATION 
WHERE CITY LIKE '%a' OR CITY LIKE '%e' OR CITY LIKE '%i' OR CITY LIKE '%o' OR CITY LIKE '%u';

-- EX6:
SELECT DISTINCT CITY FROM STATION 
WHERE NOT (CITY LIKE 'a%' OR CITY LIKE 'e%' OR CITY LIKE 'i%' OR CITY LIKE 'o%' OR CITY LIKE 'u%');

-- ex7:
SELECT NAME FROM EMPLOYEE
ORDER BY NAME;

-- EX8:
SELECT NAME FROM EMPLOYEE
WHERE salary > 2000 AND months < 10
ORDER BY employee_id;

-- ex9:
SELECT product_id FROM Products
WHERE low_fats = 'Y' AND recyclable = 'Y';

-- ex10:
SELECT name FROM Customer
WHERE referee_id <> 2 OR referee_id IS NULL;

-- ex11:
SELECT name, population, area FROM World
WHERE area>=3000000 OR population>=25000000;

-- ex12:
SELECT DISTINCT author_id AS id FROM Views 
WHERE viewer_id = author_id
ORDER BY id;

-- ex13:
SELECT part, assembly_step FROM parts_assembly
WHERE finish_date IS NULL;

-- ex14:
select * from lyft_drivers
WHERE yearly_salary<= 30000 OR yearly_salary>=70000

--ex15:
select advertising_channel from uber_advertising
WHERE money_spent > 100000 AND year = 2019;
