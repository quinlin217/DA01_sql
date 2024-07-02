-- ex1:
select name
from students
where marks>75
order by right(name, 3), id;

-- ex2:
select user_id,
concat(upper(substring(name from 1 for 1)), lower(substring(name from 2))) as name
from users
order by user_id

-- ex3:
SELECT 
  manufacturer,
  '$'|| CAST(SUM(total_sales)/1000000 AS int) || ' million' AS sale
FROM pharmacy_sales
GROUP BY manufacturer
ORDER BY CAST(SUM(total_sales)/1000000 AS int) DESC, manufacturer DESC;

-- ex4:
SELECT 
  EXTRACT(month FROM submit_date) AS mth,
  product_id,
  ROUND(AVG(stars),2) AS avg_stars
FROM reviews
GROUP BY
  EXTRACT(month FROM submit_date),
  product_id
ORDER BY mth, product_id;

-- ex5:
SELECT 
  sender_id,
  count(message_id) AS message_count
FROM messages
WHERE 
  EXTRACT(month FROM sent_date) ='8'
  AND EXTRACT(year FROM sent_date)='2022'
GROUP BY sender_id
ORDER BY message_count DESC
LIMIT 2;

-- ex6:
# Write your MySQL query statement below
select tweet_id
from tweets
where length(content)>15

-- ex8:
select 
    extract(MONTH FROM joining_date),
from employees
where (extract(MONTH FROM joining_date) BETWEEN 1 AND 7) AND extract(year from joining_date)=2022
group by extract(MONTH FROM joining_date);

-- ex9:
select 
position('a' in first_name)
from worker
where first_name = 'Amitah';

-- ex9:
select 
cast(substring(title from (length(winery)+2) FOR 4) as int) as year
from winemag_p2
where country = 'Macedonia';
