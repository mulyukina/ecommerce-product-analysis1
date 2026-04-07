with unique_viewers as (
	select 
		extract(isodow from event_time) as number_day_of_week,
		to_char(event_time, 'day') as day_of_week,
		count(distinct user_id) as unique_viewers
	from ecommerce
	where event_type = 'view'
	group by to_char(event_time, 'day'), extract(isodow from event_time)
),
unique_purchasers as (
	select 
		to_char(event_time, 'day') as day_of_week,
		count(distinct user_id) as unique_purchasers
	from ecommerce
	where event_type = 'purchase'
	group by to_char(event_time, 'day')
),
another as (
	select 
		to_char(event_time, 'day') as day_of_week,
	    count(event_type) as total_events,
	    count(distinct user_id) as unique_users  
	from ecommerce
	group by to_char(event_time, 'day')
)
select 
	number_day_of_week,
	day_of_week,
	total_events,
	unique_users,
	unique_viewers,
	unique_purchasers,
	round(unique_purchasers::numeric/unique_viewers::numeric*100.00, 2) as conversion_rate
from unique_purchasers
join unique_viewers using(day_of_week)
join another using(day_of_week)
order by number_day_of_week;