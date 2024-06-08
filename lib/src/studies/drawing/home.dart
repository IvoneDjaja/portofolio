import 'package:flutter/material.dart';

class DrawingHomePage extends StatelessWidget {
  const DrawingHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drawing'),
      ),
      body: Center(
        child: const Text('Draw'),
      ),
    );
  }
}
