/// Um marco/cena dentro de um [Filme] (RF-04, RF-05, RN-07).
///
/// É um dado estático — o estado de bloqueado/desbloqueado NÃO mora aqui.
/// Isso é calculado em tempo real por `VerificarDesbloqueio`, comparando
/// `kmRelativoPercentual` com o progresso atual do filme. Manter o
/// checkpoint "burro" evita que o estado de progresso fique duplicado ou
/// dessincronizado entre a UI e os dados.
class Checkpoint {
  const Checkpoint({
    required this.id,
    required this.titulo,
    required this.minutoFilme,
    required this.kmRelativoPercentual,
    required this.imagemUrl,
    required this.descricao,
    required this.local,
  });

  final String id;
  final String titulo;

  /// Minutagem exata na versão estendida do filme (RF-05).
  final int minutoFilme;

  /// Posição do checkpoint como fração (0.0–1.0) da distância total do
  /// filme. Usado tanto para calcular o km-alvo (RN-07) quanto para
  /// posicionar o marcador no mapa interativo (RF-03).
  final double kmRelativoPercentual;

  final String imagemUrl;
  final String descricao;
  final String local;

  factory Checkpoint.fromJson(Map<String, dynamic> json) {
    return Checkpoint(
      id: json['id'] as String,
      titulo: json['titulo'] as String,
      minutoFilme: json['minutoFilme'] as int,
      kmRelativoPercentual: (json['kmRelativoPercentual'] as num).toDouble(),
      imagemUrl: json['imagemUrl'] as String,
      descricao: json['descricao'] as String,
      local: json['local'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'titulo': titulo,
        'minutoFilme': minutoFilme,
        'kmRelativoPercentual': kmRelativoPercentual,
        'imagemUrl': imagemUrl,
        'descricao': descricao,
        'local': local,
      };
}