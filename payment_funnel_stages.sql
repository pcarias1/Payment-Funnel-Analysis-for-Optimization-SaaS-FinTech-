with max_status_reached as (
    select 
    psl.subscription_id, 
    max(psl.status_id) as max_status
from 
    public.payment_status_log psl
group by
    1
)
,
payment_funnel_stages as (
select  
    subs.subscription_id, 
    date_trunc('year',order_date) as order_year,
    current_payment_status, 
    max_status,
    case when max_status =1 then 'Payment Widget Opened'
         when max_status =2 then 'Payment Entered'
         when max_status =3 and current_payment_status  =0 then 'User Error with Payment Submission'
         when max_status =3 and current_payment_status !=0 then 'Payment Submitted'
         when max_status =4 and current_payment_status  =4 then 'Payment Processing Error with Vendor'
         when max_status =4 and current_payment_status !=0 then 'Payment successful with vendor'
         When max_status =5 then 'Complete'
         when max_status is null then 'User has no started payment process'
         end as payment_funnel_stage  
from 
    public.subscriptions subs   
left join
    max_status_reached m
    on subs.subscription_id = m.subscription_id

)
select 
    payment_funnel_stage, 
    order_year,
    count(*) as num_subs 
from 
    payment_funnel_stages
group by
    1,2
order by 
    2 desc 

The output of the payment_funnel_stages.sql query is available here:  
👉 [results/funnel.csv](results/funnel.csv)
