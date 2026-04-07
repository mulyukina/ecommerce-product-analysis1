with first_dates as (
	select 
		user_id,
		date(min(event_time)) as cohort_date
	from ecommerce
	group by user_id
),
user_activity as (
	select 
		first_dates.cohort_date,
		first_dates.user_id,
		date(event_time) as cur_date,
		date(event_time) - cohort_date as offset_days
	from first_dates 
	join ecommerce using(user_id)
),
cohort_size as (
	select 
		count(distinct user_id) as total_users,
	    cohort_date
	from user_activity
	where offset_days = 0
	group by cohort_date
),
retention_data as (
	select 
		cohort_date,
		offset_days,
		count(distinct user_id) as active_users
	from user_activity
	where offset_days <=30
	group by cohort_date, offset_days
)
select 
	retention_data.cohort_date,
	retention_data.offset_days,
	retention_data.active_users,
	cohort_size.total_users,
	round(100.0 * retention_data.active_users/cohort_size.total_users, 2) as retention_rate
from retention_data
join cohort_size using(cohort_date)
order by retention_data.cohort_date, retention_data.offset_days;

	   