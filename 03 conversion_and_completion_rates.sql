-- SQL logic to calculate Conversion Rate and Workflow Completion Rate
-- Goal: Assess how many users completed payment out of the total user base,
--       and how many completed payment out of those who actually started the process.
-- Source Tables: payment_status_log, subscriptions
-- Output: conversion rate and workflow completion rate

with max_status_reached as (
    -- For each subscription, capture the highest payment status reached
select 
    psl.subscription_id, 
    max(psl.status_id) as max_status  
from 
    public.payment_status_log as psl 
group by
    1
) 
, 
payment_funnel_stages as (
    -- Label subscriptions as "completed payment" or "started payment" based on max status
select
    subs.subscription_id, 
    date_trunc('year', order_date) as order_year,
    current_payment_status, 
    max_status, 
    case when max_status = 5 then 1 else 0 end as completed_payment, -- Status 5 indicates completed payment
    case when max_status is not null then 1 end as started_payment   -- Any status indicates payment process was started
from 
    public.subscriptions subs 
left join
    max_status_reached m 
    on subs.subscription_id = m.subscription_id
) 
select 
    sum(completed_payment) as num_subs_completed_payment, -- Total subscriptions that completed payment
    sum (started_payment) as num_subs_started_payment ,   -- Total suscriptions that started payment, 
    count (* ) as total_subs, -- Total number of subscriptions , 
    num_subs_completed_payment *100 / total_subs as conversion_rate,-- However many subs we have, what % completed and converted the payment process , 
    num_subs_completed_payment *100 / num_subs_started_payment  as workflow_completion_rate -- out of those who started the payment, how many completed it 
from 
    payment_funnel_stages

--Results 
--NUM_SUBS_COMPLETED_PAYMENT | NUM_SUBS_STARTED_PAYMENT | TOTAL_SUBS | CONVERSION_RATE | WORKFLOW_COMPLETION_RATE
--12                         | 35                        | 59         | 20.34           | 34.29

