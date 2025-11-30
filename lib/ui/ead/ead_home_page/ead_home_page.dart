import 'package:flutter/material.dart';

import 'package:medita_b_k/routing/ead_routes.dart';

/// Página inicial do módulo EAD
class EadHomePage extends StatelessWidget {
  const EadHomePage({super.key});

  static const String routeName = EadRoutes.eadHome;
  static const String routePath = EadRoutes.eadHomePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cursos'),
      ),
      body: const Center(
        child: Text('EAD Home - Em desenvolvimento'),
      ),
    );
  }
}
