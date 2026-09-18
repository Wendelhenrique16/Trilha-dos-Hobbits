/// Nível de dificuldade do desafio (RN-05).
///
/// Define o fator de escala aplicado sobre a distância real (RN-04) para
/// calcular a distância-alvo de cada filme e checkpoint. Não afeta o
/// acumulador histórico total do usuário (RN-08), que nunca é escalado.
enum Dificuldade {
  facil(0.10),
  medio(0.50),
  completo(1.00);

  const Dificuldade(this.fator);

  /// Fator multiplicador sobre a distância real (ex: 0.10 para 10%).
  final double fator;

  static Dificuldade fromNome(String nome) {
    return Dificuldade.values.firstWhere(
      (d) => d.name == nome,
      orElse: () => Dificuldade.medio,
    );
  }
}