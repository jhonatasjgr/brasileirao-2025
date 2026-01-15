# CBF Stats - Frontend Flutter

Frontend mobile em Flutter para o aplicativo CBF Stats - Análise de Desempenho de Jogadores do Brasileirão 2025.

## Requisitos

- **Flutter**: 3.1.0 ou superior
- **Dart**: 3.1.0 ou superior
- **API Backend**: Rodando em `http://localhost:3000`

## Configuração

### 1. Instalação de Dependências

```bash
cd frontend
flutter pub get
```

### 2. Estrutura de Diretórios

```
lib/
├── main.dart                 # Ponto de entrada da aplicação
├── models/                   # Modelos de dados (Jogador, Clube, etc)
│   ├── jogador.dart
│   ├── clube.dart
│   └── index.dart
├── services/                 # Serviços (API, autenticação, etc)
│   ├── player_service.dart
│   └── index.dart
├── providers/                # State management com Provider
│   └── index.dart
├── screens/                  # Telas principais
│   ├── login_screen.dart
│   ├── home_screen.dart
│   ├── jogadores_screen.dart
│   ├── detalhes_jogador_screen.dart
│   ├── comparacao_screen.dart
│   ├── rankings_screen.dart
│   └── index.dart
├── widgets/                  # Componentes reutilizáveis
│   ├── jogador_widgets.dart
│   └── index.dart
└── config/                   # Configurações
    ├── app_config.dart
    └── index.dart
```

## Telas e Funcionalidades

### 1. **Login / Seleção de Clube**
- Grid com escudos dos 20 clubes do Brasileirão
- Seleção do clube favorito do analista
- Personalização da experiência inicial

### 2. **Dashboard Inicial**
- Seletor dinâmico de rodadas (1-38)
- **Top 5 Clube**: Melhores jogadores do clube selecionado
- **Top 5 Liga**: Melhores jogadores da temporada
- **Atalhos Rápidos**: Artilharia, Comparação, Paredões

### 3. **Lista de Jogadores**
- **Busca em tempo real** por nome
- **Filtros avançados**:
  - Clube (20 opções)
  - Posição (GOL, ZAG, LAT, MEI, ATA, TEC)
- Cards com foto, pontuação média e informações essenciais

### 4. **Detalhes do Jogador**
- **Foto e dados cadastrais** completos
- **Estatísticas da temporada**: Jogos, média, máxima, mínima
- **Gráfico de evolução**: Linha mostrando pontos por rodada
- **Scouts acumulados**: Grid com Gols, Assistências, Desarmes, etc

### 5. **Comparação de Jogadores**
- Seleção de até 2 jogadores
- **Cards lado a lado** com destacamento do vencedor em cada métrica
- **Comparação de stats**: Verde para o melhor em cada quesito
- Gráfico comparativo de evolução

### 6. **Rankings**
- **3 Abas**:
  - **Por Rodada**: Top 15 da rodada específica
  - **Geral**: Top 15 da temporada
  - **Do Clube**: Top 15 específico do clube
- **Filtros de categoria**:
  - Pontuação, Gols, Assistências, Desarmes, Finalizações
  - Faltas Sofridas, Faltas Cometidas, Defesas
  - Pênaltis Defendidos, Paredões
- Medalhas visuais (1º, 2º, 3º)

## Tecnologias

### UI/UX
- **Flutter Material 3**: Design moderno e responsivo
- **fl_chart**: Gráficos de linha para evolução
- **cached_network_image**: Cache de imagens de jogadores

### State Management
- **Provider**: Gerenciamento de estado simples e eficiente

### Data & Networking
- **http**: Cliente HTTP para requisições à API
- **intl**: Formatação de datas e números

### Persistência
- **shared_preferences**: Cache local de dados

## Integração com Backend

### Endpoints Utilizados

| Endpoint | Método | Parâmetros | Descrição |
|----------|--------|-----------|-----------|
| `/jogadores` | GET | `busca`, `clube`, `posicao` | Lista de jogadores |
| `/jogadores/:id` | GET | - | Detalhes completos |
| `/jogadores/:id/rodadas` | GET | `limite` | Histórico de rodadas |
| `/comparacao` | GET | `ids` | Comparação de jogadores |
| `/rankings/:tipo` | GET | `rodada`, `limit`, `posicao`, `clube` | Rankings específicos |
| `/estatisticas/clube/:sigla` | GET | - | Stats do clube |

### Configuração de URL

Editar em `lib/config/app_config.dart`:

```dart
static const String baseUrl = 'http://localhost:3000';
```

Para **produção**, alterar para:

