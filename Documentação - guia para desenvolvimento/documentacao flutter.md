# 📘 Documentação do Projeto:  CBF Stats (Brasileirão 2025)

## 1. Visão Geral

O **CBF Stats** é um aplicativo mobile para análise de desempenho de jogadores da Série A do Brasileirão 2025, focado em métricas de Fantasy Game (estilo Cartola FC). O sistema processa dados brutos, expõe via API e apresenta em dashboards interativos.

### 🏗 Arquitetura do Sistema

- **ETL / Data Science**: Python (Pandas) processa os dados brutos e gera um CSV consolidado (`cartola_api_completo. csv`).
- **Base de Dados**: Arquivo CSV estático carregado em memória/leitura pelo Backend.
- **Backend**: Node.js (API REST) servindo os dados filtrados e agregados.
- **Frontend**:  Flutter (Mobile) consumindo a API para visualização.

---

## 2. Levantamento de Requisitos

Esta seção formaliza as necessidades do analista de desempenho baseadas no escopo do projeto. 

### 2.1. Requisitos Funcionais (RF)

| ID | Requisito | Descrição |
|---|---|---|
| **RF01** | Visualização de Estatísticas | O sistema deve permitir visualizar estatísticas consolidadas por rodada, temporada e posição. |
| **RF02** | Cálculo de Pontuação Fantasy | O sistema deve aplicar as regras de negócio (pesos de scouts) para exibir a pontuação calculada. |
| **RF03** | Dashboard de Destaques | O sistema deve exibir na tela inicial os destaques do clube selecionado e da liga geral. |
| **RF04** | Filtros Avançados | Deve ser possível filtrar jogadores por Clube, Posição (Goleiro, Zagueiro, etc.) e Rodada. |
| **RF05** | Comparação de Jogadores | O sistema deve permitir selecionar dois jogadores para comparação lado a lado de suas métricas. |
| **RF06** | Monitoramento de Evolução | O sistema deve apresentar gráficos (ex:  linha) mostrando o desempenho do jogador nas últimas rodadas. |
| **RF07** | Rankings Específicos | O sistema deve gerar rankings baseados em fundamentos específicos (ex:  Top Assistências, Top Desarmes, Paredões). |
| **RF08** | Detalhamento do Jogador | Ao selecionar um jogador, o sistema deve exibir foto, dados cadastrais e histórico completo de scouts. |

### 2.2. Requisitos Não-Funcionais (RNF)

| ID | Requisito | Descrição |
|---|---|---|
| **RNF01** | Plataforma Mobile | O aplicativo frontend deve ser desenvolvido utilizando o framework Flutter. |
| **RNF02** | Backend API | A API deve ser construída em Node.js, servindo dados em formato JSON.  |
| **RNF03** | Fonte de Dados | O sistema deve ser alimentado por arquivos CSV processados via Python/Pandas. |
| **RNF04** | Desempenho/Cache | O aplicativo deve implementar cache simples (local storage) para dados estáticos ou recorrentes, reduzindo chamadas de rede. |
| **RNF05** | Usabilidade | A interface deve priorizar a visualização de dados (Data Viz) clara para tomada de decisão rápida do analista. |

---

## 3. Regras de Negócio (Scouts e Pontuação)

A pontuação dos jogadores segue pesos específicos definidos pela análise de desempenho.

### 3.1. Scouts de Defesa

| Sigla | Descrição | Pontos | Regra Especial |
|---|---|---|---|
| **DS** | Desarme | +1.2 | - |
| **FC** | Falta Cometida | -0.3 | - |
| **GC** | Gol Contra | -3.0 | - |
| **CA** | Cartão Amarelo | -1.0 | - |
| **CV** | Cartão Vermelho | -3.0 | - |
| **SG** | Jogo Sem Sofrer Gol | +5.0 | Apenas Goleiro, Zagueiro e Lateral |
| **DE** | Defesa Difícil | +1.0 | Apenas Goleiro |
| **DP** | Defesa de Pênalti | +7.0 | Apenas Goleiro |
| **GS** | Gol Sofrido | -1.0 | Apenas Goleiro |
| **PC** | Pênalti Cometido | -1.0 | - |

### 3.2. Scouts de Ataque

| Sigla | Descrição | Pontos |
|---|---|---|
| **FS** | Falta Sofrida | +0.5 |
| **PE** | Passe Incompleto | -0.1 |
| **A** | Assistência | +5.0 |
| **FT** | Finalização na Trave | +3.0 |
| **FD** | Finalização Defendida | +1.2 |
| **FF** | Finalização pra Fora | +0.8 |
| **G** | Gol | +8.0 |
| **I** | Impedimento | -0.1 |
| **PP** | Pênalti Perdido | -4.0 |
| **PS** | Pênalti Sofrido | +1.0 |

---

## 4. Especificação da Base de Dados (CSV)

O backend deve ler o arquivo **`cartola_api_completo. csv`**.

### Colunas Chave: 

- **`id_jogador`** (int): ID único.
- **`apelido`** (string): Nome de exibição. 
- **`clube_sigla`** (string): Ex: FLA, PAL, VAS. 
- **`posicao_nome`** (string): Ex: Atacante, Goleiro. 
- **`rodada`** (int): Número da rodada.
- **`pontos_cartola`** (float): Pontuação total na rodada. 
- **`foto_url`** (string): Link da imagem do jogador.
- **`finalizacoes_perigosas`** (float): Soma pré-calculada (FD + FT).
- **Colunas de Scouts**: G, A, DS, SG, FS, DE, DP, etc.

---

## 5. Especificação da API (Node.js)

