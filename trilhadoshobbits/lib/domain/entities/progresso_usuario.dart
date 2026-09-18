import 'dificuldade.dart';

/// Estado persistido do progresso do usuário.
///
/// [totalHistoricoKm] é o acumulador global de RN-08/RF-08: reflete
/// exatamente a distância real caminhada/registrada, e nunca é
/// reduzido ou multiplicado por [dificuldade]. Já [kmPorFilme] também
/// guarda km reais (não escalados) — é o fator de dificuldade que muda
/// a META de cada filme (via `Filme.metaKm`), não o progresso acumulado.
class ProgressoUsuario {
  const ProgressoUsuario({
    required this.totalHistoricoKm,
    required this.kmPorFilme,
    required this.dificuldade,
    required this.filmeAtivoId,
  });

  /// Distância total real, de todos os tempos, independente de dificuldade
  /// ou filme (RF-08).
  final double totalHistoricoKm;

  /// Km reais acumulados em cada filme (chave = filmeId), usados para
  /// comparar contra `Filme.metaKm(dificuldade)` e `metaKmCheckpoint`.
  final Map<String, double> kmPorFilme;

  final Dificuldade dificuldade;

  /// filmeId do filme atualmente em progresso (o próximo a ser
  /// desbloqueado/completado, respeitando RN-06).
  final String filmeAtivoId;

  ProgressoUsuario copyWith({
    double? totalHistoricoKm,
    Map<String, double>? kmPorFilme,
    Dificuldade? dificuldade,
    String? filmeAtivoId,
  }) {
    return ProgressoUsuario(
      totalHistoricoKm: totalHistoricoKm ?? this.totalHistoricoKm,
      kmPorFilme: kmPorFilme ?? this.kmPorFilme,
      dificuldade: dificuldade ?? this.dificuldade,
      filmeAtivoId: filmeAtivoId ?? this.filmeAtivoId,
    );
  }

  factory ProgressoUsuario.inicial(String primeiroFilmeId) => ProgressoUsuario(
        totalHistoricoKm: 0.0,
        kmPorFilme: {},
        dificuldade: Dificuldade.medio,
        filmeAtivoId: primeiroFilmeId,
      );

  factory ProgressoUsuario.fromJson(Map<String, dynamic> json) {
    return ProgressoUsuario(
      totalHistoricoKm: (json['totalHistoricoKm'] as num).toDouble(),
      kmPorFilme: (json['kmPorFilme'] as Map<String, dynamic>)
          .map((k, v) => MapEntry(k, (v as num).toDouble())),
      dificuldade: Dificuldade.fromNome(json['dificuldade'] as String),
      filmeAtivoId: json['filmeAtivoId'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'totalHistoricoKm': totalHistoricoKm,
        'kmPorFilme': kmPorFilme,
        'dificuldade': dificuldade.name,
        'filmeAtivoId': filmeAtivoId,
      };
}