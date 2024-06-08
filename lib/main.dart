import 'package:flutter/material.dart';
import 'package:portofolio/pages/home.dart';

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


  Widget _buildStack(BuildContext context, BoxConstraints constraints) {
    return const Stack(
      children: [
        HomePage(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: _buildStack,
    );
  }
}
