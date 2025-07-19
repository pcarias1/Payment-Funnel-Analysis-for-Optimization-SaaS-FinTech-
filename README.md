# Payment-Funnel-Analysis-for-Subscription-Optimization


## Executive Summary
Using SQL and Snowflake, I conducted a payment funnel analysis to identify major drop-off points in the subscription process for a SaaS company. The analysis revealed that a significant number of users either abandon the process early or encounter errors during payment submission. These inefficiencies contribute to lower-than-expected conversion rates and revenue loss.
To improve user conversion and reduce friction in the payment process, I recommend:
1. Enhancing frontend user experience to minimize early abandonment.
2. Investigating vendor-side issues causing failed transactions.
3. Implementing targeted interventions based on user error patterns.

### Business Problem
The finance and product teams flagged a drop in conversions—many users initiated subscriptions but failed to complete payment. These unconverted subscriptions posed a significant revenue gap. The task was to:
- Understand where users fall off in the subscription funnel.
- Quantify the completion and error rates.
- Propose solutions to increase conversion.



<img width="821" height="403" alt="Subscription Payment Funnel Stages drawio" src="https://github.com/user-attachments/assets/d067ff8b-3fcf-4922-a0f3-d2078eb1ca18" />

### Methodology
1. SQL Analysis (Snowflake):
   -reated max_status_reached and payment_funnel_stages CTEs to track user progression.
   -Used CASE statements to classify funnel stages and errors.

2. Conversion Rate and Workflow Completion Rate:
   - Conversion Rate: Percentage of total subs who completed payment.
   - Workflow Completion Rate: Percentage of subscribers who started payment and completed it.

3. Error Analysis:
   - Used status_id = 0 to detect payment submission errors
   - Created a binary has_error flag via a LEFT JOIN and CASE logic to track affected subscriptions.

4. Data Visualization:
   ## 1. Funnel stage breakdown by year.
   <img width="954" height="455" alt="Screenshot 2025-07-15 at 6 51 29 PM" src="https://github.com/user-attachments/assets/e893d65e-4935-40ba-9f65-8b2d18ad411f" />
    Figure: Year over year breakdown of subscriptions by payment funnel stage. This shows where users most frequently drop off, such as failing to start or complete payment steps.


   ## 2. Stacked column chart of subscriptions with vs. without errors.
<img width="982" height="443" alt="Screenshot 2025-07-19 at 4 13 29 PM" src="https://github.com/user-attachments/assets/482c5467-6c8b-4334-83e9-0d910cef7f15" />
   Figure: Distribution of subscriptions with and without payment submission errors. Most subscriptions proceeded without technical failures, though the small portion that failed still represent key revenue loss points.

### Tools & Skills
- SQL (Snowflake): CTEs, CASE, aggregation, LEFT JOINs, error flag logic
- Data Analysis: Funnel breakdowns, conversion calculations, error segmentation
- Visualization: Stacked bar chart to compare error-based vs. error-free subs

### Results & Business Recommendations
Conversion Rate: 20.34%
Workflow Completion Rate: 34.29%

 Fallout Observations:
- Many users opened the widget but didn’t enter payment info.
- A portion of users encountered submission or vendor errors.
- Several subscribers have not attempted to pay (maxstatus = null).

Recommendations:
1. Frontend Improvements:
Add progress indicators to guide users through payment.
Send emails for users who start but don’t submit.

2. Error Resilience:
Retry failed transactions automatically or prompt users to resubmit.
Add better logging to differentiate between frontend and vendor errors 

3. Tracking Enhancements:
Track abandoned sessions explicitly with new status codes.

## Next Steps
- Build dashboards to monitor real-time funnel metrics.
- Collaborate with vendor tech teams to reduce backend failure rates
- Look at different types of users (age or location) to see how they behave in the payment process.
- Try out different versions of the payment screen to see which one helps more people finish paying.
- Investigate why subscriptions aren't even starting the payment process. Is it a process issue on our side? Are customers forgetting?

