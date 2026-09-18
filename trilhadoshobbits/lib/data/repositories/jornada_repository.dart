import 'dart:async';

import '../../domain/entities/dificuldade.dart';
import '../../domain/entities/progresso_usuario.dart';
import '../../domain/usecases/registrar_atividade.dart';
import '../../domain/usecases/verificar_desbloqueio.dart';
import '../datasources/health_datasource.dart';
import '../datasources/local_datasource.dart';

/// Fonte única da verdade do progresso do usuário.
///
/// Combina `HealthDatasource` (sensor) e `LocalDatasource` (persistência),
/// aplica as regras de negócio (via os usecases) e expõe um Stream pra UI
/// consumir reativamente — nem a UI nem os providers do Riverpod tocam
/// diretamente nos datasources.
class JornadaRepository {
  JornadaRepository({
    required HealthDatasource healthDatasource,
    required LocalDatasource localDatasource,
    required VerificarDesbloqueio verificarDesbloqueio,
  })  : _health = healthDatasource,
        _local = localDatasource,
        _verificarDesbloqueio = verificarDesbloqueio,
        _registrarAtividade = RegistrarAtividade(verificarDesbloqueio);

  final HealthDatasource _health;
  final LocalDatasource _local;
  final VerificarDesbloqueio _verificarDesbloqueio;
  final RegistrarAtividade _registrarAtividade;

  final _controller = StreamController<ProgressoUsuario>.broadcast();

  /// Progresso atual, atualizado a cada sincronização ou registro manual.
  Stream<ProgressoUsuario> get progresso$ => _controller.stream;

  ProgressoUsuario? _atual;
  ProgressoUsuario get atual =>
      _atual ?? (_atual = _local.lerProgresso() ?? _estadoInicial());

  ProgressoUsuario _estadoInicial() {
    final primeiro = _verificarDesbloqueio.filmes.first;
    return ProgressoUsuario.inicial(primeiro.filmeId);
  }

  /// RF-01: busca passos novos desde a última sincronização no Health
  /// Connect / HealthKit e credita ao progresso. RNF-02: se falhar,
  /// não altera o estado nem propaga exceção — a UI simplesmente não
  /// recebe um novo evento.
  Future<void> sincronizarComSensor({
    required DateTime desde,
    required DateTime ate,
  }) async {
    final leitura = await _health.passosNoIntervalo(inicio: desde, fim: ate);
    if (!leitura.temSucesso || leitura.passos == null) return;
    if (leitura.passos == 0) return;

    await _aplicarEPersistir(
      unidade: UnidadeEntrada.passos,
      valor: leitura.passos!,
    );
  }

  /// UC-01: entrada manual, em passos ou km.
  Future<void> registrarManual({
    required UnidadeEntrada unidade,
    required num valor,
  }) async {
    await _aplicarEPersistir(unidade: unidade, valor: valor);
  }

  Future<void> definirDificuldade(Dificuldade novaDificuldade) async {
    final novo = atual.copyWith(dificuldade: novaDificuldade);
    _atual = novo;
    await _local.salvarProgresso(novo);
    _controller.add(novo);
  }

  Future<void> _aplicarEPersistir({
    required UnidadeEntrada unidade,
    required num valor,
  }) async {
    final novo = _registrarAtividade(
      progresso: atual,
      unidade: unidade,
      valor: valor,
    );
    _atual = novo;
    await _local.salvarProgresso(novo);
    _controller.add(novo);
  }

  void dispose() => _controller.close();
}