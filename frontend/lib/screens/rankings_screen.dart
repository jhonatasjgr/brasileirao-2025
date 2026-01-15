import 'package:cbf_stats/widgets/jogador_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cbf_stats/models/index.dart';
import 'package:cbf_stats/providers/index.dart';

class RankingsScreen extends StatefulWidget {
  const RankingsScreen({Key? key}) : super(key: key);

  @override
  State<RankingsScreen> createState() => _RankingsScreenState();
}

class _RankingsScreenState extends State<RankingsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _tipoRankingSelecionado = 'pontos';
  int _rodadaSelecionada = 38;
  String? _clubeFiltro;
  String? _posicaoFiltro;

  final Map<String, String> _tiposRanking = {
    'pontos': 'Pontuação',
    'gols': 'Artilharia',
    'assistencias': 'Assistências',
    'desarmes': 'Desarmes',
    'finalizacoes_perigosas': 'Finalizações',
    'faltas_sofridas': 'Faltas Sofridas',
    'faltas_cometidas': 'Faltas Cometidas',
    'defesas_dificeis': 'Defesas',
    'penaltis_defendidos': 'Pênaltis Defendidos',
    'jogos_sem_sofrer_gol': 'Paredões',
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // agendar carregamento após o build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _carregarRanking();
    });
  }

  Future<void> _carregarRanking() async {
    final provider = context.read<RankingProvider>();
    await provider.buscarRanking(
      _tipoRankingSelecionado,
      rodada: _rodadaSelecionada == 38 ? null : _rodadaSelecionada,
      limit: 50, // aumenta o limite para mostrar mais jogadores
      posicao: _posicaoFiltro,
      clube: _clubeFiltro,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rankings'),
        backgroundColor: Colors.blue[900],
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          onTap: (_) {
            setState(() {});
          },
          tabs: const [
            Tab(text: 'Por Rodada'),
            Tab(text: 'Geral'),
            Tab(text: 'Do Clube'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // aba: por rodada
          _buildRankingTab(
            mostrarRodada: true,
            mostrarFiltroClube: false,
          ),
          // aba: geral
          _buildRankingTab(
            mostrarRodada: false,
            mostrarFiltroClube: false,
          ),
          // aba: do clube
          _buildRankingTab(
            mostrarRodada: false,
            mostrarFiltroClube: true,
          ),
        ],
      ),
    );
  }

  Widget _buildRankingTab({
    required bool mostrarRodada,
    required bool mostrarFiltroClube,
  }) {
    return Column(
      children: [
        // filtros
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.blue[50],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // seletor de tipo de ranking
              Text(
                'Tipo de Ranking',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _tiposRanking.length,
                  itemBuilder: (context, index) {
                    final tipo = _tiposRanking.keys.toList()[index];
                    final label = _tiposRanking.values.toList()[index];

                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label:
                            Text(label, style: const TextStyle(fontSize: 11)),
                        selected: _tipoRankingSelecionado == tipo,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _tipoRankingSelecionado = tipo;
                            });
                            _carregarRanking();
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              // seletor de rodada
              if (mostrarRodada) ...[
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
                          selected: _rodadaSelecionada == rodada,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _rodadaSelecionada = rodada;
                              });
                              _carregarRanking();
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
              // filtro de clube
              if (mostrarFiltroClube) ...[
                const SizedBox(height: 12),
                Text(
                  'Clube',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: clubesBrasileirao.length,
                    itemBuilder: (context, index) {
                      final clube = clubesBrasileirao[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(clube.sigla),
                          selected: _clubeFiltro == clube.sigla,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _clubeFiltro = clube.sigla;
                              });
                              _carregarRanking();
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
        // lista de rankings
        Expanded(
          child: Consumer<RankingProvider>(
            builder: (context, provider, _) {
              if (provider.isLoading) {
                return const LoadingWidget(mensagem: 'Carregando ranking...');
              }

              if (provider.erro != null) {
                return CustomErrorWidget(
                  mensagem: provider.erro!,
                  onRetry: _carregarRanking,
                );
              }

              if (provider.jogadores.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.emoji_events,
                          size: 48, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(
                        'Nenhum jogador encontrado',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: provider.jogadores.length,
                itemBuilder: (context, index) {
                  final jogador = provider.jogadores[index];
                  final posicao = index + 1;

                  return _RankingItem(
                    posicao: posicao,
                    jogador: jogador,
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        '/detalhes',
                        arguments: jogador.id,
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _RankingItem extends StatelessWidget {
  final int posicao;
  final Jogador jogador;
  final VoidCallback onTap;

  const _RankingItem({
    Key? key,
    required this.posicao,
    required this.jogador,
    required this.onTap,
  }) : super(key: key);

  Color _getMedalhaColor() {
    switch (posicao) {
      case 1:
        return const Color(0xFFFFD700);
      case 2:
        return const Color(0xFFC0C0C0);
      case 3:
        return const Color(0xFFCD7F32);
      default:
        return Colors.grey[400]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMedalha = posicao <= 3;

    return Material(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            border: isMedalha
                ? Border.all(color: _getMedalhaColor(), width: 2)
                : Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
            color:
                isMedalha ? _getMedalhaColor().withOpacity(0.05) : Colors.white,
          ),
          child: Row(
            children: [
              // posição / medalha
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _getMedalhaColor(),
                ),
                child: Center(
                  child: Text(
                    '$posicao',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: isMedalha ? 14 : 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              FotoJogador(
                fotoUrl: jogador.foto,
                size: 50,
                borderRadius: BorderRadius.circular(6),
              ),
              const SizedBox(width: 12),
              // dados do jogador
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      jogador.apelido,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${jogador.posicao} • ${jogador.clube}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              // pontuação
              _buildPontuacao(jogador),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPontuacao(Jogador jogador) {
    double? pontos;

    // tenta obter pontos de diferentes fontes
    if (jogador.mediapontos != null) {
      pontos = jogador.mediapontos;
    } else if (jogador.statsTemporada?.media != null) {
      pontos = jogador.statsTemporada!.media;
    }

    if (pontos == null || pontos == 0) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '${pontos.toStringAsFixed(1)} pts',
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.blue,
          fontSize: 12,
        ),
      ),
    );
  }
}
