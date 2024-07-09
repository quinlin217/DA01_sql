-- ex1:
select 
    country.continent, 
    floor(avg(city.population))
from country 
inner join city 
on country.code=city.countrycode
group by country.continent
order by round(avg(city.population),0);

-- ex2:
select 
  round(count(case when signup_action='Confirmed' then 1 end)*1.00/count(*),2) as confirm_rate
from emails 
inner join texts
on emails.email_id=texts.email_id

-- ex3:
select 
  b.age_bucket,
  round(100.0*sum(case when activity_type='send' then a.time_spent else 0 end)/sum(a.time_spent),2) as send_perc,
  round(100.0*sum(case when activity_type='open' then a.time_spent else 0 end)/sum(a.time_spent),2) as open_perc
from activities as a
inner join age_breakdown as b 
on a.user_id=b.user_id
where a.activity_type<>'chat'
group by b.age_bucket

-- ex4:
with supercloud_cust as (
select 
  a.customer_id,
  count(distinct b.product_category) as count
from customer_contracts as a  
inner join products as b
on a.product_id=b.product_id
group by a.customer_id) 

select customer_id
from supercloud_cust
where count = (select count(distinct product_category) from products)

-- ex5:
select 
    a.employee_id,
    a.name,
    count(*) as reports_count,
    round(avg(b.age),0) as average_age
from employees as a
left join employees as b
on a.employee_id=b.reports_to 
where b.employee_id is not null
group by a.employee_id
order by a.employee_id;

-- ex6:
select 
    a.product_name,
    sum(b.unit) as unit
from Products as a
inner join Orders as b
on a.product_id=b.product_id
where extract(month from b.order_date)=2 and extract(year from b.order_date)=2020
group by a.product_name
having sum(b.unit)>=100;

-- ex7:
select a.page_id
from pages as a 
left join page_likes as b
on a.page_id=b.page_id
where b.* is null
order by a.page_id
