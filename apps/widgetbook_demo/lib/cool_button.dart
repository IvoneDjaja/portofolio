import 'package:flutter/material.dart';

class CoolButton extends StatelessWidget {
  const CoolButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text('I am a cool button'),
      onPressed: () {},
    );
  }
}
