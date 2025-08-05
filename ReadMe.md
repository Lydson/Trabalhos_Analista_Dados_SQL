# PROJETO - Analise de trabalhos de analista de dados
Este projeto é baseado no projeto criado por Luke Barousse sobre analise de trabalhos no Linkedin focado na área de dados.

Aqui veremos em específico o trabalho do analista de dados.

Para ver os resultados da análise, clique no link a seguir: 

[project_sql folder](/project_sql/)

## Perguntas para Responder:
1. Quais são os cargos mais bem pagos para a minha função?
2. Quais são as habilidades necessárias para essas funções com altos salários?
3. Quais são as habilidades mais procuradas para a minha função?
4. Quais são as principais habilidades com base no salário para a minha função?
5. Quais são as habilidades mais adequadas para aprender?
Ideal: Alta Demanda E Alta Remuneração

## Dataset
Como a base de dados em CSV era muito grande para o Github, disponibilizo abaixo o link direto para download:

[dataset](lukeb.co/sql_project_csvs)

## Ferramentas usadas
- **SQL**: para consultar o banco de dados e descobrir insights críticos;
- **PostgreSQL**: o sistema de gerenciamento de banco de dados;
- **Visual Studio Code**: usado para o gerenciamento de banco de dados e execução de consultas SQL;
- **Git e GitHub**: para controle de versões e compartilhamento de meus scripts e análises SQL.

## Análise
Foram feitas 5 queries com o objetivo de investigar aspectos específicos do mercado de trabalho de analista de dados. Abaixo uma explicação de cada uma:

### 1. Vagas de Analista de Dados Mais Bem Pagas
Para identificar as vagas mais bem pagas, filtrei as vagas de analista de dados por salário médio anual e localização, com foco em empregos remotos. Esta consulta destaca as oportunidades de alta remuneração na área como analista de dados.

``` sql
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
```
Veja a lista dos principais cargos de analista de dados em 2023:

- Faixa Salarial: Os 10 cargos de analista de dados com os melhores salários variam de US$ 184.000 a US$ 650.000. Isso indica um salarial significativo na área.
- Empregadores Diversos: Empresas como SmartAsset, Meta e AT&T estão entre as que oferecem altos salários, demonstrando um amplo interesse em diferentes setores.
- Variedade de Cargos: Há uma grande diversidade de cargos, de Analista de Dados a Diretor de Análise, refletindo a variedade de funções e especializações em análise de dados.

![Cargos mais bem pagos](assets\1_top_paying_jobs.png)
*Gráfico de barra para vizualizar os 10 maiores salários para a analista de dados. Gerado pelo ChatGPT a partir da query SQL 1*

### 2. Habilidades para os Cargos Mais Bem Pagos

Para entender quais habilidades são mais valorizadas nos cargos com salários mais altos, cruzei os dados das vagas com as informações de competências, revelando o que as empresas mais valorizam nessas posições de alta remuneração.

```sql
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
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC;
```

Abaixo estão as habilidades mais presentes nas 10 vagas de analista de dados com os maiores salários em 2023:

* **SQL** aparece em destaque, sendo exigido em 8 das 10 vagas.
* **Python** também é altamente requisitado, presente em 7 das vagas.
* **Tableau** surge como uma ferramenta muito valorizada, com 6 menções.
  Outras competências como **R**, **Snowflake**, **Pandas** e **Excel** aparecem com menor frequência, mas ainda são relevantes.

![Habilidades mais bem pagas](assets\2_top_paying_job_skills.png)
*Gráfico de barras mostrando a frequência das habilidades nas 10 vagas mais bem pagas para analistas de dados. Criado a partir dos resultados da consulta SQL acima.*

---

### 3. Habilidades Mais Requisitadas para Analistas de Dados

A consulta a seguir identificou quais habilidades são mais mencionadas nas descrições de vagas, destacando onde estão as maiores demandas.

```sql
SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' 
    AND job_work_from_home = True 
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5;
```

Resumo das habilidades mais procuradas para analistas de dados em 2023:

* **SQL** e **Excel** continuam sendo fundamentais, reforçando a importância de bases sólidas em manipulação de dados e planilhas.
* Ferramentas de **programação** e **visualização de dados** como **Python**, **Tableau** e **Power BI** são cada vez mais exigidas, refletindo o valor de competências técnicas para suporte à decisão.

