import 'package:flutter/material.dart';

import '../../domain/entities/checkpoint.dart';

/// Ícone de um checkpoint sobre o mapa. Não sabe calcular seu próprio
/// estado — recebe [desbloqueado] pronto de quem o instancia (a tela do
/// mapa, que já consultou `VerificarDesbloqueio`).
class CheckpointMarker extends StatelessWidget {
  const CheckpointMarker({
    super.key,
    required this.checkpoint,
    required this.desbloqueado,
    required this.onTap,
  });

  final Checkpoint checkpoint;
  final bool desbloqueado;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: desbloqueado
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey.shade700,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Icon(
              desbloqueado ? Icons.flag : Icons.lock,
              color: Colors.white,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}