import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
}

Future<FilePickerResult?> pickImage() async {
  final image = await FilePicker.platform.pickFiles(type: FileType.image);
  return image;
}

Future<List<File>> pickImages() async {
  List<File> images = [];
  FilePickerResult? result = await FilePicker.platform
      .pickFiles(allowMultiple: true, type: FileType.image,);

  if (result != null) {
    List<File> imageFiles = result.paths.map((path) => File(path!)).toList();
    for (final image in imageFiles) {
      images.add(File(image.path));
    }
    return images;
  } else {
    return [];
  }
}
