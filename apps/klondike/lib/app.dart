import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class GameApp extends StatelessWidget {
  const GameApp({super.key});

  @override
  Widget build(BuildContext context) {
    final game = FlameGame();
    return GameWidget(game: game);
  }
}
