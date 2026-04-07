with unique_viewers as (
	select
		extract(hour from event_time) as hours,
		count(distinct user_id) as unique_viewers
	from ecommerce
	where event_type = 'view'
	group by extract(hour from event_time)
),
unique_purchasers as (
	select
		extract(hour from event_time) as hours,
		count(distinct user_id) as unique_purchasers
	from ecommerce
	where event_type = 'purchase'
	group by extract(hour from event_time)
),
another as (
	select 
		extract(hour from event_time) as hours,
		count(event_type) as total_events,
	    count(distinct user_id) as unique_users  
	from ecommerce
	group by extract(hour from event_time)
)
select 
	hours,
	total_events,
	unique_users,
	unique_viewers,
	unique_purchasers,
	round(unique_purchasers::numeric/unique_viewers::numeric*100.00, 2) as conversion_rate_hour
from unique_purchasers
join unique_viewers using(hours)
join another using(hours);