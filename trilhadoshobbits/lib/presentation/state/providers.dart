import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/health_datasource.dart';
import '../../data/datasources/local_datasource.dart';
import '../../data/repositories/jornada_repository.dart';
import '../../domain/constants/jornada_data.dart';
import '../../domain/entities/filme.dart';
import '../../domain/entities/progresso_usuario.dart';
import '../../domain/usecases/verificar_desbloqueio.dart';

/// Lista estática dos filmes/checkpoints (RN-04). Não muda em runtime.
final filmesProvider = Provider<List<Filme>>((ref) => jornadaCompleta);

/// Regras de desbloqueio (RN-06, RN-07) — sem estado próprio, só lógica.
final verificarDesbloqueioProvider = Provider<VerificarDesbloqueio>((ref) {
  return VerificarDesbloqueio(ref.watch(filmesProvider));
});

final _healthDatasourceProvider =
    Provider<HealthDatasource>((ref) => HealthDatasource());

final _localDatasourceProvider =
    Provider<LocalDatasource>((ref) => LocalDatasource());

/// Fonte única da verdade do progresso — repository compartilhado entre
/// todas as telas (ver `.autoDispose` deliberadamente omitido: queremos
/// que sobreviva à navegação entre telas).
final jornadaRepositoryProvider = Provider<JornadaRepository>((ref) {
  final repo = JornadaRepository(
    healthDatasource: ref.watch(_healthDatasourceProvider),
    localDatasource: ref.watch(_localDatasourceProvider),
    verificarDesbloqueio: ref.watch(verificarDesbloqueioProvider),
  );
  ref.onDispose(repo.dispose);
  return repo;
});

/// Progresso atual do usuário, como Stream reativo — qualquer widget que
/// use `ref.watch(progressoProvider)` re-renderiza automaticamente quando
/// o repository emite um novo estado (sync do sensor ou registro manual).
final progressoProvider = StreamProvider<ProgressoUsuario>((ref) {
  final repo = ref.watch(jornadaRepositoryProvider);
  // Emite o estado atual imediatamente, depois segue ouvindo o stream.
  return repo.progresso$.startWith(repo.atual);
});

/// RF-09: percentual de progresso geral da jornada (soma de todos os
/// filmes), derivado do progresso + lista de filmes.
final progressoGeralProvider = Provider<double>((ref) {
  final progresso = ref.watch(progressoProvider).value;
  final filmes = ref.watch(filmesProvider);
  final verificar = ref.watch(verificarDesbloqueioProvider);
  if (progresso == null || filmes.isEmpty) return 0.0;

  final totalMeta =
      filmes.fold<double>(0.0, (s, f) => s + f.metaKm(progresso.dificuldade));
  final totalAtual = filmes.fold<double>(
    0.0,
    (s, f) => s + (progresso.kmPorFilme[f.filmeId] ?? 0.0),
  );
  if (totalMeta <= 0) return 0.0;
  return (totalAtual / totalMeta).clamp(0.0, 1.0);
});

extension on Stream<ProgressoUsuario> {
  /// Pequeno helper equivalente ao `startWith` do rxdart, sem precisar
  /// adicionar a dependência só por causa disso.
  Stream<ProgressoUsuario> startWith(ProgressoUsuario valorInicial) async* {
    yield valorInicial;
    yield* this;
  }
}