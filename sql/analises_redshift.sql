-- ================================================
-- PicPay Fraud Sentinel — Análises no Redshift
-- Tabela: public.transacoes_fraude
-- ================================================

-- 1. Visão geral das transações por tipo
SELECT
    type,
    COUNT(*)                              AS total_transacoes,
    SUM(isFraud)                          AS fraudes_reais,
    ROUND(AVG(amount), 2)                 AS valor_medio,
    ROUND(SUM(amount), 2)                 AS volume_total
FROM public.transacoes_fraude
GROUP BY type
ORDER BY fraudes_reais DESC;

-- 2. Fraudes com maior valor — alto risco
SELECT
    type,
    nameOrig,
    nameDest,
    ROUND(amount, 2)          AS valor,
    ROUND(erro_saldo_orig, 2) AS erro_saldo,
    isFraud
FROM public.transacoes_fraude
WHERE isFraud = 1
ORDER BY amount DESC
LIMIT 20;

-- 3. Contas laranja — destinos com múltiplas origens fraudulentas
SELECT
    nameDest,
    COUNT(DISTINCT nameOrig)  AS origens_diferentes,
    COUNT(*)                  AS total_recebimentos,
    ROUND(SUM(amount), 2)     AS total_recebido,
    SUM(isFraud)              AS fraudes_confirmadas
FROM public.transacoes_fraude
GROUP BY nameDest
HAVING SUM(isFraud) > 0
ORDER BY fraudes_confirmadas DESC, total_recebido DESC
LIMIT 20;

-- 4. Padrão temporal — fraudes por hora do dia
SELECT
    MOD(step, 24)             AS hora_do_dia,
    COUNT(*)                  AS total_transacoes,
    SUM(isFraud)              AS fraudes,
    ROUND(AVG(amount), 2)     AS valor_medio
FROM public.transacoes_fraude
GROUP BY hora_do_dia
ORDER BY fraudes DESC
LIMIT 10;