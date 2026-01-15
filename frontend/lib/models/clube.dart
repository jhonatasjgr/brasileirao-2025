import 'package:equatable/equatable.dart';

class Clube extends Equatable { //Equatable é usado para facilitar comparações entre objetos
  final String sigla;
  final String nome;
  final String? logo;
  final String? cor;

  const Clube({ // construtor da classe Clube
    required this.sigla,
    required this.nome,
    this.logo,
    this.cor,
  });

  @override
  List<Object?> get props => [sigla, nome]; // props define os campos usados para comparação do clube
}

// lista de clubes do Brasileirão 2025
const List<Clube> clubesBrasileirao = [
  Clube(sigla: 'FLA', nome: 'Flamengo', cor: '#000000'),
  Clube(sigla: 'PAL', nome: 'Palmeiras', cor: '#1F7F1D'),
  Clube(sigla: 'VAS', nome: 'Vasco da Gama', cor: '#000000'),
  Clube(sigla: 'BOT', nome: 'Botafogo', cor: '#000000'),
  Clube(sigla: 'BRA', nome: 'Bragantino', cor: '#DA0B2A'),
  Clube(sigla: 'COR', nome: 'Corinthians', cor: '#FFFFFF'),
  Clube(sigla: 'SAO', nome: 'São Paulo', cor: '#FF0000'),
  Clube(sigla: 'SAN', nome: 'Santos', cor: '#FFFFFF'),
  Clube(sigla: 'MAN', nome: 'Manchester', cor: '#FF0000'),
  Clube(sigla: 'INT', nome: 'Inter', cor: '#FF0000'),
  Clube(sigla: 'GRE', nome: 'Grêmio', cor: '#0066CC'),
  Clube(sigla: 'JUV', nome: 'Juventude', cor: '#00FF00'),
  Clube(sigla: 'FEC', nome: 'Fortaleza', cor: '#0066CC'),
  Clube(sigla: 'CEA', nome: 'Ceará', cor: '#0066CC'),
  Clube(sigla: 'BAH', nome: 'Bahia', cor: '#0066CC'),
  Clube(sigla: 'VIT', nome: 'Vitória', cor: '#FF0000'),
  Clube(sigla: 'CAM', nome: 'Atlético-MG', cor: '#000000'),
  Clube(sigla: 'GOI', nome: 'Goiás', cor: '#009900'),
  Clube(sigla: 'ATH', nome: 'Athletico-PR', cor: '#FF0000'),
  Clube(sigla: 'CUI', nome: 'Cuiabá', cor: '#CC6600'),
];

const Map<String, String> posicoes = {
  'GOL': 'Goleiro',
  'ZAG': 'Zagueiro',
  'LAT': 'Lateral',
  'MEI': 'Meia',
  'ATA': 'Atacante',
  'TEC': 'Técnico',
};

enum TipoRanking {
  pontos,
  gols,
  assistencias,
  desarmes,
  finalizacoes,
  faltasSofridas,
  faltasCometidas,
  defesas,
  penaltiDefendidos,
  jogosSemSofrerGol,
}

final rankingInfo = {
  'pontos': {'titulo': 'Pontuação', 'descricao': 'Jogadores com melhor pontuação'},
  'gols': {'titulo': 'Artilharia', 'descricao': 'Top goleadores'},
  'assistencias': {'titulo': 'Assistências', 'descricao': 'Maiores assistentes'},
  'desarmes': {'titulo': 'Desarmes', 'descricao': 'Maiores defensores'},
  'finalizacoes': {'titulo': 'Finalizações', 'descricao': 'Mais finalizações perigosas'},
  'faltas_sofridas': {'titulo': 'Faltas Sofridas', 'descricao': 'Jogadores mais marcados'},
  'faltas_cometidas': {'titulo': 'Faltas Cometidas', 'descricao': 'Jogadores mais violentos'},
  'defesas': {'titulo': 'Defesas', 'descricao': 'Goleiros e zagueiros'},
  'penalti_defendidos': {'titulo': 'Pênaltis Defendidos', 'descricao': 'Top paredões'},
  'jogos_sem_sofrer_gol': {'titulo': 'Paredões', 'descricao': 'Jogos sem sofrer gol'},
};
