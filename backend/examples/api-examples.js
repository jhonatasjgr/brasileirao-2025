#!/usr/bin/env node

/**
 * exemplos de uso da API CBF Stats
 * execute cada exemplo para entender melhor os endpoints
 */

const BASE_URL = 'http://localhost:3000';

// cores para terminal
const colors = {
  reset: '\x1b[0m',
  bright: '\x1b[1m',
  green: '\x1b[32m',
  blue: '\x1b[34m',
  yellow: '\x1b[33m',
  cyan: '\x1b[36m'
};

async function exampleRequest(name, method, endpoint, params = {}) {
  console.log(`\n${colors.cyan}${'='.repeat(60)}${colors.reset}`);
  console.log(`${colors.bright}${name}${colors.reset}`);
  console.log(`${colors.cyan}${'='.repeat(60)}${colors.reset}`);
  
  const url = new URL(`${BASE_URL}${endpoint}`);
  
  // adicionar query params
  Object.entries(params).forEach(([key, value]) => {
    if (value !== null && value !== undefined) {
      url.searchParams.append(key, value);
    }
  });

  console.log(`\n${colors.blue}requisição:${colors.reset}`);
  console.log(`${colors.yellow}${method} ${endpoint}${colors.reset}`);
  if (Object.keys(params).length > 0) {
    console.log(`${colors.yellow}parâmetros:${colors.reset}`);
    Object.entries(params).forEach(([key, value]) => {
      console.log(`  - ${key}: ${value}`);
    });
  }

  try {
    const response = await fetch(url.toString());
    const data = await response.json();

    console.log(`\n${colors.green}resposta (${response.status}):${colors.reset}`);
    console.log(JSON.stringify(data, null, 2));

    return data;
  } catch (error) {
    console.error(`${colors.red}erro:${colors.reset} ${error.message}`);
  }
}

async function main() {
  console.log(`\n${colors.bright}${colors.blue}CBF Stats API - exemplos de uso${colors.reset}\n`);
  console.log(`Base URL: ${colors.yellow}${BASE_URL}${colors.reset}`);
  console.log(`para usar os exemplos:`);
  console.log(`1. certifique-se de que o servidor está rodando (npm run dev)`);
  console.log(`2. execute este arquivo: node examples/api-examples.js`);
  console.log(`3. abra http://localhost:3000/api-docs no navegador para documentação interativa\n`);

  // exemplo 1: listar todos os jogadores
  await exampleRequest(
    '1️⃣ listar todos os jogadores',
    'GET',
    '/jogadores'
  );

  // exemplo 2: listar jogadores do Flamengo
  await exampleRequest(
    '2️⃣ listar jogadores do Flamengo',
    'GET',
    '/jogadores',
    { clube: 'FLA' }
  );

  // exemplo 3: listar apenas atacantes
  await exampleRequest(
    '3️⃣ listar atacantes',
    'GET',
    '/jogadores',
    { posicao: 'ATA' }
  );

  // exemplo 4: buscar jogador por nome
  await exampleRequest(
    '4️⃣ buscar jogador por nome (parcial)',
    'GET',
    '/jogadores',
    { busca: 'Hulk' }
  );

  // exemplo 5: detalhes de um jogador específico
  // nota: 12345 é um ID de exemplo - use IDs reais dos seus dados
  await exampleRequest(
    '5️⃣ detalhes de um jogador (ID fictício)',
    'GET',
    '/jogadores/12345'
  );

  // exemplo 6: histórico de rodadas
  await exampleRequest(
    '6️⃣ histórico de rodadas de um jogador (últimas 5)',
    'GET',
    '/jogadores/12345/rodadas',
    { limite: 5 }
  );

  // exemplo 7: top 10 artilheiros
  await exampleRequest(
    '7️⃣ top 10 artilheiros (geral)',
    'GET',
    '/rankings/gols',
    { limit: 10 }
  );

  // exemplo 8: top assistentes
  await exampleRequest(
    '8️⃣ top 10 assistentes',
    'GET',
    '/rankings/assistencias',
    { limit: 10 }
  );

  // exemplo 9: ranking de pontos
  await exampleRequest(
    '9️⃣ top 10 maiores pontuações (média)',
    'GET',
    '/rankings/pontos',
    { limit: 10 }
  );

  // exemplo 10: top desarmes
  await exampleRequest(
    '🔟 top 10 defensores (desarmes)',
    'GET',
    '/rankings/desarmes',
    { limit: 10 }
  );

  // exemplo 11: top com filtros - artilheiros da rodada 20
  await exampleRequest(
    '1️⃣1️⃣ artilheiros da rodada 20 (filtro por rodada)',
    'GET',
    '/rankings/gols',
    { rodada: 20, limit: 10 }
  );

  // exemplo 12: artilheiros por posição
  await exampleRequest(
    '1️⃣2️⃣ artilheiros atacantes (filtro por posição)',
    'GET',
    '/rankings/gols',
    { posicao: 'ATA', limit: 10 }
  );

  // exemplo 13: ranking de um clube específico
  await exampleRequest(
    '1️⃣3️⃣ artilheiros do Flamengo',
    'GET',
    '/rankings/gols',
    { clube: 'FLA', limit: 10 }
  );

  // exemplo 14: comparar jogadores
  await exampleRequest(
    '1️⃣4️⃣ comparar dois jogadores (IDs fictícios)',
    'GET',
    '/comparacao',
    { ids: '12345,67890' }
  );

  // exemplo 15: estatísticas do Flamengo
  await exampleRequest(
    '1️⃣5️⃣ estatísticas consolidadas do Flamengo',
    'GET',
    '/estatisticas/clube/FLA'
  );

  // exemplo 16: health check
  await exampleRequest(
    '1️⃣6️⃣ health check do servidor',
    'GET',
    '/health'
  );

  // exemplo 17: informações da API
  await exampleRequest(
    '17 informações gerais da API',
    'GET',
    '/'
  );

  console.log(`\n${colors.cyan}${'='.repeat(60)}${colors.reset}`);
  console.log(`${colors.green}exemplos executados!${colors.reset}`);
  console.log(`${colors.cyan}${'='.repeat(60)}${colors.reset}\n`);
  console.log(`${colors.bright}próximos passos:${colors.reset}`);
  console.log(`1. abra ${colors.yellow}http://localhost:3000/api-docs${colors.reset} para documentação interativa`);
  console.log(`2. teste os endpoints com dados reais do seu CSV`);
  console.log(`3. substitua os IDs fictícios (12345, 67890) por IDs reais\n`);
}

main().catch(console.error);
