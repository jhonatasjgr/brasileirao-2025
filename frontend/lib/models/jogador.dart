import 'package:equatable/equatable.dart';

class Jogador extends Equatable {
  final int id;
  final String apelido;
  final String? nomeCompleto;
  final String clube;
  final String posicao;
  final String? foto;
  final double preco;
  final double? mediapontos;
  final StatisticasTemporada? statsTemporada;

  const Jogador({
    required this.id,
    required this.apelido,
    this.nomeCompleto,
    required this.clube,
    required this.posicao,
    this.foto,
    required this.preco,
    this.mediapontos,
    this.statsTemporada,
  });
  // factory serve para criar uma instância da classe a partir de um Map (JSON)
  factory Jogador.fromJson(Map<String, dynamic> json) {
    // Trata os diferentes formatos de campo que podem vir do backend
    final clube = json['clube'] ?? json['clube_sigla'] ?? '';
    final posicao = json['posicao'] ?? json['posicao_sigla'] ?? '';
    final foto = json['foto'] ?? json['foto_url'];

    // Tenta extrair media_pontos de diferentes lugares
    double? mediaPontos;
    if (json['media_pontos'] != null) {
      mediaPontos = (json['media_pontos'] as num?)?.toDouble();
    } else if (json['media'] != null) {
      mediaPontos = (json['media'] as num?)?.toDouble();
    } else if (json['ranking_value'] != null) {
      mediaPontos = (json['ranking_value'] as num?)?.toDouble();
    } else if (json['stats_temporada']?['media_pontos'] != null) {
      mediaPontos =
          (json['stats_temporada']['media_pontos'] as num?)?.toDouble();
    }

    return Jogador(
      id: json['id'] ?? json['id_jogador'] ?? 0,
      apelido: json['apelido'] ?? '',
      nomeCompleto: json['nome'] ?? json['nome_completo'],
      clube: clube,
      posicao: posicao,
      foto: foto,
      preco: (json['preco'] as num?)?.toDouble() ?? 0.0,
      mediapontos: mediaPontos,
      statsTemporada: json['stats_temporada'] != null
          ? StatisticasTemporada.fromJson(json['stats_temporada'])
          : null,
    );
  }
  // método para converter a instância da classe em um Map (JSON)
  Map<String, dynamic> toJson() => {
        'id': id,
        'apelido': apelido,
        'nome': nomeCompleto,
        'clube': clube,
        'posicao': posicao,
        'foto': foto,
        'preco': preco,
        'media_pontos': mediapontos,
        'stats_temporada': statsTemporada?.toJson(),
      };

  @override
  List<Object?> get props =>
      [id, apelido, clube, posicao]; // props para comparação

  Jogador copyWith({
    // método para criar uma cópia modificada da instância, útil para imutabilidade
    int? id,
    String? apelido,
    String? nomeCompleto,
    String? clube,
    String? posicao,
    String? foto,
    double? preco,
    double? mediapontos,
    StatisticasTemporada? statsTemporada,
  }) {
    return Jogador(
      id: id ?? this.id,
      apelido: apelido ?? this.apelido,
      nomeCompleto: nomeCompleto ?? this.nomeCompleto,
      clube: clube ?? this.clube,
      posicao: posicao ?? this.posicao,
      foto: foto ?? this.foto,
      preco: preco ?? this.preco,
      mediapontos: mediapontos ?? this.mediapontos,
      statsTemporada: statsTemporada ?? this.statsTemporada,
    );
  }
}

class StatisticasTemporada extends Equatable {
  // classe para estatísticas da temporada
  final int jogos;
  final int gols;
  final int assistencias;
  final int desarmes;
  final int defesasDificeis;
  final int penaltisDefendidos;
  final int jogosSemSofrerGol;
  final int cartaoAmarelo;
  final int cartaoVermelho;
  final int finalizacoesPerigosas;
  final double media;
  final double maxima;
  final double minima;

  const StatisticasTemporada({
    required this.jogos,
    required this.gols,
    required this.assistencias,
    required this.desarmes,
    this.defesasDificeis = 0,
    this.penaltisDefendidos = 0,
    this.jogosSemSofrerGol = 0,
    this.cartaoAmarelo = 0,
    this.cartaoVermelho = 0,
    this.finalizacoesPerigosas = 0,
    required this.media,
    this.maxima = 0,
    this.minima = 0,
  });

  // factory para criar uma instância a partir de JSON
  factory StatisticasTemporada.fromJson(Map<String, dynamic> json) {
    return StatisticasTemporada(
      jogos: json['jogos'] ?? 0,
      gols: json['gols'] ?? 0,
      assistencias: json['assistencias'] ?? 0,
      desarmes: json['desarmes'] ?? json['ds'] ?? 0,
      defesasDificeis: json['defesas_dificeis'] ?? json['de'] ?? 0,
      penaltisDefendidos: json['penaltis_defendidos'] ?? json['dp'] ?? 0,
      jogosSemSofrerGol: json['jogos_sem_sofrer_gol'] ?? json['sg'] ?? 0,
      cartaoAmarelo: json['cartao_amarelo'] ?? json['ca'] ?? 0,
      cartaoVermelho: json['cartao_vermelho'] ?? json['cv'] ?? 0,
      finalizacoesPerigosas: json['finalizacoes_perigosas'] ?? 0,
      media: (json['media'] as num?)?.toDouble() ?? 0.0,
      maxima: (json['maxima'] as num?)?.toDouble() ?? 0.0,
      minima: (json['minima'] as num?)?.toDouble() ?? 0.0,
    );
  }
  // método para converter a instância em JSON
  Map<String, dynamic> toJson() => {
        'jogos': jogos,
        'gols': gols,
        'assistencias': assistencias,
        'desarmes': desarmes,
        'defesas_dificeis': defesasDificeis,
        'penaltis_defendidos': penaltisDefendidos,
        'jogos_sem_sofrer_gol': jogosSemSofrerGol,
        'cartao_amarelo': cartaoAmarelo,
        'cartao_vermelho': cartaoVermelho,
        'finalizacoes_perigosas': finalizacoesPerigosas,
        'media': media,
        'maxima': maxima,
        'minima': minima,
      };

  @override
  List<Object?> get props => [
        // propriedades para comparação
        jogos,
        gols,
        assistencias,
        desarmes,
        media,
      ];
}

class RodadaDesempenho extends Equatable {
  // classe para desempenho em uma rodada específica
  final int rodada;
  final double pontos;
  final String? adversario;
  final int? gols;
  final int? assistencias;
  final int? desarmes;
  final Map<String, dynamic>? scoutsPrincipais;

  const RodadaDesempenho({
    required this.rodada,
    required this.pontos,
    this.adversario,
    this.gols,
    this.assistencias,
    this.desarmes,
    this.scoutsPrincipais,
  });
  // factory para criar uma instância a partir de JSON
  factory RodadaDesempenho.fromJson(Map<String, dynamic> json) {
    return RodadaDesempenho(
      rodada: json['rodada'] ?? 0,
      pontos: (json['pontos'] ?? json['pontos_cartola'] ?? 0).toDouble(),
      adversario: json['adversario'],
      gols: json['gols'] ?? json['g'],
      assistencias: json['assistencias'] ?? json['a'],
      desarmes: json['desarmes'] ?? json['ds'],
      scoutsPrincipais: json['scouts_principais'],
    );
  }

  @override
  List<Object?> get props => [rodada, pontos]; // props para comparação
}
