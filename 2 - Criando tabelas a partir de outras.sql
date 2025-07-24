--CRIAR TABELAS A PARTIR DE OUTRAS TABELAS
-- Abaixo criamos tabelas para as datas dos 3 primeiros meses
CREATE TABLE january_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1;

CREATE TABLE february_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 2;

CREATE TABLE march_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 3;

-- Verificando se foram criadas corretamente
SELECT job_posted_date
FROM march_jobs;