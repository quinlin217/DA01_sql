-- ex1:
with count_table as
(select
  company_id,
  title,
  description,
  count(*) as count
from job_listings
group by title, description,company_id)

select count(*) as duplicate_companies
from count_table 
where count>=2;

-- ex2:
with total_spend as
(select 
  category, 
  product,
  sum(spend) as total
from product_spend
where extract(year from transaction_date) = '2022'
group by category, product),

rank_products as 
(select 
  a.category, 
  a.product, 
  a.total,
  count(*) as rank 
from total_spend as a
join total_spend as b 
on a.category=b.category and a.total<=b.total
group by 
  a.category, 
  a.product, 
  a.total
order by category, total desc)

select 
  category, 
  product, 
  total
from rank_products 
where rank <=2;

-- ex3:
with count_calls as 
(select 
  policy_holder_id,
  count(case_id) as count
from callers
group by policy_holder_id)

select count(*) as policy_holder_count 
from count_calls
where count>=3;

-- ex4:
select a.page_id
from pages as a 
left join page_likes as b
on a.page_id=b.page_id
where b.* is null
order by a.page_id

-- ex5:
with new_table as
(select 
  user_id,
  count(*),
  extract(month from event_date) as month
from user_actions 
where extract(month from event_date)=6 and extract(year from event_date)=2022
group by user_id, extract(month from event_date)
union all 
select 
  user_id,
  count(*),
  extract(month from event_date) as month
from user_actions 
where extract(month from event_date)=7 and extract(year from event_date)=2022
group by user_id,extract(month from event_date)),
count as
(select 
  user_id,
  count(*) as count,
  max(month) as month
from new_table
group by user_id
having count(*)>=2)

select 
  month, 
  count(*) as monthly_active_users
from count
group by month
  
-- ex6:
select 
    date_format(trans_date, '%Y-%m') as month,
    country,
    count(*) as trans_count,
    count(case when state='approved' then 1 end) as approved_count,
    sum(amount) as trans_total_amount,
    sum(case when state='approved' then amount else 0 end) as approved_total_amount 
from transactions
group by date_format(trans_date, '%Y-%m'), country;

-- ex7:
with first as
(select 
    product_id,
    min(year) as first_year
from sales
group by product_id)

select 
    a.product_id,
    b.first_year,
    a.quantity,
    a.price
from sales as a
join first as b
on a.product_id=b.product_id
where a.year=b.first_year;

-- ex8:
select customer_id from customer
group by customer_id
having count( distinct product_key) >= (select count(product_key) from product)

-- ex9: 
select 
    a.employee_id
from employees as a
left join employees as b on a.manager_id=b.employee_id 
where a.salary<30000 and b.employee_id is null and a.manager_id is not null
order by a.employee_id 

-- ex10:
with count_table as
(select
  company_id,
  title,
  description,
  count(*) as count
from job_listings
group by title, description,company_id)

select count(*) as duplicate_companies
from count_table 
where count>=2;

-- ex11:
with greatest_rating as
(select 
    a.user_id,
    a.name,
    count(*) as count
from users as a
join MovieRating as b
on a.user_id=b.user_id
group by a.user_id, a.name
order by count desc, a.name
limit 1),

highest_avg as
(select 
    a.movie_id,
    b.title,
    avg(a.rating) as avg
from MovieRating as a
join movies as b
on a.movie_id=b.movie_id
where extract(month from a.created_at)=2 and extract(year from a.created_at)=2020
group by a.movie_id, b.title
order by avg desc, b.title
limit 1)

select name as results      
from greatest_rating
union
select title as results      
from highest_avg;

-- ex12: 
with count_friends as
(select 
    requester_id as id,
    count(*) as count
from RequestAccepted
group by requester_id
union all 
select 
    accepter_id as id,
    count(*) as count
from RequestAccepted
group by accepter_id)

select 
    id, 
    sum(count) as num
from count_friends
group by id
order by num desc
limit 1
