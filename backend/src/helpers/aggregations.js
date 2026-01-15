/**
 * funções auxiliares para filtragem e agregação de dados
 */

/**
 * mapeia posicao_id para sigla
 */
function getPosicaoSigla(posicaoId) {
  const mapa = {
    1: 'GOL',
    2: 'LAT',
    3: 'ZAG',
    4: 'MEI',
    5: 'ATA',
    6: 'TEC'
  };
  return mapa[parseInt(posicaoId)] || 'N/A';
}

/**
 * filtra dados de um jogador específico
 */
function filterByPlayerId(allData, id) {
  return allData.filter(row => row.id_jogador == id);
}

/**
 * obtém informações da última rodada disponível do jogador
 * necessário para foto, nome completo, clube atual
 */
function getLastRoundInfo(playerRows) {
  if (playerRows.length === 0) return null;
  
  return playerRows.reduce((latest, current) => {
    return current.rodada > latest.rodada ? current : latest;
  });
}

/**
 * calcula estatísticas acumuladas do jogador
 */
function aggregatePlayerStats(playerRows) {
  if (playerRows.length === 0) {
    return {
      jogos: 0,
      gols: 0,
      assistencias: 0,
      desarmes: 0,
      defesas_dificeis: 0,
      defesas_penalti: 0,
      jogos_sem_sofrer_gol: 0,
      faltas_sofridas: 0,
      faltas_cometidas: 0,
      finalizacoes_trave: 0,
      finalizacoes_defendida: 0,
      finalizacoes_fora: 0,
      gols_contra: 0,
      cartoes_amarelos: 0,
      cartoes_vermelhos: 0,
      penaltis_perdidos: 0,
      penaltis_sofridos: 0,
      impedimentos: 0,
      gols_sofridos: 0,
      passes_incompletos: 0,
      pontos_totais: 0,
      media_pontos: 0
    };
  }

  const stats = {
    jogos: playerRows.length,
    gols: 0,
    assistencias: 0,
    desarmes: 0,
    defesas_dificeis: 0,
    defesas_penalti: 0,
    penaltis_defendidos: 0, // alias para defesas_penalti (compatibilidade frontend)
    jogos_sem_sofrer_gol: 0,
    faltas_sofridas: 0,
    faltas_cometidas: 0,
    finalizacoes_trave: 0,
    finalizacoes_defendida: 0,
    finalizacoes_fora: 0,
    gols_contra: 0,
    cartoes_amarelos: 0,
    cartao_amarelo: 0, // alias (compatibilidade frontend)
    cartoes_vermelhos: 0,
    cartao_vermelho: 0, // alias (compatibilidade frontend)
    penaltis_perdidos: 0,
    penaltis_sofridos: 0,
    impedimentos: 0,
    gols_sofridos: 0,
    passes_incompletos: 0,
    pontos_totais: 0,
    media_pontos: 0
  };

  playerRows.forEach(row => {
    stats.gols += parseFloat(row.G) || 0;
    stats.assistencias += parseFloat(row.A) || 0;
    stats.desarmes += parseFloat(row.DS) || 0;
    stats.defesas_dificeis += parseFloat(row.DE) || 0;
    const defPenalti = parseFloat(row.DP) || 0;
    stats.defesas_penalti += defPenalti;
    stats.penaltis_defendidos += defPenalti; // alias
    stats.jogos_sem_sofrer_gol += parseFloat(row.SG) || 0;
    stats.faltas_sofridas += parseFloat(row.FS) || 0;
    stats.faltas_cometidas += parseFloat(row.FC) || 0;
    stats.finalizacoes_trave += parseFloat(row.FT) || 0;
    stats.finalizacoes_defendida += parseFloat(row.FD) || 0;
    stats.finalizacoes_fora += parseFloat(row.FF) || 0;
    stats.gols_contra += parseFloat(row.GC) || 0;
    const cartaoAmar = parseFloat(row.CA) || 0;
    stats.cartoes_amarelos += cartaoAmar;
    stats.cartao_amarelo += cartaoAmar; // alias
    const cartaoVerm = parseFloat(row.CV) || 0;
    stats.cartoes_vermelhos += cartaoVerm;
    stats.cartao_vermelho += cartaoVerm; // alias
    stats.penaltis_perdidos += parseFloat(row.PP) || 0;
    stats.penaltis_sofridos += parseFloat(row.PS) || 0;
    stats.impedimentos += parseFloat(row.I) || 0;
    stats.gols_sofridos += parseFloat(row.GS) || 0;
    stats.passes_incompletos += parseFloat(row.PE) || 0;
    stats.pontos_totais += parseFloat(row.pontuacao) || 0;
  });

  stats.media_pontos = stats.jogos > 0 ? parseFloat((stats.pontos_totais / stats.jogos).toFixed(2)) : 0;
  
  // arredondar para 2 casas decimais
  Object.keys(stats).forEach(key => {
    if (typeof stats[key] === 'number' && key !== 'jogos') {
      stats[key] = parseFloat(stats[key].toFixed(2));
    }
  });

  return stats;
}

