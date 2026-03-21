# PicPay Fraud Sentinel 🛡️

Pipeline de detecção de fraude em transações Pix usando o stack 
real de dados — PySpark, Databricks e SQL.

## Problema de negócio

O PicPay processa milhões de transações Pix por dia. Fraudes como 
account takeover, golpe do comprovante falso e uso de contas laranja 
geram prejuízo direto e afetam a confiança dos usuários.

Este projeto simula o pipeline de detecção de fraude que um time de 
Data Science desenvolveria para identificar transações suspeitas em 
tempo real.

## Arquitetura do pipeline
```
CSV (PaySim) → PySpark (Colab) → Feature Engineering → 
Random Forest → Resultados → Databricks SQL Warehouse → 
Queries Analíticas
```

## Stack utilizado

| Ferramenta | Uso |
|---|---|
| PySpark 4.0 | Processamento distribuído dos dados |
| Spark SQL | Análises e Window Functions |
| Spark MLlib | Treinamento do modelo Random Forest |
| Databricks SQL Warehouse | Armazenamento e consultas analíticas |
| Python / Pandas | Exportação dos resultados |
| Google Colab | Ambiente de desenvolvimento |

## Dataset

**PaySim** — simulação de 6,3 milhões de transações mobile  
Fonte: Kaggle (ealaxi/paysim1)  
Tipos: CASH-IN, CASH-OUT, TRANSFER, PAYMENT, DEBIT

## Principais descobertas (EDA)

- Fraudes ocorrem **exclusivamente** em CASH_OUT e TRANSFER
- Valor médio de fraude é **8x maior** que transações legítimas
- Contas fraudulentas realizam exatamente **1 transação** 
  (conta laranja descartável)
- Contas destino de fraude recebem de **múltiplas origens**

## Feature Engineering

Features criadas a partir dos padrões descobertos na EDA:

| Feature | Lógica | Importância |
|---|---|---|
| erro_saldo_orig | Diferença entre saldo esperado e real | 39.82% |
| proporcao_saldo | Valor / saldo disponível | 32.70% |
| oldbalanceOrg | Saldo original da conta | 10.41% |
| newbalanceOrig | Saldo após transação | 6.14% |

## Resultados do modelo

| Métrica | CASH_OUT | TRANSFER |
|---|---|---|
| Recall | 99.53% | 99.87% |
| Fraudes detectadas | 858/853 | 758/759 |

**AUC-ROC: 1.0** 
> Nota: AUC perfeito indica possível data leakage no dataset 
> sintético (PaySim). Em produção com dados reais, AUC de 0.85~0.92 
> seria o esperado para este tipo de modelo.

## Como executar

1. Baixe o dataset: kaggle.com/datasets/ealaxi/paysim1
2. Abra `notebooks/fraud_sentinel.ipynb` no Google Colab
3. Execute as células em ordem
4. Importe `resultado_fraude_sentinel.csv` no Databricks
5. Execute as queries em `sql/analises_databricks.sql`

## Autor

Ian Oliveira  
[LinkedIn](https://www.linkedin.com/in/ianoliveira) | 
Profissional de TI em transição para Data Science
