import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cbf_stats/models/index.dart';
import 'package:cbf_stats/providers/index.dart';
import 'package:cbf_stats/widgets/jogador_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _rodadaAtual = 38;
  late JogadorProvider _jogadorProvider;
  List<Jogador> _topClubeJogadores = [];
  List<Jogador> _topLigaJogadores = [];

  @override
  void initState() {
    super.initState();
    _jogadorProvider = context.read<JogadorProvider>();
    // agendar carregamento após o build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _carregarDestaques();
    });
  }

  Future<void> _carregarDestaques() async {
    if (!mounted) return; // Verifica se ainda está montado

    final clube = context.read<ClubeProvider>().clubeSelecionado;

    if (clube != null) {
      // carrega top 5 do clube
      await _jogadorProvider.buscarJogadores(clube: clube.sigla);
      if (!mounted) return; // Verifica novamente antes do setState
      setState(() {
        _topClubeJogadores = _jogadorProvider.jogadores.take(5).toList();
      });
    }

    // carrega top 5 da liga
    await _jogadorProvider.buscarJogadores();
    setState(() {
      _topLigaJogadores = _jogadorProvider.jogadores.take(5).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final clube = context.watch<ClubeProvider>().clubeSelecionado;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        elevation: 0,
        backgroundColor: Colors.blue[900],
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.shield,
                      size: 18,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      clube?.nome ?? 'Clube',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // seletor de rodada
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.blue[50],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rodada',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 38,
                      itemBuilder: (context, index) {
                        final rodada = index + 1;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text('$rodada'),
                            selected: _rodadaAtual == rodada,
                            onSelected: (selected) {
                              setState(() {
                                _rodadaAtual = rodada;
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            // top 5 clube
            if (_topClubeJogadores.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Top 5 - ${clube?.nome}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    TextButton(
                      onPressed: () =>
                          Navigator.of(context).pushNamed('/jogadores'),
                      child: const Text('Ver todos'),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _topClubeJogadores.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: SizedBox(
                        width: 120,
                        child: CardDestaque(
                          posicao: index + 1,
                          jogador: _topClubeJogadores[index],
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              '/detalhes',
                              arguments: _topClubeJogadores[index].id,
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
            // top 5 liga
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Top 5 - Liga',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  TextButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed('/rankings'),
                    child: const Text('Ver rankings'),
                  ),
                ],
              ),
            ),
            if (_topLigaJogadores.isNotEmpty)
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _topLigaJogadores.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: SizedBox(
                        width: 120,
                        child: CardDestaque(
                          posicao: index + 1,
                          jogador: _topLigaJogadores[index],
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              '/detalhes',
                              arguments: _topLigaJogadores[index].id,
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            // Atalhos Rápidos
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Expanded(
                    child: _AtalhoCard(
                      titulo: 'Artilharia',
                      icone: Icons.local_fire_department,
                      cor: Colors.red,
                      onTap: () => Navigator.of(context).pushNamed('/rankings'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _AtalhoCard(
                      titulo: 'Comparar',
                      icone: Icons.compare_arrows,
                      cor: Colors.blue,
                      onTap: () =>
                          Navigator.of(context).pushNamed('/comparacao'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _AtalhoCard(
                      titulo: 'Paredões',
                      icone: Icons.shield,
                      cor: Colors.green,
                      onTap: () => Navigator.of(context).pushNamed('/rankings'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AtalhoCard extends StatelessWidget {
  final String titulo;
  final IconData icone;
  final Color cor;
  final VoidCallback onTap;

  const _AtalhoCard({
    Key? key,
    required this.titulo,
    required this.icone,
    required this.cor,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: cor.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icone, color: cor, size: 28),
            const SizedBox(height: 8),
            Text(
              titulo,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: cor,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