/**
 * obtém informações resumidas de um jogador para listagem
 */
function getPlayerSummary(allData, id) {
  const playerRows = filterByPlayerId(allData, id);
  if (playerRows.length === 0) return null;

  const lastRound = getLastRoundInfo(playerRows);
  const stats = aggregatePlayerStats(playerRows);

  return {
    id: parseInt(id),
    apelido: lastRound.apelido || '',
    nome: lastRound['atletas.nome'] || '',
    foto_url: lastRound.foto || '',
    foto: lastRound.foto || '', // compatibilidade frontend
    clube_sigla: lastRound.clube_sigla || '',
    clube: lastRound.clube_sigla || '', // compatibilidade frontend
    posicao_sigla: getPosicaoSigla(lastRound.posicao_id) || '',
    posicao: getPosicaoSigla(lastRound.posicao_id) || '', // compatibilidade frontend
    posicao_nome: lastRound.posicao_nome || '',
    preco: parseFloat(lastRound.preco) || 0,
    media_pontos: stats.media_pontos,
    gols: stats.gols,
    assistencias: stats.assistencias
  };
}

/**
 * obtém todas as estatísticas detalhadas de um jogador
 */
function getPlayerDetails(allData, id) {
  const playerRows = filterByPlayerId(allData, id);
  if (playerRows.length === 0) return null;

  const lastRound = getLastRoundInfo(playerRows);
  const stats = aggregatePlayerStats(playerRows);

  return {
    id: parseInt(id),
    nome: lastRound['atletas.nome'] || '',
    apelido: lastRound.apelido || '',
    foto_url: lastRound.foto || '',
    foto: lastRound.foto || '', // compatibilidade frontend
    clube_sigla: lastRound.clube_sigla || '',
    clube: lastRound.clube_sigla || '', // compatibilidade frontend
    clube_nome: lastRound.clube_nome || '',
    posicao_sigla: getPosicaoSigla(lastRound.posicao_id) || '',
    posicao: getPosicaoSigla(lastRound.posicao_id) || '', // compatibilidade frontend
    posicao_nome: lastRound.posicao_nome || '',
    preco: parseFloat(lastRound.preco) || 0,
    stats_temporada: stats
  };
}

/**
 * obtém histórico de rodadas de um jogador
 */
function getPlayerRounds(allData, id, limit = null) {
  const playerRows = filterByPlayerId(allData, id);
  if (playerRows.length === 0) return [];

  let rounds = playerRows
    .sort((a, b) => parseInt(a.rodada) - parseInt(b.rodada))
    .map(row => ({
      rodada: parseInt(row.rodada),
      adversario: row.adversario || 'N/A',
      pontos: parseFloat(row.pontuacao) || 0,
      scouts: {
        gols: parseFloat(row.G) || 0,
        assistencias: parseFloat(row.A) || 0,
        desarmes: parseFloat(row.DS) || 0,
        defesas_dificeis: parseFloat(row.DE) || 0,
        faltas_sofridas: parseFloat(row.FS) || 0,
        finalizacoes_defendida: parseFloat(row.FD) || 0,
        finalizacoes_trave: parseFloat(row.FT) || 0
      }
    }));

  if (limit) {
    rounds = rounds.slice(-limit);
  }

  return rounds;
}

