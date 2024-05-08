import 'dart:io';
import 'package:acc/core/commons/large_text.dart';
import 'package:acc/features/chats/controller/chat_controller.dart';
import 'package:acc/features/chats/screens/chat_details.dart';
import 'package:acc/features/chats/widgets/message_card.dart';
import 'package:acc/features/chats/widgets/reactions_my.dart';
import 'package:acc/models/chat_model.dart';
import 'package:acc/models/message_model.dart';
import 'package:acc/models/user_model.dart';
import 'package:acc/theme/palette.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_chat_reactions/model/menu_item.dart';
import 'package:flutter_chat_reactions/utilities/hero_dialog_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:unicons/unicons.dart';

import '../../../core/commons/nav_bar_button.dart';
import '../../../core/constants/constants.dart';
import '../../../core/utils.dart';
import '../../auth/controller/auth_controller.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final ChatModel chat;
  const ChatScreen({
    super.key,
    required this.chat,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  ScrollController scrollController = ScrollController();
  bool notScrolled = true;
  void reactMessage(MessageModel message, UserModel currentUser,
      String reaction, BuildContext context) {
    ref
        .read(chatControllerProvider.notifier)
        .reactMessage(message, currentUser, reaction, context);
  }

  @override
  void initState() {
    super.initState();

    // Setup the listener.
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels !=
            scrollController.position.maxScrollExtent) {
          setState(() {
            notScrolled = true;
          });
        }
        // if (scrollController.position.pixels ==
        //     scrollController.position.maxScrollExtent) {
        //   setState(() {
        //     isLoading = false;
        //   });
        //   // Page is all the way down
        //   // Add your code here
        // }
      }
    });
  }

  @override
  void dispose() {
    messageController.dispose();

    super.dispose();
  }

  String formattedDate(DateTime date) {
    initializeDateFormatting('tr-TR', null);
    // initializeDateFormatting('tr_TR', null).then(onValue)
    // final DateFormat formatter =
    final formatted = DateFormat(
            DateTime.now().difference(date).inDays > 365
                ? 'EEE, d/M/y'
                : 'EEE, d MMM',
            'tr-TR')
        .format(date);
    // final String formatted = formatter.format(date);
    return formatted; // something like 2013-04-20
  }

  int counter = 0;
  int currentCarouselIndex = 0;
  List<File> images = [];
  void onPickImages() async {
    images = await pickImages(allowMultiple: false);
    setState(() {});
  }

  void deleteMessage(MessageModel message, BuildContext context) {
    ref.read(chatControllerProvider.notifier).deleteMessage(message, context);
  }

  Future sendMessage(bool isLoading) async {
    setState(() {
      counter += 1;
    });

    String link = getLinkFromText(messageController.text);
    if (images.isNotEmpty) {
      ref.read(chatControllerProvider.notifier).sendImageMessage(
          context: context,
          link: link,
          content: messageController.text.trim(),
          imageFiles: images,
          chatId: widget.chat.id);
    } else if (messageController.text.isNotEmpty) {
      ref.read(chatControllerProvider.notifier).sendTextMessage(
          context: context,
          content: messageController.text.trim(),
          link: link,
          chatId: widget.chat.id);
    }

    messageController.clear();
    if (images.isEmpty) {
      scrollController.jumpTo(scrollController.position.minScrollExtent);
    }
    images.clear();
    setState(() {});
  }

  Widget buildImages(bool isLoading) {
    return SafeArea(
      child: Stack(
        alignment: Alignment.center,
        children: [
          PageView.builder(
            controller: pageController,
            onPageChanged: (val) => setState(() {
              currentCarouselIndex = val;
            }),
            itemCount: images.length,
            itemBuilder: (context, index) {
              final imageFile = images[index];
              return Image.file(
                imageFile,
                fit: BoxFit.contain,
              );
            },
          ),
          if (images.length > 1)
            Positioned(
              bottom: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                    images.length,
                    (index) => GestureDetector(
                          onTap: () {
                            if (currentCarouselIndex == index) {
                              setState(() {
                                images.remove(images[index]);
                              });
                            } else {
                              pageController.animateToPage(index,
                                  duration: Duration(milliseconds: 200),
                                  curve: Curves.bounceInOut);
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 5),
                            height: 45,
                            width: 45,
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(width: 1.5, color: Colors.white),
                              image: DecorationImage(
                                  image: FileImage(images[index]),
                                  fit: BoxFit.cover),
                              color: currentCarouselIndex == index
                                  ? Palette.themeColor
                                  : Palette.noteIconColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: currentCarouselIndex == index
                                ? Icon(
                                    CupertinoIcons.delete,
                                    color: Palette.redColor,
                                    size: 30,
                                  )
                                : SizedBox(),
                          ),
                        )),
              ),
            ),
        ],
      ),
    );
  }

  PageController pageController = PageController();
  ScrollController textFieldScrollController = ScrollController();

  TextEditingController messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final currentUser = ref.read(userProvider)!;
    bool isLoading = ref.watch(chatControllerProvider);
    return ref.watch(getChatContentProvider(widget.chat.id)).when(
        data: (messages) {
          return SafeArea(
            child: Scaffold(
              appBar: CupertinoNavigationBar(
                transitionBetweenRoutes: false,
                backgroundColor: Colors.black,
                middle: GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) =>
                                ChatDetails(chat: widget.chat))),
                    child: largeText(widget.chat.title, false)),
                leading: JustIconButton(
                    icon: CupertinoIcons.back,
                    onPressed: () => Navigator.of(context).pop()),
                border: Border(
                    bottom:
                        BorderSide(width: 0.5, color: Palette.darkGreyColor2)),
                // trailing: JustIconButton(icon: Icons.more_horiz, onPressed: () {}),
              ),
              body: images.isNotEmpty
                  ? buildImages(isLoading)
                  : messages.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            'dostum. çabuk bi sohbet başlat.. ayıptır.',
                            style: TextStyle(
                                color: Palette.orangeColor, fontSize: 25),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : Stack(
                          alignment: Alignment.center,
                          children: [
                            Scrollbar(
                              scrollbarOrientation: ScrollbarOrientation.right,
                              thumbVisibility: true,
                              trackVisibility: true,
                              controller: scrollController,
                              child: ListView.builder(
                                reverse: true,
                                keyboardDismissBehavior:
                                    ScrollViewKeyboardDismissBehavior.onDrag,
                                controller: scrollController,
                                padding: EdgeInsets.only(
                                    bottom: 70, right: 12, left: 10),
                                // physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: messages.length,
                                itemBuilder: (BuildContext context, int index) {
                                  MessageModel message = messages[index];
                                  MessageModel? previousMessage =
                                      index + 1 != messages.length
                                          ? messages[index + 1]
                                          : null;
                                  MessageModel? nextMessage = (index - 1 >= 0)
                                      ? messages[index - 1]
                                      : null;
                                  bool showDate = previousMessage == null
                                      ? true
                                      : message.createdAt
                                              .difference(
                                                  previousMessage.createdAt)
                                              .inDays >=
                                          1;
                                  bool isPreviousMessageSameAuthor =
                                      index + 1 != messages.length
                                          ? messages[index].uid ==
                                              messages[index + 1].uid
                                          : false;
                                  bool isNextMessageSameAuthor1 =
                                      (index - 1 >= 0)
                                          ? messages[index].uid ==
                                              messages[index - 1].uid
                                          : false;
                                  print(isNextMessageSameAuthor1);

                                  return Column(
                                    children: [
                                      if (showDate)
                                        Align(
                                            alignment: Alignment.center,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5.0, bottom: 2),
                                              child: Text(
                                                formattedDate(
                                                    message.createdAt),
                                                style: TextStyle(
                                                    color:
                                                        Palette.justGrayColor),
                                              ),
                                            )),
                                      if (widget.chat.isDM &&
                                          message.uid != currentUser.uid &&
                                          !isPreviousMessageSameAuthor)
                                        ref
                                            .watch(getUserDataProvider(
                                                message.uid))
                                            .when(
                                                data: (data) => Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 5.0,
                                                              bottom: 2),
                                                      child: Text(
                                                        "@" + data.username,
                                                        style: TextStyle(
                                                            color: Palette
                                                                .justGrayColor),
                                                      ),
                                                    )),
                                                error: (error, stackTrace) =>
                                                    Text(error.toString()),
                                                loading: () => Text('')),
                                      GestureDetector(
                                        onLongPress: () =>
                                            Navigator.of(context).push(
                                          HeroDialogRoute(
                                            builder: (context) {
                                              return ReactionsDialogWidget(
                                                widgetAlignment: message.uid ==
                                                        currentUser.uid
                                                    ? Alignment.centerRight
                                                    : Alignment.centerLeft,
                                                id: message
                                                    .id, // unique id for message
                                                messageWidget: MessageCard(
                                                    message: message,
                                                    isNextMessageSameAuthor:
                                                        isNextMessageSameAuthor1,
                                                    isPreviousMessageSameAuthor:
                                                        isPreviousMessageSameAuthor), // message widget
                                                onReactionTap: (reaction) {
                                                  print('reaction: $reaction');
                                                  if (reaction == '➕') {
                                                    // show emoji picker container
                                                  } else {
                                                    reactMessage(
                                                      message,
                                                      currentUser,
                                                      reaction,
                                                      context,
                                                    );
                                                  }
                                                },
                                                menuItems: [
                                                  MenuItem(
                                                    label: 'kopyala',
                                                    icon: UniconsLine.copy,
                                                  ),
                                                  if (message.uid ==
                                                      currentUser.uid)
                                                    MenuItem(
                                                      label: 'sil',
                                                      icon:
                                                          CupertinoIcons.delete,
                                                      isDestuctive: true,
                                                    )
                                                ],
                                                onContextMenuTap: (menuItem) {
                                                  print(
                                                      'menu item: ${menuItem}');
                                                  if (menuItem.isDestuctive) {
                                                    if (message.uid ==
                                                        currentUser.uid) {
                                                      deleteMessage(
                                                          message, context);
                                                    } //else {
                                                    //   showCupertinoModalPopup(
                                                    //     context: context,
                                                    //     builder: (context) =>
                                                    //         CupertinoTheme(
                                                    //       data:
                                                    //           const CupertinoThemeData(
                                                    //               brightness:
                                                    //                   Brightness
                                                    //                       .dark),
                                                    //       child:
                                                    //           CupertinoActionSheet(
                                                    //         cancelButton:
                                                    //             CupertinoActionSheetAction(
                                                    //                 child:
                                                    //                     const Text(
                                                    //                         'Back'),
                                                    //                 onPressed: () {
                                                    //                   Navigator.of(
                                                    //                           context)
                                                    //                       .pop();
                                                    //                 }),
                                                    //         actions: [
                                                    //           CupertinoActionSheetAction(
                                                    //               child: const Text(
                                                    //                 'benden sil',
                                                    //                 style: TextStyle(
                                                    //                     color: Palette
                                                    //                         .redColor),
                                                    //               ),
                                                    //               onPressed: () {
                                                    //                 Navigator.of(
                                                    //                         context)
                                                    //                     .pop();
                                                    //               })
                                                    //         ],
                                                    //       ),
                                                    //     ),
                                                    //   );
                                                    // }
                                                  }

                                                  // handle context menu item
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                        child: Hero(
                                            tag: message.id,
                                            child: MessageCard(
                                              message: message,
                                              isPreviousMessageSameAuthor:
                                                  isPreviousMessageSameAuthor,
                                              isNextMessageSameAuthor:
                                                  isNextMessageSameAuthor1,
                                            )),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            if (isLoading)
                              Positioned(
                                child: Container(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  color: Colors.transparent,
                                  child: Center(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Palette.darkGreyColor,
                                      ),
                                      padding: EdgeInsets.all(25),
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Palette.themeColor),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                          ],
                        ),
              bottomSheet: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: const BoxDecoration(
                    color: Colors.black,
                    border: Border(
                        top: BorderSide(
                            width: 0.5, color: Palette.darkGreyColor2))),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
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
                          colorFilter: const ColorFilter.mode(
                              Colors.white, BlendMode.srcIn),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 7,
                    ),
                    Form(
                      child: Expanded(
                        child: Scrollbar(
                          scrollbarOrientation: ScrollbarOrientation.right,
                          thumbVisibility: true,
                          trackVisibility: true,
                          controller: textFieldScrollController,
                          child: CupertinoTextField(
                            keyboardType: TextInputType.multiline,
                            cursorColor: Palette.themeColor,
                            scrollController: textFieldScrollController,
                            maxLines: 4,
                            minLines: 1,
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'JetBrainsMonoRegular',
                            ),
                            controller: messageController,
                            decoration: BoxDecoration(
                                color: Palette.darkGreyColor,
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 6.0,
                    ),
                    SizedBox(
                      width: 35,
                      height: 35,
                      child: CupertinoButton(
                        borderRadius: BorderRadius.circular(130.0),
                        padding: EdgeInsets.zero,
                        color: Palette.themeColor,
                        onPressed: () => sendMessage(isLoading),
                        //   final currentUser = ref.read(userProvider)!;
                        //   String currentUserUid = currentUser.uid;
                        //   if (commentController.text.trim().isNotEmpty) {
                        //     String link =
                        //         getLinkFromText(commentController.text.trim());
                        //     if (note.uid != currentUserUid) {
                        //       ref
                        //           .read(notificationControllerProvider.notifier)
                        //           .sendNotification(
                        //             context: context,
                        //             content:
                        //                 "${currentUser.username} notuna yorum bıraktı",
                        //             type: "comment",
                        //             id: "${note.id}-comment",
                        //             receiverUid: note.uid,
                        //             senderId: currentUserUid,
                        //             noteId: note.id,
                        //           );
                        //     }
                        //     ref
                        //         .read(noteControllerProvider.notifier)
                        //         .shareTextNote(
                        //           context: context,
                        //           selectedSchoolId: note.schoolName,
                        //           content: messageController.text.trim(),
                        //           link: link,
                        //           repliedTo: widget.noteId,
                        //         );
                        //   }
                        //   messageController.clear();
                        // },
                        child: SvgPicture.asset(
                          Constants.send,
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                          height: 20,
                          width: 20,
                          colorFilter: const ColorFilter.mode(
                              Colors.black, BlendMode.srcIn),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        error: (error, stackTrace) => Text(error.toString()),
        loading: () => SizedBox());
  }
}
// import 'dart:io';
// import 'package:acc/core/commons/loader.dart';
// import 'package:dash_chat_2/dash_chat_2.dart';
// import 'package:acc/core/commons/large_text.dart';
// import 'package:acc/features/chats/controller/chat_controller.dart';
// import 'package:acc/features/chats/widgets/message_card.dart';
// import 'package:acc/features/chats/widgets/reactions_my.dart';
// import 'package:acc/models/chat_model.dart';
// import 'package:acc/models/message_model.dart';
// import 'package:acc/models/user_model.dart';
// import 'package:acc/theme/palette.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';

// import 'package:flutter_chat_reactions/utilities/hero_dialog_route.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// import '../../../core/commons/nav_bar_button.dart';
// import '../../../core/constants/constants.dart';
// import '../../../core/utils.dart';
// import '../../auth/controller/auth_controller.dart';

// class ChatScreen extends ConsumerStatefulWidget {
//   final ChatModel chat;
//   const ChatScreen({
//     super.key,
//     required this.chat,
//   });

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends ConsumerState<ChatScreen> {
//   ScrollController scrollController = ScrollController();
//   bool notScrolled = true;
//   void reactMessage(MessageModel message, UserModel currentUser,
//       String reaction, BuildContext context) {
//     ref
//         .read(chatControllerProvider.notifier)
//         .reactMessage(message, currentUser, reaction, context);
//   }

//   @override
//   void initState() {
//     super.initState();
//     // Setup the listener.
//     scrollController.addListener(() {
//       if (scrollController.position.atEdge) {
//         if (scrollController.position.pixels !=
//             scrollController.position.maxScrollExtent) {
//           setState(() {
//             notScrolled = true;
//           });
//         }
//         // if (scrollController.position.pixels ==
//         //     scrollController.position.maxScrollExtent) {
//         //   setState(() {
//         //     isLoading = false;
//         //   });
//         //   // Page is all the way down
//         //   // Add your code here
//         // }
//       }
//     });
//   }

//   @override
//   void dispose() {
//     messageController.dispose();

//     super.dispose();
//   }

//   int counter = 0;
//   int currentCarouselIndex = 0;
//   List<File> images = [];
//   void onPickImages() async {
//     images = await pickImages(allowMultiple: false);
//     setState(() {});
//   }

//   Future sendMessage(bool isLoading) async {
//     setState(() {
//       counter += 1;
//     });

//     String link = getLinkFromText(messageController.text);
//     if (images.isNotEmpty) {
//       ref.read(chatControllerProvider.notifier).sendImageMessage(
//           context: context,
//           link: link,
//           content: messageController.text.trim(),
//           imageFiles: images,
//           chatId: widget.chat.id);
//     } else if (messageController.text.isNotEmpty) {
//       ref.read(chatControllerProvider.notifier).sendTextMessage(
//           context: context,
//           content: messageController.text.trim(),
//           link: link,
//           chatId: widget.chat.id);
//     }

//     messageController.clear();
//     if (images.isEmpty) {
//       scrollController.jumpTo(scrollController.position.minScrollExtent);
//     }
//     images.clear();
//     setState(() {});
//   }

//   Widget buildImages(bool isLoading) {
//     return SafeArea(
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           PageView.builder(
//             controller: pageController,
//             onPageChanged: (val) => setState(() {
//               currentCarouselIndex = val;
//             }),
//             itemCount: images.length,
//             itemBuilder: (context, index) {
//               final imageFile = images[index];
//               return Image.file(
//                 imageFile,
//                 fit: BoxFit.contain,
//               );
//             },
//           ),
//           if (images.length > 1)
//             Positioned(
//               bottom: 70,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: List.generate(
//                     images.length,
//                     (index) => GestureDetector(
//                           onTap: () {
//                             if (currentCarouselIndex == index) {
//                               setState(() {
//                                 images.remove(images[index]);
//                               });
//                             } else {
//                               pageController.animateToPage(index,
//                                   duration: Duration(milliseconds: 200),
//                                   curve: Curves.bounceInOut);
//                             }
//                           },
//                           child: Container(
//                             margin: EdgeInsets.only(right: 5),
//                             height: 45,
//                             width: 45,
//                             padding: EdgeInsets.all(3),
//                             decoration: BoxDecoration(
//                               border:
//                                   Border.all(width: 1.5, color: Colors.white),
//                               image: DecorationImage(
//                                   image: FileImage(images[index]),
//                                   fit: BoxFit.cover),
//                               color: currentCarouselIndex == index
//                                   ? Palette.themeColor
//                                   : Palette.noteIconColor,
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: currentCarouselIndex == index
//                                 ? Icon(
//                                     CupertinoIcons.delete,
//                                     color: Palette.redColor,
//                                     size: 30,
//                                   )
//                                 : SizedBox(),
//                           ),
//                         )),
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   PageController pageController = PageController();
//   ScrollController textFieldScrollController = ScrollController();

//   TextEditingController messageController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     bool isLoading = ref.watch(chatControllerProvider);
//     final currentUser = ref.read(userProvider)!;
//     final chatCurrentUser = ChatUser(
//         id: currentUser.uid,
//         profileImage: currentUser.profilePic,
//         firstName: currentUser.username,
//         lastName: currentUser.name);
//     return ref.watch(getChatContentProvider(widget.chat.id)).when(
//         data: (messages) {
//           List<ChatMessage> chatMessages = messages
//               .map(
//                 (e) => ChatMessage(
//                     user: ChatUser(id: e.uid), createdAt: e.createdAt),
//               )
//               .toList();
//           return DashChat(
//               currentUser: chatCurrentUser,
//               onSend: (message) => sendMessage(isLoading),
//               messages: chatMessages);
//         },
//         error: (error, stackTrace) => Text(error.toString()),
//         loading: () => Loader());
//   }
// }