```dart
static const String baseUrl = 'https://sua-api.com';
```

## Execução

### Desenvolvimento

```bash
# Em um terminal, iniciar o emulador Android/iOS ou conectar dispositivo

# Executar no debug
flutter run

# Executar com modo verbose (para logs detalhados)
flutter run -v
```

## Dependências Principais

```yaml
provider: ^6.0.0           # State management
http: ^1.1.0              # HTTP client
fl_chart: ^0.64.0         # Gráficos
intl: ^0.19.0             # Internacionalização
shared_preferences: ^2.2.0 # Local storage
cached_network_image: ^3.3.0 # Cache de imagens
```

## Requisitos Funcionais Implementados

- [x] **RF01**: Visualização de Estatísticas por rodada, temporada e posição
- [x] **RF02**: Cálculo de Pontuação Fantasy (dados do backend)
- [x] **RF03**: Dashboard de Destaques (Top 5 Clube / Liga)
- [x] **RF04**: Filtros Avançados (Clube, Posição, Rodada)
- [x] **RF05**: Comparação de Jogadores lado a lado
- [x] **RF06**: Monitoramento de Evolução (Gráficos de desempenho)
- [x] **RF07**: Rankings Específicos (10 tipos)
- [x] **RF08**: Detalhamento do Jogador (Foto, dados, histórico)

## Requisitos Não-Funcionais Implementados

- [x] **RNF01**: Plataforma Mobile Flutter
- [x] **RNF02**: Integração com Backend API em Node.js
- [x] **RNF03**: Consumo de dados em JSON
- [x] **RNF04**: Cache local (shared_preferences)
- [x] **RNF05**: Interface com Data Viz clara

## Troubleshooting

### Erro: "Failed to connect to API"
- Verificar se o backend está rodando em `http://localhost:3000`
- Em emulador Android, usar `http://10.0.2.2:3000` em vez de `localhost`
- Verificar CORS no backend

### Erro: "Image failed to load"
- As URLs de imagens devem estar acessíveis
- Verificar conexão de internet
- Habilitar cache com `cached_network_image`

### Erro ao rodar Flutter
```bash
# Limpar build
flutter clean

# Obter dependências novamente
flutter pub get

# Executar em debug
flutter run
```

## Padrões de Código

### Estrutura de Provider

```dart
class MyProvider extends ChangeNotifier {
  List<Item> _items = [];
  List<Item> get items => _items;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadItems() async {
    _isLoading = true;
    notifyListeners();
    // ... lógica
    _isLoading = false;
    notifyListeners();
  }
}
```

### Uso em Widgets

```dart
Consumer<MyProvider>(
  builder: (context, provider, _) {
    if (provider.isLoading) return LoadingWidget();
    if (provider.erro != null) return ErrorWidget(message: provider.erro);
    return ListView(...);
  },
)
```

---

# 📐 Arquitetura do Frontend Flutter - CBF Stats

## Padrão de Arquitetura

O projeto segue uma arquitetura em camadas com separação clara de responsibilidades:

```
┌─────────────────────────────────────────────┐
│          User Interface (UI)                │
│  - Screens (Telas)                          │
│  - Widgets (Componentes Reutilizáveis)      │
└──────────────────┬──────────────────────────┘
                   │
┌──────────────────▼──────────────────────────┐
│      State Management (Provider)            │
│  - JogadorProvider                          │
│  - RankingProvider                          │
│  - ComparacaoProvider                       │
│  - ClubeProvider                            │
└──────────────────┬──────────────────────────┘
                   │
┌──────────────────▼──────────────────────────┐
│      Business Logic (Services)              │
│  - PlayerService                            │
│  - Cache Management                         │
└──────────────────┬──────────────────────────┘
                   │
┌──────────────────▼──────────────────────────┐
│      Data Layer (Models)                    │
│  - Jogador                                  │
│  - Clube                                    │
│  - RodadaDesempenho                         │
└──────────────────┬──────────────────────────┘
                   │
┌──────────────────▼──────────────────────────┐
│      External (API Backend)                 │
│  - HTTP Requests                            │
│  - JSON Parsing                             │
└─────────────────────────────────────────────┘
```

## Fluxo de Dados

### 1. Inicialização da App

```
main.dart
   ↓
MyApp (MultiProvider setup)
   ↓
LoginScreen (se nenhum clube selecionado)
   ├─ ClubeProvider.selecionarClube()
   └─ _MainScreen
```

### 2. Navegação Interna

```
_MainScreen (BottomNavigationBar)
├── HomeScreen
├── JogadoresScreen
├── ComparacaoScreen
└── RankingsScreen
```

