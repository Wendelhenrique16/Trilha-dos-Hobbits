import '../entities/progresso_usuario.dart';
import 'converter_distancia.dart';
import 'verificar_desbloqueio.dart';

enum UnidadeEntrada { passos, quilometros }

/// UC-01 / RN-03: aplica uma entrada de atividade (manual ou de sensor) ao
/// progresso do usuário, atualizando tanto o acumulador global (RN-08)
/// quanto o km do filme ativo.
///
/// NOTA: a especificação não define o comportamento quando a entrada
/// excede a meta do filme ativo (ex: registrar 800km de uma vez quando
/// faltam 50km pro filme 1 fechar). Aqui, por padrão, todo o delta é
/// creditado ao filme ativo no momento do registro — não há "transbordo"
/// automático pro próximo filme dentro da mesma chamada. Se o
/// comportamento desejado for outro (ex: distribuir o excedente pelos
/// filmes seguintes), isso precisa ser decidido e ajustado aqui.
class RegistrarAtividade {
  const RegistrarAtividade(this.verificarDesbloqueio);

  final VerificarDesbloqueio verificarDesbloqueio;

  ProgressoUsuario call({
    required ProgressoUsuario progresso,
    required UnidadeEntrada unidade,
    required num valor,
  }) {
    final double deltaKm = unidade == UnidadeEntrada.passos
        ? ConverterDistancia.passosParaKm(valor.round())
        : valor.toDouble();

    final filmeAtivo = verificarDesbloqueio.filmeAtivo(progresso);
    final novoKmPorFilme = Map<String, double>.from(progresso.kmPorFilme);
    if (filmeAtivo != null) {
      novoKmPorFilme[filmeAtivo.filmeId] =
          (novoKmPorFilme[filmeAtivo.filmeId] ?? 0.0) + deltaKm;
    }

    return progresso.copyWith(
      totalHistoricoKm: progresso.totalHistoricoKm + deltaKm,
      kmPorFilme: novoKmPorFilme,
      filmeAtivoId: filmeAtivo?.filmeId ?? progresso.filmeAtivoId,
    );
  }
}