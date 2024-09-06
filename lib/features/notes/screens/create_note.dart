import 'dart:io';

import 'package:acc/core/commons/debounced_button.dart';
import 'package:acc/core/commons/error_text.dart';
import 'package:acc/core/commons/image_view.dart';
import 'package:acc/core/commons/loader.dart';
import 'package:acc/features/auth/controller/auth_controller.dart';
import 'package:acc/features/notes/controller/note_controller.dart';
import 'package:acc/features/school/controller/school_controller.dart';
import 'package:acc/models/note_model.dart';
import 'package:acc/theme/palette.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
// import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/utils.dart';
import '../../../models/user_model.dart';

class CreateNote extends ConsumerStatefulWidget {
  const CreateNote({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateNoteState();
}

class _CreateNoteState extends ConsumerState<CreateNote> {
  bool isLoading = false;
  int counter = 0;
  List<Note> threads = [];
  int textLength = 0;
  FocusNode focusNode = FocusNode();
  List<File> images = [];
  // List<Uint8List> webImages = [];
  int segmentedControlValue = 2;

  final noteTextController = TextEditingController();
  @override
  void dispose() {
    noteTextController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    focusNode.requestFocus();
    super.initState();
  }

  void onPickImages() async {
    final action = await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              child: Text(
                "kamera",
                style: TextStyle(
                    fontFamily: 'SFProDisplayRegular', color: Colors.white),
              ),
              onPressed: () {
                Navigator.pop(context, "photo");
              },
            ),
            CupertinoActionSheetAction(
              child: Text(
                "fotoğraf seç",
                style: TextStyle(
                    fontFamily: 'SFProDisplayRegular', color: Colors.white),
              ),
              onPressed: () {
                Navigator.pop(context, "library");
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDestructiveAction: true,
            child: Text(
              "geri",
              style: TextStyle(
                  fontFamily: 'SFProDisplayRegular',
                  color: Palette.orangeColor),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        );
      },
    );

    if (action == "photo") {
      images = await camera(allowMultiple: false);
      setState(() {});
    } else if (action == "library") {
      images = await pickImages(allowMultiple: false);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = ref.watch(noteControllerProvider);
    final user = ref.read(userProvider)!;
    return Scaffold(
      bottomSheet: isLoading ? const SizedBox() : bottomSheet(user),
      backgroundColor: Palette.darkGreyColor,
      body: isLoading
          ? const Loader()
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CupertinoButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                padding: EdgeInsets.zero,
                                child: const Text(
                                  '< kapat',
                                  style: TextStyle(
                                      color: Palette.placeholderColor,
                                      fontSize: 19,
                                      fontFamily: 'SFProDisplayBold'),
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              const Spacer(),
                              DebouncedButton(
                                onPressed: () async {
                                  await sharenote();
                                },
                                child: const Text(
                                  'not al',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 19,
                                    fontFamily: 'SFProDisplayBold',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: Colors.white12),
                                    image: DecorationImage(
                                        image: NetworkImage(
                                          user.profilePic,
                                        ),
                                        fit: BoxFit.cover),
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: CupertinoTheme(
                                  data: CupertinoThemeData(
                                    primaryColor: Palette.themeColor,
                                  ),
                                  child: CupertinoTextField(
                                    cursorColor: Palette.themeColor,
                                    onChanged: (val) {
                                      textLength = val.trim().length;
                                      setState(() {});
                                    },
                                    maxLengthEnforcement:
                                        MaxLengthEnforcement.enforced,
                                    controller: noteTextController,
                                    focusNode: focusNode,
                                    maxLines: null,
                                    maxLength: 400,
                                    keyboardType: TextInputType.multiline,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'SFProDisplayRegular'),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    placeholder: 'hmmmm...',
                                    placeholderStyle: const TextStyle(
                                        color: Palette.placeholderColor,
                                        fontFamily: 'SFProDisplayRegular'),
                                    decoration: const BoxDecoration(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (images.isNotEmpty)
                      CarouselSlider(
                          items: images.map((file) {
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
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(right: 8.0, top: 20),
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 120,
                                      width: 120,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                              ),
                            );
                          }).toList(),
                          options: CarouselOptions(
                              viewportFraction: 0.3,
                              enableInfiniteScroll: false,
                              disableCenter: true))
                  ],
                ),
              ),
            ),
    );
  }

