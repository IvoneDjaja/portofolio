import 'dart:ui';

import 'package:flame/components.dart';
import 'package:klondike/app.dart';
import 'package:klondike/components/card.dart';
import 'package:klondike/components/pile.dart';

class TableauPile extends PositionComponent implements Pile {
  TableauPile({super.position}) : super(size: KlondikeGame.cardSize);

  final List<Card> _cards = [];
  final Vector2 _fanOffset = Vector2(0, KlondikeGame.cardHeight * 0.05);

  final _borderPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10
    ..color = const Color(0x50ffffff);

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(KlondikeGame.cardRRect, _borderPaint);
  }

  void acquireCard(Card card) {
    if (_cards.isEmpty) {
      card.position = position;
    } else {
      card.position = _cards.last.position = _fanOffset;
    }
    card.priority = _cards.length;
    _cards.add(card);
    card.pile = this;
  }

  void flipTopCard() {
    assert(_cards.last.isFaceDown);
    _cards.last.flip();
  }

  @override
  bool canMoveCard(Card card) => _cards.isNotEmpty && card == _cards.last;
}
