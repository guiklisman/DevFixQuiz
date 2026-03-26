import 'package:flutter/material.dart';

class OptionTile extends StatelessWidget {
  final int indice;
  final String opcao;
  final bool respondido;
  final bool selecionado;
  final bool correto;
  final VoidCallback onTap;

  const OptionTile({
    super.key,
    required this.indice,
    required this.opcao,
    required this.respondido,
    required this.selecionado,
    required this.correto,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color corFundo = Colors.white.withValues(alpha: 0.1);
    Color corBorda = Colors.white.withValues(alpha: 0.3);
    Widget iconeLetra = Text(
      String.fromCharCode(65 + indice),
      key: ValueKey('texto_letra_$indice'),
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );

    if (respondido) {
      if (correto) {
        corFundo = Colors.greenAccent.withValues(alpha: 0.3);
        corBorda = Colors.greenAccent;
        iconeLetra = const Icon(Icons.check,
            key: ValueKey('icone_check'), color: Colors.greenAccent, size: 20);
      } else if (selecionado) {
        corFundo = Colors.redAccent.withValues(alpha: 0.3);
        corBorda = Colors.redAccent;
        iconeLetra = const Icon(Icons.close,
            key: ValueKey('icone_close'), color: Colors.redAccent, size: 20);
      } else {
        corFundo = Colors.white.withValues(alpha: 0.05);
        corBorda = Colors.white.withValues(alpha: 0.1);
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 24,
          ),
          decoration: BoxDecoration(
            color: corFundo,
            border: Border.all(
              color: corBorda,
              width: (selecionado && !correto) || (respondido && correto)
                  ? 2.5
                  : 1.5,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: respondido && (correto || selecionado)
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: (respondido && correto)
                        ? Colors.greenAccent
                        : (respondido && selecionado
                            ? Colors.redAccent
                            : Colors.transparent),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: iconeLetra,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  opcao,
                  style: TextStyle(
                    fontSize: 16,
                    color: respondido && !correto && !selecionado
                        ? Colors.white54
                        : Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
