--ex1:
select distinct city from station 
where id%2=0;

--ex2:
select count(city) - count(distinct city)
from station;

--ex4:
SELECT ROUND(CAST(SUM(item_count*order_occurrences)/SUM(order_occurrences) AS decimal), 1) AS mean
FROM items_per_order;

--ex5:
SELECT candidate_id
FROM candidates
WHERE skill IN('Python','Tableau','PostgreSQL')
GROUP BY candidate_id
HAVING COUNT(skill) = 3;

--ex6:
SELECT 
  user_id,
  DATE(MAX(post_date))-DATE(MIN(post_date)) AS days_between
FROM posts
WHERE post_date BETWEEN '2021-01-01' AND '2022-01-01'  
GROUP BY user_id
HAVING COUNT(post_id)>=2;

--ex7:
SELECT 
  card_name,
  MAX(issued_amount)-MIN(issued_amount) AS difference
FROM monthly_cards_issued
GROUP BY card_name
ORDER BY MAX(issued_amount)-MIN(issued_amount) DESC;

--ex8:
SELECT 
  manufacturer,
  count(drug) AS drug_count,
  abs(sum(cogs-total_sales)) AS total_loss
FROM pharmacy_sales
WHERE total_sales<cogs
GROUP BY manufacturer
ORDER BY abs(sum(total_sales-cogs)) DESC

--ex9:
select *
from cinema
where id%2<>0 and description<>'boring'
order by rating desc

--ex10:
# Write your MySQL query statement belows
select 
    teacher_id,
    count(distinct subject_id) AS cnt
from teacher
group by teacher_id

--ex11:
select 
    user_id,
    count(follower_id) as followers_count
from followers
group by user_id
order by user_id

--ex12:
select class
from courses
group by class
having count(student)>=5
