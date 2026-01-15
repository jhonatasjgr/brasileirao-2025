const express = require('express');
const router = express.Router();
const { filterByPlayerId, getPlayerSummary, getPlayerDetails, getPlayerRounds, groupByPlayerId } = require('../helpers/aggregations');
const { isValidId } = require('../utils/helpers');

/**
 * GET /jogadores
 * lista paginada de jogadores com filtros
 * query params: busca, clube, posicao
 */
router.get('/', (req, res) => {
  try {
    const { busca = '', clube = '', posicao = '' } = req.query;
    const allData = req.app.locals.allData;

    // agrupar por jogador
    const grouped = groupByPlayerId(allData);

    // map para resumo
    let jogadores = Object.keys(grouped)
      .map(id => getPlayerSummary(allData, id))
      .filter(j => j !== null);

    // filtros
    if (busca) {
      const searchLower = busca.toLowerCase();
      jogadores = jogadores.filter(j => 
        j.apelido.toLowerCase().includes(searchLower) || 
        j.nome.toLowerCase().includes(searchLower)
      );
    }

    if (clube) {
      jogadores = jogadores.filter(j => j.clube_sigla === clube.toUpperCase());
    }

    if (posicao) {
      jogadores = jogadores.filter(j => j.posicao_sigla === posicao.toUpperCase());
    }

    res.json({
      total: jogadores.length,
      jogadores: jogadores.sort((a, b) => b.media_pontos - a.media_pontos)
    });
  } catch (error) {
    console.error('Erro em GET /jogadores:', error);
    res.status(500).json({ error: error.message });
  }
});

/**
 * GET /jogadores/:id
 * detalhes completos de um jogador
 */
router.get('/:id', (req, res) => {
  try {
    const { id } = req.params;
    const allData = req.app.locals.allData;

    if (!isValidId(id)) {
      return res.status(400).json({ error: 'ID inválido' });
    }

    const playerData = getPlayerDetails(allData, id);

    if (!playerData) {
      return res.status(404).json({ error: 'Jogador não encontrado' });
    }

    res.json(playerData);
  } catch (error) {
    console.error(`Erro em GET /jogadores/${req.params.id}:`, error);
    res.status(500).json({ error: error.message });
  }
});

/**
 * GET /jogadores/:id/rodadas
 * histórico de desempenho por rodada
 * query params: limite
 */
router.get('/:id/rodadas', (req, res) => {
  try {
    const { id } = req.params;
    const { limite } = req.query;
    const allData = req.app.locals.allData;

    if (!isValidId(id)) {
      return res.status(400).json({ error: 'ID inválido' });
    }

    const playerRows = filterByPlayerId(allData, id);

    if (playerRows.length === 0) {
      return res.status(404).json({ error: 'Jogador não encontrado' });
    }

    const rodadas = getPlayerRounds(allData, id, limite ? parseInt(limite) : null);

    res.json({
      id: parseInt(id),
      total_rodadas: rodadas.length,
      rodadas
    });
  } catch (error) {
    console.error(`Erro em GET /jogadores/:id/rodadas:`, error);
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
