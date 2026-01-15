# Base de Dados — Processamento e Extração (Notebook)

Este documento descreve, de forma robusta, tudo o que foi feito no notebook de extração e processamento de dados da temporada do Brasileirão 2025, que está em [Base de dados/notebook_extracao_dados.ipynb](Base%20de%20dados/notebook_extracao_dados.ipynb).

---

## Objetivo

- Ler os arquivos CSV por rodada da pasta [Base de dados/cartola/](Base%20de%20dados/cartola/) (rodadas 1 a 38)
- Enriquecer os dados com colunas de apoio (posição, ranking, percentil, classificação)
- Salvar os CSVs processados por rodada em [Base de dados/cartola_processado/](Base%20de%20dados/cartola_processado/)
- Gerar um CSV consolidado para alimentar a API do backend: [Base de dados/cartola_api_completo.csv](Base%20de%20dados/cartola_api_completo.csv)
- Validar consultas típicas que o backend expõe (jogadores, rankings, comparações, estatísticas de clube)

---

## Estrutura de Pastas e Arquivos

- [Base de dados/cartola/](Base%20de%20dados/cartola/)  
  CSVs originais por rodada (rodada-1.csv a rodada-38.csv)

- [Base de dados/cartola_processado/](Base%20de%20dados/cartola_processado/)  
  Saídas geradas pelo notebook:
  - `rodada-N_processado.csv` (N = 1..38): enriquecido com posição, ranking, percentil, classificação e destaque
  - `resumo_rodadas.csv`: agregação por rodada (jogaram, maior/média pontuação)

- [Base de dados/cartola_api_completo.csv](Base%20de%20dados/cartola_api_completo.csv)  
  CSV mestre, consolidando todas as rodadas, usado diretamente pela API do backend

---

## Principais Etapas (Notebook)

1) Verificação de amostra
- Leitura de [rodada-1.csv](Base%20de%20dados/cartola/rodada-1.csv) e inspeção (`head()`, `info()`) para validar colunas e tipos

2) Definição de regras de pontuação (Scouts)
- Tabela `SCOUTS_PESOS` com pesos (Cartola FC):
  - Defesa: `DS=+1.2`, `FC=-0.3`, `CA=-1.0`, `CV=-3.0`, `SG=+5.0`, `DE=+1.0`, `DP=+7.0`, `GS=-1.0`, `PC=-1.0`
  - Ataque: `FS=+0.5`, `PE=-0.1`, `A=+5.0`, `FT=+3.0`, `FD=+1.2`, `FF=+0.8`, `G=+8.0`, `I=-0.1`, `PP=-4.0`, `PS=+1.0`
- Posições com bônus de `SG`: Goleiro, Lateral, Zagueiro (`POSICOES_COM_SG = [1,2,3]`)
- Scouts exclusivos do goleiro: `['DE','DP','GS']`

3) Top pontuações por rodada
- Para cada rodada (1..38), filtra quem entrou em campo (`atletas.entrou_em_campo == True`)
- Identifica o jogador de maior pontuação, guarda (`Rodada`, `Atleta`, `Clube`, `Posição`, `Pontuação`)
- Gera DataFrame `df_resultados` e exibe os Top 10

4) Processamento por rodada (saída `rodada-N_processado.csv`)
- Mapeia posição (`atletas.posicao_id → posicao_nome`)
- Calcula `ranking_rodada` para quem jogou (rank por `atletas.pontos_num`)
- Calcula `percentil_pontuacao` (0–100) para quem jogou
- Classifica desempenho (`Excelente`, `Muito Bom`, `Bom`, `Regular`, `Ruim`)
- Marca `destaque_rodada` para Top 10% da pontuação
- Salva cada rodada em [Base de dados/cartola_processado/rodada-N_processado.csv](Base%20de%20dados/cartola_processado/rodada-1_processado.csv)
- Gera [Base de dados/cartola_processado/resumo_rodadas.csv](Base%20de%20dados/cartola_processado/resumo_rodadas.csv) com agregações

5) Consolidação (saída `cartola_api_completo.csv`)
- Adiciona metadados: `rodada`, `temporada`
- Renomeia colunas para padronização (ex.: `atletas.atleta_id → id_jogador`, `atletas.apelido → apelido`, `atletas.pontos_num → pontos_cartola`)
- Mapeia posição: `posicao_id → posicao_nome` e `posicao_sigla` (`GOL`, `LAT`, `ZAG`, `MEI`, `ATA`, `TEC`)
- Garante scouts com números (faltantes viram 0)
- Cria métricas derivadas: `finalizacoes_perigosas = FD + FT`, `total_finalizacoes = FD + FT + FF`, `defesas_totais = DE + DP`
- Seleciona colunas úteis para a API e concatena todas as rodadas
- Salva CSV mestre: [Base de dados/cartola_api_completo.csv](Base%20de%20dados/cartola_api_completo.csv)
- Exibe estatísticas: total de registros (~28.589), jogadores únicos (~980), clubes únicos, intervalo de rodadas

