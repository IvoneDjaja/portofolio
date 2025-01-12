import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:space_shooter/main.dart';

class Player extends SpriteComponent with HasGameRef<SpaceShooterGame> {
  static final _paint = Paint()..color = Colors.white;

  Player()
      : super(
          size: Vector2(100, 150),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await gameRef.loadSprite('player-sprite.png');
    position = gameRef.size / 2;
  }

  void move(Vector2 delta) {
    position.add(delta);
  }
}
