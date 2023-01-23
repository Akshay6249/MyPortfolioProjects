/*
A. Number of jobs reviewed: Amount of jobs reviewed over time.
# Calculate the number of jobs reviewed per hour per day for November 2020?
*/
SELECT
	COUNT(DISTINCT job_id)/(30*24) AS_number_of_jobs_reviewed_per_hour_per_day
FROM
	 operations_2.case_1;

/*
B. Throughput: It is the no. of events happening per second.
Calculate 7 day rolling average of throughput? For throughput, do you prefer daily metric or 7-day rolling and why?
# */
SELECT 
	ds, 
	jobs_reviewed, 
    AVG(jobs_reviewed) OVER(ORDER BY ds ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) 
AS 
	throughput_7 
FROM 
	( SELECT ds, COUNT( DISTINCT job_id) 
AS 
	jobs_reviewed 
FROM 
	 operations_2.case_1 
WHERE ds BETWEEN '2020-11-01' AND '2020-11-30' 
GROUP BY 
	ds 
ORDER BY 
	ds ) a;
    
/*
C. Percentage share of each language: Share of each language for different contents.
# Calculate the percentage share of each language in the last 30 days?
*/
SELECT 
	language, 
	(num_of_jobs/total_jobs)*100 AS percent_share_of_language 
FROM 
	(SELECT 
		language, 
        COUNT(DISTINCT job_id) AS num_of_jobs 
	FROM 
		case_1 
	GROUP BY
		language) a 
CROSS JOIN 
	(SELECT 
		COUNT(DISTINCT job_id) AS total_jobs 
	FROM 
		 operations_2.case_1) b;
 
 /*
D. Duplicate rows: Rows that have the same value present in them.
# Let’s say you see some duplicate rows in the data. How will you display duplicates from the table?
*/
SELECT 
	* 
FROM 
	(SELECT 
		*, 
        ROW_NUMBER() OVER(PARTITION BY job_id) AS row_num 
	FROM case_1) a 
WHERE 
	row_num>1
 