### 3. Fluxo de Requisição

```
Screen (UI)
   ↓
Provider.método() (State)
   ├─ _isLoading = true
   ├─ _erro = null
   └─ notifyListeners()
   ↓
PlayerService.requisição() (API)
   ├─ http.get()
   ├─ jsonDecode()
   └─ Modelo.fromJson()
   ↓
Provider (retorno)
   ├─ _items = dados
   ├─ _isLoading = false
   └─ notifyListeners()
   ↓
Widget (rebuild)
```

## Padrões Utilizados

### 1. **Provider Pattern**
Gerenciamento de estado com `ChangeNotifier`:

```dart
class MyProvider extends ChangeNotifier {
  List<Item> _items = [];
  List<Item> get items => _items;

  Future<void> loadItems() async {
    _items = await service.fetch();
    notifyListeners(); // Notifica listeners para rebuild
  }
}
```

### 2. **Model Pattern**
Serialização de dados com `fromJson` e `toJson`:

```dart
class Jogador {
  factory Jogador.fromJson(Map<String, dynamic> json) {
    return Jogador(
      id: json['id'],
      apelido: json['apelido'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'apelido': apelido,
  };
}
```

### 3. **Service Layer**
Isolamento de lógica de API:

```dart
class PlayerService {
  Future<List<Jogador>> buscarJogadores() async {
    // Lógica de requisição e parsing
  }
}
```

### 4. **Widget Composition**
Componentes pequenos e reutilizáveis:

```dart
class CardJogador extends StatelessWidget {
  // Componente específico para card de jogador
  // Reutilizável em múltiplas telas
}
```

## Performance

### 1. **Lazy Loading**
- ListView com `itemBuilder` (não renderiza todos ao mesmo tempo)
- Scroll infinito em grandes listas

### 2. **Caching**
- `cached_network_image` para imagens
- `shared_preferences` para dados locais

### 3. **Build Otimizado**
- `const` constructors onde possível
- `Consumer` em lugar específico (não widget pai)

## Segurança

### Tratamento de Erros

```dart
try {
  final data = await service.fetch();
  // ... processar
} catch (e) {
  setState(() => _erro = e.toString());
  // Exibir ErrorWidget
}
```

### Validação de Dados

```dart
if (provider.erro != null) {
  return ErrorWidget(mensagem: provider.erro);
}

if (provider.isLoading) {
  return LoadingWidget();
}
```

## Tema e Estilo

### Cores Principais
- **Primária**: Azul (#2196F3 e variações)
- **Sucesso**: Verde (#4CAF50)
- **Aviso**: Laranja (#FF9800)
- **Erro**: Vermelho (#F44336)

## Convenções de Código

### Naming
- Classes: `PascalCase` (ExemploClasse)
- Funções/Métodos: `camelCase` (exemploMetodo)
- Variáveis Privadas: `_camelCase` (_exemploPrivado)
- Constants: `UPPER_CASE` ou `camelCase`

---

# Flutter Build & Deployment

## Como compilar para Android

```bash
# Build APK (debug)
flutter build apk

# Build APK (release)
flutter build apk --release

# Build AAB (Google Play)
flutter build appbundle --release
```

## Como compilar para iOS

```bash
# Build iOS (debug)
flutter build ios

# Build iOS (release)
flutter build ios --release
```

## Arquivos importantes

- `.android/`: Configurações e build Android
- `.ios/`: Configurações e build iOS
- `ios/Runner.xcodeproj`: Projeto Xcode para edição avançada
- `android/app/build.gradle`: Configurações Gradle

## Requisitos para build

### Android
- Android SDK 21+
- Gradle
- Java JDK

### iOS
- Xcode 13+
- CocoaPods
- Disponível apenas em macOS

## Variáveis de ambiente

```bash
# Localizar SDK do Flutter
flutter doctor

# Verificar versão
flutter --version

# Listar dispositivos
flutter devices
```

## Build Produção

```bash
# Android
flutter build apk --release
flutter build appbundle --release

# iOS
flutter build ios --release

# Web (se habilitado)
flutter build web --release
```

---

## Próximos Passos

1. **Otimizações de Performance**:
   - Lazy loading de listas grandes
   - Paginação em rankings
   - Cache inteligente com expiração

2. **Melhorias UX**:
   - Animações de transição
   - Shimmer loading
   - Offline mode

3. **Features Futuras**:
   - Notificações push
   - Salvar favoritos
   - Histórico de buscas
   - Modo escuro

## Suporte

Para dúvidas ou reportar bugs, abrir issue no repositório do projeto.

---