| Habilidade   | Contagem da demanda |
| -------- | ------------ |
| SQL      | 7291         |
| Excel    | 4611         |
| Python   | 4330         |
| Tableau  | 3745         |
| Power BI | 2609         |

*Tabela com as 5 habilidades mais solicitadas em vagas para analistas de dados.*

---

### 4. Habilidades Relacionadas aos Maiores Salários

Esta consulta buscou entender quais habilidades estão associadas aos maiores salários médios nas vagas para analistas de dados.

```sql
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
LIMIT 25;
```

Resumo das habilidades com os maiores salários para analistas de dados:

* **Big Data e Machine Learning**: Tecnologias como PySpark, Couchbase, DataRobot e Jupyter estão entre as mais bem pagas, demonstrando o valor atribuído a competências em processamento e modelagem preditiva.
* **Desenvolvimento e Deploy de Software**: Ferramentas como GitLab, Kubernetes e Airflow aparecem como diferenciais lucrativos, indicando uma valorização de quem domina automação e pipelines de dados.
* **Computação em Nuvem**: Conhecimentos em ferramentas como Elasticsearch, Databricks e GCP reforçam a crescente demanda por soluções baseadas em nuvem.

| Habilidade        | Salário Médio (\$) |
| ------------- | ------------------: |
| pyspark       |             208,172 |
| bitbucket     |             189,155 |
| couchbase     |             160,515 |
| watson        |             160,515 |
| datarobot     |             155,486 |
| gitlab        |             154,500 |
| swift         |             153,750 |
| jupyter       |             152,777 |
| pandas        |             151,821 |
| elasticsearch |             145,000 |

---

### 5. Habilidades Mais Estratégicas para Aprender

Combinando informações de demanda e salário, essa análise aponta quais habilidades são ao mesmo tempo bem pagas e muito procuradas — um ótimo ponto de partida para quem quer investir em sua carreira.

```sql
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
```

| Skill ID | Habilidade     | Contagem da Demanda | Salário Médio (\$) |
| -------- | ---------- | ------------ | ------------------: |
| 8        | go         | 27           |             115,320 |
| 234      | confluence | 11           |             114,210 |
| 97       | hadoop     | 22           |             113,193 |
| 80       | snowflake  | 37           |             112,948 |
| 74       | azure      | 34           |             111,225 |
| 77       | bigquery   | 13           |             109,654 |
| 76       | aws        | 32           |             108,317 |
| 4        | java       | 17           |             106,906 |
| 194      | ssis       | 12           |             106,683 |
| 233      | jira       | 20           |             104,918 |

Resumo das habilidades mais estratégicas para analistas de dados em 2023:

* **Linguagens de Programação em Alta**: Python e R continuam liderando em termos de procura, embora seus salários médios sejam um pouco mais modestos, mostrando que são amplamente requisitadas, mas também bastante ofertadas.
* **Tecnologias de Nuvem e Big Data**: Habilidades como Snowflake, Azure, AWS e BigQuery oferecem boas remunerações e têm boa demanda, sendo um diferencial competitivo.
* **Ferramentas de BI e Visualização**: Tableau e Looker mostram que a capacidade de transformar dados em insights visuais é extremamente valorizada no mercado.
* **Bancos de Dados**: Conhecimentos em tecnologias como Oracle, SQL Server e NoSQL ainda são indispensáveis, com salários médios consideráveis.

---

## O que Aprendi

Durante essa análise, aprimorei consideravelmente minha habilidade com SQL:

* **🧩 Consultas Complexas:** Aprendi a usar `WITH` e `JOIN` de forma eficaz para combinar tabelas e construir consultas robustas.
* **📊 Agregações de Dados:** Dominei `GROUP BY`, `COUNT()` e `AVG()` para resumir e extrair insights relevantes dos dados.
* **💡 Análise Prática:** Transformei problemas do mundo real em consultas SQL acionáveis, gerando insights úteis para tomada de decisão.

---

## Conclusões

1. **Vagas com Maiores Salários:** As oportunidades mais bem pagas para analistas de dados remotos podem ultrapassar os \$650.000 anuais.
2. **Habilidades para Bons Salários:** SQL é uma habilidade essencial nas vagas mais bem remuneradas.
3. **Habilidades Mais Demandadas:** SQL também é a competência mais requisitada no mercado, sendo indispensável para quem busca uma vaga.
4. **Habilidades com Maiores Salários Médios:** Competências como SVN e Solidity estão entre as mais lucrativas, indicando valorização de especializações.