  Container bottomSheet(UserModel user) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: const BoxDecoration(
          color: Palette.darkGreyColor,
          border: Border(top: BorderSide(width: 0.1, color: Colors.grey))),
      child: Row(
        children: [
          Container(
            width: 35.0,
            height: 35.0,
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  width: 1.5,
                  color: Palette.themeColor,
                )),
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: onPickImages,
              child: SvgPicture.asset(
                "assets/svgs/image-outlined.svg",
                colorFilter:
                    const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Container(
              height: 35,
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 1.5,
                      color: textLength == 400
                          ? Palette.redColor
                          : Palette.themeColor),
                  borderRadius: BorderRadius.circular(100)),
              child: Center(
                child: Text(
                  "${textLength.toString()} / 400",
                  style: TextStyle(
                      fontFamily: 'SFProDisplayMedium',
                      fontSize: 14,
                      color:
                          textLength == 400 ? Palette.redColor : Colors.white),
                ),
              )),
          const Spacer(),
          SizedBox(
            height: 35,
            child: CustomSlidingSegmentedControl<int>(
              initialValue: segmentedControlValue,
              children: {
                1: Text(
                  'dünya',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontFamily: "SFProDisplayMedium",
                  ),
                ),
                2: Text(
                  user.schoolId,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontFamily: "SFProDisplayMedium",
                  ),
                ),
                // 3: Text(
                //   "agalar",
                //   style: TextStyle(
                //     fontSize: 14,
                //     color: Colors.white,
                //     fontFamily: "SFProDisplayMedium",
                //   ),
                // ),
              },
              decoration: BoxDecoration(
                border: Border.all(color: Palette.themeColor, width: 1.5),
                borderRadius: BorderRadius.circular(100),
              ),
              thumbDecoration: BoxDecoration(
                color: Palette.themeColor,
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.3),
                    blurRadius: 4.0,
                    spreadRadius: 1.0,
                    offset: const Offset(
                      0.0,
                      2.0,
                    ),
                  ),
                ],
              ),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              onValueChanged: (v) {
                setState(() {
                  segmentedControlValue = v;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Future sharenote() async {
    setState(() {
      isLoading = true;
      counter += 1;
    });

    String link = getLinkFromText(noteTextController.text);
    final currentUser = ref.read(userProvider)!;

    if (images.isNotEmpty) {
      ref.read(getSchoolByIdProvider(currentUser.schoolId)).when(
          data: (school) {
            ref.read(noteControllerProvider.notifier).shareImageNote(
                  context: context,
                  selectedSchoolId: segmentedControlValue ==
                          1 /* 1 means world, :2 means school */
                      ? ""
                      : segmentedControlValue == 2
                          ? currentUser.schoolId
                          : 'closeFriends-${currentUser.uid}',
                  files: images,
                  link: link,
                  content: noteTextController.text.trim(),
                  school: school,
                  repliedTo: '',
                );
          },
          error: (error, stackTrace) => Text(error.toString()),
          loading: () => const Loader());
    } else if (noteTextController.text.isNotEmpty) {
      ref.read(getSchoolByIdProvider(currentUser.schoolId)).when(
            data: (school) {
              ref.read(noteControllerProvider.notifier).shareTextNote(
                    repliedTo: '',
                    context: context,
                    schoolId: segmentedControlValue ==
                            1 /* 1 means world, :2 means school */
                        ? ""
                        : segmentedControlValue == 2
                            ? currentUser.schoolId
                            : "closeFriends-${currentUser.uid}",
                    content: noteTextController.text.trim(),
                    link: link,
                  );
            },
            error: (error, stackTrace) => Text(error.toString()),
            loading: () => const Loader(),
          );
    } else {
      showSnackBar(context, 'Please enter all the fields');
    }
  }
}
