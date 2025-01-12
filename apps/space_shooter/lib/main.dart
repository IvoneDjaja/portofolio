import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:space_shooter/player.dart';

class SpaceShooterGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(Player()
      ..position = size / 2
      ..width = 50
      ..height = 100
      ..anchor = Anchor.center);
  }
}

void main() {
  runApp(GameWidget(game: SpaceShooterGame()));
}
