import '../entities/checkpoint.dart';
import '../entities/filme.dart';
import '../entities/progresso_usuario.dart';

/// Regras de desbloqueio sequencial (RN-06) e de checkpoints (RN-07).
class VerificarDesbloqueio {
  const VerificarDesbloqueio(this.filmes);

  /// Todos os filmes da jornada, ordenados por [Filme.ordem].
  final List<Filme> filmes;

  double _kmNoFilme(ProgressoUsuario progresso, String filmeId) =>
      progresso.kmPorFilme[filmeId] ?? 0.0;

  /// RF-09: percentual de progresso (0.0–1.0) de um filme, já considerando
  /// a meta ajustada pela dificuldade ativa.
  double percentualFilme(Filme filme, ProgressoUsuario progresso) {
    final meta = filme.metaKm(progresso.dificuldade);
    if (meta <= 0) return 0.0;
    final atual = _kmNoFilme(progresso, filme.filmeId);
    return (atual / meta).clamp(0.0, 1.0);
  }

  bool filmeCompleto(Filme filme, ProgressoUsuario progresso) =>
      percentualFilme(filme, progresso) >= 1.0;

  /// RN-06: o filme 1 sempre está desbloqueado; os demais só quando o
  /// filme anterior (por [Filme.ordem]) estiver 100% completo.
  bool filmeDesbloqueado(Filme filme, ProgressoUsuario progresso) {
    if (filme.ordem <= 1) return true;
    final anterior = filmes.where((f) => f.ordem == filme.ordem - 1);
    if (anterior.isEmpty) return true;
    return filmeCompleto(anterior.first, progresso);
  }

  /// RN-07: checkpoint desbloqueado quando a distância acumulada no filme
  /// atinge a meta relativa do checkpoint, na escala da dificuldade ativa.
  bool checkpointDesbloqueado(
    Filme filme,
    Checkpoint checkpoint,
    ProgressoUsuario progresso,
  ) {
    final atual = _kmNoFilme(progresso, filme.filmeId);
    final alvo = filme.metaKmCheckpoint(checkpoint, progresso.dificuldade);
    return atual >= alvo;
  }

  /// Próximo filme a receber km registrados: o primeiro ainda não completo,
  /// em ordem. Usado para saber onde `RegistrarAtividade` deve somar.
  Filme? filmeAtivo(ProgressoUsuario progresso) {
    final ordenados = [...filmes]..sort((a, b) => a.ordem.compareTo(b.ordem));
    for (final f in ordenados) {
      if (!filmeCompleto(f, progresso)) return f;
    }
    return ordenados.isEmpty ? null : ordenados.last;
  }
}