/*
Pergunta: Quais são os empregos de analista de dados mais bem pagos?
- Identificar as 10 vagas de Analista de Dados mais bem pagas que estão disponíveis remotamente.
- Concentra-se em anúncios de emprego com salários específicos (removendo os nulos).
- Por quê? Para destacar as oportunidades mais bem pagas para Analistas de Dados, oferecendo insights sobre a profissão.
*/
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;

/*
Pergunta: Quais são os empregos de analista de dados mais bem pagos no BRASIL?
*/
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Brazil' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 5;