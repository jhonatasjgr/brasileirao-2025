import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cbf_stats/providers/index.dart';
import 'package:cbf_stats/screens/login_screen.dart';
import 'package:cbf_stats/screens/home_screen.dart';
import 'package:cbf_stats/screens/jogadores_screen.dart';
import 'package:cbf_stats/screens/detalhes_jogador_screen.dart';
import 'package:cbf_stats/screens/comparacao_screen.dart';
import 'package:cbf_stats/screens/rankings_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ClubeProvider()),
        ChangeNotifierProvider(create: (_) => JogadorProvider()),
        ChangeNotifierProvider(create: (_) => RankingProvider()),
        ChangeNotifierProvider(create: (_) => ComparacaoProvider()),
      ],
      child: MaterialApp(
        title: 'CBF Stats',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
          appBarTheme: AppBarTheme(
            elevation: 2,
            backgroundColor: Colors.blue[900],
            foregroundColor: Colors.white,
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.blue[900],
          ),
        ),
        home: Consumer<ClubeProvider>(
          builder: (context, clubeProvider, _) {
            if (clubeProvider.clubeSelecionado == null) {
              return const LoginScreen();
            }
            return const _MainScreen();
          },
        ),
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/home':
              return MaterialPageRoute(
                builder: (_) => const HomeScreen(),
              );
            case '/jogadores':
              return MaterialPageRoute(
                builder: (_) => const JogadoresScreen(),
              );
            case '/detalhes':
              final jogadorId = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => DetalhesJogadorScreen(jogadorId: jogadorId),
              );
            case '/comparacao':
              return MaterialPageRoute(
                builder: (_) => const ComparacaoScreen(),
              );
            case '/rankings':
              return MaterialPageRoute(
                builder: (_) => const RankingsScreen(),
              );
            default:
              return MaterialPageRoute(
                builder: (_) => const HomeScreen(),
              );
          }
        },
      ),
    );
  }
}

class _MainScreen extends StatefulWidget {
  const _MainScreen({Key? key}) : super(key: key);

  @override
  State<_MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<_MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const JogadoresScreen(),
    const ComparacaoScreen(),
    const RankingsScreen(),
  ];

  final List<String> _titles = [
    'Dashboard',
    'Jogadores',
    'Comparação',
    'Rankings',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedIndex: _selectedIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.people),
            icon: Icon(Icons.people_outlined),
            label: 'Jogadores',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.compare_arrows),
            icon: Icon(Icons.compare_arrows_outlined),
            label: 'Comparação',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.emoji_events),
            icon: Icon(Icons.emoji_events_outlined),
            label: 'Rankings',
          ),
        ],
      ),
    );
  }
}
