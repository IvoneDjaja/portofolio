import 'package:flutter/material.dart';
import 'package:rally/codeviewer/code_displayer.dart';

class GalleryDemo {
  const GalleryDemo({
    required this.title,
    required this.subtitle,
  });
  final String title;
  final String subtitle;
}

class Demos {
  static Map<String, GalleryDemo> studies() {
    return <String, GalleryDemo>{
      'drawing': GalleryDemo(
        title: 'Drawing',
        subtitle: 'A simple drawing app',
      ),
      'rally': GalleryDemo(
        title: 'Rally',
        subtitle: 'A personal finance app',
      ),
      'material': GalleryDemo(
        title: 'Material 3',
        subtitle: 'A Material 3 demo',
      ),
      'gorouter': GalleryDemo(
        title: 'Go Router',
        subtitle: 'A GoRouter demo',
      ),
    };
  }
}
