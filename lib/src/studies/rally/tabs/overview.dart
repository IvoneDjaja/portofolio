import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:portofolio/src/studies/rally/data.dart';

class OverviewView extends StatelessWidget {
  const OverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return const SingleChildScrollView(
          child: Row(children: [
        Flexible(
          flex: 7,
          child: Placeholder(),
        ),
        SizedBox(width: 24),
        Flexible(
          flex: 3,
          child: Placeholder(),
        )
      ]));
    }
    return const SingleChildScrollView(
      child: Column(
        children: [
          Placeholder(),
          SizedBox(height: 12),
          Placeholder(),
        ],
      ),
    );
  }
}
