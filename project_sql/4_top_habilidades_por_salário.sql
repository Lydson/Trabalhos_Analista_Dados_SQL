/*
Pergunta: Quais são as principais habilidades com base no salário?
- Salário médio associado a cada habilidade para cargos de Analista de Dados
- Funções com salários específicos, independentemente da localização
- Por quê? Revela como diferentes habilidades impactam os níveis salariais para Analistas de Dados e ajuda a identificar as habilidades financeiramente mais gratificantes para adquirir ou aprimorar.
*/

SELECT
    skills,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    -- AND job_work_from_home = True
GROUP BY 
    skills
ORDER BY
    avg_salary DESC
LIMIT 25

-- Abaixo para trabalhos remotos
SELECT
    skills,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = True
GROUP BY 
    skills
ORDER BY
    avg_salary DESC
LIMIT 25

/*
🔍 Insights:
1. Big Data e Cloud valem mais
Habilidades como PySpark (processamento distribuído) indicam que profissionais que lidam com grandes volumes de dados e engenharia de dados são mais valorizados.

2. Ferramentas de automação e IA são premiadas
Watson (da IBM) e DataRobot são plataformas de IA e AutoML — quem sabe usá-las tende a atuar em empresas que pagam mais por automação de insights.

3. Integração com DevOps cresce em importância
Bitbucket (controle de versão/Git) aparece bem, indicando que trabalhar com versionamento e pipelines está cada vez mais associado a salários maiores.

4. Ferramentas mais tradicionais (Excel, Power BI, SQL) não aparecem no topo do ranking salarial, mas continuam essenciais para entrar na área.

📈 Tendência de mercado:
- O analista de dados do futuro se aproxima do perfil de engenheiro de dados + analista de negócio.
- Dominar pipelines de dados, automação e cloud está se tornando diferencial competitivo para salários acima de $150k/ano nos EUA.
*/