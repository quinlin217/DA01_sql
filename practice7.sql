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
with new_table as
(select 
  *,
  rank() over(partition by user_id order by transaction_date desc) as rank
from user_transactions)

select 
  transaction_date,
  user_id, 
  count(*) as purchase_count
from new_table
where rank=1
group by transaction_date, user_id
order by transaction_date;

-- ex5:
with new_table as
(select
  *,
  lag(tweet_count) over (partition by user_id order by tweet_date) as previous_tweet_count,
  lag(tweet_count,2) over (partition by user_id order by tweet_date) as previous2_tweet_count
from tweets)

select 
  user_id,
  tweet_date,
case 
  when previous_tweet_count is null and previous2_tweet_count is null then round(tweet_count,2)
  when previous2_tweet_count is null then round((tweet_count+previous_tweet_count)/2.0,2)
  else round((tweet_count+previous_tweet_count+previous2_tweet_count)/3.0,2)
end 
from new_table;

-- ex6:
with new_table as 
(select 
  *,
  lead(transaction_timestamp) over(partition by merchant_id, credit_card_id, amount order by transaction_timestamp) as next_transaction_timestamp,
  (lead(transaction_timestamp) over(partition by merchant_id, credit_card_id, amount order by transaction_timestamp))-transaction_timestamp as diff_time
from transactions)

select count(*) as count
from new_table 
where extract(epoch from diff_time)/60<=10 

-- ex7:
with new_table as
(select 
  category,
  product,
  sum(spend) total_spend,
  rank() over (partition by category order by sum(spend) desc) as rank
from product_spend 
where extract(year from transaction_date)=2022
group by category, product
order by category)

select 
  category,
  product, 
  total_spend
from new_table
where rank<=2

-- ex8:
with new_table as
(select 
  a.artist_name,
  dense_rank() over(order by count(*) desc) as artist_rank
from artists as a  
join songs as b on a.artist_id=b.artist_id
join global_song_rank as c on b.song_id=c.song_id
where c.rank<=10
group by artist_name)

select artist_name, artist_rank
from new_table
where artist_rank<=5
