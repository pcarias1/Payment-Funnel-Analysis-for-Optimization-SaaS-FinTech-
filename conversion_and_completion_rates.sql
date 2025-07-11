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

    case when max_status =5 then 1 else 0 end as completed_payment, 
    case when max_status is not null then 1 else 0 end as started_payment
from 
    public.subscriptions subs   
left join
    max_status_reached m
    on subs.subscription_id = m.subscription_id

)
select 
    sum(completed_payment) as num_subs_completed_payment, 
    sum(started_payment) as num_subs_started_payment,
    count(*) as total_subs,
    num_subs_completed_payment *100/ total_subs as conversion_rate, 
    num_subs_completed_payment *100/ num_subs_started_payment as workflow_completion_rate
from
    payment_funnel_stages

--Results 
--NUM_SUBS_COMPLETED_PAYMENT | NUM_SUBS_STARTED_PAYMENT | TOTAL_SUBS | CONVERSION_RATE | WORKFLOW_COMPLETION_RATE
--12                         | 35                        | 59         | 20.34           | 34.29

