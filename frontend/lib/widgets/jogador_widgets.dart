import 'package:flutter/material.dart';
import 'package:cbf_stats/models/index.dart';

// widget para exibir foto do jogador com fallback
class FotoJogador extends StatelessWidget {
  final String? fotoUrl;
  final double size;
  final BorderRadius? borderRadius;

  const FotoJogador({
    Key? key,
    this.fotoUrl,
    this.size = 60,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        color: Colors.grey[300],
      ),
      child: fotoUrl != null && fotoUrl!.isNotEmpty
          ? ClipRRect(
              borderRadius: borderRadius ?? BorderRadius.circular(8),
              child: Image.network(
                fotoUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.person,
                    size: 30,
                    color: Colors.grey,
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  );
                },
              ),
            )
          : const Icon(
              Icons.person,
              size: 30,
              color: Colors.grey,
            ),
    );
  }
}

class CardJogador extends StatelessWidget {
  final Jogador jogador;
  final VoidCallback onTap;
  final bool destacado;

  const CardJogador({
    Key? key,
    required this.jogador,
    required this.onTap,
    this.destacado = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: destacado ? 8 : 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              FotoJogador(fotoUrl: jogador.foto, size: 60),
              const SizedBox(width: 12),
              // informações do jogador
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      jogador.apelido,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${jogador.posicao} • ${jogador.clube}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          'R\$ ${jogador.preco.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 11),
                        ),
                        const SizedBox(width: 12),
                        if (jogador.mediapontos != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${jogador.mediapontos!.toStringAsFixed(1)} pts',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.blue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              // Ícone de seta
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardDestaque extends StatelessWidget {
  final int posicao;
  final Jogador jogador;
  final VoidCallback onTap;

  const CardDestaque({
    Key? key,
    required this.posicao,
    required this.jogador,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // medalha
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _getMedalhaColor(posicao),
              ),
              child: Center(
                child: Text(
                  '$posicao°',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            FotoJogador(
              fotoUrl: jogador.foto,
              size: 50,
              borderRadius: BorderRadius.circular(6),
            ),
            const SizedBox(height: 8),
            // nome
            Text(
              jogador.apelido,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            // posição e clube
            Text(
              '${jogador.posicao} • ${jogador.clube}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            // pontos
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${jogador.statsTemporada?.media.toStringAsFixed(1) ?? '0'} pts',
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getMedalhaColor(int posicao) {
    switch (posicao) {
      case 1:
        return const Color(0xFFFFD700); // Ouro
      case 2:
        return const Color(0xFFC0C0C0); // Prata
      case 3:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return Colors.grey;
    }
  }
}

class StatisticaRow extends StatelessWidget {
  final String label;
  final String valor;
  final String? icone;
  final Color? cor;

  const StatisticaRow({
    Key? key,
    required this.label,
    required this.valor,
    this.icone,
    this.cor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (icone != null) ...[
                Text(icone!, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          Text(
            valor,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: cor ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomErrorWidget extends StatelessWidget {
  final String mensagem;
  final VoidCallback? onRetry;

  const CustomErrorWidget({
    Key? key,
    required this.mensagem,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 48,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            'Erro ao carregar dados',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              mensagem,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar Novamente'),
            ),
          ],
        ],
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  final String? mensagem;

  const LoadingWidget({
    Key? key,
    this.mensagem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          if (mensagem != null) ...[
            const SizedBox(height: 16),
            Text(mensagem!),
          ],
        ],
      ),
    );
  }
}
