import 'package:flutter/material.dart';

import 'src/app.dart';

void main() async {
  runApp(const PortofolioApp());
}

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Material(
      child: Backdrop(),
    );
  }
}

class Backdrop extends StatelessWidget {
  const Backdrop({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Home'));
  }
}
