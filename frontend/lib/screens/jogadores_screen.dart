import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cbf_stats/models/index.dart';
import 'package:cbf_stats/providers/index.dart';
import 'package:cbf_stats/widgets/jogador_widgets.dart';

class JogadoresScreen extends StatefulWidget {
  const JogadoresScreen({Key? key}) : super(key: key);

  @override
  State<JogadoresScreen> createState() => _JogadoresScreenState();
}

class _JogadoresScreenState extends State<JogadoresScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _clubeSelecionado;
  String? _posicaoSelecionada;
  bool _mostrarFiltros = false;

  @override
  void initState() {
    super.initState();
    _carregarJogadores();
  }

  Future<void> _carregarJogadores() async {
    context.read<JogadorProvider>().buscarJogadores(
          busca: _searchController.text.isEmpty ? null : _searchController.text,
          clube: _clubeSelecionado,
          posicao: _posicaoSelecionada,
        );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jogadores'),
        elevation: 0,
        backgroundColor: Colors.blue[900],
      ),
      body: Column(
        children: [
          // barra de busca
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue[50],
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (_) {
                    _carregarJogadores();
                  },
                  decoration: InputDecoration(
                    hintText: 'Buscar por nome...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
                const SizedBox(height: 12),
                // Botão de filtros
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () {
                          setState(() {
                            _mostrarFiltros = !_mostrarFiltros;
                          });
                        },
                        icon: const Icon(Icons.filter_list),
                        label: const Text('Filtros'),
                      ),
                    ),
                    if (_clubeSelecionado != null ||
                        _posicaoSelecionada != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              _clubeSelecionado = null;
                              _posicaoSelecionada = null;
                            });
                            _carregarJogadores();
                          },
                          child: const Text('Limpar'),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          // Painel de Filtros
          if (_mostrarFiltros)
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Clube',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: clubesBrasileirao.map((clube) {
                      final isSelected = _clubeSelecionado == clube.sigla;
                      return FilterChip(
                        label: Text(clube.sigla),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _clubeSelecionado = selected ? clube.sigla : null;
                          });
                          _carregarJogadores();
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Posição',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: posicoes.entries.map((entry) {
                      final isSelected = _posicaoSelecionada == entry.key;
                      return FilterChip(
                        label: Text(entry.value),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _posicaoSelecionada = selected ? entry.key : null;
                          });
                          _carregarJogadores();
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          // Lista de Jogadores
          Expanded(
            child: Consumer<JogadorProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) {
                  return const LoadingWidget(
                      mensagem: 'Carregando jogadores...');
                }

                if (provider.erro != null) {
                  return CustomErrorWidget(
                    mensagem: provider.erro!,
                    onRetry: _carregarJogadores,
                  );
                }

                if (provider.jogadores.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.people,
                          size: 48,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Nenhum jogador encontrado',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tente ajustar os filtros',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: provider.jogadores.length,
                  itemBuilder: (context, index) {
                    final jogador = provider.jogadores[index];
                    return CardJogador(
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
      ),
    );
  }
}
