import 'dart:io';

import 'package:acc/core/commons/error_text.dart';
import 'package:acc/core/commons/image_view.dart';
import 'package:acc/core/commons/loader.dart';
import 'package:acc/features/auth/controller/auth_controller.dart';
import 'package:acc/features/posts/controller/post_controller.dart';
import 'package:acc/features/school/controller/school_controller.dart';
import 'package:acc/models/post_model.dart';
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

class CreatePost extends ConsumerStatefulWidget {
  const CreatePost({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreatePostState();
}

class _CreatePostState extends ConsumerState<CreatePost> {
  List<Post> threads = [];
  int textLength = 0;
  FocusNode focusNode = FocusNode();
  List<File> images = [];
  // List<Uint8List> webImages = [];
  int segmentedControlValue = 2;

  final postTextController = TextEditingController();
  @override
  void dispose() {
    postTextController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    focusNode.requestFocus();
    super.initState();
  }

  void onPickImages() async {
    images = await pickImages();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = ref.watch(postControllerProvider);
    final user = ref.read(userProvider)!;
    return Scaffold(
      bottomSheet: isLoading ? const SizedBox() : bottomSheet(),
      backgroundColor: Palette.textfieldColor,
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
                                  Routemaster.of(context).pop();
                                },
                                padding: EdgeInsets.zero,
                                child: const Text(
                                  '< kapat',
                                  style: TextStyle(
                                      color: Palette.placeholderColor,
                                      fontSize: 19,
                                      fontFamily: 'JetBrainsMonoExtraBold'),
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              const Spacer(),
                              SizedBox(
                                height: 35,
                                child: CupertinoButton(
                                  onPressed: sharePost,
                                  color: Palette.themeColor,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  borderRadius: BorderRadius.circular(40),
                                  child: const Text(
                                    'post',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 19,
                                      fontFamily: 'JetBrainsMonoExtraBold',
                                    ),
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
                                child: CupertinoTextField(
                                  onChanged: (val) {
                                    textLength = val.trim().length;
                                    setState(() {});
                                  },
                                  maxLengthEnforcement:
                                      MaxLengthEnforcement.enforced,
                                  controller: postTextController,
                                  focusNode: focusNode,
                                  maxLines: null,
                                  maxLength: 400,
                                  keyboardType: TextInputType.multiline,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'JetBrainsMonoRegular'),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  placeholder: 'aklından ne geçiyor?',
                                  placeholderStyle: const TextStyle(
                                      color: Palette.placeholderColor,
                                      fontFamily: 'JetBrainsMonoRegular'),
                                  decoration: const BoxDecoration(),
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
                                CupertinoPageRoute(
                                  builder: (context) => ImageView(
                                    imageUrls: const [],
                                    imageFiles: images,
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

  Container bottomSheet() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: const BoxDecoration(
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
                      fontFamily: 'JetBrainsMonoBold',
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
              children: const {
                1: Text(
                  'World',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontFamily: "JetBrainsMonoBold",
                  ),
                ),
                2: Text(
                  'School',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontFamily: "JetBrainsMonoBold",
                  ),
                ),
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
          // SizedBox(
          //   height: 30,
          //   width: 30,
          //   child: CupertinoButton(
          //     borderRadius: BorderRadius.circular(100),
          //     padding: EdgeInsets.zero,
          //     color: Palette.themeColor,
          //     child: const Center(
          //         child: Icon(
          //       Icons.add,
          //       color: Colors.white,
          //     )),
          //     onPressed: () {
          //       threads.add(Post(id: id, title: title, schoolName: schoolName, schoolProfilePic: schoolProfilePic, likes: likes, threads: threads, commentCount: commentCount, username: username, uid: uid, type: type, createdAt: createdAt))
          //     },
          //   ),
        ],
      ),
    );
  }

  void sharePost() async {
    String link = _getLinkFromText(postTextController.text);
    final user = ref.read(userProvider)!;

    if (images.isNotEmpty) {
      ref.read(getSchoolByIdProvider(user.schoolId)).when(
          data: (school) {
            ref.read(postControllerProvider.notifier).shareImagePost(
                  context: context,
                  selectedSchoolId: segmentedControlValue ==
                          1 /* 1 means world, :2 means school */
                      ? ""
                      : user.schoolId,
                  files: images,
                  link: link,
                  content: postTextController.text.trim(),
                  school: school,
                );
          },
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader());
    } else if (postTextController.text.isNotEmpty) {
      ref.read(getSchoolByIdProvider(user.schoolId)).when(
            data: (school) {
              ref.read(postControllerProvider.notifier).shareTextPost(
                    context: context,
                    selectedSchoolId: segmentedControlValue ==
                            1 /* 1 means world, :2 means school */
                        ? ""
                        : user.schoolId,
                    content: postTextController.text.trim(),
                    link: link,
                    school: school,
                  );
            },
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          );
    } else {
      showSnackBar(context, 'Please enter all the fields');
    }
  }

  String _getLinkFromText(String text) {
    String link = '';
    List<String> wordsInSentence = text.split(' ');
    for (String word in wordsInSentence) {
      if (word.startsWith("https://") || word.startsWith("www.")) {
        link = word;
      }
    }
    return link;
  }
}
