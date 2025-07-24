-- UNION para combinar tabelas
SELECT
    job_title_short,
    company_id,
    job_location
FROM
    january_jobs

UNION ALL

-- Adicionar trabalhos e empresas de Fevereiro
SELECT
    job_title_short,
    company_id,
    job_location
FROM
    february_jobs

UNION ALL

-- Adicionar trabalhos e empresas de Março
SELECT
    job_title_short,
    company_id,
    job_location
FROM
    march_jobs

/*
Encontre vagas de emprego do primeiro trimestre com salário superior a US$ 70 mil
- Combine tabelas de vagas de emprego do primeiro trimestre de 2023 (janeiro a março)
- Obtenha vagas de emprego com salário médio anual > US$ 70.000
*/
SELECT 
    job_title_short,
    job_location,
    job_via,
    job_posted_date::date,
    salary_year_avg
FROM (
    SELECT *
    FROM january_jobs
    UNION ALL
    SELECT *
    FROM february_jobs
    UNION ALL
    SELECT *
    FROM march_jobs
) AS quarter1_job_postings
WHERE 
    salary_year_avg > 70000 AND
    job_title_short = 'Data Analyst'
ORDER BY
    salary_year_avg DESC;