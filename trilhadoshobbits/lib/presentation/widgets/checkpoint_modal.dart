import 'package:flutter/material.dart';

import '../../domain/entities/checkpoint.dart';

/// Matriz que converte a imagem pra preto e branco (RF-04).
const _matrizCinza = <double>[
  0.2126, 0.7152, 0.0722, 0, 0, //
  0.2126, 0.7152, 0.0722, 0, 0,
  0.2126, 0.7152, 0.0722, 0, 0,
  0, 0, 0, 1, 0,
];

/// UC-02 / RF-04 / RF-05: modal de um checkpoint.
///
/// Bloqueado: mostra só a imagem em P&B e um aviso — nada de minutagem,
/// citação ou descrição (RF-04). Desbloqueado: imagem colorida + descrição
/// completa + minutagem exata (RF-05).
class CheckpointModal extends StatelessWidget {
  const CheckpointModal({
    super.key,
    required this.checkpoint,
    required this.desbloqueado,
  });

  final Checkpoint checkpoint;
  final bool desbloqueado;

  static Future<void> mostrar(
    BuildContext context, {
    required Checkpoint checkpoint,
    required bool desbloqueado,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => CheckpointModal(
        checkpoint: checkpoint,
        desbloqueado: desbloqueado,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imagem = Image.asset(checkpoint.imagemUrl, fit: BoxFit.cover);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: desbloqueado
                    ? imagem
                    : ColorFiltered(
                        colorFilter:
                            const ColorFilter.matrix(_matrizCinza),
                        child: imagem,
                      ),
              ),
            ),
            const SizedBox(height: 16),
            if (desbloqueado) ...[
              Text(
                checkpoint.titulo,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              Text(
                '${checkpoint.local} — min. ${checkpoint.minutoFilme}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              Text(checkpoint.descricao),
            ] else ...[
              Text(
                'Marco ainda não alcançado',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              const Text(
                'Caminhe mais para desbloquear os detalhes e a '
                'minutagem do filme.',
              ),
            ],
          ],
        ),
      ),
    );
  }
}