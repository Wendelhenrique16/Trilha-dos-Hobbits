import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/usecases/registrar_atividade.dart';
import '../../state/providers.dart';

class RegistroManualScreen extends ConsumerStatefulWidget {
  const RegistroManualScreen({super.key});

  @override
  ConsumerState<RegistroManualScreen> createState() =>
      _RegistroManualScreenState();
}

class _RegistroManualScreenState extends ConsumerState<RegistroManualScreen> {
  final _controller = TextEditingController();
  UnidadeEntrada _unidade = UnidadeEntrada.quilometros;
  bool _salvando = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    final valor = num.tryParse(_controller.text.replaceAll(',', '.'));
    if (valor == null || valor <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe um valor válido.')),
      );
      return;
    }

    setState(() => _salvando = true);
    await ref
        .read(jornadaRepositoryProvider)
        .registrarManual(unidade: _unidade, valor: valor);

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar atividade')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SegmentedButton<UnidadeEntrada>(
              segments: const [
                ButtonSegment(
                  value: UnidadeEntrada.quilometros,
                  label: Text('Quilômetros'),
                ),
                ButtonSegment(
                  value: UnidadeEntrada.passos,
                  label: Text('Passos'),
                ),
              ],
              selected: {_unidade},
              onSelectionChanged: (novo) =>
                  setState(() => _unidade = novo.first),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: _unidade == UnidadeEntrada.quilometros
                    ? 'Distância (km)'
                    : 'Número de passos',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _salvando ? null : _salvar,
              child: _salvando
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}