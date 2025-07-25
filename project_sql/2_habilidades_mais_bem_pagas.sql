/*
Pergunta: Quais habilidades são necessárias para os cargos de analista de dados mais bem pagos?
- Aproveitando os 10 cargos de Analista de Dados mais bem pagos da primeira consulta
- Adicionando as habilidades específicas necessárias para essas funções
- Por quê? Ele fornece uma visão detalhada de quais empregos bem remunerados exigem certas habilidades, ajudando os candidatos a entender quais habilidades desenvolver que se alinham aos melhores salários
*/

WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        salary_year_avg,
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
    LIMIT 10
)

SELECT 
    top_paying_jobs.*,
    skills_dim.skills 
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC;

/*
💡 Insights Relevantes:
1. SQL é essencial
Aparece em 8 dos 10 cargos. Continua sendo a base para qualquer analista de dados.
2. Python segue forte
Com 7 ocorrências, mostra que habilidades em programação e automação de análises são valorizadas.
3. Ferramentas de Visualização são destaque
- Tableau (6) e Power BI (2) mostram que saber comunicar dados visualmente é diferencial.
- Ter pelo menos uma ferramenta de BI no currículo é importante.
4. R ainda tem espaço
Apesar de menos usado que Python, aparece em 4 cargos — especialmente em áreas que envolvem estatística.
5. Snowflake, Pandas e Excel
Demonstram a importância de dominar tanto ferramentas modernas (Snowflake, Pandas) quanto tradicionais (Excel).
6. Conhecimento em Cloud e DevOps
Ferramentas como Azure, Bitbucket, GitLab, Confluence e Atlassian indicam que analistas mais bem pagos frequentemente atuam em ambientes integrados com engenharia e nuvem.
*/