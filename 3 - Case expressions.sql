-- 3 CASE EXPRESSIONS
/*
Criação de uma nova coluna para dividir os trabalhos como:
- 'Anywere' jobs as 'Remote'
- 'New York, NY' jobs as 'Local'
- De outra forma 'Onsite'
*/

SELECT
    COUNT(job_id) AS number_of_jobs,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    location_category
ORDER BY number_of_jobs DESC;
