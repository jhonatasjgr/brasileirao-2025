import 'package:flutter/material.dart';
import 'package:cbf_stats/models/index.dart';
import 'package:cbf_stats/services/index.dart';

// provider para gerenciar o estado dos jogadores
// inclui busca, detalhes e histórico de desempenho

class JogadorProvider extends ChangeNotifier {
  final PlayerService _playerService =
      PlayerService(); // instancia do serviço de jogadores

  List<Jogador> _jogadores = [];
  List<Jogador> get jogadores => _jogadores;

  bool _isLoading = false; // indicador de carregamento
  bool get isLoading => _isLoading;

  String? _erro; // mensagem de erro (se houver)
  String? get erro => _erro;

  Future<void> buscarJogadores({
    // busca de jogadores com filtros opcionais
    String? busca, // termo de busca(nome, clube, etc.)
    String? clube,
    String? posicao,
  }) async {
    _isLoading = true; // está carregando
    _erro = null; // sem erro por enquanto
    notifyListeners(); // notifica ouvintes sobre mudança de estado

    try {
      _jogadores = await _playerService.buscarJogadores(
        // chama o serviço para buscar jogadores
        busca: busca, // passa os filtros
        clube: clube, // passa o clube
        posicao: posicao, // passa a posição
      );
      _isLoading = false; // finaliza o carregamento
      notifyListeners(); // notifica ouvintes sobre mudança de estado
    } catch (e) {
      // erro
      _erro = e.toString(); // armazena a mensagem de erro
      _isLoading = false; // finaliza o carregamento
      notifyListeners(); // notifica ouvintes sobre mudança de estado
    }
  }

  Future<Jogador?> buscarJogadorDetalhes(int id) async {
    _isLoading = true; // está carregando
    _erro = null; // sem erro por enquanto
    notifyListeners(); // notifica ouvintes sobre mudança de estado

    try {
      final jogador = await _playerService.buscarJogadorDetalhes(id);
      _isLoading = false; // finaliza o carregamento
      notifyListeners(); // notifica ouvintes sobre mudança de estado
      return jogador; // retorna o jogador encontrado
    } catch (e) {
      _erro = e.toString(); // armazena a mensagem de erro
      _isLoading = false; // finaliza o carregamento
      notifyListeners(); // notifica ouvintes sobre mudança de estado
      return null;
    }
  }

  // busca o histórico de desempenho do jogador por rodadas
  Future<List<RodadaDesempenho>> buscarHistoricoRodadas(
    int id, {
    // id do jogador
    int? limite, // quantidade máxima de rodadas a buscar
  }) async {
    try {
      return await _playerService.buscarHistoricoRodadas(id,
          limite: limite); // chama o serviço para buscar o histórico
    } catch (e) {
      _erro = e.toString(); // armazena a mensagem de erro
      notifyListeners(); // notifica ouvintes sobre mudança de estado
      return [];
    }
  }
}

// provider para gerenciar o estado do ranking de jogadores
class RankingProvider extends ChangeNotifier {
  final PlayerService _playerService =
      PlayerService(); // instancia do serviço de jogadores

  List<Jogador> _jogadores = [];
  List<Jogador> get jogadores => _jogadores;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _erro;
  String? get erro => _erro;

  String _tipoRanking = 'pontos'; // tipo padrão de ranking
  String get tipoRanking => _tipoRanking;

  Future<void> buscarRanking(
    // busca o ranking de jogadores
    String tipo, {
    // tipo de ranking (pontos, assistências, etc.)
    int? rodada, // rodada específica (opcional)
    int limit = 10, // limite de jogadores a retornar
    String? posicao,
    String? clube,
  }) async {
    print(
        '[INFO] RankingProvider: Buscando ranking tipo=$tipo, rodada=$rodada, limit=$limit');
    _isLoading = true;
    _erro = null;
    _tipoRanking = tipo;
    notifyListeners(); // notifica ouvintes sobre mudança de estado

    try {
      _jogadores = await _playerService.buscarRanking(
        // chama o serviço para buscar o ranking
        tipo,
        rodada: rodada,
        limit: limit,
        posicao: posicao,
        clube: clube,
      );
      print(
          '[CORRETO] RankingProvider: ${_jogadores.length} jogadores carregados');
      _isLoading = false;
      notifyListeners(); // notifica ouvintes sobre mudança de estado
    } catch (e) {
      print('[ERRO] RankingProvider: Erro ao buscar ranking - $e');
      _erro = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}

// provider para gerenciar o estado da comparação de jogadores
class ComparacaoProvider extends ChangeNotifier {
  final PlayerService _playerService = PlayerService();

  List<Jogador> _jogadores = [];
  List<Jogador> get jogadores => _jogadores;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _erro;
  String? get erro => _erro;

  Future<void> compararJogadores(List<int> ids) async {
    // compara jogadores pelos seus IDs
    if (ids.length < 2) {
      // valida se há pelo menos 2 jogadores para comparar
      _erro = 'Selecione pelo menos 2 jogadores';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _erro = null;
    notifyListeners();

    try {
      _jogadores = await _playerService.compararJogadores(
          ids); // chama o serviço para comparar os jogadores, passando os IDs
      _isLoading = false;
      notifyListeners(); // notifica ouvintes sobre mudança de estado
    } catch (e) {
      _erro = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void limpar() {
    // limpa a comparação
    _jogadores = [];
    _erro = null;
    notifyListeners();
  }
}

class ClubeProvider extends ChangeNotifier {
  // provider para gerenciar o estado dos clubes
  Clube? _clubeSelecionado; // clube atualmente selecionado
  Clube? get clubeSelecionado => _clubeSelecionado;

  void selecionarClube(Clube clube) {
    // seleciona um clube
    _clubeSelecionado = clube;
    notifyListeners();
  }
}
