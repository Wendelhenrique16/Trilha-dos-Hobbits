import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/dificuldade.dart';
import '../../state/providers.dart';
import '../mapa/mapa_screen.dart';
import '../registro_manual/registro_manual_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressoAsync = ref.watch(progressoProvider);
    final filmes = ref.watch(filmesProvider);
    final verificar = ref.watch(verificarDesbloqueioProvider);
    final progressoGeral = ref.watch(progressoGeralProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Trilha dos Hobbits')),
      body: progressoAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erro ao carregar progresso: $e')),
        data: (progresso) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // RF-08: distância total real, nunca escalada.
              Text(
                'Distância total percorrida',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              Text(
                '${progresso.totalHistoricoKm.toStringAsFixed(1)} km',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),

              // RF-09: progresso geral da jornada (na dificuldade ativa).
              Text(
                'Progresso da jornada — ${(progressoGeral * 100).toStringAsFixed(0)}%',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progressoGeral,
                  minHeight: 10,
                ),
              ),
              const SizedBox(height: 24),

              // RF-07: seletor de dificuldade.
              Text('Dificuldade', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              SegmentedButton<Dificuldade>(
                segments: const [
                  ButtonSegment(value: Dificuldade.facil, label: Text('Fácil')),
                  ButtonSegment(value: Dificuldade.medio, label: Text('Médio')),
                  ButtonSegment(
                      value: Dificuldade.completo, label: Text('Completo')),
                ],
                selected: {progresso.dificuldade},
                onSelectionChanged: (novo) {
                  ref
                      .read(jornadaRepositoryProvider)
                      .definirDificuldade(novo.first);
                },
              ),
              const SizedBox(height: 24),

              // Progresso por filme (RF-09), com bloqueio sequencial (RN-06).
              Text('Filmes', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              ...filmes.map((filme) {
                final desbloqueado =
                    verificar.filmeDesbloqueado(filme, progresso);
                final percentual = verificar.percentualFilme(filme, progresso);
                return Card(
                  child: ListTile(
                    enabled: desbloqueado,
                    leading: Icon(
                      desbloqueado ? Icons.lock_open : Icons.lock,
                      color: desbloqueado ? null : Colors.grey,
                    ),
                    title: Text(filme.titulo),
                    subtitle: desbloqueado
                        ? LinearProgressIndicator(value: percentual)
                        : const Text('Bloqueado'),
                    trailing: desbloqueado
                        ? Text('${(percentual * 100).toStringAsFixed(0)}%')
                        : null,
                    onTap: desbloqueado
                        ? () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => MapaScreen(filme: filme),
                              ),
                            )
                        : null,
                  ),
                );
              }),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const RegistroManualScreen()),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Registrar'),
      ),
    );
  }
}