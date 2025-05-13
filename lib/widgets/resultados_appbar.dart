import 'package:flutter/material.dart';

class ResultadosAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ResultadosAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Historial de Resultados'),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}