/*
Topic: DISTINCT
Task: Tạo danh sách tất cả chi phí thay thế (replacement costs )  khác nhau của các film.
Question: Chi phí thay thế thấp nhất là bao nhiêu?
Answer: 9.99
*/
select distinct replacement_cost
from film
order by replacement_cost;

/*
Topic: CASE + GROUP BY
Task: Viết một truy vấn cung cấp cái nhìn tổng quan về số lượng phim có chi phí thay thế trong các phạm vi chi phí sau
1.low: 9.99 - 19.99
2.medium: 20.00 - 24.99
3.high: 25.00 - 29.99
Question: Có bao nhiêu phim có chi phí thay thế thuộc nhóm “low”?
Answer: 514
*/

select 
count(*)
from film
where 
(case 
	when replacement_cost between 9.99 and 19.99 then 'low'
	when replacement_cost between 20.00 and 24.99 then 'medium'
	when replacement_cost between 25.00 and 29.00 then 'high'
end)='low'
group by (case 
	when replacement_cost between 9.99 and 19.99 then 'low'
	when replacement_cost between 20.00 and 24.99 then 'medium'
	when replacement_cost between 25.00 and 29.00 then 'high'
end);

/*
Topic: JOIN
Task: Tạo danh sách các film_title bao gồm tiêu đề (title), độ dài (length) và tên danh mục (category_name) 
được sắp xếp theo độ dài giảm dần. Lọc kết quả để chỉ các phim trong danh mục 'Drama' hoặc 'Sports'.
Question: Phim dài nhất thuộc thể loại nào và dài bao nhiêu?
Answer: Sports : 184
*/
-- film_id(film-film_category)
-- category_id (film_category-category)
select a.title, a.length, c.name
from film as a 
inner join film_category as b on a.film_id=b.film_id
inner join category as c on b.category_id=c.category_id
where c.name='Drama' or c.name='Sports'
order by a.length desc;

/*
Topic: JOIN & GROUP BY
Task: Đưa ra cái nhìn tổng quan về số lượng phim (tilte) trong mỗi danh mục (category).
Question:Thể loại danh mục nào là phổ biến nhất trong số các bộ phim?
Answer: Sports :74 titles
*/
select 
	c.name,
	count(*) as titles
from film as a 
inner join film_category as b on a.film_id=b.film_id
inner join category as c on b.category_id=c.category_id
group by c.name
order by titles desc;

/*
Topic: JOIN & GROUP BY
Task:Đưa ra cái nhìn tổng quan về họ và tên của các diễn viên cũng như số lượng phim họ tham gia.
Question: Diễn viên nào đóng nhiều phim nhất?
Answer: Susan Davis : 54 movies
*/
-- film_id(film-film_actor)
-- actor_id(film_actor-actor)

select 
	c.last_name,
	c.first_name,
	count(*) as movies
from film as a 
inner join film_actor as b on a.film_id=b.film_id
inner join actor as c on b.actor_id=c.actor_id
group by c.last_name, c.first_name
order by movies desc;

/*
Topic: LEFT JOIN & FILTERING
Task: Tìm các địa chỉ không liên quan đến bất kỳ khách hàng nào.
Question: Có bao nhiêu địa chỉ như vậy?
Answer: 4
*/

select count(distinct a.address_id)-count(distinct b.address_id) as count
from address as a
left join customer as b
on a.address_id=a.address_id;

/*
Topic: JOIN & GROUP BY
Task: Danh sách các thành phố và doanh thu tương ừng trên từng thành phố 
Question:Thành phố nào đạt doanh thu cao nhất?
Answer: Cape Coral : 221.55
*/
-- city_id(city-address)
-- address_id(customer-address)
-- customer_id(customer-payment)

select 
	a.city,
	sum(amount) as sum
from city as a
inner join address as b on a.city_id=b.city_id
inner join customer as c on b.address_id=c.address_id
inner join payment as d on c.customer_id=d.customer_id
group by a.city
order by sum desc;

/*
Topic: JOIN & GROUP BY
Task: Tạo danh sách trả ra 2 cột dữ liệu: 
-cột 1: thông tin thành phố và đất nước ( format: “city, country")
-cột 2: doanh thu tương ứng với cột 1
Question: thành phố của đất nước nào đat doanh thu cao nhất
Answer: United States, Tallahassee : 50.85.
*/

select 
	a.city || ', ' || e.country as city_country,
	sum(d.amount) as sum
from city as a
inner join address as b on a.city_id=b.city_id
inner join customer as c on b.address_id=c.address_id
inner join payment as d on c.customer_id=d.customer_id
inner join country as e on a.country_id=e.country_id
group by a.city, e.country
order by sum desc;

