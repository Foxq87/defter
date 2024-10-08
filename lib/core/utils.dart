import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../theme/palette.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Text(
          text,
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        behavior: SnackBarBehavior.floating,
      ),
    );
}

Future<FilePickerResult?> pickImage() async {
  final image = await FilePicker.platform.pickFiles(
      type: FileType.image, allowCompression: true, compressionQuality: 40);
  return image;
}

Future<List<File>> pickImages({required bool allowMultiple}) async {
  List<File> images = [];
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    allowMultiple: allowMultiple,
    type: FileType.image,
    allowCompression: true,
    compressionQuality: 15,
  );

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

Future<List<File>> camera({required bool allowMultiple}) async {
  List<File> images = [];
  final picker = ImagePicker();
  final pickedFile =
      await picker.pickImage(source: ImageSource.camera, imageQuality: 15);

  if (pickedFile != null) {
    images.add(File(pickedFile.path));
  }

  return images;
}

// Future<File> compressImage(String noteId, File file, int index) async {
//   final tempDir = await getTemporaryDirectory();
//   final path = tempDir.path;
//   Im.Image? imageFile = Im.decodeImage(file.readAsBytesSync());
//   File compressedImage = File('$path/img_${noteId}${index}.jpg')
//     ..writeAsBytesSync(Im.encodeJpg(imageFile!, quality: 25));
//   return compressedImage;
// }

String getLinkFromText(String text) {
  String link = '';
  List<String> wordsInSentence = text.split(' ');
  for (String word in wordsInSentence) {
    if (word.startsWith("https://") ||
        word.startsWith("www.") ||
        word.startsWith("http://")) {
      link = word;
    }
  }
  return link;
}

String emailFormatter(String email) {
  List<String> res = email.split("@");
  String formattedEmail = "${res.first.replaceAll(".", "") + "@" + res[1]}";
  print(formattedEmail);
  return formattedEmail;
}

Future<dynamic> alertNotAvailable(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Icon(
              CupertinoIcons.alarm,
              size: 40,
              color: Palette.themeColor,
            ),
            content: Text(
              'bu özellik şu anda aktif değil, sonraki sürümleri bekleyin',
              style: TextStyle(fontSize: 17),
            ),
            actions: [
              CupertinoButton(
                  color: Palette.themeColor,
                  child: Text(
                    'tamam',
                    style: TextStyle(),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  })
            ],
          ));
}
