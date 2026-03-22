
-- 1. Visão geral da performance do modelo por tipo de transação
SELECT 
    type,
    COUNT(*)                                           AS total_transacoes,
    SUM(CAST(isFraud AS INT))                          AS fraudes_reais,
    SUM(CAST(prediction AS INT))                       AS fraudes_detectadas,
    ROUND(AVG(score_fraude) * 100, 4)                  AS score_medio_pct,
    ROUND(SUM(CASE WHEN prediction = 1 
              AND isFraud = 1 THEN 1 ELSE 0 END) * 100.0 
              / NULLIF(SUM(CAST(isFraud AS INT)),0), 2) AS recall_pct
FROM pagbank_fraude.resultado_fraude_sentinel
GROUP BY type
ORDER BY fraudes_reais DESC;

-- 2. Transações de alto risco (score > 0.8) — bloqueio automático
SELECT
    type,
    nameOrig,
    nameDest,
    ROUND(amount, 2)           AS valor,
    ROUND(proporcao_saldo, 2)  AS proporcao_saldo,
    ROUND(score_fraude, 4)     AS score_fraude,
    isFraud                    AS fraude_real
FROM pagbank_fraude.resultado_fraude_sentinel
WHERE score_fraude > 0.8
ORDER BY score_fraude DESC
LIMIT 20;

-- 3. Identificação de contas laranja
SELECT
    nameDest,
    COUNT(DISTINCT nameOrig)          AS origens_diferentes,
    COUNT(*)                          AS total_recebimentos,
    ROUND(SUM(amount), 2)             AS total_recebido,
    SUM(CAST(isFraud AS INT))         AS confirmadas_fraude,
    ROUND(AVG(score_fraude), 4)       AS score_medio
FROM pagbank_fraude.resultado_fraude_sentinel
GROUP BY nameDest
HAVING COUNT(DISTINCT nameOrig) > 3
ORDER BY confirmadas_fraude DESC, score_medio DESC
LIMIT 20;
