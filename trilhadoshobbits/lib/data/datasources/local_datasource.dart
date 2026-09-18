import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import '../../domain/entities/progresso_usuario.dart';

/// Wrapper sobre Hive — RNF-01 (offline-first, dados sempre disponíveis).
///
/// Usa boxes separados por responsabilidade:
/// - `box_progresso`: o [ProgressoUsuario] serializado como Map (via
///   toJson/fromJson) — não precisamos de TypeAdapter/codegen porque os
///   tipos primitivos (String, double, Map) já são suportados nativamente.
/// - `box_config`: preferências simples que não fazem parte do progresso
///   em si (ex: se o usuário já viu o onboarding).
///
/// Os dados estáticos da jornada (filmes/checkpoints) NÃO ficam aqui —
/// vêm direto de `jornada_data.dart`, já que não mudam em runtime.
class LocalDatasource {
  static const _boxProgresso = 'box_progresso';
  static const _boxConfig = 'box_config';
  static const _chaveProgresso = 'progresso_usuario';

  /// Chama uma vez em main(), antes de runApp().
  static Future<void> inicializar() async {
    await Hive.initFlutter();
    await Hive.openBox(_boxProgresso);
    await Hive.openBox(_boxConfig);
  }

  Box get _progressoBox => Hive.box(_boxProgresso);
  Box get _configBox => Hive.box(_boxConfig);

  ProgressoUsuario? lerProgresso() {
    final raw = _progressoBox.get(_chaveProgresso);
    if (raw == null) return null;
    return ProgressoUsuario.fromJson(Map<String, dynamic>.from(raw as Map));
  }

  Future<void> salvarProgresso(ProgressoUsuario progresso) async {
    await _progressoBox.put(_chaveProgresso, progresso.toJson());
  }

  bool get onboardingConcluido =>
      _configBox.get('onboarding_concluido', defaultValue: false) as bool;

  Future<void> marcarOnboardingConcluido() async {
    await _configBox.put('onboarding_concluido', true);
  }
}