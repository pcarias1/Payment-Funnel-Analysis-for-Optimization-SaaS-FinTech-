-- Payment Funnel Analysis: SQL logic to generate subscription funnel breakdown
-- Goal: Identify user drop-off points and payment submission errors in the funnel
-- Source Tables: payment_status_log, subscriptions
-- Output: payment_funnel_stage breakdown by year and status

with max_status_reached as (
select 
    psl.subscription_id, 
    max(psl.status_id) as max_status  
from 
    public.payment_status_log as psl 
group by
    1
) 
, 
--created another CTE to summarize data by counting # of subs in each payment funnel stage that was just designed 
payment_funnel_stages as (
select
    subs.subscription_id, 
    date_trunc('year', order_date) as order_year,
    current_payment_status, 
    max_status, 
    case when max_status = 1 then 'Payment Widget Opened'
         when max_status = 2 then 'Payment Entered'
         when max_status = 3 and current_payment_status  =0 then 'User Error with Payment Submission'
         when max_status = 3 and current_payment_status !=0 then 'Payment Submitted'
         when max_status = 4 and current_payment_status  =0 then 'Payment processing error with vendor'
         when max_status = 4 and current_payment_status !=0 then ' Payment completed with Vendor'
         when max_status = 5 then 'Complete'
         when max_status is null then 'User has not Started Payment Process'
         end as payment_funnel_stage
from 
    public.subscriptions subs 

-- Used LEFT JOIN to keep all subscriptions, even those that never started payment.
-- If we used INNER JOIN, subscriptions without a payment status would be excluded.
-- We want to include those users to track who didn’t start the payment process.

left join
    max_status_reached m 
    on subs.subscription_id = m.subscription_id
) 
select 
    payment_funnel_stage, 
    order_year,
    -- Used count to count subs in each category 
    count (*) as num_subs 
from 
    payment_funnel_stages
group by
    1, 2
order by
    -- Used 2 desc so that we can see everything in order year 
    2 desc 

--The output of the payment_funnel_stages.sql query is available here:  
--👉 (results_funnel.csv) 
