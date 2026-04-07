with user_events as (
    select 
        user_id,
        max(case when event_type = 'view' then 1 else 0 end) as has_view,
        max(case when event_type = 'cart' then 1 else 0 end) as has_cart,
        max(case when event_type = 'purchase' then 1 else 0 end) as has_purchase
    from ecommerce
    group by user_id
)
select 
    count(*) as total_users,
    sum(has_view) as users_with_view,
    sum(has_cart) as users_with_cart,
    sum(has_purchase) as users_with_purchase,
    round(100.0*sum(has_cart)/nullif(sum(has_view), 0), 2) as view_to_cart_cr,
    round(100.0*sum(has_purchase)/nullif(sum(has_cart), 0), 2) as cart_to_purchase_cr,
    round(100.0*sum(has_purchase)/nullif(sum(has_view), 0), 2) as overall_cr
from user_events;