/**
 * agrupa dados por id_jogador
 */
function groupByPlayerId(allData) {
  return allData.reduce((grouped, row) => {
    const id = row.id_jogador;
    if (!grouped[id]) {
      grouped[id] = [];
    }
    grouped[id].push(row);
    return grouped;
  }, {});
}

/**
 * gera ranking baseado em um tipo específico
 */
function generateRanking(allData, rankingType, rodada = null, posicao = null, clube = null, limit = 10) {
  let filteredData = allData;

  // filtrar por rodada se especificada
  if (rodada) {
    filteredData = filteredData.filter(row => parseInt(row.rodada) === parseInt(rodada));
  }

  // filtrar por posição se especificada
  if (posicao) {
    filteredData = filteredData.filter(row => getPosicaoSigla(row.posicao_id) === posicao.toUpperCase());
  }

  // filtrar por clube se especificado
  if (clube) {
    filteredData = filteredData.filter(row => row.clube_sigla === clube.toUpperCase());
  }

  // agrupar por jogador
  const grouped = groupByPlayerId(filteredData);

  // mapear para objeto de ranking
  const ranking = Object.entries(grouped).map(([id, playerRows]) => {
    const lastRound = getLastRoundInfo(playerRows);
    const stats = aggregatePlayerStats(playerRows);
    
    // calcular valor baseado no tipo de ranking
    let rankingValue = 0;
    switch (rankingType) {
      case 'pontos':
        rankingValue = stats.media_pontos;
        break;
      case 'gols':
        rankingValue = stats.gols;
        break;
      case 'assistencias':
        rankingValue = stats.assistencias;
        break;
      case 'desarmes':
        rankingValue = stats.desarmes;
        break;
      case 'finalizacoes_perigosas':
        rankingValue = stats.finalizacoes_defendida + stats.finalizacoes_trave;
        break;
      case 'faltas_sofridas':
        rankingValue = stats.faltas_sofridas;
        break;
      case 'faltas_cometidas':
        rankingValue = stats.faltas_cometidas;
        break;
      case 'defesas_dificeis':
        rankingValue = stats.defesas_dificeis;
        break;
      case 'penaltis_defendidos':
        rankingValue = stats.defesas_penalti;
        break;
      case 'jogos_sem_sofrer_gol':
        rankingValue = stats.jogos_sem_sofrer_gol;
        break;
      default:
        rankingValue = stats.media_pontos;
    }

    return {
      id: parseInt(id),
      apelido: lastRound.apelido || '',
      foto_url: lastRound.foto || '',
      foto: lastRound.foto || '', // compatibilidade frontend
      clube_sigla: lastRound.clube_sigla || '',
      clube: lastRound.clube_sigla || '', // compatibilidade frontend
      posicao_sigla: getPosicaoSigla(lastRound.posicao_id) || '',
      posicao: getPosicaoSigla(lastRound.posicao_id) || '', // compatibilidade frontend
      posicao_nome: lastRound.posicao_nome || '',
      preco: parseFloat(lastRound.preco) || 0,
      ranking_value: parseFloat(rankingValue.toFixed(2))
    };
  });

  // ordenar por ranking_value decrescente
  ranking.sort((a, b) => b.ranking_value - a.ranking_value);

  // limitar resultados
  return ranking.slice(0, limit);
}

module.exports = {
  getPosicaoSigla,
  filterByPlayerId,
  getLastRoundInfo,
  aggregatePlayerStats,
  getPlayerSummary,
  getPlayerDetails,
  getPlayerRounds,
  groupByPlayerId,
  generateRanking
};
