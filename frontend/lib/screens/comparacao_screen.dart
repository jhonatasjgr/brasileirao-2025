import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cbf_stats/models/index.dart';
import 'package:cbf_stats/providers/index.dart';
import 'package:cbf_stats/widgets/jogador_widgets.dart';

// tela para comparar dois jogadores
class ComparacaoScreen extends StatefulWidget {
  const ComparacaoScreen({Key? key}) : super(key: key);

  @override
  State<ComparacaoScreen> createState() => _ComparacaoScreenState();
}

class _ComparacaoScreenState extends State<ComparacaoScreen> {
  final List<Jogador> _selecionados = [];
  final JogadorProvider _jogadorProvider =
      JogadorProvider(); // provider do jogador, para comparação
  final TextEditingController _searchController =
      TextEditingController(); // controlador do campo de busca
  List<Jogador> _resultadoBusca = [];
  bool _mostrandoBusca = false; // indica se está mostrando resultados de busca

  @override
  void initState() {
    super.initState();
  }

  Future<void> _buscarJogadores(String termo) async {
    // busca jogadores pelo termo (nome ou apelido)
    if (termo.isEmpty) {
      // nenhum termo, limpa resultados
      setState(() {
        _resultadoBusca = [];
      });
      return;
    }

    await _jogadorProvider.buscarJogadores(
        busca: termo); // busca jogadores no provider
    setState(() {
      _resultadoBusca = _jogadorProvider.jogadores;
    });
  }

