const express = require('express');
const router = express.Router();
const { groupByPlayerId, aggregatePlayerStats, getPlayerSummary } = require('../helpers/aggregations');

/**
 * GET /estatisticas/clube/:sigla
 * estatísticas agregadas do clube
 */
router.get('/clube/:sigla', (req, res) => {
  try {
    const { sigla } = req.params;
    const allData = req.app.locals.allData;

    if (!sigla || sigla.length !== 3) {
      return res.status(400).json({ error: 'Sigla do clube inválida (use 3 letras)' });
    }

    const siglaTrim = sigla.toUpperCase();

    // filtrar dados do clube
    const clubeData = allData.filter(row => row.clube_sigla === siglaTrim);

    if (clubeData.length === 0) {
      return res.status(404).json({ error: 'Clube não encontrado' });
    }

    // agrupar por jogador
    const grouped = groupByPlayerId(clubeData);

    // calcular estatísticas do clube
    let totalGols = 0;
    let totalAssistencias = 0;
    let totalDefarmes = 0;
    let totalPontos = 0;
    let totalJogos = 0;

    const jogadores = [];

    for (const [id, playerRows] of Object.entries(grouped)) {
      const playerSummary = getPlayerSummary(allData, id);
      if (playerSummary) {
        jogadores.push(playerSummary);
        
        const stats = aggregatePlayerStats(playerRows);
        totalGols += stats.gols;
        totalAssistencias += stats.assistencias;
        totalDefarmes += stats.desarmes;
        totalPontos += stats.pontos_totais;
        totalJogos += stats.jogos;
      }
    }

    // identificar destaques
    const orderedByGols = jogadores.sort((a, b) => b.gols - a.gols);
    const orderedByAssist = jogadores.sort((a, b) => b.assistencias - a.assistencias);
    const orderedByPoints = jogadores.sort((a, b) => b.media_pontos - a.media_pontos);

    const artilheiro = orderedByGols[0] || null;
    const garcom = orderedByAssist[0] || null;
    const destaque = orderedByPoints[0] || null;

    const mediaPontos = totalJogos > 0 ? parseFloat((totalPontos / totalJogos).toFixed(2)) : 0;

    res.json({
      clube_sigla: siglaTrim,
      total_jogadores: jogadores.length,
      estatisticas: {
        total_gols: parseFloat(totalGols.toFixed(2)),
        total_assistencias: parseFloat(totalAssistencias.toFixed(2)),
        total_desarmes: parseFloat(totalDefarmes.toFixed(2)),
        media_pontos_time: mediaPontos
      },
      destaques: {
        artilheiro: artilheiro ? {
          id: artilheiro.id,
          apelido: artilheiro.apelido,
          gols: artilheiro.gols,
          foto_url: artilheiro.foto_url
        } : null,
        garcom: garcom ? {
          id: garcom.id,
          apelido: garcom.apelido,
          assistencias: garcom.assistencias,
          foto_url: garcom.foto_url
        } : null,
        destaque_geral: destaque ? {
          id: destaque.id,
          apelido: destaque.apelido,
          media_pontos: destaque.media_pontos,
          foto_url: destaque.foto_url
        } : null
      }
    });
  } catch (error) {
    console.error(`Erro em GET /estatisticas/clube/:sigla:`, error);
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
