SELECT * FROM operations_2.events;
/*
A.User Engagement: To measure the activeness of a user. Measuring if the user finds quality in a product/service.
# Your task: Calculate the weekly user engagement?
*/

SELECT EXTRACT(WEEK FROM occurred_at) AS weeknum , 
COUNT(DISTINCT user_id) AS no_of_distinct_user
FROM operations_2.events
GROUP BY weeknum
/*
B. User Growth: Amount of users growing over time for a product.
#  Your task: Calculate the user growth for product?
*/
SELECT year, weeknum, num_active_user, SUM(num_active_user)
OVER(ORDER BY year,weeknum ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cum_active_users 
FROM (SELECT EXTRACT(year from activated_at) AS year, 
			EXTRACT(week from activated_at) AS weeknum, 
            COUNT(DISTINCT user_id) AS num_active_user 
FROM operations_2.users a
	WHERE state='active' 
	GROUP BY year, weeknum 
	ORDER BY year, weeknum )  a;

/*
C. Weekly Retention: Users getting retained weekly after signing-up for a product.
#  Your task: Calculate the weekly retention of users-sign up cohort?
*/
SELECT
	COUNT(user_id), 
    SUM(CASE WHEN retention_week = 1 THEN 1 ELSE 0 END) as week_1 
FROM (SELECT 
		a.user_id, 
		a.signup_week, 
		b.engagement_week, 
		b.engagement_week - a.signup_week AS retention_week 
	FROM ((SELECT DISTINCT user_id, 
			EXTRACT(week FROM occurred_at) AS signup_week 
		FROM operations_2.events  A
		WHERE event_type = 'signup_flow' AND event_name = 'complete_signup' AND EXTRACT(week from occurred_at) = 18 ) a 
		LEFT JOIN (SELECT 
				DISTINCT user_id, 
                EXTRACT(week FROM occurred_at) AS engagement_week 
			FROM operations_2.events  A
			WHERE event_type = 'engagement') b 
		ON a.user_id = b.user_id ) 
		ORDER BY a.user_id) A;
        
/*
D.Weekly Engagement: To measure the activeness of a user. Measuring if the user finds quality in a product/service weekly.
# Your task: Calculate the weekly engagement per device?
*/

SELECT 
	EXTRACT(year FROM occurred_at) AS year, 
    EXTRACT(week from occurred_at) AS week, device, 
    COUNT(distinct user_id) 
FROM 
	operations_2.events a
WHERE 
	event_type ='engagement' 
GROUP BY 
	1,2,3 
ORDER by 
	1,2,3;
    
/*
E.Email Engagement: Users engaging with the email service.
# Your task: Calculate the email engagement metrics?
*/

SELECT 
	100.0 *SUM(CASE WHEN email_cat = 'email_open' THEN 1 ELSE 0 END)/SUM(CASE WHEN email_cat = 'email_sent' THEN 1 ELSE 0 END) AS email_open_rate, 
    100.0 *SUM(CASE WHEN email_cat = 'email_clicked' THEN 1 ELSE 0 END)/SUM(CASE WHEN email_cat = 'email_sent' THEN 1 ELSE 0 END) AS email_clicked_rate 
FROM 
	(SELECT 
		*, 
        CASE 
			WHEN action IN ('sent_weekly_digest', 'sent_reengagement_email') THEN 'email_sent' 
			WHEN action IN ('email_open') THEN 'email_open' 
            WHEN action in ('email_clickthrough') THEN 'email_clicked' 
		END AS email_cat 
	FROM operations_2.email_events) a;


        