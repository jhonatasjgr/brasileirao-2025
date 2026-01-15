# 🛠 Especificação Técnica: Backend CBF Stats (Node.js)

## 1. Contexto e Objetivo

Desenvolver uma **API REST em Node.js (Express)** que serve dados estatísticos do Brasileirão 2025. A fonte de dados é um arquivo CSV único (`cartola_api_completo. csv`) que deve ser carregado em memória na inicialização do servidor.

---

## 2. Stack Tecnológica

- **Runtime**: Node.js (v18+)
- **Framework**: Express.js
- **Leitura de Dados**: csv-parser (ou similar)
- **CORS**: cors (Habilitado para qualquer origem)

---

## 3. Estrutura de Dados (In-Memory)

O sistema **não usa banco de dados SQL/NoSQL**. Ao iniciar, o servidor deve ler o CSV e armazenar os dados em uma variável global (Array de Objetos).

### 3.1. Estrutura do CSV (`cartola_api_completo.csv`)

Cada linha representa a **performance de 1 jogador em 1 rodada**.

- **Identificadores**: `id_jogador`, `apelido`, `clube_sigla`, `posicao_sigla`.
- **Tempo**: `rodada` (1 a 38), `temporada`.
- **Métricas (Acumulativas na rodada)**: `G` (Gols), `A` (Assist.), `DS` (Desarmes), `SG` (Saldo Gol), `DE` (Defesa Difícil), etc.
- **Meta**: `pontos_cartola`, `media_pontos`, `preco`.

### 3.2. Lógica de Agregação (CRÍTICO)

Como o CSV tem histórico, a API deve realizar **agregações em tempo de execução**:

- **Dados Cadastrais**:  Pegar do registro mais recente (`max(rodada)`) do jogador.
- **Totais da Temporada (Soma)**: Somar colunas (`G`, `A`, `DS`, etc.) de todas as rodadas do jogador.
- **Médias**: Calcular `soma(pontos_cartola) / count(jogos_jogados)`.

---

## 4. Endpoints da API

### 📡 Grupo A: Jogadores (Core)

#### 1. `GET /jogadores`

Lista paginada ou completa de jogadores com resumo.

**Filtros (Query Params)**: 
- `busca`: String (Match parcial em `apelido` ou `nome_completo`).
- `clube`: String (Ex: 'FLA', 'PAL').
- `posicao`: String (Ex: 'ATA', 'ZAG', 'GOL').

**Lógica de Implementação**: 
1. Agrupar dados por `id_jogador`.
2. Para cada ID, pegar o registro da última rodada disponível (para foto, nome, clube atual).
3. Aplicar filtros. 

**Response (JSON)**:
```json
[
  {
    "id": 12345,
    "apelido": "Hulk",
    "foto":  "https://...",
    "clube": "CAM",
    "posicao": "ATA",
    "preco": 15.4,
    "media_pontos": 8.5
  }
]
```

---

#### 2. `GET /jogadores/:id`

Detalhes completos de um jogador específico.

**Lógica de Implementação**: 
1. Filtrar todas as linhas onde `id_jogador == :id`.
2. Se vazio, retornar **404**.
3. Calcular objeto `stats_acumulados` somando as colunas de scouts (`G`, `A`, `DS`, `DE`, `SG`, `FS`, `FF`, `FD`).

**Response (JSON)**:
```json
{
  "id": 12345,
  "nome": "Givanildo Vieira...",
  "apelido": "Hulk",
  "clube": "CAM",
  "posicao": "ATA",
  "stats_temporada":  {
    "jogos": 20,
    "gols":  12,
    "assistencias": 5,
    "desarmes": 15,
    "media": 8.50
  }
}
```

---

#### 3. `GET /jogadores/:id/rodadas`

Histórico de pontuação para gráficos.

**Query Params**: `limite` (Opcional, ex: 5).

**Lógica**: 
1. Filtrar linhas do `id_jogador`.
2. Ordenar por `rodada` (Crescente).
3. Se houver `limite`, pegar as últimas N.

**Response (JSON)**: Array de objetos contendo `{ rodada, pontos, adversario (se houver), scouts_principais }`.

---

#### 4. `GET /comparacao`

