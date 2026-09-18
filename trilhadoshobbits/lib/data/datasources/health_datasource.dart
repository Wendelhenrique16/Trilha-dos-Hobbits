import 'package:health/health.dart';

/// Resultado de uma leitura do sensor de saúde — nunca lança exceção pra
/// cima (RNF-02: falha no Health Connect não pode travar o app nem impedir
/// a entrada manual).
class LeituraSaude {
  const LeituraSaude.sucesso(this.passos) : erro = null;
  const LeituraSaude.falha(this.erro) : passos = null;

  final int? passos;
  final String? erro;

  bool get temSucesso => erro == null;
}

/// Wrapper sobre o pacote `health` (Health Connect no Android, HealthKit no
/// iOS) — RF-01.
///
/// Isola o resto do app da API do plugin: se a lib mudar ou o dispositivo
/// não suportar, só este arquivo é afetado.
class HealthDatasource {
  HealthDatasource() : _health = Health();

  final Health _health;

  static final _tipos = [HealthDataType.STEPS];

  /// Pede permissão de leitura de passos. Retorna false silenciosamente em
  /// caso de erro — RNF-02.
  Future<bool> solicitarPermissao() async {
    try {
      await _health.configure();
      return await _health.requestAuthorization(_tipos);
    } catch (_) {
      return false;
    }
  }

  /// Total de passos no intervalo. Nunca lança — retorna
  /// `LeituraSaude.falha` em qualquer erro (permissão negada, Health
  /// Connect ausente, timeout etc.), pra UI decidir como reagir sem
  /// travar (RNF-02).
  Future<LeituraSaude> passosNoIntervalo({
    required DateTime inicio,
    required DateTime fim,
  }) async {
    try {
      final total = await _health.getTotalStepsInInterval(inicio, fim);
      return LeituraSaude.sucesso(total ?? 0);
    } catch (e) {
      return LeituraSaude.falha(e.toString());
    }
  }
}