# CBF Stats - Análise de Desempenho do Brasileirão 2025

> Aplicativo mobile completo em **Flutter** para análise de desempenho de jogadores do Brasileirão 2025, com backend API em **Node.js** e documentação robusta.

**Versão**: 1.0.0 | **Data**: 27 de dezembro de 2025 | **Status**: **COMPLETO**

---

## Índice Completo

1. [Visão Geral](#visão-geral)
2. [Quick Start (5 minutos)](#quick-start-comece-em-5-minutos)
3. [Arquitetura do Sistema](#arquitetura-do-sistema)
4. [Estrutura do Projeto](#estrutura-do-projeto)
5. [Stack Tecnológico](#stack-tecnológico)
6. [Funcionalidades](#funcionalidades)
7. [Requisitos Atendidos](#requisitos-atendidos)
8. [Endpoints da API](#endpoints-da-api)
9. [Guia de Instalação](#guia-de-instalação)
10. [Integração Frontend + Backend](#integração-frontend--backend)
11. [Documentação Detalhada](#documentação-detalhada)
12. [Troubleshooting](#troubleshooting)
13. [Deploy & Produção](#deploy--produção)
14. [Próximos Passos](#próximos-passos)

---

## Visão Geral

O **CBF Stats** é um ecossistema completo para análise de desempenho de jogadores da Série A do Brasileirão 2025. O sistema processa dados em CSV, expõe via API REST e apresenta em um aplicativo mobile interativo com gráficos, rankings e comparações.

### O que foi construído

**Backend API** (Node.js) - 17 endpoints com 10 tipos de rankings  
**Frontend Mobile** (Flutter) - 6 telas com navegação fluida  
**Banco de Dados** (CSV) - 28.589 registros de 980 jogadores  
**Documentação Swagger** - Interativa e completa  
**Documentação Técnica** - Robusta e detalhada  

---

## Quick Start - Comece em 5 minutos

### 1. Instalar Dependências

```bash
# Frontend
cd frontend
flutter pub get

# Backend (se necessário)
cd ../backend
npm install
```

### 2. Iniciar Backend

```bash
cd backend
npm start
# Aguarde: Server listening on http://localhost:3000
```

### 3. Iniciar Frontend

```bash
cd frontend
flutter run
```

### 4. Testar Funcionalidades

- [ ] LoginScreen aparece com 20 clubes
- [ ] Selecione seu clube favorito
- [ ] Veja Top 5 jogadores do clube
- [ ] Navegue para Jogadores e busque por nome
- [ ] Clique em um jogador para ver detalhes
- [ ] Veja gráfico de evolução (LineChart)
- [ ] Acesse Rankings e explore as 10 categorias
- [ ] Teste Comparação com 2 jogadores
- [ ] Pronto!

---

## Arquitetura do Sistema

```
┌────────────────────────────────────────────────────────────────┐
│                      USUÁRIO FINAL                             │
│                  (Analista de Desempenho)                      │
└────────────────────────────────────────────────────────────────┘
                              ↓
┌────────────────────────────────────────────────────────────────┐
│                    FLUTTER APP (Frontend)                      │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │ Screens (6 principais)                                   │  │
│  │  ├─ LoginScreen (seleção clube)                         │  │
│  │  ├─ HomeScreen (dashboard + top 5)                      │  │
│  │  ├─ JogadoresScreen (busca e filtros)                   │  │
│  │  ├─ DetalhesScreen (stats + gráfico)                    │  │
│  │  ├─ ComparacaoScreen (2 jogadores)                      │  │
│  │  └─ RankingsScreen (3 abas × 10 tipos)                  │  │
│  └──────────────────────────────────────────────────────────┘  │
│                              ↓                                  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │ State Management (Provider Pattern)                      │  │
│  │  ├─ JogadorProvider (listagem + detalhes)              │  │
│  │  ├─ RankingProvider (rankings dinâmicos)               │  │
│  │  ├─ ComparacaoProvider (comparação 2 players)          │  │
│  │  └─ ClubeProvider (clube selecionado)                  │  │
│  └──────────────────────────────────────────────────────────┘  │
│                              ↓                                  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │ 🔌 Serviços (PlayerService)                             │  │
│  │  ├─ buscarJogadores()                                  │  │
│  │  ├─ buscarJogadorDetalhes()                            │  │
│  │  ├─ buscarHistoricoRodadas()                           │  │
│  │  ├─ compararJogadores()                                │  │
│  │  ├─ buscarRanking()                                    │  │
│  │  └─ buscarEstatisticasClube()                          │  │
│  └──────────────────────────────────────────────────────────┘  │
│                              ↓ HTTP/JSON                       │
└────────────────────────────────────────────────────────────────┘
                              ↓
┌────────────────────────────────────────────────────────────────┐
│                  NODE.JS API (Backend)                         │
│  http://localhost:3000                                         │
│                                                                │
│  Endpoints (6 principais):                                     │
│  ├─ GET /jogadores (com filtros)                             │
│  ├─ GET /jogadores/:id (detalhes)                            │
│  ├─ GET /jogadores/:id/rodadas (histórico)                   │
│  ├─ GET /comparacao (compare 2)                              │
│  ├─ GET /rankings/:tipo (10 tipos)                           │
│  └─ GET /estatisticas/clube/:sigla                           │
│                                                                │
│  + Swagger/OpenAPI em /api-docs                               │
└────────────────────────────────────────────────────────────────┘
                              ↓
┌────────────────────────────────────────────────────────────────┐
│                   BASE DE DADOS (CSV)                          │
│  28.589 registros | 980 jogadores únicos | 38 rodadas        │
│  ├─ cartola_api_completo.csv (dados brutos)                  │
│  ├─ cartola/ (dados por rodada)                              │
│  └─ cartola_processado/ (dados processados)                  │
└────────────────────────────────────────────────────────────────┘
```

---

## Estrutura do Projeto

```
brasileirao-2025/
│
├── frontend/                          ← Aplicativo Flutter
│   ├── lib/
│   │   ├── main.dart                     # Raiz (297 linhas)
│   │   │
│   │   ├── models/                       # Modelos de dados
│   │   │   ├── jogador.dart              # (171 linhas)
│   │   │   ├── clube.dart                # (61 linhas)
│   │   │   └── index.dart
│   │   │
│   │   ├── services/                     # Camada de API
│   │   │   ├── player_service.dart       # (178 linhas)
│   │   │   └── index.dart
│   │   │
│   │   ├── providers/                    # State management
│   │   │   └── index.dart                # (247 linhas)
│   │   │       ├─ JogadorProvider
│   │   │       ├─ RankingProvider
│   │   │       ├─ ComparacaoProvider
│   │   │       └─ ClubeProvider
│   │   │
│   │   ├── screens/                      # 6 Telas
│   │   │   ├── login_screen.dart         # (146 linhas)
│   │   │   ├── home_screen.dart          # (198 linhas)
│   │   │   ├── jogadores_screen.dart     # (179 linhas)
│   │   │   ├── detalhes_jogador_screen.dart  # (278 linhas)
│   │   │   ├── comparacao_screen.dart    # (296 linhas)
│   │   │   ├── rankings_screen.dart      # (252 linhas)
│   │   │   └── index.dart
│   │   │
│   │   ├── widgets/                      # Componentes reutilizáveis
│   │   │   ├── jogador_widgets.dart      # (341 linhas)
│   │   │   └── index.dart
│   │   │
│   │   └── config/                       # Configurações
│   │       ├── app_config.dart           # (24 linhas)
│   │       └── index.dart
│   │
│   ├── pubspec.yaml                      # Dependências
│   ├── analysis_options.yaml
│   ├── .gitignore
│   └── README.md                         # Documentação frontend
│
├── backend/                           ← API Node.js (Pré-existente)
│   ├── src/
│   │   ├── server.js                     # Servidor Express
│   │   └── routes/                       # Rotas da API
│   ├── package.json
│   ├── README.md                         # Documentação backend
│   └── AUDITORIA.md                      # Relatório de testes
│
├── Base de dados/                     ← Dados CSV
│   ├── cartola_api_completo.csv          # 28.589 registros
│   ├── cartola/                          # 38 rodadas (arquivos)
│   └── cartola_processado/               # Dados processados
│
├── Documentação - guia para desenvolvimento/
│   ├── documentacao inicial.md           # Requisitos iniciais
│   ├── documentacao node.md              # Backend spec
│   └── documentacao flutter.md           # Frontend spec
│
├── README.md                          # ← VOCÊ ESTÁ AQUI
├── QUICK_START.md                     # Quick start (5 min)
├── PROJECT_COMPLETION.md              # Status final
├── FRONTEND_SUMMARY.md                # Resumo frontend
├── INTEGRATION_GUIDE.md               # Guia integração
├── PROJECT_VISUALIZATION.md           # Diagramas ASCII
├── FILE_INVENTORY.md                  # Inventário de arquivos
└── INDEX.md                           # Índice de documentos
```

---

## Stack Tecnológico

### Frontend (Flutter)

| Tecnologia | Versão | Propósito |
|-----------|--------|-----------|
| **Flutter** | 3.1.0+ | Framework mobile |
| **Dart** | 3.1.0+ | Linguagem |
| **Provider** | 6.0.0 | State management |
| **http** | 1.1.0 | Cliente HTTP |
| **fl_chart** | 0.64.0 | Gráficos (LineChart) |
| **cached_network_image** | 3.3.0 | Cache de imagens |
| **shared_preferences** | 2.2.0 | Persistência local |
| **intl** | 0.19.0 | Formatação i18n |
| **go_router** | 13.0.0 | Navegação nomeada |

### Backend (Node.js)

| Tecnologia | Versão | Propósito |
|-----------|--------|-----------|
| **Node.js** | 16+ | Runtime |
| **Express** | 4.x | Framework web |
| **csv-parser** | - | Parser CSV |
| **Swagger/OpenAPI** | 3.0 | Documentação |
| **CORS** | - | Requisições frontend |

### Dados (CSV)

| Item | Quantidade |
|------|-----------|
| **Total de registros** | 28.589 |
| **Jogadores únicos** | 980 |
| **Rodadas** | 38 |
| **Clubes** | 20 |
| **Temporada** | 2025 |

---

## Funcionalidades

### Frontend (6 Telas)

#### 1. **Login / Seleção de Clube**
- Grid 3×7 com 20 clubes do Brasileirão
- Seleção persistente com ClubeProvider
- Navegação automática para Home
- Personalização de experiência

#### 2. **Dashboard Inicial**
- Seletor dinâmico de rodadas (1-38)
- **Top 5 Clube**: Melhores do clube selecionado
- **Top 5 Liga**: Melhores da temporada
- **3 Atalhos Rápidos**:
  - Artilharia (maiores artilheiros)
  - Comparação (comparar 2 jogadores)
  - Paredões (menos gols sofridos)
- CardDestaque com medalhas

#### 3. **Lista de Jogadores**
- **Busca em tempo real** por nome/apelido
- **Filtros avançados**:
  - Clube (20 opções)
  - Posição (6 categorias: GOL, ZAG, LAT, MEI, ATA, TEC)
  - Combinação de filtros
- CardJogador com foto, preço e média
- Estado vazio com mensagem amigável
- Navegação para detalhes

#### 4. **Detalhes do Jogador**
- **Header**: Foto grande + dados cadastrais
- **Estatísticas**: Jogos, Média, Máxima, Mínima
- **Gráfico de Evolução**: LineChart mostrando pontos por rodada (38 rodadas)
  - Eixo X: Rodadas (1-38)
  - Eixo Y: Pontos (floating point)
  - Gradient stroke, fill gradient, grid lines
- **Grid de Scouts**: 6 scouts (Gols, Assistências, Desarmes, etc)

#### 5. **Comparação de Jogadores**
- Busca e seleção de até 2 jogadores
- Cards lado a lado
- **Comparação de stats**:
  - Jogos, Média, Gols, Assistências, Preço
  - Verde destaca o melhor em cada métrica
- Métrica "Quem custa menos?"
- Gráfico comparativo

#### 6. **Rankings com 3 Abas**
- **Aba 1 - Por Rodada**: Específica da rodada (1-38)
- **Aba 2 - Geral**: Temporada inteira
- **Aba 3 - Do Clube**: Filtro por clube selecionado

**10 Tipos de Ranking**:
1. Pontuação (padrão)
2. Gols (artilheiros)
3. Assistências
4. Desarmes
5. Finalizações Perigosas
6. Faltas Sofridas
7. Faltas Cometidas
8. Defesas Difíceis
9. Pênaltis Defendidos
10. Paredões (jogos sem sofrer gol)

**Características**:
- Medalhas para top 3 (🥇 🥈 🥉)
- Limite configurável (padrão 15)
- Filtros por posição/clube
- Lista ordenada com placar

---

### 🔌 Backend API (17 Endpoints)

#### Endpoints de Jogadores (3)

```bash
GET /jogadores
├─ Parâmetros: busca, clube, posicao, limit
└─ Retorno: Array<Jogador>

GET /jogadores/:id
├─ Parâmetro: id (número)
└─ Retorno: Jogador (completo com stats)

GET /jogadores/:id/rodadas
├─ Parâmetros: id, limite
└─ Retorno: Array<RodadaDesempenho> (histórico)
```

#### Endpoint de Comparação (1)

```bash
GET /comparacao
├─ Parâmetros: ids (ex: "123,456")
└─ Retorno: Array<Jogador> (2 jogadores)
```

#### Endpoints de Rankings (10 tipos + 1 rota)

```bash
GET /rankings/:tipo
├─ Tipos suportados:
│  ├─ pontos (padrão)
│  ├─ gols
│  ├─ assistencias
│  ├─ desarmes
│  ├─ finalizacoes_perigosas
│  ├─ faltas_sofridas
│  ├─ faltas_cometidas
│  ├─ defesas_dificeis
│  ├─ penaltis_defendidos
│  └─ jogos_sem_sofrer_gol
│
├─ Parâmetros: rodada, limit, posicao, clube
└─ Retorno: Array<Jogador> (ordenados)
```

#### Endpoint de Estatísticas (1)

```bash
GET /estatisticas/clube/:sigla
├─ Parâmetro: sigla (ex: "FLA")
└─ Retorno: EstatisticasClube
```

#### Endpoints de Sistema (2)

```bash
GET /
└─ Retorno: Info da API (nome, versão, endpoints)

GET /health
└─ Retorno: {"status": "ok", "data_loaded": true, "total_records": 28589}
```

---

## Requisitos Atendidos

### Requisitos Funcionais (8/8)

| ID | Requisito | Status | Onde |
|---|---|---|---|
| **RF01** | Visualização de Estatísticas por rodada, temporada e posição | OK | Rankings + Detalhes |
| **RF02** | Cálculo de Pontuação Fantasy com regras de pesos | OK | Backend (dados) |
| **RF03** | Dashboard de Destaques (Top 5 Clube / Liga) | OK | HomeScreen |
| **RF04** | Filtros Avançados (Clube, Posição, Rodada) | OK | JogadoresScreen + Rankings |
| **RF05** | Comparação de Jogadores lado a lado | OK | ComparacaoScreen |
| **RF06** | Monitoramento de Evolução (Gráficos) | OK | DetalhesScreen (LineChart) |
| **RF07** | Rankings Específicos (10 tipos) | OK | RankingsScreen |
| **RF08** | Detalhamento do Jogador (Foto, dados, histórico) | OK | DetalhesScreen |

### Requisitos Não-Funcionais (5/5)

| ID | Requisito | Status | Implementação |
|---|---|---|---|
| **RNF01** | Plataforma Mobile com Flutter | OK | Flutter 3.1.0+ |
| **RNF02** | Backend API em Node.js | OK | Express + CSV |
| **RNF03** | Fonte de Dados em CSV | OK | 28.589 registros |
| **RNF04** | Cache Local (Local Storage) | OK | shared_preferences |
| **RNF05** | Interface Data Viz clara | OK | Material 3 + fl_chart |

---

## Guia de Instalação

### Pré-requisitos

- **Flutter**: 3.1.0 ou superior ([Instalar](https://flutter.dev/docs/get-started/install))
- **Dart**: 3.1.0 ou superior (instalado com Flutter)
- **Node.js**: 16+ ([Instalar](https://nodejs.org/))
- **Android SDK** ou **Xcode** (para compilar)
- **Emulador Android** ou **dispositivo físico** conectado

### Passo 1: Clonar o Repositório

```bash
git clone https://github.com/seu-usuario/brasileirao-2025.git
cd brasileirao-2025
```

### Passo 2: Instalar Dependências Frontend

```bash
cd frontend
flutter pub get
```

### Passo 3: Instalar Dependências Backend

```bash
cd ../backend
npm install
```

### Passo 4: Iniciar o Backend

```bash
# No diretório backend/
npm start

# Aguarde a mensagem:
# Server listening on http://localhost:3000
```

### Passo 5: Iniciar o Frontend

```bash
cd ../frontend
flutter run
```

### Passo 6: Testar

- LoginScreen aparece com 20 clubes
- Selecione um clube
- Navegue entre as telas
- Teste busca, filtros e gráficos

---

## Integração Frontend + Backend

### Configuração de URL

**Arquivo**: `frontend/lib/config/app_config.dart`

```dart
class ApiConfig {
  // Desenvolvimento local
  static const String baseUrl = 'http://localhost:3000';
  static const int requestTimeout = 10; // segundos
}
```

### Emulador Android

Se usar emulador Android, localhost não funciona. Use:

```dart
static const String baseUrl = 'http://10.0.2.2:3000';
```

### Dispositivo Físico

```bash
# Descobrir IP da máquina
ipconfig  # Windows: procure por IPv4
ifconfig # macOS/Linux

# Editar em app_config.dart:
static const String baseUrl = 'http://192.168.1.100:3000';
```

### Verificação de Conectividade

```bash
# Testar endpoint base
curl http://localhost:3000

# Testar jogadores
curl http://localhost:3000/jogadores

# Testar Swagger
# Abra no navegador: http://localhost:3000/api-docs
```

### Fluxo de Requisição

```
Frontend (Flutter)
    ↓ (chama método)
PlayerService (HTTP client)
    ↓ (envia GET)
Backend (Express)
    ↓ (processa CSV)
Retorna JSON
    ↓
Provider (atualiza state)
    ↓
Widget (rebuild)
    ↓
Tela (exibe resultado)
```

---

## Documentação Detalhada

### 📖 Arquivos de Documentação

| Arquivo | Tamanho | Conteúdo |
|---------|---------|----------|
| **README.md** (raiz) | Este arquivo | Documentação geral completa |
| **frontend/README.md** | 550 linhas | Guia detalhado do frontend (arquitetura + build) |
| **backend/README.md** | 1.500+ linhas | Documentação completa da API + Swagger |
| **QUICK_START.md** | 80 linhas | Começar em 5 minutos |
| **INTEGRATION_GUIDE.md** | 430 linhas | Guia de integração frontend+backend |
| **PROJECT_COMPLETION.md** | 430 linhas | Status final do projeto |
| **FRONTEND_SUMMARY.md** | 370 linhas | Resumo técnico do frontend |
| **PROJECT_VISUALIZATION.md** | 680 linhas | Diagramas ASCII e fluxos |
| **FILE_INVENTORY.md** | 500 linhas | Inventário de todos os arquivos |
| **INDEX.md** | 600 linhas | Índice navegável de documentação |
| **backend/AUDITORIA.md** | 300 linhas | Relatório de testes e validação |

### 🔍 Por onde começar?

```
Se você quer...                    → Leia
─────────────────────────────────────────────────
Começar agora (5 min)              → QUICK_START.md
Entender a arquitetura             → PROJECT_VISUALIZATION.md
Integrar frontend + backend        → INTEGRATION_GUIDE.md
Guia detalhado do frontend         → frontend/README.md
Documentação da API                → backend/README.md
Ver o que foi criado               → FILE_INVENTORY.md
Navegar toda documentação          → INDEX.md
```

---

## Troubleshooting

### ❌ "Failed to connect to localhost"

**Causa**: Backend não está rodando

**Solução**:
```bash
cd backend
npm start
```

### ❌ "Connection refused" (erro 111 ou 10061)

**Causa**: Backend rodando em porta diferente

**Solução**: Verificar porta em `backend/src/server.js`
```bash
grep "listen\|PORT" backend/src/server.js
```

### ❌ Emulador Android não conecta

**Causa**: Localhost refere-se ao emulador, não ao host

**Solução**: Editar `frontend/lib/config/app_config.dart`
```dart
static const String baseUrl = 'http://10.0.2.2:3000';
```

### ❌ "Image failed to load"

**Causa**: URLs de imagens inacessíveis ou sem internet

**Solução**: Verificar conexão e usar `cached_network_image`

### ❌ Erro ao rodar Flutter

```bash
# Limpar build
flutter clean

# Obter dependências novamente
flutter pub get

# Executar com logs
flutter run -v
```

### ❌ "Invalid JSON response"

**Causa**: Resposta do backend não é JSON válido

**Solução**:
```bash
# Testar endpoint direto
curl -i http://localhost:3000/jogadores

# Verificar logs do backend (console do Node)
```

---

## Deploy & Produção

### Build para Produção

#### Android

```bash
cd frontend

# Build APK
flutter build apk --release

# Build AAB (Google Play)
flutter build appbundle --release

# Saída
# APK: build/app/outputs/flutter-app.apk
# AAB: build/app/outputs/bundle/release/app-release.aab
```

#### iOS

```bash
cd frontend

# Build iOS
flutter build ios --release

# Saída
# build/ios/iphoneos/Runner.app
```

#### Web

```bash
cd frontend
flutter build web --release
# Saída: build/web/
```

### Configuração para Produção

**Editar**: `frontend/lib/config/app_config.dart`

```dart
class ApiConfig {
  // Mudança para produção
  static const String baseUrl = 'https://sua-api.cbfstats.com.br';
  static const int requestTimeout = 15; // aumentar timeout
}
```

### Deploy Backend

```bash
# Deploy em servidor (exemplo Heroku)
cd backend

# Adicionar scripts em package.json
"scripts": {
  "start": "node src/server.js",
  "dev": "nodemon src/server.js"
}

# Deploy (exemplo)
git push heroku main
```

---

## Próximos Passos

### Fase 2: Melhorias (Futuro)

- [ ] **Unit Tests**: Testes para models e services
- [ ] **Widget Tests**: Testes para screens
- [ ] **Integration Tests**: Testes e2e
- [ ] **Offline Mode**: Sincronização quando offline
- [ ] **Push Notifications**: Notificações de atualizações
- [ ] **Dark Mode**: Tema escuro
- [ ] **Histórico de Buscas**: Salvar buscas recentes
- [ ] **Favoritos**: Salvar jogadores favoritos
- [ ] **Analytics**: Rastrear uso
- [ ] **Otimização**: Paginação, lazy loading

### Fase 3: Expansão

- [ ] **Web Version**: Versão desktop/web
- [ ] **Admin Panel**: Painel de administração
- [ ] **Real-time Updates**: WebSocket para atualizações ao vivo
- [ ] **Notificações**: Alertas de milestones
- [ ] **Relatórios**: Exportar PDFs/Excel
- [ ] **Machine Learning**: Previsões de performance
- [ ] **Social**: Compartilhar análises

---

## Métricas do Projeto

```
CÓDIGO
├─ Linhas de Dart: ~2.450
├─ Linhas de JavaScript: ~500
├─ Arquivos criados: 31
└─ Documentação: ~4.000 linhas

FUNCIONALIDADES
├─ Telas: 6
├─ Providers: 4
├─ Endpoints: 17 (6 principais + system)
├─ Tipos de Ranking: 10
├─ Filtros: 2 (clube + posição)
└─ Requisitos: 13 (8 RF + 5 RNF)

DADOS
├─ Total de registros: 28.589
├─ Jogadores únicos: 980
├─ Clubes: 20
├─ Rodadas: 38
└─ Scouts: 20+ tipos

TEMPO
├─ Backend: Pré-existente
├─ Frontend: Completo
└─ Documentação: Robusta

STATUS
└─ Projeto: 100% COMPLETO
```

---

## Checklist Final

- Backend API funcionando
- Frontend Flutter implementado
- 6 telas com navegação
- 4 providers para state management
- Integração frontend + backend
- 10 tipos de ranking
- Gráficos (LineChart)
- Busca em tempo real
- Filtros avançados
- Comparação de jogadores
- Swagger documentation
- Documentação técnica completa
- Troubleshooting guide
- Build para produção
- Todos requisitos atendidos

---

## Suporte e Contribuição

### 📧 Suporte

Para dúvidas ou reportar bugs:
1. Consulte a [Documentação Detalhada](#documentação-detalhada)
2. Verifique o [Troubleshooting](#troubleshooting)
3. Abra uma issue no repositório

### 🤝 Contribuição

1. Fork o repositório
2. Crie uma branch (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

---

## Licença

Este projeto é licenciado sob a MIT License - veja o arquivo [LICENSE](LICENSE) para detalhes.

---

## Informações do Projeto

- **Nome**: CBF Stats
- **Subtítulo**: Análise de Desempenho do Brasileirão 2025
- **Versão**: 1.0.0
- **Data**: 27 de dezembro de 2025
- **Status**: Completo
- **Linguagens**: Dart (Flutter) + JavaScript (Node.js)
- **Banco de Dados**: CSV (28.589 registros)
- **Plataformas**: Mobile (Android/iOS) + Backend API

---

## Autor

Desenvolvido como parte do projeto **Brasileirão 2025 - Análise de Desempenho**.

**Data da Última Atualização**: 27 de dezembro de 2025

---

**🎉 Projeto Completo e Pronto para Uso!**

Para começar em 5 minutos, acesse [QUICK_START.md](QUICK_START.md).
