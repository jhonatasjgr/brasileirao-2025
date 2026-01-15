const express = require('express');
const cors = require('cors');
const path = require('path');
const swaggerUi = require('swagger-ui-express');
const swaggerSpec = require('./config/swagger');
const { loadCSVData } = require('./utils/helpers');

// importar rotas
const jogadoresRouter = require('./routes/jogadores');
const comparacaoRouter = require('./routes/comparacao');
const rankingsRouter = require('./routes/rankings');
const estatisticasRouter = require('./routes/estatisticas');

const app = express();
const PORT = process.env.PORT || 3000;
const CSV_PATH = path.join(__dirname, '..', '..', 'Base de dados', 'cartola_api_completo.csv');

// middleware
app.use(cors());
app.use(express.json());

// documentação swagger
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec, {
  swaggerOptions: {
    persistAuthorization: true,
    displayOperationId: true
  },
  customCss: '.swagger-ui .topbar { display: none }',
  customSiteTitle: 'CBF Stats API Documentação'
}));

// middleware de logging
// faz logging de todas as requisições
app.use((req, res, next) => {
  console.log(`[${new Date().toISOString()}] ${req.method} ${req.path}`);
  next();
});

/**
 * inicializar servidor
 */
async function initializeServer() {
  try {
    console.log('iniciando servidor CBF Stats API...');
    console.log(`carregando dados de: ${CSV_PATH}`);

    // carregar dados do CSV
    const allData = await loadCSVData(CSV_PATH);
    app.locals.allData = allData;

    // registrar rotas
    app.use('/jogadores', jogadoresRouter);
    app.use('/comparacao', comparacaoRouter);
    app.use('/rankings', rankingsRouter);
    app.use('/estatisticas', estatisticasRouter);

    // rota de health check
    // status do servidor
    app.get('/health', (req, res) => {
      res.json({ 
        status: 'ok',
        timestamp: new Date().toISOString(),
        data_loaded: true,
        total_records: allData.length
      });
    });

  

    // rota raiz com documentação básica
    // swagger
    app.get('/', (req, res) => {
      res.json({
        nome: 'CBF Stats API',
        versao: '1.0.0',
        descricao: 'API REST para análise de desempenho de jogadores do Brasileirão 2025',
        endpoints: {
          jogadores: {
            lista: 'GET /jogadores?busca=&clube=&posicao=',
            detalhes: 'GET /jogadores/:id',
            rodadas: 'GET /jogadores/:id/rodadas?limite='
          },
          comparacao: 'GET /comparacao?ids=123,456',
          rankings: 'GET /rankings/:tipo?rodada=&posicao=&clube=&limit=',
          estatisticas: 'GET /estatisticas/clube/:sigla',
          saude: 'GET /health'
        }
      });
    });

    // erro 404, não encontrado
    app.use((req, res) => {
      res.status(404).json({ 
        error: 'Endpoint não encontrado',
        caminho: req.path
      });
    });

    // handler de erros global
    app.use((err, req, res, next) => {
      console.error('Erro não tratado:', err);
      res.status(500).json({ 
        error: 'Erro interno do servidor',
        message: err.message
      });
    });

    // iniciar servidor
    app.listen(PORT, () => {
      console.log(`\nservidor rodando na porta ${PORT}`);
      console.log(`documentação: http://localhost:${PORT}/`);
      console.log(`health check: http://localhost:${PORT}/health`);
      console.log(`swagger UI: http://localhost:${PORT}/api-docs`);
      console.log(`\nexemplos de requisições:`);
      console.log(`   http://localhost:${PORT}/jogadores`);
      console.log(`   http://localhost:${PORT}/jogadores/12345`);
      console.log(`   http://localhost:${PORT}/rankings/gols?limit=10`);
      console.log(`   http://localhost:${PORT}/estatisticas/clube/SAO\n`);
    });

  } catch (error) {
    console.error('erro ao inicializar servidor:', error.message);
    process.exit(1);
  }
}

// iniciar servidor
initializeServer();

module.exports = app;