O servidor deve rodar na **porta 3000**. A estrutura abaixo cobre os 15 endpoints requeridos no documento original.

### Grupo A: Jogadores e Detalhes

#### 1. Listar Jogadores
- **Rota**: `GET /jogadores`
- **Query Params**: `clube` (ex: FLA), `posicao` (ex: ATA), `busca` (nome parcial).
- **Retorno**: Lista filtrada de jogadores.

#### 2. Detalhes do Jogador
- **Rota**: `GET /jogadores/:id`
- **Retorno**: Dados cadastrais + acumulado da temporada (Médias, Totais).

#### 3. Histórico de Rodadas
- **Rota**: `GET /jogadores/:id/rodadas`
- **Query Params**: `limite` (ex: últimas 5).
- **Retorno**: Histórico jogo a jogo (Adversário, Pontos, Scouts principais).

#### 4. Comparação Direta
- **Rota**: `GET /comparacao`
- **Query Params**: `ids` (ex: 123,456).
- **Retorno**: Objeto comparativo com stats dos jogadores solicitados. 

#### 5. Estatísticas do Clube
- **Rota**: `GET /estatisticas/clube/:sigla`
- **Retorno**: Overview do clube (Total de gols, assistências, melhor jogador).

### Grupo B: Rankings e Tops (Scouts Específicos)

Para simplificar a implementação sem perder a especificidade, utilizaremos uma rota dinâmica **`/rankings/:tipo`** que cobre os requisitos 7 a 15 do documento original. 

#### Rota: `GET /rankings/:tipo`

**Query Params**:
- `rodada` (opcional - se omitido, considera temporada inteira).
- `limit` (padrão 10).
- `posicao` (filtro opcional, ex: ZAG).
- `clube` (filtro opcional).

**Tipos de Ranking Suportados (`:tipo`)**:

| Tipo | Descrição | Requisito Original |
|---|---|---|
| **pontos** | Maior pontuação (Fantasy) | Ranking Geral |
| **assistencias** | Mais Assistências (A) | Req 7 |
| **desarmes** | Mais Desarmes (DS) | Req 8 |
| **gols** | Mais Gols (G) | Req 9 |
| **finalizacoes_perigosas** | Finalizações Perigosas (FD + FT) | Req 10 |
| **faltas_sofridas** | Mais Faltas Sofridas (FS) | Req 11 |
| **faltas_cometidas** | Mais Faltas Cometidas (FC) | Req 12 |
| **defesas_dificeis** | Mais Defesas Difíceis (DE) - Goleiros | Req 13 |
| **penaltis_defendidos** | Pênaltis Defendidos (DP) - Goleiros | Req 14 |
| **jogos_sem_sofrer_gol** | Jogos sem sofrer gol (SG) - Defensores | Req 15 |

---

## 6. Especificação do Frontend (Flutter)

A interface deve atender às necessidades do analista de desempenho com as seguintes telas:

### 1. Tela de Login / Seleção de Clube (Opcional)

**Objetivo**: Restringir ou personalizar a visão inicial. 

**Elementos**:
- Dropdown ou Grid com escudos dos times.
- Botão "Entrar como Analista". 

### 2. Dashboard Inicial

- **Filtros Globais**:  Seletor de Rodada (Atual / Última / Específica).
- **Cards de Destaque**:
  - **Top 5 Clube**:  Melhores pontuadores do clube selecionado na rodada. 
  - **Top 5 Liga**: Melhores pontuadores gerais do campeonato. 
- **Atalhos Rápidos**: Botões para "Artilharia", "Comparador", "Paredões". 

### 3. Lista de Jogadores

- **Layout**: Lista vertical (ListView).
- **Item da Lista**: Foto, Apelido, Posição, Escudo do Clube, Pontuação (Média ou Última Rodada).
- **Barra de Busca**: Pesquisa por nome.
- **Filtros Avançados**: Chips ou Dropdown para Posição (GOL, ZAG, LAT, MEI, ATA, TEC) e Clube.

### 4. Detalhe do Jogador

- **Cabeçalho**:  Foto grande, Nome completo, Preço atual.
- **Painel de Stats**: Média, Máxima, Mínima, Jogos disputados. 
- **Gráfico de Evolução**: Linha do tempo (Rodadas x Pontuação) para monitorar regularidade.
- **Scouts Acumulados**: Exibição clara de Gols, Assistências, Desarmes, etc. 

### 5. Tela de Comparação

- **Interação**: Usuário seleciona 2 jogadores.
- **Visualização**:  Colunas lado a lado. 
- **Destaque**:  Realçar em verde quem tem o melhor número em cada quesito (ex: Quem tem mais Gols? Quem custa menos?).
- **Gráfico Comparativo**:  Duas linhas no mesmo gráfico de evolução.

### 6. Tela de Rankings

- **Abas (Tabs)**:
  - **Por Rodada**: Quem brilhou na rodada X.
  - **Geral (Temporada)**: Os melhores do campeonato até agora.
  - **Do Clube**: Ranking interno do elenco.
- **Filtro de Categoria**:  Dropdown para alternar entre "Pontos", "Gols", "Desarmes", "SG", etc (consumindo a rota `/rankings/:tipo`).

---

## 7. Fluxo de Desenvolvimento

### Backend: 
- Implementar a rota `/rankings/:tipo` com switch/case para tratar todas as métricas (DS, FS, G, A, SG, etc).
- Certificar-se de que o filtro `rodada` funciona em todos os endpoints. 

### Frontend:
- Utilizar **BottomNavigationBar** para navegar entre: Home, Rankings, Jogadores, Comparação. 
- Implementar o serviço **PlayerService** para centralizar as chamadas HTTP.

---

**Fim da Documentação**