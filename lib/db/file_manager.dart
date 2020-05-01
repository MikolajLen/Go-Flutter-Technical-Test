import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:random_string/random_string.dart';

class FileManager {
  static String _imagesPath;

  String get imagesPath {
    assert(_imagesPath != null, 'File manager not initialized!');
    return _imagesPath;
  }

  Future<void> init() async {
    _imagesPath = (await getApplicationDocumentsDirectory()).path;
    if (!(await isInitialized(_imagesPath))) {
      await _copyImagesToInternalStorage(_images, _imagesPath);
    }
  }

  Future<bool> isInitialized(String imagesPath) async {
    for (final fileName in _images) {
      final exists = await File('$imagesPath/$fileName').exists();
      if (!exists) {
        return false;
      }
    }
    return true;
  }

  Future<String> copyFileToInternalStorage(File file) async {
    final directory = await getApplicationDocumentsDirectory();
    final filename = '${randomNumeric(10)}${basename(file.path)}';
    final path = '${directory.path}/$filename';
    await file.copy(path);
    return filename;
  }

  Future<void> _copyImagesToInternalStorage(
      List<String> files, String imagesPath) async {
    for (final fileName in files) {
      final path = '$imagesPath/$fileName';
      final localFile = File(path);
      final assetsFile = await rootBundle.load(join('assets', fileName));
      final List<int> bytes = assetsFile.buffer
          .asUint8List(assetsFile.offsetInBytes, assetsFile.lengthInBytes);
      await localFile.writeAsBytes(bytes, flush: true);
    }
  }

  static const _images = [
    'cat_woman.png',
    'eddie.png',
    'harry.png',
    'kylo.png',
    'wonder_woman.png'
  ];
}
