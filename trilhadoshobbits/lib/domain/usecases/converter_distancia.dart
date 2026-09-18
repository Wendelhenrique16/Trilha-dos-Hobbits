/// Conversões entre passos e quilômetros (RN-01, RN-02, RN-03).
///
/// Comprimento médio do passo fixado em 0,75m (RN-01): 1 km ≈ 1.333 passos.
class ConverterDistancia {
  const ConverterDistancia._();

  static const double metrosPorPasso = 0.75;

  /// RN-02: distanciaKm = (passos * 0.75) / 1000
  static double passosParaKm(int passos) => (passos * metrosPorPasso) / 1000;

  /// RN-03 (entrada manual em km): passos = (km * 1000) / 0.75
  static int kmParaPassos(double km) =>
      ((km * 1000) / metrosPorPasso).round();
}