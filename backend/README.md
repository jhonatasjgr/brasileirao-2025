# CBF Stats API - Documentação Completa do Backend

> API REST em Node.js para análise de desempenho de jogadores do Brasileirão 2025 com documentação Swagger/OpenAPI 3.0 completa e interativa.

**Versão**: 1.0.0 | **Data**: 26 de dezembro de 2025

---

## Índice

1. [Visão Geral](#visão-geral)
2. [Requisitos do Projeto](#requisitos-do-projeto)
3. [Regras de Negócio](#regras-de-negócio-scouts-e-pontuação)
4. [Quick Start](#quick-start)
5. [Documentação Swagger](#documentação-swagger-interativa)
6. [Endpoints da API](#endpoints-da-api)
7. [Base de Dados](#especificação-da-base-de-dados-csv)
8. [Estrutura do Projeto](#estrutura-do-projeto)
9. [Tecnologias](#tecnologias-utilizadas)
10. [Frontend - Especificação Flutter](#especificação-do-frontend-flutter)
11. [Guia de Uso do Swagger](#guia-completo-do-swagger)
12. [Exemplos de Uso](#exemplos-de-uso)
13. [Checklist de Verificação](#checklist-de-verificação)
14. [Notas Importantes](#notas-importantes)
15. [Troubleshooting](#troubleshooting)
16. [Deploy e Produção](#deploy-e-produção)
17. [Suporte](#suporte-e-contribuição)

---

---

## Visão Geral

O **CBF Stats** é um aplicativo mobile para análise de desempenho de jogadores da Série A do Brasileirão 2025, focado em métricas de Fantasy Game (estilo Cartola FC). O sistema processa dados brutos, expõe via API e apresenta em dashboards interativos.

### Arquitetura do Sistema

```
┌─────────────────────────────────────────────────┐
│  Frontend (Flutter Mobile)                      │
│  - Dashboards, Rankings, Comparações           │
└────────────────────┬────────────────────────────┘
                     │ HTTP/JSON
┌────────────────────▼────────────────────────────┐
│  Backend (Node.js API)                          │
│  - REST API com 17 endpoints específicos        │
│  - Documentação Swagger/OpenAPI 3.0             │
└────────────────────┬────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────┐
│  Base de Dados (CSV)                            │
│  - cartola_api_completo.csv                     │
│  - 28.589 registros, 980 jogadores únicos       │
└─────────────────────────────────────────────────┘
```

---

## Requisitos do Projeto

### Requisitos Funcionais (RF)

| ID | Requisito | Status |
|---|---|---|
| **RF01** | Visualização de Estatísticas por rodada, temporada e posição | Implementado |
| **RF02** | Cálculo de Pontuação Fantasy com regras de pesos | Dados fornecidos |
| **RF03** | Dashboard de Destaques (Top 5 Clube / Liga) | Frontend |
| **RF04** | Filtros Avançados (Clube, Posição, Rodada) | Implementado |
| **RF05** | Comparação de Jogadores lado a lado | Implementado |
| **RF06** | Monitoramento de Evolução (Gráficos de desempenho) | Frontend |
| **RF07** | Rankings Específicos (Top Gols, Top Assistências, etc) | 10 tipos |
| **RF08** | Detalhamento do Jogador (Foto, dados, histórico) | Implementado |

### Requisitos Não-Funcionais (RNF)

| ID | Requisito | Status |
|---|---|---|
| **RNF01** | Plataforma Mobile com Flutter | Em desenvolvimento |
| **RNF02** | Backend API em Node.js com JSON | Completo |
| **RNF03** | Fonte de Dados em CSV processado | 28.589 registros |
| **RNF04** | Cache simples (Local Storage Frontend) | Frontend |
| **RNF05** | Interface Data Viz clara para análise rápida | Frontend |

---

## Regras de Negócio (Scouts e Pontuação)

A pontuação dos jogadores segue pesos específicos definidos pela análise de desempenho Fantasy.

### Scouts de Defesa

| Sigla | Descrição | Pontos | Regra Especial |
|---|---|---|---|
| **DS** | Desarme | +1.2 | - |
| **FC** | Falta Cometida | -0.3 | - |
| **GC** | Gol Contra | -3.0 | - |
| **CA** | Cartão Amarelo | -1.0 | - |
| **CV** | Cartão Vermelho | -3.0 | - |
| **SG** | Jogo Sem Sofrer Gol | +5.0 | Apenas Goleiro, Zagueiro, Lateral |
| **DE** | Defesa Difícil | +1.0 | Apenas Goleiro |
| **DP** | Defesa de Pênalti | +7.0 | Apenas Goleiro |
| **GS** | Gol Sofrido | -1.0 | Apenas Goleiro |
| **PC** | Pênalti Cometido | -1.0 | - |

### Scouts de Ataque

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

### 30 Segundos para começar

```bash
# 1. Navegue até a pasta do backend
cd backend

# 2. Instale as dependências
npm install

# 3. Inicie o servidor em modo desenvolvimento
npm run dev
```

**Acesse imediatamente:**
- **Documentação Interativa Swagger**: http://localhost:3000/api-docs
- **Health Check**: http://localhost:3000/health
- **Informações da API**: http://localhost:3000/

**Acesse imediatamente:**
- **Documentação Interativa Swagger**: http://localhost:3000/api-docs
- **Health Check**: http://localhost:3000/health
- **Informações da API**: http://localhost:3000/

### Instalação Detalhada

```bash
cd backend
npm install
```

### Variáveis de Ambiente

Crie um arquivo `.env` (opcional):

```
PORT=3000
```

### Execução

**Desenvolvimento (com auto-reload)**:
```bash
npm run dev
```

**Produção**:
```bash
npm start
```

O servidor iniciará na porta **3000** por padrão.

### Acessar Documentação

Após iniciar o servidor:

- **Swagger UI (Interativo)**: http://localhost:3000/api-docs
- **Health Check**: http://localhost:3000/health
- **Documentação Básica**: http://localhost:3000/

---

## Documentação Swagger Interativa

### O que é Swagger?

Swagger (OpenAPI 3.0) é uma especificação padrão para descrever APIs REST. Nossa API possui documentação **completa e interativa** que permite:

- Visualizar todos os endpoints de forma estruturada
- Testar requisições diretamente do navegador (Try it out)
- Ver esquemas de requisição e resposta em tempo real
- Entender parâmetros e seus tipos
- Copiar exemplos de código (curl, JavaScript, etc)
- Download da especificação OpenAPI em JSON

### Acessar Swagger UI

**URL**: http://localhost:3000/api-docs

### Como Testar um Endpoint no Swagger

1. **Abra** http://localhost:3000/api-docs
2. **Selecione um endpoint** (ex: GET /jogadores)
3. **Clique em "Try it out"**
4. **Preencha os parâmetros** (se necessário)
   - Exemplo: `clube: SAO`, `posicao: ATA`
5. **Clique em "Execute"**
6. **Veja a resposta JSON em tempo real**

### Recursos do Swagger

#### Schemas Documentados
Todos os tipos de dados estão documentados:
- `Jogador` - Dados resumidos para listas
- `JogadorDetalhado` - Dados completos com estatísticas
- `Rodada` - Histórico de desempenho
- `RankingItem` - Itens de ranking
- `EstatisticasClube` - Estatísticas agregadas do clube
- `Error` - Padrão de resposta de erro

#### Parâmetros Documentados
Cada parâmetro inclui:
- Tipo de dado (string, number, integer)
- Se é obrigatório ou opcional
- Valores permitidos (enums)
- Exemplos de uso
- Descrição detalhada

#### Respostas por Status Code
Cada endpoint documenta:
- **200** - Sucesso
- **400** - Validação/Parâmetros inválidos
- **404** - Recurso não encontrado
- **500** - Erro interno do servidor

### Recursos Avançados

#### 1. Copiar como Curl
```bash
curl -X GET "http://localhost:3000/jogadores?clube=SAO" -H "accept: application/json"
```

#### 2. Download da Especificação OpenAPI
```
http://localhost:3000/api-docs/swagger.json
```

Pode ser importada em:
- Postman
- Insomnia  
- Swagger Editor
- Qualquer ferramenta compatível com OpenAPI

#### 3. Navegação por Tags
A documentação está organizada em categorias:
- **Jogadores** - Listar, detalhar, histórico
- **Rankings** - Rankings dinâmicos (10 tipos)
- **Comparação** - Comparar múltiplos jogadores
- **Estatísticas** - Stats agregadas por clube
- **Saúde** - Monitoramento do servidor

---

## Endpoints da API

### Resumo dos 17 Endpoints Específicos

#### Estrutura

| Categoria | Endpoints | Total |
|-----------|-----------|-------|
| **Jogadores** | `/jogadores`, `/jogadores/:id`, `/jogadores/:id/rodadas` | 3 |
| **Comparação** | `/comparacao` | 1 |
| **Rankings** (10 tipos dinâmicos) | `/rankings/pontos`, `/rankings/gols`, `/rankings/assistencias`, `/rankings/desarmes`, `/rankings/finalizacoes_perigosas`, `/rankings/faltas_sofridas`, `/rankings/faltas_cometidas`, `/rankings/defesas_dificeis`, `/rankings/penaltis_defendidos`, `/rankings/jogos_sem_sofrer_gol` | 10 |
| **Estatísticas** | `/estatisticas/clube/:sigla` | 1 |
| **Sistema** | `/`, `/health` | 2 |
| | | **17 Total** |

#### Endpoints Detalhados

| # | Método | Rota | Descrição | Documentado |
|----|--------|------|-----------|-------------|
| 1 | **GET** | `/jogadores` | Listar jogadores com filtros | Swagger |
| 2 | **GET** | `/jogadores/:id` | Detalhes completo do jogador | Swagger |
| 3 | **GET** | `/jogadores/:id/rodadas` | Histórico de rodadas | Swagger |
| 4 | **GET** | `/comparacao` | Comparar múltiplos jogadores | Swagger |
| 5 | **GET** | `/rankings/pontos` | Ranking por pontuação geral | Swagger |
| 6 | **GET** | `/rankings/gols` | Ranking por gols | Swagger |
| 7 | **GET** | `/rankings/assistencias` | Ranking por assistências | Swagger |
| 8 | **GET** | `/rankings/desarmes` | Ranking por desarmes | Swagger |
| 9 | **GET** | `/rankings/finalizacoes_perigosas` | Ranking por finalizações perigosas | Swagger |
| 10 | **GET** | `/rankings/faltas_sofridas` | Ranking por faltas sofridas | Swagger |
| 11 | **GET** | `/rankings/faltas_cometidas` | Ranking por faltas cometidas | Swagger |
| 12 | **GET** | `/rankings/defesas_dificeis` | Ranking por defesas difíceis | Swagger |
| 13 | **GET** | `/rankings/penaltis_defendidos` | Ranking por pênaltis defendidos | Swagger |
| 14 | **GET** | `/rankings/jogos_sem_sofrer_gol` | Ranking por jogos sem sofrer gol | Swagger |
| 15 | **GET** | `/estatisticas/clube/:sigla` | Stats agregadas do clube | Swagger |
| 16 | **GET** | `/health` | Health check do servidor | Swagger |
| 17 | **GET** | `/` | Informações da API | Swagger |

**Total: 17 endpoints específicos completamente documentados**

### Jogadores

#### Listar Jogadores
```
GET /jogadores?busca=&clube=&posicao=
```

**Query Params:**
- `busca` (string) - Busca parcial por nome ou apelido
- `clube` (string) - Filtro por sigla do clube (ex: SAO)
- `posicao` (string) - Filtro por posição (GOL, ZAG, LAT, MEI, ATA, TEC)

**Exemplo:**
```bash
curl "http://localhost:3000/jogadores?clube=SAO&posicao=ATA"
```

---

#### Detalhes do Jogador
```
GET /jogadores/:id
```

**Exemplo:**
```bash
curl "http://localhost:3000/jogadores/12345"
```

**Response:**
```json
{
  "id": 12345,
  "nome": "Givanildo Vieira de Sousa",
  "apelido": "Hulk",
  "foto_url": "https://...",
  "clube_sigla": "CAM",
  "clube_nome": "Atlético-MG",
  "posicao_sigla": "ATA",
  "posicao_nome": "Atacante",
  "preco": 15.4,
  "stats_temporada": {
    "jogos": 20,
    "gols": 12,
    "assistencias": 5,
    "desarmes": 15,
    "defesas_dificeis": 0,
    "media_pontos": 8.5
  }
}
```

---

#### Histórico de Rodadas
```
GET /jogadores/:id/rodadas?limite=
```

**Query Params:**
- `limite` (number) - Últimas N rodadas

**Exemplo:**
```bash
curl "http://localhost:3000/jogadores/12345/rodadas?limite=5"
```

---

### Comparação

#### Comparar Jogadores
```
GET /comparacao?ids=123,456
```

**Query Params:**
- `ids` (string) - IDs separados por vírgula (máx 10)

**Exemplo:**
```bash
curl "http://localhost:3000/comparacao?ids=12345,67890"
```

---

### Rankings

#### Gerar Ranking
```
GET /rankings/:tipo?rodada=&posicao=&clube=&limit=
```

**Tipos Suportados:**
- `pontos` - Maior pontuação média
- `gols` - Mais gols
- `assistencias` - Mais assistências
- `desarmes` - Mais desarmes
- `finalizacoes_perigosas` - Finalizações perigosas (FD + FT)
- `faltas_sofridas` - Mais faltas sofridas
- `faltas_cometidas` - Mais faltas cometidas
- `defesas_dificeis` - Mais defesas difíceis
- `penaltis_defendidos` - Pênaltis defendidos
- `jogos_sem_sofrer_gol` - Jogos sem sofrer gol

**Query Params:**
- `rodada` (number) - Filtrar por rodada específica
- `posicao` (string) - Filtrar por posição
- `clube` (string) - Filtrar por clube
- `limit` (number) - Limite de resultados (padrão: 10, máx: 100)

**Exemplos:**
```bash
# Top 10 artilheiros gerais
curl "http://localhost:3000/rankings/gols?limit=10"

# Top 5 assistentes da rodada 20
curl "http://localhost:3000/rankings/assistencias?rodada=20&limit=5"

# Melhores defensores do Sao Paulo
curl "http://localhost:3000/rankings/desarmes?clube=SAO&limit=10"

# Top artilheiros goleiros (não retorna resultado, restrito aos dados)
curl "http://localhost:3000/rankings/gols?posicao=GOL"
```

---

### Estatísticas por Clube

#### Estatísticas do Clube
```
GET /estatisticas/clube/:sigla
```

**Exemplo:**
```bash
curl "http://localhost:3000/estatisticas/clube/SAO"
```

**Response:**
```json
{
  "clube_sigla": "SAO",
  "total_jogadores": 25,
  "estatisticas": {
    "total_gols": 45,
    "total_assistencias": 20,
    "total_desarmes": 150,
    "media_pontos_time": 65.4
  },
  "destaques": {
    "artilheiro": {
      "id": 12345,
      "apelido": "Pedro",
      "gols": 15,
      "foto_url": "https://..."
    },
    "garcom": {
      "id": 67890,
      "apelido": "Arrascaeta",
      "assistencias": 10,
      "foto_url": "https://..."
    },
    "destaque_geral": {
      "id": 11111,
      "apelido": "Jogador X",
      "media_pontos": 8.9,
      "foto_url": "https://..."
    }
  }
}
```

---

## � Especificação da Base de Dados (CSV)

O backend lê o arquivo **`cartola_api_completo.csv`** localizado em `../../Base de dados/`.

### Características do Dataset

- **Total de Registros**: 28.589
- **Jogadores Únicos**: 980
- **Temporadas**: Brasileirão 2025 (38 rodadas)
- **Atualização**: Automática no startup do servidor

### Colunas Principais

| Coluna | Tipo | Descrição |
|--------|------|-----------|
| `id_jogador` | int | ID único do jogador |
| `apelido` | string | Nome de exibição |
| `clube_sigla` | string | Ex: FLA, PAL, VAS, SAO, etc |
| `clube_nome` | string | Nome completo do clube |
| `posicao_sigla` | string | GOL, ZAG, LAT, MEI, ATA, TEC |
| `posicao_nome` | string | Goleiro, Zagueiro, Lateral, etc |
| `rodada` | int | Número da rodada (1-38) |
| `pontos_cartola` | float | Pontuação total na rodada |
| `foto_url` | string | Link da imagem do jogador |
| `preco` | float | Preço do jogador |

### Colunas de Scouts

**Ataque**: `G` (Gols), `A` (Assistências), `FT` (Finalizações Trave), `FD` (Finalizações Defendidas), `FF` (Finalizações Fora), `FS` (Faltas Sofridas)

**Defesa**: `DS` (Desarmes), `SG` (Jogos sem sofrer gol), `DE` (Defesas Difíceis), `DP` (Defesas de Pênalti), `GS` (Gols Sofridos), `FC` (Faltas Cometidas)

### Carregamento de Dados

No startup do servidor (`src/server.js`):

```javascript
// 1. Arquivo CSV é lido de forma síncrona
// 2. Todos os 28.589 registros são carregados em memória
// 3. Dados estão prontos para consultas rápidas
// 4. Health check mostra: "total_records": 28589
```

---

---

## Estrutura do Projeto

```
backend/
├── src/
│   ├── server.js                    # Servidor principal + integração Swagger
│   ├── config/
│   │   └── swagger.js               # Configuração OpenAPI 3.0
│   ├── helpers/
│   │   └── aggregations.js          # Funções de agregação e filtragem
│   ├── routes/
│   │   ├── jogadores.js             # Rotas de jogadores + JSDoc Swagger
│   │   ├── comparacao.js            # Rotas de comparação + JSDoc Swagger
│   │   ├── rankings.js              # Rotas de rankings + JSDoc Swagger
│   │   └── estatisticas.js          # Rotas de estatísticas + JSDoc Swagger
│   └── utils/
│       └── helpers.js               # Utilitários e validações
├── examples/
│   └── api-examples.js              # 17 exemplos de uso da API
├── package.json                     # Dependências (incluindo Swagger)
├── .gitignore
└── README.md                        # Esta documentação completa
```

---

## Tecnologias Utilizadas

| Tecnologia | Versão | Propósito |
|------------|--------|----------|
| **Node.js** | 18+ | Runtime JavaScript |
| **Express.js** | ^4.18.2 | Framework web minimalista |
| **CORS** | ^2.8.5 | Compartilhamento de recursos entre origens |
| **csv-parser** | ^3.0.0 | Leitura e parse de arquivos CSV |
| **swagger-ui-express** | ^5.0.0 | Interface Swagger UI integrada |
| **swagger-jsdoc** | ^6.2.8 | Geração de especificação OpenAPI |
| **nodemon** | ^3.0.2 | Auto-reload em desenvolvimento (devDep) |

### Arquitetura

- **Dados em Memória**: CSV carregado na inicialização
- **Sem Banco de Dados**: Operações 100% em memória (rápido)
- **RESTful API**: Padrões REST para todos os endpoints
- **Documentação OpenAPI 3.0**: Totalmente documentado
- **CORS Habilitado**: Acesso de qualquer origem

---

## Especificação do Frontend (Flutter)

A interface deve atender às necessidades do analista de desempenho com as seguintes telas e funcionalidades:

### Arquitetura Frontend

```
┌─────────────────────────────────────┐
│  Flutter Mobile App (CBF Stats)     │
├─────────────────────────────────────┤
│  BottomNavigationBar (5 abas)       │
│  ├─ Home (Dashboard)                │
│  ├─ Rankings                        │
│  ├─ Jogadores                       │
│  ├─ Comparação                      │
│  └─ Configurações                   │
├─────────────────────────────────────┤
│  PlayerService (Camada HTTP)        │
│  └─ Consumindo 17 endpoints da API  │
└─────────────────────────────────────┘
```

### Telas Especificadas

#### 1. **Tela de Login / Seleção de Clube** (Opcional)

**Objetivo**: Personalizar visão inicial por analista

**Elementos**:
- Dropdown ou Grid com escudos dos times
- Botão "Entrar como Analista"
- Persistência de preferência do usuário (SharedPreferences)

---

#### 2. **Dashboard Inicial (Home)**

**Objetivo**: Visualizar destaques e atalhos rápidos

**Seções**:
- **Filtros Globais**
  - Seletor de Rodada (Atual / Última / Específica)
  - Seletor de Clube (se não fixo)

- **Card: Top 5 Clube**
  - Melhores pontuadores do clube selecionado
  - Endpoint: `GET /jogadores?clube=XXX&limit=5`

- **Card: Top 5 Liga**
  - Melhores pontuadores gerais do campeonato
  - Endpoint: `GET /rankings/pontos?limit=5`

- **Atalhos Rápidos (Chips/Botões)**
  - Artilharia (→ `/rankings/gols`)
  - Garçons (→ `/rankings/assistencias`)
  - Defensores (→ `/rankings/desarmes`)
  - Comparador (→ Tela de Comparação)
  - Paredões (→ `/rankings/jogos_sem_sofrer_gol`)

---

#### 3. **Lista de Jogadores**

**Objetivo**: Visualizar todos os jogadores com filtros avançados

**Layout**:
- ListView vertical com jogadores
- Barra de busca (por nome - parâmetro `busca`)

**Filtros Avançados** (Chips/Dropdown):
- Posição: GOL, ZAG, LAT, MEI, ATA, TEC
- Clube: Dropdown com 20 times
- Rodada: Seletor (ou "temporada inteira")

**Item da Lista**:
```
┌─────────────────────────────────┐
│ [FOTO] | Nome | Posição | Clube│
│        | 8.5 (média) | R$15     │
└─────────────────────────────────┘
```

**Endpoints Utilizados**:
- `GET /jogadores?busca=&clube=&posicao=`

---

#### 4. **Detalhe do Jogador**

**Objetivo**: Análise profunda do jogador

**Cabeçalho**:
- Foto grande do jogador
- Nome completo + Apelido
- Clube + Posição + Preço atual

**Abas/Seções**:

**Painel de Stats** (Temporada Inteira):
- Jogos disputados
- Gols | Assistências | Desarmes
- Pontos: Mínima | Média | Máxima
- Tabela com todos os scouts

**Gráfico de Evolução** (Linha):
- Eixo X: Rodadas (1-38)
- Eixo Y: Pontos (de 0 até máximo)
- Mostra regularidade visual
- Dois botões: "Temporada" e "Últimas 5"

**Histórico de Rodadas** (Tabela):
- Rodada | Adversário | Pontos | Scouts principais
- ScrollView horizontal para scouts

**Endpoints Utilizados**:
- `GET /jogadores/:id` (detalhes)
- `GET /jogadores/:id/rodadas?limite=` (histórico)

---

#### 5. **Tela de Comparação**

**Objetivo**: Comparar 2+ jogadores lado a lado

**Interação**:
1. Tela de Busca (autocomplete)
2. Selecionar até 2 jogadores
3. Exibição comparativa

**Visualização - Colunas Lado a Lado**:
```
┌──────────────┬──────────────┐
│  Jogador A   │  Jogador B   │
├──────────────┼──────────────┤
│ [FOTO]       │ [FOTO]       │
│ Givanildo    │ Neymar Jr    │
│              │              │
│ Gols: 12     │ Gols: 8      │
│ Assist: 5    │ Assist: 10   │
│ R$: 15.4     │ R$: 16.8     │
│ Méd: 8.5     │ Méd: 8.2     │
└──────────────┴──────────────┘
```

**Destaques**:
- Campo com maior valor em **verde**
- Cada quesito tem check/X

**Gráfico Comparativo**:
- Duas linhas no mesmo gráfico (Rodadas x Pontos)
- Cores diferentes por jogador
- Legenda clara

**Endpoints Utilizados**:
- `GET /comparacao?ids=123,456`
- `GET /jogadores/:id/rodadas` (para gráfico)

---

#### 6. **Tela de Rankings**

**Objetivo**: Visualizar rankings por diferentes métricas

**Navegação**:
- **Abas (Tabs)**:
  - Por Rodada
  - Geral (Temporada Inteira) ← Padrão
  - Do Clube

- **Filtro de Categoria** (Dropdown):
  - Pontos (padrão)
  - Gols
  - Assistências
  - Desarmes
  - Finalizações Perigosas
  - Faltas Sofridas
  - Faltas Cometidas
  - Defesas Difíceis
  - Pênaltis Defendidos
  - Jogos Sem Sofrer Gol

**Filtros Adicionais**:
- Posição (GOL, ZAG, LAT, MEI, ATA, TEC)
- Clube
- Limit (10, 20, 50)

**Visualização - Lista Ranqueada**:
```
Ranking de Gols (Temporada)
─────────────────────────────
1. Givanildo (CAM) - 12 gols
2. Neymar Jr (SAN) - 10 gols
3. Vinicius Jr (RMA) - 9 gols
4. Rodrygo (RMA) - 8 gols
   ...
```

**Item da Lista**:
- Posição (número)
- Foto do jogador
- Nome | Clube | Valor da métrica
- Opcional: Mudança em relação à rodada anterior (↑↓)

**Endpoints Utilizados**:
- `GET /rankings/:tipo?rodada=&posicao=&clube=&limit=`

---

### Padrão de Desenvolvimento

#### PlayerService (Camada de Serviço HTTP)

```dart
class PlayerService {
  static const String baseUrl = 'http://localhost:3000';

  // Jogadores
  Future<List<Player>> getPlayers({
    String? club, String? position, String? search
  }) async { /* GET /jogadores */ }
  
  Future<PlayerDetail> getPlayerDetail(int id) async { 
    /* GET /jogadores/:id */ 
  }
  
  Future<List<Round>> getPlayerRounds(int id, int limit) async { 
    /* GET /jogadores/:id/rodadas */ 
  }

  // Rankings
  Future<List<RankingItem>> getRanking(String type, {
    int? round, String? position, String? club, int limit = 10
  }) async { 
    /* GET /rankings/:tipo */ 
  }

  // Comparação
  Future<ComparisonResult> comparePlayers(List<int> ids) async { 
    /* GET /comparacao?ids=... */ 
  }

  // Estatísticas
  Future<ClubStats> getClubStats(String sigla) async { 
    /* GET /estatisticas/clube/:sigla */ 
  }
}
```

#### Widgets Principais

- `PlayerListWidget` → Lista com filtros
- `PlayerDetailWidget` → Detalhes + gráfico
- `ComparisonWidget` → Comparação lado a lado
- `RankingWidget` → Lista ranqueada
- `DashboardWidget` → Home com destaques

#### Dependências Recomendadas

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0
  provider: ^6.0.0
  fl_chart: ^0.65.0  # Gráficos
  cached_network_image: ^3.3.0  # Cache de imagens
  intl: ^0.19.0  # Localização
```

---

## Fluxo de Desenvolvimento Recomendado

### Backend (Concluído):
- Implementar todos os 17 endpoints
- Validar dados (28.589 registros carregados)
- Documentação Swagger/OpenAPI 3.0
- CORS habilitado para frontend
- Health check e info API

### Frontend (Em Desenvolvimento):
1. Criar estrutura base (main.dart, routes)
2. Implementar PlayerService (camada HTTP)
3. Tela de Login/Seleção de Clube
4. Dashboard Inicial
5. Lista de Jogadores com filtros
6. Detalhe do Jogador com gráficos
7. Tela de Comparação
8. Tela de Rankings
9. Cache local (SharedPreferences/Hive)
10. Testes e polimento

---

---

## Guia completo do Swagger

### Navegando pela Documentação Swagger

A interface Swagger está organizada em **tags** (categorias):

#### 1. **Jogadores** (3 endpoints)
- Listar jogadores com filtros
- Obter detalhes de um jogador específico
- Histórico de rodadas do jogador

#### 2. **Rankings** (1 endpoint dinâmico)
- Gerar rankings por 10 métricas diferentes

#### 3. **Comparação** (1 endpoint)
- Comparar até 10 jogadores lado a lado

#### 4. **Estatísticas** (1 endpoint)
- Stats agregadas por clube

#### 5. **Saúde** (2 endpoints)
- Health check
- Informações da API

### Testando Endpoints no Swagger

#### Exemplo Passo a Passo

**Cenário**: Buscar os atacantes do Sao Paulo

1. **Acesse**: http://localhost:3000/api-docs
2. **Localize**: `GET /jogadores`
3. **Clique**: "Try it out" (botão verde)
4. **Preencha**:
   - `clube`: `SAO`
   - `posicao`: `ATA`
5. **Execute**: Clique em "Execute"
6. **Resultado**: Veja o JSON com os atacantes do Sao Paulo

### Schemas Disponíveis

Todos os modelos de dados estão documentados:

```javascript
// Jogador (resumido para listas)
{
  id: number,
  apelido: string,
  clube_sigla: string,
  posicao_sigla: string,
  media_pontos: number,
  gols: number,
  assistencias: number
}

// JogadorDetalhado (completo)
{
  ...Jogador,
  stats_temporada: {
    jogos: number,
    gols: number,
    assistencias: number,
    desarmes: number,
    media_pontos: number,
    // ... mais estatísticas
  }
}

// Rodada (histórico)
{
  rodada: number,
  adversario: string,
  pontos: number,
  scouts: { ... }
}

// RankingItem
{
  id: number,
  apelido: string,
  ranking_value: number,
  // valor da métrica (gols, assists, etc)
}
```

### Copiando Requisições

O Swagger permite copiar requisições em diferentes formatos:

**Curl**:
```bash
curl -X GET "http://localhost:3000/jogadores?clube=SAO" \
  -H "accept: application/json"
```

**JavaScript (Fetch)**:
```javascript
fetch('http://localhost:3000/jogadores?clube=SAO')
  .then(res => res.json())
  .then(data => console.log(data));
```

### Download da Especificação

Baixe a especificação OpenAPI completa:
```
http://localhost:3000/api-docs/swagger.json
```

Use em ferramentas externas:
- **Postman**: File → Import → Cole a URL
- **Insomnia**: Import → From URL
- **VS Code**: Extensões OpenAPI

---

## Exemplos de Uso

### Executar Exemplos Prontos

```bash
cd backend
node examples/api-examples.js
```

Isso executa **17 exemplos** de uso da API:
1. Listar todos os jogadores
2. Listar jogadores do Sao Paulo
3. Listar apenas atacantes
4. Buscar jogador por nome
5. Detalhes de um jogador específico
6. Histórico de rodadas
7-10. Top 10 por várias métricas
11-13. Rankings com filtros
14. Comparar dois jogadores
15. Estatísticas do clube
16-17. Health check e info da API

### Exemplos via Curl

```bash
# 1. Listar todos os jogadores
curl http://localhost:3000/jogadores

# 2. Filtrar por clube
curl "http://localhost:3000/jogadores?clube=SAO"

# 3. Filtrar por posição
curl "http://localhost:3000/jogadores?posicao=ATA"

# 4. Buscar por nome
curl "http://localhost:3000/jogadores?busca=Hulk"

# 5. Detalhes de um jogador
curl http://localhost:3000/jogadores/12345

# 6. Histórico (últimas 5 rodadas)
curl "http://localhost:3000/jogadores/12345/rodadas?limite=5"

# 7. Top 10 artilheiros
curl "http://localhost:3000/rankings/gols?limit=10"

# 8. Artilheiros de uma rodada
curl "http://localhost:3000/rankings/gols?rodada=20&limit=10"

# 9. Comparar jogadores
curl "http://localhost:3000/comparacao?ids=123,456"

# 10. Stats do Sao Paulo
curl http://localhost:3000/estatisticas/clube/SA0

# 11. Health check
curl http://localhost:3000/health
```

### Exemplos via JavaScript/Node.js

```javascript
// Usando fetch (Node 18+)
const BASE_URL = 'http://localhost:3000';

// 1. Listar jogadores do Palmeiras
async function listarJogadores() {
  const res = await fetch(`${BASE_URL}/jogadores?clube=PAL`);
  const data = await res.json();
  console.log(`${data.total} jogadores encontrados`);
  return data.jogadores;
}

// 2. Obter detalhes de um jogador
async function detalhesJogador(id) {
  const res = await fetch(`${BASE_URL}/jogadores/${id}`);
  const jogador = await res.json();
  console.log(`${jogador.apelido}: ${jogador.stats_temporada.media_pontos} pts`);
  return jogador;
}

// 3. Top 5 artilheiros
async function topArtilheiros() {
  const res = await fetch(`${BASE_URL}/rankings/gols?limit=5`);
  const data = await res.json();
  data.ranking.forEach((j, i) => {
    console.log(`${i+1}. ${j.apelido} - ${j.ranking_value} gols`);
  });
  return data.ranking;
}

// 4. Comparar dois jogadores
async function compararJogadores(id1, id2) {
  const res = await fetch(`${BASE_URL}/comparacao?ids=${id1},${id2}`);
  const data = await res.json();
  data.jogadores.forEach(j => {
    console.log(`${j.apelido}: ${j.stats_temporada.gols} gols`);
  });
  return data.jogadores;
}

// Executar exemplos
(async () => {
  await listarJogadores();
  await detalhesJogador(12345);
  await topArtilheiros();
  await compararJogadores(123, 456);
})();
```

### Exemplos via Python

```python
import requests

BASE_URL = 'http://localhost:3000'

# 1. Listar jogadores
def listar_jogadores(clube=None):
    params = {'clube': clube} if clube else {}
    res = requests.get(f'{BASE_URL}/jogadores', params=params)
    data = res.json()
    print(f"{data['total']} jogadores encontrados")
    return data['jogadores']

# 2. Top artilheiros
def top_artilheiros(limit=10):
    res = requests.get(f'{BASE_URL}/rankings/gols', params={'limit': limit})
    data = res.json()
    for i, jogador in enumerate(data['ranking'], 1):
        print(f"{i}. {jogador['apelido']}: {jogador['ranking_value']} gols")
    return data['ranking']

# 3. Stats de um clube
def stats_clube(sigla):
    res = requests.get(f'{BASE_URL}/estatisticas/clube/{sigla}')
    data = res.json()
    print(f"Clube: {data['clube_sigla']}")
    print(f"Total de gols: {data['estatisticas']['total_gols']}")
    return data

# Executar
listar_jogadores('SAO')
top_artilheiros(5)
stats_clube('PAL')
```

---

## Checklist de Verificação

### Depois de instalar e iniciar o servidor, verifique:

#### 1. Dependências Instaladas

```bash
npm list swagger-jsdoc swagger-ui-express
```

Deve mostrar:
```
├── swagger-jsdoc@6.2.8
└── swagger-ui-express@5.0.0
```

#### 2. Servidor Iniciado

```bash
npm run dev
```

Console deve mostrar:
```
Dados CSV carregados: 5000 registros
Servidor rodando na porta 3000
Swagger disponível em http://localhost:3000/api-docs
```

#### 3. Health Check

```bash
curl http://localhost:3000/health
```

Resposta esperada:
```json
{
  "status": "ok",
  "data_loaded": true,
  "total_records": 5000
}
```

#### 4. Swagger Acessível

Abra no navegador: **http://localhost:3000/api-docs**

Deve carregar a interface interativa com 5 tags:
- Jogadores
- Rankings
- Comparação
- Estatísticas
- Saúde

#### 5. Teste um Endpoint

No Swagger UI:
1. Abra **GET /jogadores**
2. Clique em **"Try it out"**
3. Clique em **"Execute"**
4. Veja a lista de jogadores retornada

#### 6. Execute os Exemplos

```bash
node examples/api-examples.js
```

Deve executar 17 exemplos e mostrar resultados coloridos.

---

Se todos os itens acima passaram: **Parabéns! Seu backend está 100% funcional!**

---

## Notas Importantes

### Carregamento de Dados

- O CSV é **carregado em memória** na inicialização do servidor
- Alterações no arquivo CSV requerem **reinicialização do servidor**
- Localização esperada: `../Base de dados/cartola_api_completo.csv` (relativo à pasta `src/`)

### Colunas Esperadas no CSV

**Identificadores:**
- `id_jogador`, `apelido`, `nome`
- `clube_sigla`, `clube_nome`
- `posicao_sigla`, `posicao_nome`

**Temporais:**
- `rodada`, `temporada`

**Métricas:**
- `pontos_cartola`, `preco`, `foto_url`, `adversario`

**Scouts (Métricas de Jogo):**
- Ataque: `G`, `A`, `FT`, `FD`, `FF`, `FS`, `PS`, `PP`, `I`
- Defesa: `DS`, `DE`, `DP`, `SG`, `GS`, `FC`, `GC`, `CA`, `CV`, `PC`
- Outros: `PE` (passes errados)

### Performance

- Com ~5.000 registros: operações são **instantâneas**
- Todas as operações em memória (sem I/O de disco)
- Ideal para até 50.000 registros
- Para datasets maiores, considere banco de dados

### Validação Automática

Todos os endpoints validam:
- Tipos de dados (number, string)
- IDs numéricos válidos
- Siglas de clube (3 letras)
- Posições válidas (GOL, ZAG, LAT, MEI, ATA, TEC)
- Tipos de ranking permitidos
- Limites de resultados (máx 100)

---

## Troubleshooting

### Problemas Comuns e Soluções

#### "Arquivo CSV não encontrado"

**Causa**: Caminho do CSV incorreto

**Solução**:
```bash
# Verifique se o arquivo existe (Windows)
dir "..\Base de dados\cartola_api_completo.csv"

# Se necessário, ajuste o caminho em src/server.js
const CSV_PATH = path.join(__dirname, '..', '..', 'Base de dados', 'cartola_api_completo.csv');
```

#### "Cannot find module 'swagger-jsdoc'"

**Causa**: Dependências do Swagger não instaladas

**Solução**:
```bash
npm install swagger-jsdoc swagger-ui-express
```

#### "Porta já em uso"

**Causa**: Porta 3000 ocupada por outro processo

**Solução**:
```bash
# Opção 1: Use outra porta
$env:PORT=3001; npm run dev

# Opção 2: Mate o processo na porta 3000 (Windows)
netstat -ano | findstr :3000
taskkill /PID <PID> /F
```

#### "Swagger UI não aparece"

**Causa**: Erro na configuração do Swagger

**Solução**:
1. Verifique se `src/config/swagger.js` existe
2. Verifique console do servidor para erros
3. Limpe cache do navegador (Ctrl+F5)
4. Reinicie o servidor

#### "Endpoints retornam array vazio"

**Causa**: Dados não carregados ou filtros muito restritivos

**Solução**:
```bash
# 1. Verifique se dados foram carregados
curl http://localhost:3000/health
# Veja "total_records" - deve ser > 0

# 2. Teste sem filtros
curl http://localhost:3000/jogadores

# 3. Verifique se o clube/posição existe
curl "http://localhost:3000/jogadores?clube=SAO"
```

#### "ID inválido" ou "Jogador não encontrado"

**Causa**: ID não existe ou não é numérico

**Solução**:
- Use IDs reais do seu CSV
- IDs devem ser números inteiros positivos
- Liste jogadores primeiro para obter IDs válidos

### Verificação Rápida

Execute este checklist:

```bash
# 1. Servidor está rodando?
curl http://localhost:3000/health

# 2. Dados foram carregados?
# Veja "total_records" no health

# 3. Swagger está acessível?
# Abra: http://localhost:3000/api-docs

# 4. Um endpoint funciona?
curl http://localhost:3000/jogadores
```

Se todos passarem, seu backend está 100% funcional!

---

## Deploy e Produção

### Preparação para Deploy

#### 1. Variáveis de Ambiente

Crie arquivo `.env`:
```bash
PORT=3000
NODE_ENV=production
CSV_PATH=C:/caminho/absoluto/para/cartola_api_completo.csv
```

#### 2. Build/Otimizações

```bash
# Instalar apenas dependências de produção
npm install --production

# Ou remover devDependencies
npm prune --production
```

#### 3. Desabilitar Swagger em Produção (Opcional)

Em `src/server.js`:
```javascript
// Comentar estas linhas em produção
if (process.env.NODE_ENV !== 'production') {
  app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec));
}
```

### Deploy em Diferentes Plataformas

#### Heroku

```bash
# 1. Criar Procfile
echo "web: node src/server.js" > Procfile

# 2. Deploy
heroku create cbf-stats-api
git push heroku main

# 3. Configurar variáveis
heroku config:set NODE_ENV=production
```

#### AWS EC2 / VPS

```bash
# 1. Instalar PM2 (gerenciador de processos)
npm install -g pm2

# 2. Iniciar aplicação
pm2 start src/server.js --name cbf-stats-api

# 3. Configurar para iniciar no boot
pm2 startup
pm2 save
```

#### Docker

Crie `Dockerfile`:
```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install --production
COPY . .
EXPOSE 3000
CMD ["node", "src/server.js"]
```

Build e run:
```bash
docker build -t cbf-stats-api .
docker run -p 3000:3000 cbf-stats-api
```

### Monitoramento

#### Health Check Endpoint

```bash
# Monitore periodicamente
curl http://seu-dominio.com/health

# Resposta esperada:
{
  "status": "ok",
  "timestamp": "2025-12-26T...",
  "data_loaded": true,
  "total_records": 5000
}
```

#### Logs

```bash
# Com PM2
pm2 logs cbf-stats-api

# Docker
docker logs -f container-id
```

### CORS em Produção

Configure origens permitidas em `src/server.js`:
```javascript
const corsOptions = {
  origin: ['https://seu-frontend.com', 'https://app.seu-dominio.com']
};
app.use(cors(corsOptions));
```

---

## Arquivos de Documentação Disponíveis

Este **README.md** consolida toda a documentação do backend. Arquivos adicionais de referência:

| Arquivo | Descrição | Status |
|---------|-----------|--------|
| **README.md** | Documentação completa consolidada (este arquivo) | Ativo |
| SWAGGER.md | Guia detalhado do Swagger UI | Referência |
| SWAGGER-PREVIEW.md | Preview visual da interface | Referência |
| SWAGGER-IMPLEMENTACAO.md | Detalhes técnicos de implementação | Referência |
| SWAGGER-CHECKLIST.md | Checklist de verificação | Referência |
| SWAGGER-SUMMARY.md | Resumo executivo | Referência |
| DOCUMENTACAO-INDEX.md | Índice de documentação | Referência |
| COMECE-AQUI.md | Guia rápido de 30 segundos | Referência |

> **Nota**: A documentação completa está neste README.md. Os outros arquivos são mantidos como referência opcional.

---

## Suporte e Contribuição

### Recursos Adicionais

- **Swagger UI**: http://localhost:3000/api-docs
- **Exemplos**: `node examples/api-examples.js`
- **Health Check**: http://localhost:3000/health

### Estrutura para Contribuir

1. Fork o repositório
2. Crie uma branch: `git checkout -b feature/nova-funcionalidade`
3. Commit suas mudanças: `git commit -m 'Adiciona nova funcionalidade'`
4. Push para a branch: `git push origin feature/nova-funcionalidade`
5. Abra um Pull Request

### Reportar Issues

Ao reportar problemas, inclua:
- Versão do Node.js
- Sistema operacional
- Comando executado
- Erro completo
- Passos para reproduzir

---

## Licença

MIT

---

## Conclusão

Você agora tem:

**Backend REST completo** com 8 endpoints  
**Documentação Swagger interativa**  
**17 exemplos de uso prontos**  
**Guia completo de troubleshooting**  
**Instruções de deploy**  
**Performance otimizada**  

**Próximos passos sugeridos:**

1. **Teste a API**: http://localhost:3000/api-docs
2. **Execute exemplos**: `node examples/api-examples.js`
3. **Crie o frontend** em Flutter consumindo esta API
4. **Deploy em produção** seguindo o guia acima

---

**Desenvolvido para análise de desempenho do Brasileirão 2025**

**Versão**: 1.0.0 | **Data**: 26 de dezembro de 2025
