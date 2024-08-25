import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rally/codeviewer/code_displayer.dart';

class DemoSectionCode extends StatelessWidget {
  const DemoSectionCode({
    this.maxHeight,
    this.codeWidget,
  });

  final double? maxHeight;
  final Widget? codeWidget;

  @override
  Widget build(BuildContext context) {
    return
        // Theme(
        //   // data: GalleryThemeData.darkThemeData,
        //   child:
        Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Container(
              // color: kIsWeb ? null : GalleryThemeData.darkThemeData.canvasColor,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: maxHeight,
              child: codeWidget,
            )
            // ),
            );
  }
}

class CodeDisplayPage extends StatelessWidget {
  const CodeDisplayPage(
    this.code, {
    super.key,
  });

  final CodeDisplayer code;

  @override
  Widget build(BuildContext context) {
    final richTextCode = code(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SelectableText.rich(
                richTextCode,
                textDirection: TextDirection.ltr,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
