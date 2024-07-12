-- ex1:
with total_spend as
(select 
  extract(year from transaction_date) as year,
  product_id,
  sum(spend) as curr_year_spend
from user_transactions
group by extract(year from transaction_date), product_id)

select 
  *,
  lag(curr_year_spend) over (partition by product_id order by year) as prev_year_spend,
  ROUND(100.0*(curr_year_spend-lag(curr_year_spend) over (partition by product_id order by year))/lag(curr_year_spend) over (partition by product_id order by year),2) as yoy_rate
from total_spend;

-- ex2:
with new_table as
(select 
  card_name,
  row_number() over(partition by card_name order by issue_year, issue_month) as rank,
  issued_amount
from monthly_cards_issued)

select 
  card_name,
  issued_amount
from new_table 
where rank=1
order by issued_amount desc;

-- ex3:
with new_table as
(select 
  *,
  rank() over(partition by user_id order by transaction_date) as rank_user
from transactions)

select user_id, spend, transaction_date
from new_table
where rank_user=3

-- ex4:
