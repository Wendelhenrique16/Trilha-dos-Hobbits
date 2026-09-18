import '../entities/checkpoint.dart';
import '../entities/filme.dart';

/// Dados estáticos dos 3 filmes e seus checkpoints (RN-04).
///
/// Filme 1 populado com os 4 checkpoints do seu documento como exemplo.
/// Filmes 2 e 3 ficam com lista de checkpoints vazia até você definir os
/// marcos — a estrutura e as regras já funcionam com qualquer quantidade.
final List<Filme> jornadaCompleta = [
  Filme(
    filmeId: 'lotr_fotr_extended',
    titulo: 'A Sociedade do Anel (Edição Estendida)',
    ordem: 1,
    duracaoMinutos: 228,
    distanciaBaseKm: 740.0,
    checkpoints: const [
      Checkpoint(
        id: 'cp_01',
        titulo: 'O Limite do Condado',
        minutoFilme: 28,
        kmRelativoPercentual: 0.05,
        imagemUrl: 'assets/scenes/cp_01.jpg',
        descricao:
            'Se eu der mais um passo, será o ponto mais distante de casa que já estive.',
        local: 'Bolsão / Campos do Condado',
      ),
      Checkpoint(
        id: 'cp_02',
        titulo: 'Saiam da Estrada!',
        minutoFilme: 43,
        kmRelativoPercentual: 0.14,
        imagemUrl: 'assets/scenes/cp_02.jpg',
        descricao:
            'Os Cavaleiros Negros farejam os arredores sob as raízes das árvores.',
        local: 'Mata dos Hobbits',
      ),
      Checkpoint(
        id: 'cp_03',
        titulo: 'O Topo do Vento',
        minutoFilme: 92,
        kmRelativoPercentual: 0.50,
        imagemUrl: 'assets/scenes/cp_03.jpg',
        descricao: 'O Rei Bruxo fere Frodo com a lâmina de Morgul.',
        local: 'Amon Sûl',
      ),
      Checkpoint(
        id: 'cp_04',
        titulo: 'A Queda de Boromir e a Partida',
        minutoFilme: 228,
        kmRelativoPercentual: 1.00,
        imagemUrl: 'assets/scenes/cp_04.jpg',
        descricao:
            'Eu prometi a ele, senhor Frodo. Não o abandone, Samwise Gamgi.',
        local: 'Amon Hen',
      ),
    ],
  ),
  Filme(
    filmeId: 'lotr_ttt_extended',
    titulo: 'As Duas Torres (Edição Estendida)',
    ordem: 2,
    duracaoMinutos: 0, // TODO: preencher
    distanciaBaseKm: 1300.0,
    checkpoints: const [],
  ),
  Filme(
    filmeId: 'lotr_rotk_extended',
    titulo: 'O Retorno do Rei (Edição Estendida)',
    ordem: 3,
    duracaoMinutos: 0, // TODO: preencher
    distanciaBaseKm: 850.0,
    checkpoints: const [],
  ),
];