const express = require('express');
const router = express.Router();
const { generateRanking } = require('../helpers/aggregations');
const { isValidRankingType } = require('../utils/helpers');

/**
 * GET /rankings/:tipo
 * gera ranking baseado em tipo específico
 * tipos: pontos, gols, assistencias, desarmes, finalizacoes_perigosas, 
 *        faltas_sofridas, faltas_cometidas, defesas_dificeis, 
 *        penaltis_defendidos, jogos_sem_sofrer_gol
 * query params: rodada, posicao, clube, limit
 */
router.get('/:tipo', (req, res) => {
  try {
    const { tipo } = req.params;
    const { rodada, posicao, clube, limit = 10 } = req.query;
    const allData = req.app.locals.allData;

    if (!isValidRankingType(tipo)) {
      return res.status(400).json({ 
        error: 'Tipo de ranking inválido',
        tipos_validos: [
          'pontos', 'gols', 'assistencias', 'desarmes', 
          'finalizacoes_perigosas', 'faltas_sofridas', 'faltas_cometidas',
          'defesas_dificeis', 'penaltis_defendidos', 'jogos_sem_sofrer_gol'
        ]
      });
    }

    const limitNum = Math.min(parseInt(limit) || 10, 100);

    const ranking = generateRanking(
      allData,
      tipo.toLowerCase(),
      rodada ? parseInt(rodada) : null,
      posicao,
      clube,
      limitNum
    );

    res.json({
      tipo: tipo.toLowerCase(),
      rodada: rodada ? parseInt(rodada) : 'Temporada',
      posicao: posicao || 'Todas',
      clube: clube || 'Todos',
      total: ranking.length,
      ranking
    });
  } catch (error) {
    console.error(`Erro em GET /rankings/:tipo:`, error);
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
