const express = require('express');
const router = express.Router();
const { getPlayerDetails } = require('../helpers/aggregations');
const { isValidId } = require('../utils/helpers');

/**
 * GET /comparacao
 * compara múltiplos jogadores
 * query params: ids (separados por vírgula, ex: 123,456)
 */
router.get('/', (req, res) => {
  try {
    const { ids } = req.query;
    const allData = req.app.locals.allData;

    if (!ids) {
      return res.status(400).json({ error: 'Parâmetro "ids" é obrigatório' });
    }

    const idList = ids.split(',').map(id => id.trim());

    // validar IDs
    for (const id of idList) {
      if (!isValidId(id)) {
        return res.status(400).json({ error: `ID inválido: ${id}` });
      }
    }

    // limitar a 10 jogadores por comparação
    if (idList.length > 10) {
      return res.status(400).json({ error: 'Máximo 10 jogadores por comparação' });
    }

    // buscar dados dos jogadores
    const jogadores = [];
    for (const id of idList) {
      const playerData = getPlayerDetails(allData, id);
      if (playerData) {
        jogadores.push(playerData);
      } else {
        jogadores.push({
          id: parseInt(id),
          error: 'Jogador não encontrado'
        });
      }
    }

    res.json({
      total: jogadores.length,
      jogadores
    });
  } catch (error) {
    console.error('Erro em GET /comparacao:', error);
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
