-- ex1:
WITH rank_table AS
(SELECT
    *,
    RANK() OVER (PARTITION BY customer_id ORDER BY order_date) AS rank_1,
    CASE
    WHEN order_date=customer_pref_delivery_date THEN 1 
    END AS immediate
FROM Delivery) 

SELECT 
ROUND(100.0*COUNT(customer_id)/(SELECT COUNT(*) FROM rank_table WHERE rank_1=1),2) AS immediate_percentage 
FROM rank_table 
WHERE rank_1=1 AND immediate IS NOT NULL;

-- ex2:
select 
    round(count(distinct player_id)/(select count(distinct player_id) from Activity),2) as fraction  
from Activity
where (player_id, date_sub(event_date, interval 1 day)) in
(select 
    player_id, 
    min(event_date)
from Activity
group by player_id)

-- ex3:
select 
case 
    when id = (select max(id) from Seat) and id%2=1 then id
    when id%2=1 then id+1
    else id-1
end as id,
student
from Seat
order by id

-- ex4:


-- ex5:
select round(sum(tiv_2016),2) as tiv_2016
from Insurance as a
where tiv_2015 in 
(
select tiv_2015
from Insurance
where pid<>a.pid
) and
(lat,lon) not in
(
select lat, lon
from Insurance
where pid<>a.pid
)

-- ex6:
