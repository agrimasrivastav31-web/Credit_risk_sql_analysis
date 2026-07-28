# Credit Risk Analysis (SQL)

## Objective
Analyzed a 1,000-record German credit dataset to identify patterns 
in borrower risk across loan purpose, savings status, housing, and age.

## Tools
MySQL Workbench, Excel

## Key Questions Explored
- Which loan purposes carry the highest bad-risk rate?
- Do bad-risk borrowers take larger or longer loans on average?
- How does risk vary by savings account level and housing status?
- Who are the top borrowers within each loan purpose category?

## Key Findings
- Loan taken for vacations/others has the highest bad risk rate of 41.67%.
- Bad-risk borrowers take loans for longer duration (24.9 months) compared to 
  good-risk borrowers (19.2 months).
- Bad-risk rate drops steadily as savings level increases — from 36% for 
  borrowers with "little" savings down to 12.5% for those with "rich" savings.
- Borrowers with free or rented housing show notably higher bad-risk rates 
  (40.7% and 39.1%) than those who own their home (26.1%).
## Techniques Used
Aggregate functions, GROUP BY/HAVING, CASE WHEN bucketing, 
correlated subqueries, window functions (RANK, PERCENT_RANK), CTEs

## Data Source
[German Credit Risk dataset – Kaggle](https://www.kaggle.com/datasets/kabure/german-credit-data-with-risk)
