import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/filme.dart';
import '../../state/providers.dart';
import '../../widgets/checkpoint_marker.dart';
import '../../widgets/checkpoint_modal.dart';

/// RF-03: mapa interativo (pinch-to-zoom via InteractiveViewer) com os
/// checkpoints do [filme] posicionados sobre uma imagem de fundo.
///
/// Posicionamento: cada checkpoint usa `kmRelativoPercentual` (0.0–1.0)
/// como fração horizontal da largura da imagem — funciona bem pra uma
/// "trilha" linear estilo mapa de jogo. Se o mapa real tiver um traçado
/// não-linear, essa conta precisa trocar por coordenadas (x, y) fixas por
/// checkpoint em vez de derivadas do percentual.
class MapaScreen extends ConsumerWidget {
  const MapaScreen({super.key, required this.filme});

  final Filme filme;

  static const _larguraMapa = 1600.0;
  static const _alturaMapa = 900.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressoAsync = ref.watch(progressoProvider);
    final verificar = ref.watch(verificarDesbloqueioProvider);

    return Scaffold(
      appBar: AppBar(title: Text(filme.titulo)),
      body: progressoAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erro: $e')),
        data: (progresso) {
          return InteractiveViewer(
            minScale: 0.5,
            maxScale: 4.0,
            constrained: false,
            child: SizedBox(
              width: _larguraMapa,
              height: _alturaMapa,
              child: Stack(
                children: [
                  // TODO: trocar por asset real do mapa da trilha
                  // (assets/maps/<filmeId>.jpg).
                  Container(color: Colors.black26),
                  for (final checkpoint in filme.checkpoints)
                    Positioned(
                      left: checkpoint.kmRelativoPercentual * _larguraMapa - 18,
                      top: _alturaMapa / 2 - 18,
                      child: Builder(builder: (context) {
                        final desbloqueado = verificar.checkpointDesbloqueado(
                          filme,
                          checkpoint,
                          progresso,
                        );
                        return CheckpointMarker(
                          checkpoint: checkpoint,
                          desbloqueado: desbloqueado,
                          onTap: () => CheckpointModal.mostrar(
                            context,
                            checkpoint: checkpoint,
                            desbloqueado: desbloqueado,
                          ),
                        );
                      }),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}