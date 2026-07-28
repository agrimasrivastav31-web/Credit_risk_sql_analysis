use credit_project;

Select * from german_credit_data Limit 1000;

Describe german_credit_data;
select distinct purpose from german_credit_data;
select distinct risk from german_credit_data;
select distinct 'Saving accounts' from german_credit_data;
select distinct Housing from german_credit_data;
select distinct duration, count(Serial_no)
 from  german_credit_data
 group by duration
 ORDER BY DURATION DESC;

-- What % of applicants are good vs bad risk?
SELECT Risk, COUNT(*) AS total,
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM german_credit_data), 1) AS pct
FROM german_credit_data
GROUP BY Risk;

-- Which purposes (car, education, furniture, etc.) have the highest bad-risk rate?
Select purpose, 
count(*) as total_loans,
SUM(case when risk = "bad" then 1 else 0 end) as bad_loan,
round(sum(case when risk = "Bad" then 1 else 0 end) * 100.00 / count(*), 2) as bad_risk_pct
from german_credit_data
Group by purpose
having count(*) > 10 
order by bad_risk_pct desc;

-- Do bad-risk borrowers take larger loans, or longer durations, on average?
Select risk,
        round(avg(`Credit amount`), 0) as avg_credit_amount,
        round(avg(duration), 1) as avg_duration_borrowed
        from german_credit_data
        group by risk;
        
-- Does owning vs renting vs free housing correlate with risk?
Select Housing,
		    count(*) as total,
            round(sum(case when risk = "bad" then 1 else 0 end) * 100.00/count(*), 2) as bad_risk_pct
            from german_credit_data
            group by housing
			order by bad_risk_pct desc;
        
-- How does risk change across age brackets?
SELECT
  CASE
    WHEN Age < 25 THEN 'Under 25'
    WHEN Age BETWEEN 25 AND 34 THEN '25-34'
    WHEN Age BETWEEN 35 AND 49 THEN '35-49'
    ELSE '50+'
  END AS age_group,
  COUNT(*) AS total,
  ROUND(SUM(CASE WHEN Risk = 'bad' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS bad_risk_pct
FROM german_credit_data
GROUP BY age_group
ORDER BY age_group;

-- Who are the 3 largest borrowers within each loan purpose?
SELECT * FROM (
  SELECT Purpose, `Credit amount`, Risk,
         RANK() OVER (PARTITION BY Purpose ORDER BY `Credit amount` DESC) AS rank_within_purpose
  from german_credit_data
) ranked
where rank_within_purpose <= 3;

-- Which applicants borrowed more than the average for their job type?
SELECT Job, `Credit amount`, Risk
FROM german_credit_data c
WHERE `Credit amount` > (
  SELECT AVG(`Credit amount`) FROM german_credit_data c2 WHERE c2.Job = c.Job
)
ORDER BY Job;

-- Calculate risk rate per savings category in the WITH clause, then filter in the main query.
WITH savings_risk AS (
  SELECT `Saving accounts`,
         COUNT(*) AS total,
         SUM(CASE WHEN Risk = 'bad' THEN 1 ELSE 0 END) AS bad_count
  FROM german_credit_data
  GROUP BY `Saving accounts`
)
SELECT `Saving accounts`, total, bad_count,
       ROUND(bad_count * 100.0 / total, 1) AS bad_risk_pct
FROM savings_risk
WHERE total > 10
ORDER BY bad_risk_pct DESC; 

-- Who are the top 5% of borrowers by credit amount across the whole dataset?
SELECT * FROM (
  SELECT *,
         PERCENT_RANK() OVER (ORDER BY `Credit amount` DESC) AS pct_rank
  FROM german_credit_data
) ranked
WHERE pct_rank <= 0.05;
