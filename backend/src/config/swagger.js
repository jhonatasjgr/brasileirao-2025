/**
 * configuração do Swagger/OpenAPI para documentação da API
 */

const swaggerJsdoc = require('swagger-jsdoc');

const options = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'CBF Stats API',
      version: '1.0.0',
      description: 'API REST para análise de desempenho de jogadores do Brasileirão 2025. Sistema completo com estatísticas, rankings e comparação de jogadores.',
      contact: {
        name: 'Desenvolvimento',
        email: 'dev@cbfstats.com'
      },
      license: {
        name: 'MIT'
      }
    },
    servers: [
      {
        url: 'http://localhost:3000',
        description: 'Servidor de Desenvolvimento',
        variables: {
          port: {
            default: '3000'
          }
        }
      },
      {
        url: 'https://api.cbfstats.com',
        description: 'Servidor de Produção'
      }
    ],
    components: {
      schemas: {
        Jogador: {
          type: 'object',
          properties: {
            id: {
              type: 'integer',
              example: 12345
            },
            apelido: {
              type: 'string',
              example: 'Hulk'
            },
            nome: {
              type: 'string',
              example: 'Givanildo Vieira de Sousa'
            },
            foto_url: {
              type: 'string',
              format: 'uri',
              example: 'https://example.com/foto.jpg'
            },
            clube_sigla: {
              type: 'string',
              example: 'CAM',
              description: 'Sigla do clube (3 letras)'
            },
            clube_nome: {
              type: 'string',
              example: 'Atlético-MG'
            },
            posicao_sigla: {
              type: 'string',
              example: 'ATA',
              enum: ['GOL', 'ZAG', 'LAT', 'MEI', 'ATA', 'TEC']
            },
            posicao_nome: {
              type: 'string',
              example: 'Atacante'
            },
            preco: {
              type: 'number',
              format: 'float',
              example: 15.4
            },
            media_pontos: {
              type: 'number',
              format: 'float',
              example: 8.5
            }
          },
          required: ['id', 'apelido', 'clube_sigla', 'posicao_sigla']
        },
        JogadorDetalhado: {
          type: 'object',
          properties: {
            id: {
              type: 'integer',
              example: 12345
            },
            nome: {
              type: 'string',
              example: 'Givanildo Vieira de Sousa'
            },
            apelido: {
              type: 'string',
              example: 'Hulk'
            },
            foto_url: {
              type: 'string',
              format: 'uri'
            },
            clube_sigla: {
              type: 'string',
              example: 'CAM'
            },
            clube_nome: {
              type: 'string',
              example: 'Atlético-MG'
            },
            posicao_sigla: {
              type: 'string',
              example: 'ATA'
            },
            posicao_nome: {
              type: 'string',
              example: 'Atacante'
            },
            preco: {
              type: 'number',
              format: 'float'
            },
            stats_temporada: {
              type: 'object',
              properties: {
                jogos: {
                  type: 'integer',
                  example: 20
                },
                gols: {
                  type: 'number',
                  format: 'float',
                  example: 12
                },
                assistencias: {
                  type: 'number',
                  format: 'float',
                  example: 5
                },
                desarmes: {
                  type: 'number',
                  format: 'float',
                  example: 15
                },
                defesas_dificeis: {
                  type: 'number',
                  format: 'float',
                  example: 0
                },
                defesas_penalti: {
                  type: 'number',
                  format: 'float',
                  example: 0
                },
                media_pontos: {
                  type: 'number',
                  format: 'float',
                  example: 8.5
                }
              }
            }
          }
        },
        Rodada: {
          type: 'object',
          properties: {
            rodada: {
              type: 'integer',
              example: 1
            },
            adversario: {
              type: 'string',
              example: 'Flamengo'
            },
            pontos: {
              type: 'number',
              format: 'float',
              example: 8.5
            },
            scouts: {
              type: 'object',
              properties: {
                gols: { type: 'number' },
                assistencias: { type: 'number' },
                desarmes: { type: 'number' },
                defesas_dificeis: { type: 'number' },
                faltas_sofridas: { type: 'number' },
                finalizacoes_defendida: { type: 'number' },
                finalizacoes_trave: { type: 'number' }
              }
            }
          }
        },
        RankingItem: {
          type: 'object',
          properties: {
            id: {
              type: 'integer',
              example: 12345
            },
            apelido: {
              type: 'string',
              example: 'Hulk'
            },
            foto_url: {
              type: 'string',
              format: 'uri'
            },
            clube_sigla: {
              type: 'string',
              example: 'CAM'
            },
            posicao_sigla: {
              type: 'string',
              example: 'ATA'
            },
            posicao_nome: {
              type: 'string',
              example: 'Atacante'
            },
            preco: {
              type: 'number',
              format: 'float'
            },
            ranking_value: {
              type: 'number',
              format: 'float',
              example: 12,
              description: 'Valor da métrica escolhida (gols, pontos, etc)'
            }
          }
        },
        EstatisticasClube: {
          type: 'object',
          properties: {
            clube_sigla: {
              type: 'string',
              example: 'FLA'
            },
            total_jogadores: {
              type: 'integer',
              example: 25
            },
            estatisticas: {
              type: 'object',
              properties: {
                total_gols: {
                  type: 'number',
                  format: 'float'
                },
                total_assistencias: {
                  type: 'number',
                  format: 'float'
                },
                total_desarmes: {
                  type: 'number',
                  format: 'float'
                },
                media_pontos_time: {
                  type: 'number',
                  format: 'float'
                }
              }
            },
            destaques: {
              type: 'object',
              properties: {
                artilheiro: {
                  type: 'object',
                  properties: {
                    id: { type: 'integer' },
                    apelido: { type: 'string' },
                    gols: { type: 'number' },
                    foto_url: { type: 'string' }
                  }
                },
                garcom: {
                  type: 'object',
                  properties: {
                    id: { type: 'integer' },
                    apelido: { type: 'string' },
                    assistencias: { type: 'number' },
                    foto_url: { type: 'string' }
                  }
                },
                destaque_geral: {
                  type: 'object',
                  properties: {
                    id: { type: 'integer' },
                    apelido: { type: 'string' },
                    media_pontos: { type: 'number' },
                    foto_url: { type: 'string' }
                  }
                }
              }
            }
          }
        },
        Error: {
          type: 'object',
          properties: {
            error: {
              type: 'string',
              example: 'Mensagem de erro'
            }
          }
        }
      },
      parameters: {
        buscaQuery: {
          name: 'busca',
          in: 'query',
          description: 'Busca parcial por nome ou apelido do jogador',
          schema: {
            type: 'string',
            example: 'Hulk'
          }
        },
        clubeQuery: {
          name: 'clube',
          in: 'query',
          description: 'Filtro por sigla do clube (3 letras)',
          schema: {
            type: 'string',
            example: 'FLA'
          }
        },
        posicaoQuery: {
          name: 'posicao',
          in: 'query',
          description: 'Filtro por posição',
          schema: {
            type: 'string',
            enum: ['GOL', 'ZAG', 'LAT', 'MEI', 'ATA', 'TEC'],
            example: 'ATA'
          }
        },
        rodadaQuery: {
          name: 'rodada',
          in: 'query',
          description: 'Filtro por número da rodada (1-38). Se omitido, usa temporada inteira',
          schema: {
            type: 'integer',
            example: 20
          }
        },
        limitQuery: {
          name: 'limit',
          in: 'query',
          description: 'Limite de resultados (padrão: 10, máximo: 100)',
          schema: {
            type: 'integer',
            default: 10,
            minimum: 1,
            maximum: 100
          }
        },
        limiteRodasQuery: {
          name: 'limite',
          in: 'query',
          description: 'Número de últimas rodadas a retornar',
          schema: {
            type: 'integer',
            example: 5
          }
        },
        idPath: {
          name: 'id',
          in: 'path',
          required: true,
          description: 'ID único do jogador',
          schema: {
            type: 'integer'
          }
        },
        siglaClubeParam: {
          name: 'sigla',
          in: 'path',
          required: true,
          description: 'Sigla do clube (3 letras)',
          schema: {
            type: 'string',
            example: 'FLA'
          }
        },
        tipoRankingParam: {
          name: 'tipo',
          in: 'path',
          required: true,
          description: 'Tipo de ranking desejado',
          schema: {
            type: 'string',
            enum: [
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
            ],
            example: 'gols'
          }
        }
      }
    },
    tags: [
      {
        name: 'Jogadores',
        description: 'Endpoints relacionados a informações de jogadores'
      },
      {
        name: 'Rankings',
        description: 'Endpoints para geração de rankings dinâmicos'
      },
      {
        name: 'Comparação',
        description: 'Endpoint para comparar múltiplos jogadores'
      },
      {
        name: 'Estatísticas',
        description: 'Endpoints de estatísticas agregadas por clube'
      },
      {
        name: 'Saúde',
        description: 'Endpoints de monitoramento do servidor'
      }
    ]
  },
  apis: [
    './src/routes/jogadores.js',
    './src/routes/comparacao.js',
    './src/routes/rankings.js',
    './src/routes/estatisticas.js',
    './src/server.js'
  ]
};

const swaggerSpec = swaggerJsdoc(options);

module.exports = swaggerSpec;
