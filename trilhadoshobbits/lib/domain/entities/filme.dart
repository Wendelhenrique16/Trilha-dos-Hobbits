import 'checkpoint.dart';
import 'dificuldade.dart';

/// Dados estáticos de um filme da trilogia (RN-04).
///
/// Assim como [Checkpoint], não guarda estado de progresso — apenas a
/// distância real e as metas por dificuldade (RN-05). O progresso
/// acumulado do usuário mora em `ProgressoUsuario`.
class Filme {
  const Filme({
    required this.filmeId,
    required this.titulo,
    required this.ordem,
    required this.duracaoMinutos,
    required this.distanciaBaseKm,
    required this.checkpoints,
  });

  final String filmeId;
  final String titulo;

  /// Posição na trilogia: 1, 2 ou 3 (usado para RN-06, desbloqueio sequencial).
  final int ordem;
  final int duracaoMinutos;

  /// Distância real (100%) deste filme, em km (RN-04).
  final double distanciaBaseKm;

  final List<Checkpoint> checkpoints;

  /// Meta de distância deste filme para uma dada [Dificuldade] (RN-05).
  /// Ex: Filme 1 no fácil -> 740 * 0.10 = 74.0 km.
  double metaKm(Dificuldade dificuldade) => distanciaBaseKm * dificuldade.fator;

  /// Meta de distância (em km, na escala da dificuldade ativa) para um
  /// checkpoint específico deste filme (RN-07: kmAlvoCheckpoint).
  double metaKmCheckpoint(Checkpoint checkpoint, Dificuldade dificuldade) {
    return metaKm(dificuldade) * checkpoint.kmRelativoPercentual;
  }

  factory Filme.fromJson(Map<String, dynamic> json) {
    return Filme(
      filmeId: json['filmeId'] as String,
      titulo: json['titulo'] as String,
      ordem: json['ordem'] as int,
      duracaoMinutos: json['duracaoMinutos'] as int,
      distanciaBaseKm: (json['distanciaBaseKm'] as num).toDouble(),
      checkpoints: (json['checkpoints'] as List<dynamic>)
          .map((c) => Checkpoint.fromJson(c as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'filmeId': filmeId,
        'titulo': titulo,
        'ordem': ordem,
        'duracaoMinutos': duracaoMinutos,
        'distanciaBaseKm': distanciaBaseKm,
        'checkpoints': checkpoints.map((c) => c.toJson()).toList(),
      };
}