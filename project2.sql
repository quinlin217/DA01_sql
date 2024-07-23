-- 1: Số lượng đơn hàng và số lượng khách hàng mỗi tháng
select 
  format_timestamp('%Y/%m', delivered_at) as year_month,
  count(user_id) as total_user,
  sum(case when status='Complete' then 1 else 0 end) as total_order
from bigquery-public-data.thelook_ecommerce.order_items
where format_timestamp('%Y/%m', delivered_at) between '2019/01' and '2022/04'
group by format_timestamp('%Y/%m', delivered_at)
order by year_month;
/*
Insight: Số lượng người mua và đơn hàng nhìn chung là tăng đáng kể (mặc dù tổng đơn hàng hoàn thành không nhất quán)
*/

-- 2: Giá trị đơn hàng trung bình (AOV) và số lượng khách hàng mỗi tháng
select 
  format_timestamp('%Y/%m', created_at) as year_month,
  count( distinct user_id) as distinct_users,
  round(avg(sale_price),2) as average_order_value
from bigquery-public-data.thelook_ecommerce.order_items
where format_timestamp('%Y/%m', created_at) between '2019/01' and '2019/04'
group by format_timestamp('%Y/%m', created_at)
order by year_month;
/*
Insight: Số lượng người dùng khác nhau tăng ngoạn mục mỗi tháng và số tiền trung bình tăng mặc dù tăng không nhất quán
*/

-- 3: Nhóm khách hàng theo độ tuổi
create or replace temp table temp_table as
with youngest as
(select 
  first_name, last_name, gender, age, 'youngest' AS tag
from bigquery-public-data.thelook_ecommerce.users
where gender='F' and age=(select min(age) from bigquery-public-data.thelook_ecommerce.users where gender='F' and format_timestamp('%Y/%m', created_at) between '2019/01' and '2019/04')
union all
select 
  first_name, last_name, gender, age, 'youngest' AS tag
from bigquery-public-data.thelook_ecommerce.users
where gender='M' and age=(select min(age) from bigquery-public-data.thelook_ecommerce.users where gender='M' and format_timestamp('%Y/%m', created_at) between '2019/01' and '2019/04')),
oldest as
(select 
  first_name, last_name, gender, age, 'oldest' AS tag
from bigquery-public-data.thelook_ecommerce.users
where gender='F' and age=(select max(age) from bigquery-public-data.thelook_ecommerce.users where gender='F' and format_timestamp('%Y/%m', created_at) between '2019/01' and '2019/04')
union all
select 
  first_name, last_name, gender, age, 'oldest' AS tag
from bigquery-public-data.thelook_ecommerce.users
where gender='M' and age=(select max(age) from bigquery-public-data.thelook_ecommerce.users where gender='M' and format_timestamp('%Y/%m', created_at) between '2019/01' and '2019/04'))

select *
from youngest
union all
select *
from oldest;

select
  gender,
  tag,
  min(age) as youngest_age,
  max(age) as oldest_age,
  count(*)
from temp_table
group by gender, tag;

-- 4: Top 5 sản phẩm mỗi tháng.
with monthly_profits as (
  select 
    format_timestamp('%Y-%m', b.delivered_at) as year_month,
    b.product_id,
    a.name as product_name,
    round(sum(b.sale_price), 2) as sales,
    round(sum(a.cost), 2) as costs,
    round(sum(b.sale_price) - sum(a.cost), 2) as profit
  from 
    bigquery-public-data.thelook_ecommerce.products as a
  join bigquery-public-data.thelook_ecommerce.order_items as b
  on a.id = b.product_id
  group by 
    year_month, b.product_id, a.name
),

ranked_products as (
  select
    year_month,
    product_id,
    product_name,
    sales,
    costs,
    profit,
    dense_rank() over (partition by year_month order by profit desc) as product_rank
  from
    monthly_profits
)

select
  year_month,
  product_id,
  product_name,
  sales,
  costs,
  profit,
  product_rank
from
  ranked_products
where
  product_rank <= 5
order by
  year_month,
  product_rank;

-- 5:
select 
  format_timestamp('%Y/%m/%d', b.delivered_at) as date,
  a.category,
  round(sum(b.sale_price) - sum(a.cost), 2) as profit
from bigquery-public-data.thelook_ecommerce.products as a
join bigquery-public-data.thelook_ecommerce.order_items as b
on a.id = b.product_id
where format_timestamp('%Y/%m/%d', b.delivered_at) between '2022/04/15' and '2022/01/15'and b.status='Complete'
group by format_timestamp('%Y/%m/%d', b.delivered_at),
  a.category
order by date 

/*1) Giả sử team của bạn đang cần dựng dashboard và có yêu cầu xử lý dữ liệu trước khi kết nối với BI tool. 
Sau khi bàn bạc, team của bạn quyết định các metric cần thiết cho dashboard và cần phải trích xuất dữ liệu từ database 
để ra được 1 dataset như mô tả Yêu cầu dataset.
Hãy sử dụng câu lệnh SQL để tạo ra 1 dataset như mong muốn và lưu dataset đó vào VIEW đặt tên là vw_ecommerce_analyst
*/
with cte as
(select 
  format_timestamp('%Y-%m', b.created_at) as month,
  format_timestamp('%Y', b.created_at) as year,
  c.category as product_category,
  round(sum(case when b.status='Complete' then a.sale_price else 0 end),2) as TPV,
  count(a.order_id) as TPO,
  round(sum(case when b.status='Complete' then c.cost else 0 end),2) as total_cost
from bigquery-public-data.thelook_ecommerce.order_items as a
join bigquery-public-data.thelook_ecommerce.orders as b on a.order_id=b.order_id
join bigquery-public-data.thelook_ecommerce.products as c on a.product_id=c.id
group by 
  format_timestamp('%Y-%m', b.created_at),
  format_timestamp('%Y', b.created_at),
  c.category)

select 
  *,
  round(tpv-total_cost,2) as total_profit,
  case when total_cost<>0 then round((tpv-total_cost)/total_cost,2)
  else 0 end as profit_to_cost_ratio,
  case when tpv<> 0 then round(100.0*(lead(tpv) over(partition by product_category order by month)-tpv)/tpv,2) || '%'
  else 100 || '%' end as revenue_growth,
  case when tpo<> 0 then round(100.0*(lead(tpo) over(partition by product_category order by month)-tpo)/tpo,2) || '%'
  else 100 || '%' end as order_growth
from cte
order by product_category;
