import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cbf_stats/models/index.dart';

class PlayerService {
  static const String baseUrl = 'http://localhost:3000';

  static final PlayerService _instance = PlayerService._internal();

  factory PlayerService() {
    return _instance;
  }

  PlayerService._internal();

  /// buscar lista de jogadores com filtros
  Future<List<Jogador>> buscarJogadores({
    String? busca,
    String? clube,
    String? posicao,
  }) async {
    try {
      String url = '$baseUrl/jogadores';
      Map<String, String> params = {};

      if (busca != null && busca.isNotEmpty) {
        params['busca'] = busca;
      }
      if (clube != null && clube.isNotEmpty) {
        params['clube'] = clube;
      }
      if (posicao != null && posicao.isNotEmpty) {
        params['posicao'] = posicao;
      }

      if (params.isNotEmpty) {
        url += '?' + params.entries.map((e) => '${e.key}=${e.value}').join('&');
      }

      print('[INFO] Requisição: GET $url');
      final response =
          await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));

      print('[INFO] Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        // a API retorna {total, jogadores} então pegamos o array jogadores
        List<dynamic> data = jsonResponse is Map
            ? (jsonResponse['jogadores'] ?? [])
            : jsonResponse;
        print('[CORRETO] Recebidos ${data.length} jogadores');
        return data.map((json) => Jogador.fromJson(json)).toList();
      } else {
        print('[ERRO] Status ${response.statusCode}');
        throw Exception('Erro ao buscar jogadores: ${response.statusCode}');
      }
    } catch (e) {
      print('[ERRO] Exceção: $e');
      rethrow;
    }
  }

  /// buscar detalhes completos de um jogador
  Future<Jogador> buscarJogadorDetalhes(int id) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/jogadores/$id'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return Jogador.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Jogador não encontrado');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// buscar histórico de rodadas de um jogador
  Future<List<RodadaDesempenho>> buscarHistoricoRodadas(
    int id, {
    int? limite,
  }) async {
    try {
      String url = '$baseUrl/jogadores/$id/rodadas';
      if (limite != null) {
        url += '?limite=$limite';
      }

      final response =
          await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        // a API retorna {id, total_rodadas, rodadas}
        List<dynamic> data = jsonResponse is Map
            ? (jsonResponse['rodadas'] ?? [])
            : jsonResponse;
        return data.map((json) => RodadaDesempenho.fromJson(json)).toList();
      } else {
        throw Exception('Erro ao buscar histórico');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// comparar dois ou mais jogadores
  Future<List<Jogador>> compararJogadores(List<int> ids) async {
    try {
      final idsStr = ids.join(',');
      final response = await http
          .get(Uri.parse('$baseUrl/comparacao?ids=$idsStr'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        // a API retorna {total, jogadores}
        List<dynamic> data = jsonResponse is Map
            ? (jsonResponse['jogadores'] ?? [])
            : jsonResponse;
        return data.map((json) => Jogador.fromJson(json)).toList();
      } else {
        throw Exception('Erro ao comparar jogadores');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// buscar ranking por tipo
  Future<List<Jogador>> buscarRanking(
    String tipo, {
    int? rodada,
    int limit = 10,
    String? posicao,
    String? clube,
  }) async {
    try {
      String url = '$baseUrl/rankings/$tipo?limit=$limit';

      if (rodada != null) {
        url += '&rodada=$rodada';
      }
      if (posicao != null && posicao.isNotEmpty) {
        url += '&posicao=$posicao';
      }
      if (clube != null && clube.isNotEmpty) {
        url += '&clube=$clube';
      }

      print('[INFO] Requisição: GET $url');
      final response =
          await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));

      print('[INFO] Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        // a API retorna {tipo, rodada, posicao, clube, total, ranking}
        List<dynamic> data = jsonResponse is Map
            ? (jsonResponse['ranking'] ?? [])
            : jsonResponse;
        print('[CORRETO] Recebidos ${data.length} jogadores no ranking');
        return data.map((json) => Jogador.fromJson(json)).toList();
      } else {
        print('[ERRO] Status ${response.statusCode}');
        throw Exception('Erro ao buscar ranking: ${response.statusCode}');
      }
    } catch (e) {
      print('[ERRO] Exceção no ranking: $e');
      rethrow;
    }
  }

  /// buscar estatísticas do clube
  Future<Map<String, dynamic>> buscarEstatisticasClube(String sigla) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/estatisticas/clube/$sigla'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Erro ao buscar estatísticas do clube');
      }
    } catch (e) {
      rethrow;
    }
  }
}
