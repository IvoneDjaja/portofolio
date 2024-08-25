import 'package:flutter/material.dart';

class CodeStyle extends InheritedWidget {
  const CodeStyle({
    super.key,
    this.baseStyle,
    this.numberStyle,
    this.commentStyle,
    this.keywordStyle,
    this.stringStyle,
    this.punctuationStyle,
    this.classStyle,
    this.constantStyle,
    required super.child,
  });

  final TextStyle? baseStyle;
  final TextStyle? numberStyle;
  final TextStyle? commentStyle;
  final TextStyle? keywordStyle;
  final TextStyle? stringStyle;
  final TextStyle? punctuationStyle;
  final TextStyle? classStyle;
  final TextStyle? constantStyle;

  static CodeStyle of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CodeStyle>()!;
  }

  @override
  bool updateShouldNotify(CodeStyle oldWidget) {
    return true;
  }
}
