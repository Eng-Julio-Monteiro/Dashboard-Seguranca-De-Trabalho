-- criação
CREATE TABLE acidentes_trabalho(
    id INT PRIMARY KEY,
    data_acidente DATE,
    setor VARCHAR(50),
    tipo_acidente VARCHAR(50),
    gravidade VARCHAR(20),
    funcionario_id INT,
    tempo_empresa_anos INT,
    uso_epi VARCHAR(10),
    turno VARCHAR(20),
    dias_sem_acidente INT
);

SELECT * FROM acidentes_trabalho
WHERE gravidade = 'Grave';
--qual setor tem mais acidentes?
SELECT setor, COUNT(*) 
FROM acidentes_trabalho
GROUP BY setor;
-- para saber sobre taxas de acidentes!
SELECT 
    COUNT(*) * 100.0 / (SELECT COUNT(*) FROM acidentes_trabalho) AS perc_graves
FROM acidentes_trabalho
WHERE gravidade = 'Grave';
--ESTAVAM usando EPIS?
SELECT 
    uso_epi,
    COUNT(*) AS total
FROM acidentes_trabalho
GROUP BY uso_epi;
-- INSERINDO MAIS DADOS NA TABELA DE FORMA ALEATORIA
INSERT INTO acidentes_trabalho (
    id, data_acidente, setor, tipo_acidente, gravidade,
    funcionario_id, tempo_empresa_anos, uso_epi, turno, dias_sem_acidente
)
SELECT 
    generate_series(11,110) AS id,
    DATE '2025-01-01' + (random() * 60)::int AS data_acidente,

    (ARRAY['Produção','Manutenção','Logística','Qualidade'])[floor(random()*4)+1],

    (ARRAY['Corte','Queda','Colisão','Queimadura','Prensagem','Choque elétrico'])[floor(random()*6)+1],

    (ARRAY['Leve','Moderado','Grave'])[floor(random()*3)+1],

    (random()*2300)::int,

    (random()*10)::int,

    (ARRAY['Sim','Não'])[floor(random()*2)+1],

    (ARRAY['Manhã','Tarde','Noite'])[floor(random()*3)+1],

    (random()*10)::int
;
--Tempo de empresa vs acidentes
SELECT 
    CASE 
        WHEN tempo_empresa_anos <= 2 THEN 'Iniciante'
        WHEN tempo_empresa_anos <= 5 THEN 'Intermediário'
        ELSE 'Experiente'
    END AS nivel,
    COUNT(*) AS total
FROM acidentes_trabalho
GROUP BY nivel;
--turno que mais tem ocorrência de acidentes:
SELECT 
    turno,
    COUNT(*) AS total
FROM acidentes_trabalho
GROUP BY turno
ORDER BY total DESC;
--uso de EPIS X ACIDENTES
SELECT 
    uso_epi,
    COUNT(*) AS total
FROM acidentes_trabalho
GROUP BY uso_epi;
--QUAIS FORAM OS ACIDENTES MAIS RECENTE?
SELECT * FROM acidentes_trabalho
ORDER BY data_acidente DESC;
--maior periodo sem acidentes na empresas?
SELECT MAX(dias_sem_acidente) AS maior_periodo_sem_acidentes
FROM acidentes_trabalho;
--informa qual foi o acidente
SELECT *
FROM acidentes_trabalho
ORDER BY dias_sem_acidente DESC
LIMIT 1;
--“Era contratado ou estagiário?”
--“Era do chão de fábrica ou administrativo?”
--não tinha essas informações então vamos adicionar na tabela
ALTER TABLE acidentes_trabalho
ADD COLUMN tipo_contrato VARCHAR(20),
ADD COLUMN nivel_funcao VARCHAR(30);
--inserindo agora dados variados para eles;
UPDATE acidentes_trabalho
SET 
tipo_contrato = (ARRAY['CLT','Terceirizado','Estagiário'])[floor(random()*3)+1],
nivel_funcao = (ARRAY['Operacional','Administrativo','Técnico','Supervisão'])[floor(random()*4)+1];
--vamos visualizar a tabela novamente;
select *
from acidentes_trabalho;
-- QUEM MAIS SOFREM ACIDENTES?
SELECT nivel_funcao, COUNT(*) 
FROM acidentes_trabalho
GROUP BY nivel_funcao
ORDER BY COUNT(*) DESC;
--Tipo de contrato mais afetado!
SELECT tipo_contrato, COUNT(*)
FROM acidentes_trabalho
GROUP BY tipo_contrato
ORDER BY COUNT(*) DESC;
--DADOS CRUZADOS RESUMO
SELECT nivel_funcao, gravidade, COUNT(*)
FROM acidentes_trabalho
GROUP BY nivel_funcao, gravidade
ORDER BY COUNT(*) DESC;
