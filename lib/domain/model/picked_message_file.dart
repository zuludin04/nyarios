import 'dart:io';

class PickedMessageFile {
  final File file;
  final String path;
  final String size;

  PickedMessageFile({
    required this.file,
    required this.path,
    required this.size,
  });
}
