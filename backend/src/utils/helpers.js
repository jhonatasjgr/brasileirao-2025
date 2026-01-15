/**
 * utilitários para carregamento e validação de dados
 */

const fs = require('fs');
const path = require('path');
const csv = require('csv-parser');

/**
 * carrega dados do arquivo CSV para memória
 */
function loadCSVData(csvPath) {
  return new Promise((resolve, reject) => {
    const data = [];
    
    if (!fs.existsSync(csvPath)) {
      reject(new Error(`Arquivo CSV não encontrado: ${csvPath}`));
      return;
    }

    fs.createReadStream(csvPath)
      .pipe(csv())
      .on('data', (row) => {
        data.push(row);
      })
      .on('end', () => {
        console.log(`✓ Carregados ${data.length} registros do CSV`);
        resolve(data);
      })
      .on('error', (error) => {
        reject(error);
      });
  });
}

/**
 * valida se um ID é válido (numérico)
 */
function isValidId(id) {
  return !isNaN(parseInt(id)) && parseInt(id) > 0;
}

/**
 * valida se uma posição é válida
 */
function isValidPosition(posicao) {
  const validPositions = ['GOL', 'ZAG', 'LAT', 'MEI', 'ATA', 'TEC'];
  return validPositions.includes(posicao.toUpperCase());
}

/**
 * valida se um tipo de ranking é válido
 */
function isValidRankingType(tipo) {
  const validTypes = [
    'pontos',
    'gols',
    'assistencias',
    'desarmes',
    'finalizacoes_perigosas',
    'faltas_sofridas',
    'faltas_cometidas',
    'defesas_dificeis',
    'penaltis_defendidos',
    'jogos_sem_sofrer_gol'
  ];
  return validTypes.includes(tipo.toLowerCase());
}

/**
 * resposta padrão de erro
 */
function errorResponse(message, statusCode = 400) {
  return {
    error: true,
    message,
    statusCode
  };
}

/**
 * resposta padrão de sucesso
 */
function successResponse(data) {
  return {
    error: false,
    data
  };
}

module.exports = {
  loadCSVData,
  isValidId,
  isValidPosition,
  isValidRankingType,
  errorResponse,
  successResponse
};
