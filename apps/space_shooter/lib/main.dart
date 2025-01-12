import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:space_shooter/player.dart';

class SpaceShooterGame extends FlameGame with PanDetector {
  late Player player;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    player = Player();
    add(player);
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    player.move(info.delta.global);
  }
}

void main() {
  runApp(GameWidget(game: SpaceShooterGame()));
}
