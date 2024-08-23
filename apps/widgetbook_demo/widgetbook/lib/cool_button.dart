import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

// Import the widget from your app
import 'package:widgetbook_demo/cool_button.dart';

@widgetbook.UseCase(name: 'Default', type: CoolButton)
Widget buildCoolButtonUseCase(BuildContext context) {
  return const CoolButton();
}