Compara 2 ou mais jogadores lado a lado.

**Query Params**: `ids` (Lista separada por vírgula:  `123,456`).

**Lógica**:
1. Para cada ID, executar a mesma lógica de agregação do endpoint `/jogadores/:id`.
2. Retornar lista dos objetos processados.

---

### 📡 Grupo B:  Rankings e Tops

Este endpoint deve ser **genérico** para atender todos os requisitos de "Top X".

#### 5. `GET /rankings/:tipo`

Retorna os top jogadores ordenados por uma métrica específica.

**Parâmetros de Rota (`:tipo`)**:
- `pontos` → Ordenar por `media_pontos` ou soma de `pontos_cartola`.
- `gols` → Soma de `G`.
- `assistencias` → Soma de `A`.
- `desarmes` → Soma de `DS`.
- `finalizacoes` → Soma de `finalizacoes_perigosas` (ou `FD + FT`).
- `faltas_sofridas` → Soma de `FS`.
- `faltas_cometidas` → Soma de `FC`.
- `defesas` → Soma de `DE` (ou `DE + DP`).
- `sem_gol` → Soma de `SG` (Apenas defensores).

**Query Params**:
- `rodada`: (Number) Se informado, **NÃO soma a temporada**. Filtra apenas aquela rodada e ordena.
- `posicao`: (String) Filtra pela sigla (`GOL`, `ZAG`, `LAT`, `MEI`, `ATA`).
- `limit`: (Number) Padrão 10.

**Lógica de Implementação (Switch Case)**:
1. Filtrar dataset (se houver param `rodada` usa apenas ela, senão usa todo dataset e agrega por jogador).
2. `switch(tipo)`:
   - Caso `desarmes`: Ordenar decrescente por `soma(DS)`.
   - Caso `gols`: Ordenar decrescente por `soma(G)`.
   - *(Repetir para outros tipos mapeando para colunas do CSV)*. 
3. Aplicar `slice(0, limit)`.

---

### 📡 Grupo C: Clube

#### 6. `GET /estatisticas/clube/:sigla`

**Lógica**:
1. Filtrar todos os jogadores do clube atual.
2. Calcular médias do time. 
3. Identificar o "Artilheiro" (Max `G`) e o "Garçom" (Max `A`) do time.

**Response**: 
```json
{
  "clube": "FLA",
  "total_gols_pro": 45,
  "media_pontos_time": 65.4,
  "destaque_artilheiro": { "apelido": "Pedro", "gols": 15 },
  "destaque_assistencia": { "apelido": "Arrascaeta", "ass": 10 }
}
```

---

## 5. Mapeamento de Colunas (CSV → Código)

Use este dicionário para garantir que o código leia as colunas certas: 

| Parâmetro API | Coluna CSV | Descrição |
|---|---|---|
| Gols | `G` | Gols marcados |
| Assistências | `A` | Assistências |
| Desarmes | `DS` | Desarmes |
| Defesas Difíceis | `DE` | (Goleiros) |
| Defesas Pênalti | `DP` | (Goleiros) |
| Saldo Gol | `SG` | Jogos sem sofrer gol |
| Faltas Sofridas | `FS` | - |
| Faltas Cometidas | `FC` | - |
| Fin. Trave | `FT` | - |
| Fin. Defendida | `FD` | - |
| Fin. Fora | `FF` | - |
| Pontos | `pontos_cartola` | Pontuação da rodada |
| Média | `media_pontos` | Média acumulada |

---

## 6. Instruções para o Desenvolvedor

1. Crie um arquivo **`server.js`**.
2. Use `fs.createReadStream` com `csv-parser` para carregar o arquivo `cartola_api_completo.csv` em um array global `const allData = []` assim que o servidor iniciar. 
3. Crie **funções auxiliares** (helpers) para:
   - `filterByPlayerId(id)`
   - `aggregatePlayerStats(playerRows)` → Retorna objeto com somatórias. 
   - `getLastRoundInfo(playerRows)` → Retorna nome, foto, clube atual.
4. Implemente as rotas usando `app.get`.
5. Garanta **tratamento de erro** (ex:  ID não numérico, Jogador não encontrado).

---

**Fim da Especificação Técnica**