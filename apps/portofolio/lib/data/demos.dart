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
        subtitle: 'A material 3 demo',
      ),
    };
  }
}
