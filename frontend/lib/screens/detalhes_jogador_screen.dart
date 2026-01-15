import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cbf_stats/models/index.dart';
import 'package:cbf_stats/widgets/jogador_widgets.dart';
import 'package:cbf_stats/providers/index.dart';

class DetalhesJogadorScreen extends StatefulWidget {
  final int jogadorId;

  const DetalhesJogadorScreen({
    Key? key,
    required this.jogadorId,
  }) : super(key: key);

  @override
  State<DetalhesJogadorScreen> createState() => _DetalhesJogadorScreenState();
}

class _DetalhesJogadorScreenState extends State<DetalhesJogadorScreen> {
  late Jogador _jogador;
  late List<RodadaDesempenho> _historico;
  bool _isLoading = true;
  String? _erro;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _carregarDetalhes();
    });
  }

  Future<void> _carregarDetalhes() async {
    try {
      final provider = context.read<JogadorProvider>();

      final jogador = await provider.buscarJogadorDetalhes(widget.jogadorId);
      final historico = await provider.buscarHistoricoRodadas(widget.jogadorId);

      if (jogador != null) {
        setState(() {
          _jogador = jogador;
          _historico = historico;
          _isLoading = false;
        });
      } else {
        setState(() {
          _erro = 'Jogador não encontrado';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _erro = e.toString();
        _isLoading = false;
      });
    }
  }

  List<FlSpot> _gerarPontosGrafico() {
    return _historico
        .map((r) => FlSpot(r.rodada.toDouble(), r.pontos))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Carregando...')),
        body: const LoadingWidget(
          mensagem: 'Carregando informações do jogador...',
        ),
      );
    }

    if (_erro != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Erro')),
        body: CustomErrorWidget(
          mensagem: _erro!,
          onRetry: _carregarDetalhes,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_jogador.apelido),
        backgroundColor: Colors.blue[900],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // header com foto e informações básicas
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.blue[50],
              child: Column(
                children: [
                  FotoJogador(
                    fotoUrl: _jogador.foto,
                    size: 120,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  const SizedBox(height: 16),
                  // nome completo
                  Text(
                    _jogador.nomeCompleto ?? _jogador.apelido,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  // posição e clube
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_jogador.posicao} • ${_jogador.clube}',
                      style: TextStyle(
                        color: Colors.blue[900],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Preço
                  Text(
                    'R\$ ${_jogador.preco.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            // painel de estatísticas
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Estatísticas da Temporada',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  if (_jogador.statsTemporada != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          StatisticaRow(
                            label: 'Jogos',
                            valor: '${_jogador.statsTemporada!.jogos}',
                            icone: '',
                          ),
                          Divider(color: Colors.grey[300]),
                          StatisticaRow(
                            label: 'Pontuação Média',
                            valor:
                                '${_jogador.statsTemporada!.media.toStringAsFixed(1)}',
                            icone: '',
                            cor: Colors.blue,
                          ),
                          Divider(color: Colors.grey[300]),
                          StatisticaRow(
                            label: 'Máxima',
                            valor:
                                '${_jogador.statsTemporada!.maxima.toStringAsFixed(1)}',
                            icone: '',
                            cor: Colors.green,
                          ),
                          Divider(color: Colors.grey[300]),
                          StatisticaRow(
                            label: 'Mínima',
                            valor:
                                '${_jogador.statsTemporada!.minima.toStringAsFixed(1)}',
                            icone: '',
                            cor: Colors.orange,
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Gráfico de Evolução
            if (_historico.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Evolução por Rodada',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 300,
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: true,
                            horizontalInterval: 5,
                            verticalInterval: 5,
                            getDrawingHorizontalLine: (value) {
                              return FlLine(
                                color: Colors.grey[300]!,
                                strokeWidth: 1,
                              );
                            },
                            getDrawingVerticalLine: (value) {
                              return FlLine(
                                color: Colors.grey[300]!,
                                strokeWidth: 1,
                              );
                            },
                          ),
                          titlesData: FlTitlesData(
                            show: true,
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 30,
                                interval: 5,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    '${value.toInt()}',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  );
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    '${value.toInt()}',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(
                            show: true,
                            border: Border.all(
                              color: Colors.grey[300]!,
                            ),
                          ),
                          lineBarsData: [
                            LineChartBarData(
                              spots: _gerarPontosGrafico(),
                              isCurved: true,
                              gradient: LinearGradient(
                                colors: [Colors.blue, Colors.blue[700]!],
                              ),
                              barWidth: 3,
                              isStrokeCapRound: true,
                              dotData: const FlDotData(show: true),
                              belowBarData: BarAreaData(
                                show: true,
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.blue.withOpacity(0.3),
                                    Colors.blue.withOpacity(0.0),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                          ],
                          minX: 1,
                          maxX: 38,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            // Scouts Acumulados
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Scouts Acumulados',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  if (_jogador.statsTemporada != null)
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      childAspectRatio: 2.2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      children: [
                        _ScoutCard(
                          label: 'Gols',
                          valor: '${_jogador.statsTemporada!.gols}',
                          icone: '',
                        ),
                        _ScoutCard(
                          label: 'Assistências',
                          valor: '${_jogador.statsTemporada!.assistencias}',
                          icone: '',
                        ),
                        _ScoutCard(
                          label: 'Desarmes',
                          valor: '${_jogador.statsTemporada!.desarmes}',
                          icone: '',
                        ),
                        _ScoutCard(
                          label: 'Defesas Difíceis',
                          valor: '${_jogador.statsTemporada!.defesasDificeis}',
                          icone: '',
                        ),
                        _ScoutCard(
                          label: 'Pênaltis Defendidos',
                          valor:
                              '${_jogador.statsTemporada!.penaltisDefendidos}',
                          icone: '',
                        ),
                        _ScoutCard(
                          label: 'Jogos sem Sofrer Gol',
                          valor:
                              '${_jogador.statsTemporada!.jogosSemSofrerGol}',
                          icone: '',
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _ScoutCard extends StatelessWidget {
  final String label;
  final String valor;
  final String icone;

  const _ScoutCard({
    Key? key,
    required this.label,
    required this.valor,
    required this.icone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icone.isNotEmpty)
            Text(icone, style: const TextStyle(fontSize: 20)),
          if (icone.isNotEmpty) const SizedBox(height: 2),
          Flexible(
            child: Text(
              valor,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 2),
          Flexible(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