  void _selecionarJogador(Jogador jogador) {
    // seleciona ou deseleciona um jogador
    if (_selecionados.any((j) => j.id == jogador.id)) {
      // já está selecionado, remove
      setState(() {
        _selecionados.removeWhere((j) =>
            j.id == jogador.id); // remove o jogador da lista de selecionados
      });
    } else if (_selecionados.length < 2) {
      // ainda pode selecionar mais jogadores
      setState(() {
        _selecionados
            .add(jogador); // adiciona o jogador à lista de selecionados
      });

      if (_selecionados.length == 2) {
        // se já tem dois jogadores selecionados, inicia a comparação
        context
            .read<ComparacaoProvider>() // acessa o provider de comparação
            .compararJogadores([
          _selecionados[0].id,
          _selecionados[1].id
        ]); // inicia a comparação dos dois jogadores selecionados
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // constrói a interface da tela de comparação
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comparação'),
        backgroundColor: Colors.blue[900],
      ),
      body: SingleChildScrollView(
        // single child scroll view para permitir rolagem
        child: Column(
          children: [
            // campo de busca
            Container(
              // container para o campo de busca
              padding: const EdgeInsets.all(16),
              color: Colors.blue[50],
              child: Column(
                // filho coluna para o campo de busca e instruções
                crossAxisAlignment:
                    CrossAxisAlignment.start, // alinha à esquerda
                children: [
                  // filhos da coluna
                  Text(
                    'Selecione até 2 jogadores para comparar',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[700],
                        ),
                  ),
                  const SizedBox(height: 12), // espaçamento
                  TextField(
                    // campo de texto para busca
                    controller: _searchController,
                    onChanged: (value) {
                      _buscarJogadores(value);
                      setState(() {
                        _mostrandoBusca = value.isNotEmpty;
                      });
                    },
                    decoration: InputDecoration(
                      // decoração do campo de texto
                      hintText: 'Buscar jogador...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        // borda arredondada
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                  // resultados da busca
                  if (_mostrandoBusca &&
                      _resultadoBusca
                          .isNotEmpty) // se está mostrando busca e há resultados, mostra a lista
                    Container(
                      // container para a lista de resultados
                      margin: const EdgeInsets.only(top: 12),
                      decoration: BoxDecoration(
                        // decoração do container
                        border: Border.all(
                            color: Colors.grey[300]!), // borda cinza clara
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListView.builder(
                        // lista de resultados da busca
                        shrinkWrap: true, // encolhe para caber no conteúdo
                        physics:
                            const NeverScrollableScrollPhysics(), // desabilita rolagem interna
                        itemCount:
                            _resultadoBusca.length, // número de resultados
                        itemBuilder: (context, index) {
                          // constrói cada item da lista
                          final jogador =
                              _resultadoBusca[index]; // jogador atual
                          final isSelected = _selecionados.any((j) =>
                              j.id ==
                              jogador
                                  .id); // verifica se o jogador está selecionado

                          return Container(
                            // container para o item da lista
                            color: isSelected
                                ? Colors.blue.withOpacity(0.1)
                                : null, // se selecionado, muda a cor de fundo
                            child: ListTile(
                              // lista de tile (item) por jogador
                              leading: FotoJogador(
                                fotoUrl: jogador.foto,
                                size: 40,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              title: Text(jogador.apelido),
                              subtitle:
                                  Text('${jogador.posicao} • ${jogador.clube}'),
                              trailing: Checkbox(
                                value: isSelected,
                                onChanged: (value) {
                                  _selecionarJogador(jogador);
                                },
                              ),
                              onTap: () {
                                _selecionarJogador(jogador);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
            // Jogadores selecionados
            if (_selecionados.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Jogadores Selecionados (${_selecionados.length}/2)',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      // wrap para os chips dos jogadores selecionados
                      spacing: 8,
                      children: _selecionados.map((jogador) {
                        return Chip(
                          avatar: SizedBox(
                            width: 32,
                            height: 32,
                            child: FotoJogador(
                              fotoUrl: jogador.foto,
                              size: 32,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          label: Text(jogador.apelido),
                          onDeleted: () {
                            setState(() {
                              _selecionados
                                  .removeWhere((j) => j.id == jogador.id);
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            // Comparação
            if (_selecionados.length == 2)
              Consumer<ComparacaoProvider>(
                builder: (context, provider, _) {
                  if (provider.isLoading) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: LoadingWidget(
                        mensagem: 'Comparando jogadores...',
                      ),
                    );
                  }

                  if (provider.jogadores.length < 2) {
                    return const SizedBox.shrink();
                  }

                  final jogador1 = provider.jogadores[0];
                  final jogador2 = provider.jogadores[1];

                  return Column(
                    children: [
                      // cards lado a lado
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Expanded(
                              child: _CartaoJogadorComparacao(
                                jogador: jogador1,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _CartaoJogadorComparacao(
                                jogador: jogador2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Comparação de stats
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Comparação de Estatísticas',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 12),
                            if (jogador1.statsTemporada != null &&
                                jogador2.statsTemporada != null)
                              Column(
                                children: [
                                  _ComparacaoStat(
                                    label: 'Jogos',
                                    valor1: '${jogador1.statsTemporada!.jogos}',
                                    valor2: '${jogador2.statsTemporada!.jogos}',
                                    vencedor: jogador1.statsTemporada!.jogos >
                                            jogador2.statsTemporada!.jogos
                                        ? 1
                                        : (jogador1.statsTemporada!.jogos <
                                                jogador2.statsTemporada!.jogos
                                            ? 2
                                            : 0),
                                  ),
                                  _ComparacaoStat(
                                    label: 'Média de Pontos',
                                    valor1:
                                        '${jogador1.statsTemporada!.media.toStringAsFixed(1)}',
                                    valor2:
                                        '${jogador2.statsTemporada!.media.toStringAsFixed(1)}',
                                    vencedor: jogador1.statsTemporada!.media >
                                            jogador2.statsTemporada!.media
                                        ? 1
                                        : (jogador1.statsTemporada!.media <
                                                jogador2.statsTemporada!.media
                                            ? 2
                                            : 0),
                                  ),
                                  _ComparacaoStat(
                                    label: 'Gols',
                                    valor1: '${jogador1.statsTemporada!.gols}',
                                    valor2: '${jogador2.statsTemporada!.gols}',
                                    vencedor: jogador1.statsTemporada!.gols >
                                            jogador2.statsTemporada!.gols
                                        ? 1
                                        : (jogador1.statsTemporada!.gols <
                                                jogador2.statsTemporada!.gols
                                            ? 2
                                            : 0),
                                  ),
                                  _ComparacaoStat(
                                    label: 'Assistências',
                                    valor1:
                                        '${jogador1.statsTemporada!.assistencias}',
                                    valor2:
                                        '${jogador2.statsTemporada!.assistencias}',
                                    vencedor:
                                        jogador1.statsTemporada!.assistencias >
                                                jogador2.statsTemporada!
                                                    .assistencias
                                            ? 1
                                            : (jogador1.statsTemporada!
                                                        .assistencias <
                                                    jogador2.statsTemporada!
                                                        .assistencias
                                                ? 2
                                                : 0),
                                  ),
                                  _ComparacaoStat(
                                    label: 'Preço',
                                    valor1:
                                        'R\$ ${jogador1.preco.toStringAsFixed(2)}',
                                    valor2:
                                        'R\$ ${jogador2.preco.toStringAsFixed(2)}',
                                    vencedor: jogador1.preco < jogador2.preco
                                        ? 1
                                        : (jogador1.preco > jogador2.preco
                                            ? 2
                                            : 0),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _CartaoJogadorComparacao extends StatelessWidget {
  final Jogador jogador;

  const _CartaoJogadorComparacao({
    Key? key,
    required this.jogador,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue[300]!),
        borderRadius: BorderRadius.circular(8),
        color: Colors.blue[50],
      ),
      child: Column(
        children: [
          FotoJogador(
            fotoUrl: jogador.foto,
            size: 60,
            borderRadius: BorderRadius.circular(6),
          ),
          const SizedBox(height: 8),
          Text(
            jogador.apelido,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            '${jogador.posicao}',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '${jogador.statsTemporada?.media.toStringAsFixed(1) ?? '-'}',
              style: const TextStyle(
                fontSize: 11,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ComparacaoStat extends StatelessWidget {
  final String label;
  final String valor1;
  final String valor2;
  final int vencedor; // 1 = jogador1, 2 = jogador2, 0 = empate

  const _ComparacaoStat({
    Key? key,
    required this.label,
    required this.valor1,
    required this.valor2,
    required this.vencedor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: vencedor == 1
                    ? Colors.green.withOpacity(0.1)
                    : Colors.white,
                border: Border.all(
                  color: vencedor == 1 ? Colors.green : Colors.grey[300]!,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                children: [
                  Text(
                    valor1,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: vencedor == 1 ? Colors.green : Colors.black,
                    ),
                  ),
                  if (vencedor == 1)
                    const Text(
                      '✓',
                      style: TextStyle(color: Colors.green, fontSize: 12),
                    ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: vencedor == 2
                    ? Colors.green.withOpacity(0.1)
                    : Colors.white,
                border: Border.all(
                  color: vencedor == 2 ? Colors.green : Colors.grey[300]!,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                children: [
                  Text(
                    valor2,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: vencedor == 2 ? Colors.green : Colors.black,
                    ),
                  ),
                  if (vencedor == 2)
                    const Text(
                      '✓',
                      style: TextStyle(color: Colors.green, fontSize: 12),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
