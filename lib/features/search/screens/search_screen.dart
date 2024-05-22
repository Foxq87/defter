import 'dart:io';

import 'package:acc/core/commons/commons.dart';
import 'package:acc/features/auth/controller/auth_controller.dart';
import 'package:acc/features/chats/controller/chat_controller.dart';
import 'package:acc/features/notes/controller/note_controller.dart';
import 'package:acc/features/school/controller/school_controller.dart';
import 'package:acc/features/user_profile/controller/user_profile_controller.dart';
import 'package:acc/models/school_model.dart';
import 'package:acc/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';

import '../../../core/commons/error_text.dart';
import '../../../core/commons/loader.dart';
import '../../../core/utils.dart';
import '../../../theme/palette.dart';

class SearchScreen extends ConsumerStatefulWidget {
  final bool? isForChat;
  final bool? isForCloseFriends;
  const SearchScreen({
    super.key,
    this.isForChat = false,
    this.isForCloseFriends = false,
  });
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen>
    with AutomaticKeepAliveClientMixin<SearchScreen> {
  List<File> images = [];
  List<String> selectedProfileUids = [];
  List<UserModel> selectedProfiles = [];
  int currentPage = 0;
  @override
  bool get wantKeepAlive => true;

  String query = "";
  List contentItems = [
    ['kullanıcılar', true],
    ['okullar', false],
  ];
  void selectAndUnselectOthers(int index) {
    if (kDebugMode) {
      print(contentItems.first[1]);
    }
    for (var element in contentItems) {
      setState(() {
        element[1] = false;
        contentItems[index][1] = true;
      });
    }
  }

  void onPickImage() async {
    images = await pickImages(allowMultiple: false);
    setState(() {});
    print(images);
  }

  Padding buildContentItem({required String text, required bool isSelected}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 15.0, 8.0, 0.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  width: 4,
                  color:
                      isSelected ? Palette.orangeColor : Colors.transparent)),
        ),
        child: Text(
          text,
          style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontFamily: 'JetBrainsMonoBold'),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    searchController.dispose();
    groupTitleController.dispose();
    super.dispose();
  }

  PageController pageController = PageController();
  ScrollController scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();
  TextEditingController groupTitleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    bool isLoading = ref.watch(chatControllerProvider);
    final currentUser = ref.read(userProvider)!;
    super.build(context);
    return Scaffold(
      appBar: CupertinoNavigationBar(
        leading: widget.isForChat! || widget.isForCloseFriends!
            ? CupertinoButton(
                padding: EdgeInsets.zero,
                child: Text(
                  widget.isForChat! && currentPage == 1 ? 'geri' : 'kapat',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      fontFamily: 'JetBrainsMonoRegular'),
                ),
                onPressed: () {
                  if (currentPage == 0) {
                    Navigator.pop(context);
                  } else {
                    pageController.animateToPage(0,
                        duration: Duration(milliseconds: 200),
                        curve: Curves.bounceInOut);
                  }
                })
            : null,
        automaticallyImplyLeading: false,
        transitionBetweenRoutes: false,
        backgroundColor: Palette.backgroundColor,
        middle: Column(
          children: [
            if (widget.isForChat! || widget.isForCloseFriends!)
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                height: 5,
                width: 40,
                decoration: BoxDecoration(
                    color: Palette.darkGreyColor2,
                    borderRadius: BorderRadius.circular(100)),
              ),
            largeText(
                widget.isForChat!
                    ? 'yeni sohbet'
                    : widget.isForCloseFriends!
                        ? 'yakın arkadaş ekle'
                        : 'ara',
                false),
          ],
        ),
      ),
      body: isLoading
          ? Loader()
          : PageView(
              physics: NeverScrollableScrollPhysics(),
              onPageChanged: (value) => setState(() {
                currentPage = value;
              }),
              controller: pageController,
              children: [
                Column(
                  children: [
                    Form(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10),
                        child: SizedBox(
                          height: 40,
                          child: CupertinoTextField(
                            cursorColor: Palette.themeColor,
                            onChanged: (text) {
                              setState(() {
                                query = text;
                              });
                            },
                            controller: searchController,
                            decoration: BoxDecoration(
                              color: Palette.textFieldColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: "JetBrainsMonoRegular",
                            ),
                            placeholder: 'ara',
                            placeholderStyle: const TextStyle(
                              color: Palette.placeholderColor,
                              fontFamily: 'JetBrainsMonoBold',
                            ),
                          ),
                        ),
                      ),
                    ),
                    if ((widget.isForChat! || widget.isForCloseFriends!) &&
                        selectedProfiles.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: SingleChildScrollView(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                                selectedProfiles.length,
                                (index) => Padding(
                                      padding: const EdgeInsets.all(8.0)
                                          .copyWith(left: 0, right: 10),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Stack(
                                              clipBehavior: Clip.none,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                  child: Image.network(
                                                    selectedProfiles[index]
                                                        .profilePic,
                                                    height: 50,
                                                    width: 50,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                Positioned(
                                                  top: -8,
                                                  right: -8,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        selectedProfileUids
                                                            .remove(
                                                                selectedProfiles[
                                                                        index]
                                                                    .uid);
                                                        selectedProfiles.remove(
                                                            selectedProfiles[
                                                                index]);
                                                      });
                                                    },
                                                    child: CircleAvatar(
                                                        radius: 12,
                                                        backgroundColor: Palette
                                                            .darkGreyColor2,
                                                        child: Icon(
                                                          CupertinoIcons.clear,
                                                          size: 15,
                                                        )),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            SizedBox(
                                              width: 55,
                                              child: Text(
                                                selectedProfiles[index]
                                                    .username,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(fontSize: 11),
                                                textAlign: TextAlign.center,
                                              ),
                                            )
                                          ]),
                                    )),
                          ),
                        ),
                      ),
                    if (!widget.isForChat! && !widget.isForCloseFriends!)
                      Column(
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children:
                                  List.generate(contentItems.length, (index) {
                                return CupertinoButton(
                                  onPressed: () =>
                                      selectAndUnselectOthers(index),
                                  padding: EdgeInsets.zero,
                                  child: buildContentItem(
                                      text: contentItems[index][0].toString(),
                                      isSelected: contentItems[index][1]),
                                );
                              })),
                          const Divider(
                            thickness: 0.5,
                            height: 0,
                          ),
                        ],
                      ),
                    if (widget.isForCloseFriends!)
                      Expanded(
                        child: ref.watch(searchFollowerProvider(query)).when(
                              data: (List<UserModel> items) {
                                items.remove(currentUser);
                                return Scrollbar(
                                  scrollbarOrientation:
                                      ScrollbarOrientation.right,
                                  thumbVisibility: true,
                                  trackVisibility: true,
                                  controller: scrollController,
                                  child: ListView.builder(
                                    controller: scrollController,
                                    itemCount: items.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final item = items[index];

                                      return ListTile(
                                        leading: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          child: Image.network(
                                            item.profilePic,
                                            height: 40,
                                            width: 40,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        title: Text(item.name),
                                        subtitle: Text(
                                          "@" + item.username,
                                          style: TextStyle(
                                              color: Palette.placeholderColor),
                                        ),
                                        onTap: () {
                                          if (widget.isForChat! ||
                                              widget.isForCloseFriends!) {
                                            if (!selectedProfiles
                                                    .contains(item) &&
                                                !selectedProfileUids
                                                    .contains(item.uid)) {
                                              setState(() {
                                                selectedProfiles.add(item);
                                                selectedProfileUids
                                                    .add(item.uid);
                                              });
                                              print(selectedProfiles);
                                            } else {
                                              setState(() {
                                                selectedProfiles.remove(item);
                                                selectedProfileUids
                                                    .remove(item.uid);
                                              });
                                            }
                                          } else {
                                            navigateToProfile(context, item);
                                          }
                                        },
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            if (item.roles
                                                .contains('appbeyoglu-user'))
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                child: Image.asset(
                                                  'assets/appbeyoglu-icon.png',
                                                  height: 35,
                                                  width: 35,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            if (selectedProfiles
                                                    .contains(item) &&
                                                (widget.isForChat! ||
                                                    widget.isForCloseFriends!))
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 15.0),
                                                child: CircleAvatar(
                                                  radius: 12,
                                                  backgroundColor:
                                                      Palette.themeColor,
                                                  child: Center(
                                                    child: Icon(
                                                      UniconsLine.check,
                                                      size: 20,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            else if (!selectedProfiles
                                                    .contains(item) &&
                                                (widget.isForChat! ||
                                                    widget.isForCloseFriends!))
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 15.0),
                                                child: CircleAvatar(
                                                  radius: 12,
                                                  backgroundColor:
                                                      Palette.darkGreyColor2,
                                                ),
                                              )
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                              error: (error, stackTrace) {
                                print(error.toString());
                                return ErrorText(
                                  error: error.toString(),
                                );
                              },
                              loading: () => const Loader(),
                            ),
                      ),
                    if (contentItems.first[1] && !widget.isForCloseFriends!)
                      Expanded(
                        child: ref.watch(searchUserProvider(query)).when(
                              data: (List<UserModel> items) => Scrollbar(
                                scrollbarOrientation:
                                    ScrollbarOrientation.right,
                                thumbVisibility: true,
                                trackVisibility: true,
                                controller: scrollController,
                                child: ListView.builder(
                                  controller: scrollController,
                                  itemCount: items.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final item = items[index];

                                    return ListTile(
                                      leading: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        child: Image.network(
                                          item.profilePic,
                                          height: 40,
                                          width: 40,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      title: Text(item.name),
                                      subtitle: Text(
                                        "@" + item.username,
                                        style: TextStyle(
                                            color: Palette.placeholderColor),
                                      ),
                                      onTap: () {
                                        if (widget.isForChat!) {
                                          if (!selectedProfiles
                                                  .contains(item) &&
                                              !selectedProfileUids
                                                  .contains(item.uid)) {
                                            setState(() {
                                              selectedProfiles.add(item);
                                              selectedProfileUids.add(item.uid);
                                            });
                                            print(selectedProfiles);
                                          } else {
                                            setState(() {
                                              selectedProfiles.remove(item);
                                              selectedProfileUids
                                                  .remove(item.uid);
                                            });
                                          }
                                        } else {
                                          navigateToProfile(context, item);
                                        }
                                      },
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (item.roles
                                              .contains('appbeyoglu-user'))
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: Image.asset(
                                                'assets/appbeyoglu-icon.png',
                                                height: 35,
                                                width: 35,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          if (selectedProfiles.contains(item) &&
                                              widget.isForChat!)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15.0),
                                              child: CircleAvatar(
                                                radius: 12,
                                                backgroundColor:
                                                    Palette.themeColor,
                                                child: Center(
                                                  child: Icon(
                                                    UniconsLine.check,
                                                    size: 20,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            )
                                          else if (!selectedProfiles
                                                  .contains(item) &&
                                              widget.isForChat!)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15.0),
                                              child: CircleAvatar(
                                                radius: 12,
                                                backgroundColor:
                                                    Palette.darkGreyColor2,
                                              ),
                                            )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              error: (error, stackTrace) => ErrorText(
                                error: error.toString(),
                              ),
                              loading: () => const Loader(),
                            ),
                      )
                    else if (!widget.isForCloseFriends!)
                      Expanded(
                        child: ref.watch(searchSchoolProvider(query)).when(
                              data: (List<School> items) => Scrollbar(
                                scrollbarOrientation:
                                    ScrollbarOrientation.right,
                                thumbVisibility: true,
                                trackVisibility: true,
                                controller: scrollController,
                                child: ListView.builder(
                                  controller: scrollController,
                                  itemCount: items.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final item = items[index];

                                    return ListTile(
                                      leading: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        child: Image.network(
                                          item.avatar,
                                          height: 40,
                                          width: 40,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      title: Text(item.title),
                                      subtitle: Text(
                                        item.id,
                                        style: TextStyle(
                                            color: Palette.placeholderColor),
                                      ),
                                      onTap: () {
                                        navigateToSchool(
                                            context, item.id as String);
                                      },
                                    );
                                  },
                                ),
                              ),
                              error: (error, stackTrace) => ErrorText(
                                error: error.toString(),
                              ),
                              loading: () => const Loader(),
                            ),
                      ),
                  ],
                ),
                if (widget.isForChat!)
                  ListView(
                    children: [
                      ListTile(
                        leading: CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: onPickImage,
                          child: Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                color: Palette.darkGreyColor2,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: images.isEmpty
                                  ? Icon(
                                      CupertinoIcons.camera,
                                      color: Colors.white,
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.file(
                                        images.first,
                                        fit: BoxFit.cover,
                                      ))),
                        ),
                        title: CupertinoTextField(
                          controller: groupTitleController,
                          cursorColor: Palette.themeColor,
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'JetBrainsMonoRegular'),
                          placeholder: 'grup başlığı',
                          placeholderStyle: TextStyle(
                              color: Palette.placeholderColor,
                              fontFamily: 'JetBrainsMonoRegular'),
                          decoration: BoxDecoration(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 20)
                            .copyWith(bottom: 10),
                        child: largeText('üyeler', false),
                      ),
                      Column(
                        children:
                            List.generate(selectedProfiles.length, (index) {
                          final item = selectedProfiles[index];
                          return ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.network(
                                item.profilePic,
                                height: 40,
                                width: 40,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(item.name),
                            subtitle: Text(
                              "@" + item.username,
                              style: TextStyle(color: Palette.placeholderColor),
                            ),
                            onTap: () {
                              if (widget.isForChat!) {
                                if (!selectedProfiles.contains(item) &&
                                    !selectedProfileUids.contains(item.uid)) {
                                  setState(() {
                                    selectedProfiles.add(item);
                                    selectedProfileUids.add(item.uid);
                                  });
                                  print(selectedProfiles);
                                } else {
                                  setState(() {
                                    selectedProfiles.remove(item);
                                    selectedProfileUids.remove(item.uid);
                                  });
                                }
                              } else {
                                navigateToProfile(context, item);
                              }
                            },
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (item.roles.contains('appbeyoglu-user'))
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.asset(
                                      'assets/appbeyoglu-icon.png',
                                      height: 35,
                                      width: 35,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                if (selectedProfiles.contains(item))
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedProfileUids.remove(item.uid);
                                        selectedProfiles.remove(item);
                                      });
                                    },
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 15.0),
                                      child: Center(
                                        child: Icon(
                                          CupertinoIcons.clear,
                                          size: 22,
                                          color: Palette.redColor,
                                        ),
                                      ),
                                    ),
                                  )
                              ],
                            ),
                          );
                        }),
                      )
                    ],
                  ),
              ],
            ),
      bottomNavigationBar: isLoading
          ? null
          : widget.isForChat!
              ? forChatNavBar(context)
              : widget.isForCloseFriends!
                  ? forCloseFriendsNavBar(context, currentUser)
                  : null,
    );
  }

  SafeArea forChatNavBar(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(width: 0.5, color: Palette.darkGreyColor2))),
        child: Row(
          children: [
            if (selectedProfiles.length == 1 && currentPage == 0)
              CupertinoButton(
                child: Text(
                  'sohbet aç',
                  style: TextStyle(
                      color: Palette.themeColor,
                      fontFamily: 'JetBrainsMonoRegular'),
                ),
                onPressed: () {
                  // this is a dm
                  ref.read(chatControllerProvider.notifier).startChat(
                      uids: [selectedProfileUids.first],
                      title: '',
                      description: '',
                      profilePic: null,
                      context: context,
                      isDM: true);
                  //close this bottom sheet
                  //navigate to chat page
                },
              ),
            Spacer(),
            CupertinoButton(
              child: Text(
                selectedProfiles.isEmpty
                    ? 'en az bir kişi seçin'
                    : 'grup oluştur',
                style: TextStyle(
                    color: selectedProfiles.length > 1
                        ? Palette.themeColor
                        : selectedProfiles.length == 1
                            ? Palette.themeColor
                            : Colors.white,
                    fontFamily: 'JetBrainsMonoRegular'),
              ),
              onPressed: () {
                bool isDM = selectedProfileUids.length == 1;
                if (selectedProfileUids.isEmpty) {
                  pageController.animateToPage(0,
                      duration: Duration(milliseconds: 200),
                      curve: Curves.bounceInOut);
                } else if (selectedProfileUids.length >= 1 &&
                    currentPage == 0) {
                  // going to create a group

                  //go to setting title and a profile pic for group page
                  pageController.animateToPage(1,
                      duration: Duration(milliseconds: 200),
                      curve: Curves.bounceInOut);
                } else if (selectedProfileUids.length >= 1 &&
                    currentPage == 1) {
                  if (groupTitleController.text.trim().isNotEmpty) {
                    ref.read(chatControllerProvider.notifier).startChat(
                        uids: selectedProfileUids,
                        title: groupTitleController.text.trim(),
                        description: '',
                        profilePic: images.isEmpty ? null : images.first,
                        context: context,
                        isDM: false);
                  }
                }
              },
            )
          ],
        ),
      ),
    );
  }

  SafeArea forCloseFriendsNavBar(BuildContext context, UserModel currentUser) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(width: 0.5, color: Palette.darkGreyColor2))),
        child: Row(
          children: [
            Spacer(),
            CupertinoButton(
              child: Text(
                selectedProfiles.isEmpty
                    ? 'en az bir kişi seçin'
                    : 'yakın arkadaş ekle',
                style: TextStyle(
                    color: selectedProfiles.length > 1
                        ? Palette.themeColor
                        : selectedProfiles.length == 1
                            ? Palette.themeColor
                            : Colors.white,
                    fontFamily: 'JetBrainsMonoRegular'),
              ),
              onPressed: () {
                if (widget.isForCloseFriends!) {
                  ref
                      .read(userProfileControllerProvider.notifier)
                      .addCloseFriend(context, selectedProfiles, currentUser);
                } else {
                  bool isDM = selectedProfileUids.length == 1;
                  if (selectedProfileUids.isEmpty) {
                    pageController.animateToPage(0,
                        duration: Duration(milliseconds: 200),
                        curve: Curves.bounceInOut);
                  } else if (selectedProfileUids.length >= 1 &&
                      currentPage == 0) {
                    // going to create a group

                    //go to setting title and a profile pic for group page
                    pageController.animateToPage(1,
                        duration: Duration(milliseconds: 200),
                        curve: Curves.bounceInOut);
                  } else if (selectedProfileUids.length >= 1 &&
                      currentPage == 1) {
                    if (groupTitleController.text.trim().isNotEmpty) {
                      ref.read(chatControllerProvider.notifier).startChat(
                          uids: selectedProfileUids,
                          title: groupTitleController.text.trim(),
                          description: '',
                          profilePic: images.isEmpty ? null : images.first,
                          context: context,
                          isDM: false);
                    }
                  }
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
