import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:rally/codeviewer/code_displayer.dart';
import 'package:rally/codeviewer/code_segments.dart';

class GalleryDemo {
  const GalleryDemo({
    required this.title,
    required this.subtitle,
    this.configurations = const [],
    this.slug,
  });
  final String title;
  final String subtitle;
  final String? slug;
  final List<GalleryDemoConfiguration> configurations;
}

class GalleryDemoConfiguration {
  const GalleryDemoConfiguration({
    required this.title,
    required this.description,
    required this.documentationUrl,
    required this.buildRoute,
    required this.code,
  });

  final String title;
  final String description;
  final String documentationUrl;
  final WidgetBuilder buildRoute;
  final CodeDisplayer code;
}

class Demos {
  static Map<String?, GalleryDemo> asSlugToDemoMap() {
    return LinkedHashMap<String?, GalleryDemo>.fromIterable(
      studies().values.toList(),
      key: (dynamic demo) => demo.slug as String?,
    );
  }

  static Map<String, GalleryDemo> studies() {
    return <String, GalleryDemo>{
      'drawing': GalleryDemo(
        title: 'Drawing',
        subtitle: 'A simple drawing app',
      ),
      'rally': GalleryDemo(
        title: 'Rally',
        subtitle: 'A personal finance app',
        slug: 'rally',
        configurations: [
          GalleryDemoConfiguration(
            title: 'Rally',
            description: 'A personal finance app',
            documentationUrl: '',
            buildRoute: (_) => Placeholder(),
            code: CodeSegments.RallyApp,
          )
        ],
      ),
      'material': GalleryDemo(
        title: 'Material 3',
        subtitle: 'A material 3 demo',
      ),
    };
  }
}
