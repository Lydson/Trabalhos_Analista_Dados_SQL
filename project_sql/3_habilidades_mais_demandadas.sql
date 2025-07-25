/*
Pergunta: Quais são as habilidades mais procuradas para analistas de dados no Brasil?
- Unindo anúncios de emprego a uma tabela de junção interna semelhante à consulta 2
- Identificar as 5 principais habilidades em demanda para um analista de dados.
- Concentre-se em todos os anúncios de emprego.
- Por quê? Recupera as 5 principais habilidades com maior demanda no mercado de trabalho, fornecendo insights sobre as habilidades mais valiosas para quem procura emprego.
*/
SELECT
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Brazil'
GROUP BY 
    skills
ORDER BY
    demand_count DESC
LIMIT 5

/*
FORMA ALTERNATIVA DE RESOLVER
Contagem do número de vagas de emprego remotas por habilidade:
- Exiba as 5 principais habilidades por sua demanda em empregos remotos
- Inclua o ID da habilidade, o nome e a contagem de vagas que exigem a habilidade
*/
WITH remote_job_skills AS(
SELECT
    skill_id,
    COUNT(*) AS skill_count
FROM
    skills_job_dim AS skills_to_job
INNER JOIN job_postings_fact AS job_postings 
    ON job_postings.job_id = skills_to_job.job_id
WHERE
    job_postings.job_work_from_home = TRUE AND
    job_postings.job_title_short = 'Data Analyst'
GROUP BY
    skill_id
)

SELECT 
    skills.skill_id,
    skills AS skill_name,
    skill_count
FROM remote_job_skills
INNER JOIN skills_dim AS skills
    ON skills.skill_id = remote_job_skills.skill_id
ORDER BY skill_count DESC
LIMIT 5;