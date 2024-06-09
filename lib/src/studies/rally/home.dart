import 'package:flutter/material.dart';

class RallyHomePage extends StatelessWidget {
  const RallyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rally'),
      ),
      body: Center(
        child: const Text('rally'),
      ),
    );
  }
}
