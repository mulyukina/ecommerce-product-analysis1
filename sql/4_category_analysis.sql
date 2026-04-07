with purchase as ( 
	select 
		category_id,
		category_code,
		round(sum(price)::numeric,2) as revenue,
		count(event_type) as purchase_count,
		round(sum(price)::numeric/count(event_type)::numeric,2) as avg_check,
		count(distinct user_id) as unique_purchasers
	from ecommerce
	where event_type = 'purchase'
	group by category_id, category_code
),
views as (
	select 
		category_id,
		count(distinct user_id) as unique_viewers
	from ecommerce
	where event_type = 'view'
	group by category_id
),
carts as(
	select 
		category_id,
		count(event_type) as carts_count
	from ecommerce
	where event_type = 'cart'
	group by category_id
)
select 
	category_code,
	revenue,
	purchase_count,
	avg_check,
	unique_viewers,
	unique_purchasers,
	round(100.0 * unique_purchasers/unique_viewers, 2) as convertion_rate,
	round((1.0 -purchase_count::numeric/carts_count::numeric)*100.0, 2) as cart_abandon_rate
from purchase
join views using(category_id)
join carts using(category_id)
order by revenue desc
limit 10;
		