6) Validações (simulações de endpoints)
- Filtragem típica `GET /jogadores?clube=FLA&posicao=ATA`
- Perfil de jogador (ex.: "Lucero"): ID, clube, posição, jogos, pontos, média, gols, assistências, desarmes
- Histórico de rodadas (Top 5 do jogador)
- Ranking da rodada (ex.: `rodada=21`, `limite=5`)
- Comparação (ex.: Lucero vs Neymar)
- Estatísticas de clube (ex.: `FLA`)

---

## Esquema do CSV Consolidado (cartola_api_completo.csv)

Principais colunas:
- Identificação: `id_jogador`, `nome_completo`, `apelido`, `slug`
- Clube/Posição: `clube_id`, `clube_sigla`, `posicao_id`, `posicao_nome`, `posicao_sigla`
- Contexto: `rodada`, `temporada`, `entrou_em_campo`
- Cartola: `pontos_cartola`, `preco`, `media_pontos`, `jogos_acumulados`, `variacao_preco`, `status_id`
- Mídia: `foto_url`
- Scouts (normatizados): `DS`, `FC`, `FD`, `FF`, `FS`, `G`, `CA`, `I`, `DE`, `DP`, `GS`, `SG`, `A`, `FT`, `PS`, `PC`, `CV`, `PP`, `GC`, `V`
- Derivadas: `finalizacoes_perigosas`, `total_finalizacoes`, `defesas_totais`

---

## Métricas e Estatísticas

- Registros totais: ~28.589  
- Jogadores únicos: ~980  
- Clubes únicos: 20  
- Rodadas: 1 a 38  
- Colunas disponíveis: 60+ (inclui scouts e derivadas)

---

## Como Reproduzir (Passo a Passo)

1) Preparar ambiente (Python 3.10+)

```bash
python -m venv .venv
. .venv/Scripts/Activate.ps1 
pip install pandas jupyter
```

2) Abrir o notebook

```bash
jupyter notebook Base\ de\ dados/notebook_extracao_dados.ipynb
```

3) Executar todas as células
- Verifique paths relativos (notebook assume pasta atual como `Base de dados/`)
- Ao final, os arquivos devem existir:
  - [Base de dados/cartola_processado/resumo_rodadas.csv](Base%20de%20dados/cartola_processado/resumo_rodadas.csv)
  - [Base de dados/cartola_processado/rodada-N_processado.csv](Base%20de%20dados/cartola_processado/rodada-1_processado.csv)
  - [Base de dados/cartola_api_completo.csv](Base%20de%20dados/cartola_api_completo.csv)

---

## Dicas & Troubleshooting

- "File not found" ao ler uma rodada: valide o nome do arquivo na pasta [Base de dados/cartola/](Base%20de%20dados/cartola/)
- Diferença de encoding/sep: `pd.read_csv(..., sep=',', encoding='utf-8')`
- Performance: use `chunksize` ou rode em máquina com mais RAM; o consolidado concatena 38 CSVs
- Caminhos com espaço (Windows): escape ou use aspas, ex.: `"Base de dados/cartola/rodada-1.csv"`

---

## Relação com o Backend e Frontend

- Backend consome diretamente [Base de dados/cartola_api_completo.csv](Base%20de%20dados/cartola_api_completo.csv) para todos os endpoints.
- Frontend utiliza os endpoints do backend para exibir rankings, comparações, detalhes e gráficos.

Consulte:
- Documentação da API: [backend/README.md](backend/README.md)
- Documentação do Frontend: [frontend/README.md](frontend/README.md)

---

## Checklist de Entregas (Notebook)

- [x] Definição de pesos e regras de scouts
- [x] Processamento e classificação por rodada (38 arquivos)
- [x] Resumo de rodadas
- [x] CSV mestre consolidado para a API
- [x] Validações de consultas típicas (jogadores, rankings, comparação, clube)

---

## Observações Finais

- O notebook foi estruturado para ser claro, reproduzível e diretamente útil ao backend.
- As colunas foram padronizadas para facilitar consumo e documentação (Swagger).
- Os artefatos gerados estão versionados na pasta [Base de dados/](Base%20de%20dados/).

