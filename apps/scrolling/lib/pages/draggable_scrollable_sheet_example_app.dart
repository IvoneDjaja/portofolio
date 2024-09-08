import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DraggableScrollableSheetExampleApp extends StatefulWidget {
  const DraggableScrollableSheetExampleApp({super.key});

  @override
  State<DraggableScrollableSheetExampleApp> createState() =>
      _DraggableScrollableSheetExampleAppState();
}

class _DraggableScrollableSheetExampleAppState
    extends State<DraggableScrollableSheetExampleApp> {
  double _sheetPosition = 0.5;
  final double _dragSensitivity = 600;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return DraggableScrollableSheet(
      initialChildSize: _sheetPosition,
      builder: (context, scrollController) {
        return ColoredBox(
          color: colorScheme.primary,
          child: Column(
            children: <Widget>[
              Grabber(onVerticalDragUpdate: (details) {
                setState(() {
                  _sheetPosition -= details.delta.dy / _dragSensitivity;

                  if (_sheetPosition < 0.25) {
                    _sheetPosition = 0.25;
                  }
                  if (_sheetPosition > 1.0) {
                    _sheetPosition = 1.0;
                  }
                });
              }),
              Flexible(
                child: ListView.builder(
                  controller: kIsWeb ? null : scrollController,
                  itemCount: 25,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        'Item $index',
                        style: TextStyle(color: colorScheme.surface),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// A draggable widget that accepts vertical drag gestures
/// and this is only visible on desktop and web platforms.
class Grabber extends StatelessWidget {
  const Grabber({
    required this.onVerticalDragUpdate,
  });

  final ValueChanged<DragUpdateDetails> onVerticalDragUpdate;

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      return const SizedBox.shrink();
    }
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onVerticalDragUpdate: onVerticalDragUpdate,
      child: Container(
        width: double.infinity,
        color: colorScheme.onSurface,
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8.0),
              )),
        ),
      ),
    );
  }
}
