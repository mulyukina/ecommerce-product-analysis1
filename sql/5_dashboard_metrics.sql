with total_revenue as (
	select 
		round(sum(price)::numeric, 2) as total_revenue,
		count(distinct user_id) as purchasers,
		count(event_type) as purchases,
		1 as step
	from ecommerce
	where event_type = 'purchase'
),
total_users as (
	select 
		count(distinct user_id) as total_users,
		1 as step
	from ecommerce
),
viewers as (
	select 
		count(distinct user_id) as viewers,
		count(event_type) as views,
		1 as step
	from ecommerce
	where event_type = 'view'
),
carts as (
	select 
		count(distinct user_id) as carters,
		count(event_type) as carts, 
		1 as step
	from ecommerce
	where event_type = 'cart'
),
active_users as (
	select 
		1 as step,
		count(distinct user_id) as active_users
	from ecommerce
	where event_time >= '2019-11-24'
)
select 
	total_revenue,
	total_users,
	round(total_revenue::numeric/total_users::numeric, 2) as ARPU,
	round(purchasers*100.0/viewers, 2) as convertion_rate,
	round((1.0-purchases::numeric/carts::numeric)*100.0, 2) as cart_abandonment_rate,
	active_users
from total_revenue
join total_users using(step)
join viewers using(step)
join carts using(step)
join active_users using(step);
	   

