import 'dart:io';

import 'package:acc/core/commons/loader.dart';
import 'package:acc/core/utils.dart';
import 'package:acc/features/auth/controller/auth_controller.dart';
import 'package:acc/features/updates/controller/update_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/commons/image_view.dart';
import '../../../core/commons/large_text.dart';
import '../../../models/user_model.dart';
import '../../../theme/palette.dart';

class CreateUpdateScreen extends ConsumerStatefulWidget {
  const CreateUpdateScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateUpdateScreenState();
}

class _CreateUpdateScreenState extends ConsumerState<CreateUpdateScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  List<File> images = [];
  String errorText = '';
  void onPickImages() async {
    images = await pickImages(allowMultiple: true);
    setState(() {});
  }

  void onShareUpdate(UserModel user) async {
    if (titleController.text.trim().isNotEmpty &&
        descriptionController.text.trim().isNotEmpty) {
      errorText = "";
      ref.read(updateControllerProvider.notifier).shareUpdate(
          user,
          titleController.text.trim(),
          descriptionController.text.trim(),
          images,
          context);
    } else {
      setState(() {
        errorText = "lütfen tüm alanları doldurun";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.read(userProvider)!;
    bool isLoading = ref.watch(updateControllerProvider);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CupertinoNavigationBar(
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(
            CupertinoIcons.back,
            color: Colors.white,
            size: 27,
          ),
          onPressed: () {
            Routemaster.of(context).pop();
          },
        ),
        backgroundColor: Palette.backgroundColor,
        // border: const Border(
        //   bottom: BorderSide(width: 1, color: Palette.textFieldColor),
        // ),
        middle: largeText('yenilik ekle', false),
        trailing: SizedBox(
          height: 35,
          child: CupertinoButton(
            onPressed: () {
              if (!isLoading) {
                onShareUpdate(currentUser);
              }
            },
            color: Palette.themeColor,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            borderRadius: BorderRadius.circular(40),
            child: const Text(
              'not al',
              style: TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontFamily: 'JetBrainsMonoExtraBold',
              ),
            ),
          ),
        ),
      ),
      body: isLoading
          ? Loader()
          : Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: Palette.backgroundColor,
                  padding: images.isEmpty
                      ? null
                      : EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Wrap(
                      spacing: 7.0,
                      runSpacing: 7.0,
                      direction: Axis.horizontal,
                      children: images.map((file) {
                        return GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ImageView(
                                imageUrls: const [],
                                imageFiles: images,
                                index: images.indexOf(file),
                              ),
                            ),
                          ),
                          child: Stack(
                            children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.width / 3 - 10,
                                width:
                                    MediaQuery.of(context).size.width / 3 - 10,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                        image: FileImage(file),
                                        fit: BoxFit.cover)),
                              ),
                              Positioned(
                                top: 7,
                                right: 7,
                                child: Container(
                                  height: 25,
                                  width: 25,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black),
                                  child: CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    child: const Center(
                                      child: Icon(
                                        CupertinoIcons.clear,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        images.remove(file);
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                if (images.isEmpty)
                  Container(
                    color: Palette.backgroundColor,
                    padding: EdgeInsets.all(10.0),
                    child: GestureDetector(
                      onTap: onPickImages,
                      child: Container(
                        child: Row(
                          children: [
                            Expanded(
                                child: AspectRatio(
                              aspectRatio: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        width: 0.5,
                                        color: Palette.placeholderColor)),
                                child: Center(
                                  child: Icon(
                                    CupertinoIcons.camera,
                                    size: 30,
                                  ),
                                ),
                              ),
                            )),
                            SizedBox(
                              width: 7,
                            ),
                            Expanded(
                                child: AspectRatio(
                                    aspectRatio: 1,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                              width: 0.5,
                                              color: Palette.placeholderColor)),
                                    ))),
                            SizedBox(
                              width: 7,
                            ),
                            Expanded(
                                child: AspectRatio(
                                    aspectRatio: 1,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                              width: 0.5,
                                              color: Palette.placeholderColor)),
                                    ))),
                          ],
                        ),
                      ),
                    ),
                  ),
                SizedBox(
                  height: 20.0,
                ),
                CupertinoTextField(
                  controller: titleController,
                  style: TextStyle(
                      color: Colors.white, fontFamily: 'JetBrainsMonoRegular'),
                  placeholder: 'başlık',
                  placeholderStyle: TextStyle(
                      color: Palette.placeholderColor,
                      fontFamily: 'JetBrainsMonoRegular'),
                  padding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                  decoration: BoxDecoration(
                    color: Palette.backgroundColor,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                CupertinoTextField(
                  controller: descriptionController,
                  style: TextStyle(
                      color: Colors.white, fontFamily: 'JetBrainsMonoRegular'),
                  placeholder: 'açıklama',
                  placeholderStyle: TextStyle(
                      color: Palette.placeholderColor,
                      fontFamily: 'JetBrainsMonoRegular'),
                  padding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                  decoration: BoxDecoration(color: Palette.backgroundColor),
                ),
                if (errorText.isNotEmpty)
                  Text(
                    errorText,
                    style: TextStyle(
                        color: Palette.redColor,
                        fontFamily: "JetBrainsMonoBold"),
                  )
              ],
            ),
    );
  }
}
