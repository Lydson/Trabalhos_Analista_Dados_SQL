/*
Resposta: Quais são as habilidades mais adequadas para aprender (ou seja, se estão em alta demanda e são bem remuneradas)?
- Identificar habilidades em alta demanda e associadas a altos salários médios para cargos de Analista de Dados
- Concentrar-se em cargos remotos com salários médios
- Por quê? Visa habilidades que oferecem segurança no emprego (alta demanda) e benefícios financeiros altos salários), oferecendo insights estratégicos para o desenvolvimento de carreira em análise de dados
*/

-- Identificar habilidades em alta demanda para vagas de analista de dados usando o resultado 3
WITH skills_demand AS (
    SELECT
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst' 
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = True 
    GROUP BY
        skills_dim.skill_id
), 
-- Habilidades com salários médios altos para analista de dados usando o resultado 4
average_salary AS (
    SELECT 
        skills_job_dim.skill_id,
        ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = True 
    GROUP BY
        skills_job_dim.skill_id
)

-- Retorna 10 habilidades em alta demanda e com altos salários
SELECT
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
FROM
    skills_demand
INNER JOIN  average_salary ON skills_demand.skill_id = average_salary.skill_id
WHERE  
    demand_count > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25;

-- Mesma query escrita mais sucintamente
SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = True 
GROUP BY
    skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.job_id) > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25;

/*
As habilidades mais relevantes para analistas de dados em 2023
1. Linguagens de Programação em Alta Demanda
Python e R se destacam como as linguagens mais requisitadas, com 236 e 148 menções, respectivamente. Apesar dessa alta procura, os salários médios giram em torno de US$ 101.397 para Python e US$ 100.499 para R — o que mostra que essas habilidades são muito valorizadas, mas também amplamente dominadas no mercado.

2. Ferramentas e Tecnologias em Nuvem
Conhecimentos em plataformas como Snowflake, Azure, AWS e BigQuery estão cada vez mais em evidência. Essas tecnologias têm alta demanda e oferecem salários médios elevados, o que evidencia a crescente importância da computação em nuvem e do big data no trabalho de análise de dados.

3. Ferramentas de BI e Visualização de Dados
Soluções como Tableau (com 230 menções) e Looker (com 49) demonstram o papel essencial da visualização e da inteligência de negócios. Os salários médios são competitivos — em torno de US$ 99.288 para Tableau e US$ 103.795 para Looker —, reforçando que saber apresentar dados de forma clara e estratégica é um diferencial.

4. Tecnologias de Banco de Dados
A demanda por habilidades em bancos tradicionais e NoSQL (como Oracle, SQL Server e NoSQL) continua alta. Os salários médios variam de US$ 97.786 a US$ 104.534, refletindo a importância constante de saber armazenar, consultar e gerenciar grandes volumes de dados com eficiência.
*/