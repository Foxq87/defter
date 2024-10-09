import 'package:acc/core/commons/image_view.dart';
import 'package:acc/core/commons/large_text.dart';
import 'package:acc/features/auth/controller/auth_controller.dart';
import 'package:acc/features/chats/controller/chat_controller.dart';
import 'package:acc/features/chats/widgets/stacked_reactions_my.dart';
import 'package:acc/features/notes/controller/note_controller.dart';
import 'package:acc/features/notes/screens/note_details.dart';
import 'package:acc/features/notes/widgets/detailed_note_card.dart';
import 'package:acc/features/notes/widgets/note_card.dart';
import 'package:acc/models/message_model.dart';
import 'package:acc/models/user_model.dart';
import 'package:acc/theme/palette.dart';
import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/commons/loader.dart';
import '../../user_profile/screens/user_profile_screen.dart';

class MessageCard extends ConsumerStatefulWidget {
  final MessageModel message;
  final bool isPreviousMessageSameAuthor;
  final bool isNextMessageSameAuthor;
  const MessageCard({
    super.key,
    required this.message,
    this.isPreviousMessageSameAuthor = false,
    this.isNextMessageSameAuthor = false,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MessageCardState();
}

class _MessageCardState extends ConsumerState<MessageCard> {
  String messageText = '';
  String noteId = '';
  @override
  void initState() {
    final link = widget.message.link;
    if (link.contains('defter.web.app/note/')) {
      // Extract the post ID or any other identifier from the link
      setState(() {
        noteId = link.split('defter.web.app/note/').last;
      });

      // Navigate to the post screen within your app
      // Get.to(() => NoteDetails(noteId: noteId));
    }
    setState(() {
      messageText = widget.message.text;
      messageText = messageText.replaceAll(widget.message.link, '');
    });

    super.initState();
  }

  @override
  void dispose() {
    noteId = '';

    super.dispose();
  }

  void removeReaction(
      UserModel currentUser, MessageModel message, String reaction) {
    ref
        .read(chatControllerProvider.notifier)
        .reactMessage(message, currentUser, '', context);
  }

  String formattedDate(DateTime date) {
    final DateFormat formatter = DateFormat('HH:mm');
    final String formatted = formatter.format(date);
    return formatted; // something like 2013-04-20
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.read(userProvider)!;
    bool isImageMessage = widget.message.imageUrls.isNotEmpty;
    bool isMyMessage = widget.message.uid == currentUser.uid;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Align(
          alignment: isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
          child: FittedBox(
            fit: BoxFit.fill,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  constraints: const BoxConstraints(
                    maxWidth: 250,
                    minWidth: 10,
                  ),
                  margin: EdgeInsets.only(
                      bottom: widget.message.reactions.isNotEmpty
                          ? 28
                          : widget.isNextMessageSameAuthor
                              ? 3
                              : 6),
                  padding: isImageMessage
                      ? EdgeInsets.zero
                      : EdgeInsets.fromLTRB(
                          isMyMessage ? 10 : 7, 10, isMyMessage ? 7 : 10, 3),
                  decoration: BoxDecoration(
                      color: isMyMessage
                          ? Palette.themeColor
                          : Palette.iconBackgroundColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(
                              widget.isPreviousMessageSameAuthor && !isMyMessage
                                  ? 6
                                  : 20),
                          topRight: Radius.circular(
                              widget.isPreviousMessageSameAuthor && isMyMessage
                                  ? 6
                                  : 20),
                          bottomLeft: isMyMessage
                              ? const Radius.circular(20)
                              : Radius.circular(
                                  widget.isNextMessageSameAuthor ? 6 : 20),
                          bottomRight: isMyMessage
                              ? Radius.circular(
                                  widget.isPreviousMessageSameAuthor && !widget.isNextMessageSameAuthor ? 20 : 6)
                              : const Radius.circular(20))),
                  child: Column(
                    crossAxisAlignment: isMyMessage
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      if (isImageMessage)
                        Stack(
                          alignment: isMyMessage
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.to(() => ImageView(
                                      imageUrls: widget.message.imageUrls,
                                      imageFiles: [],
                                      index: 0,
                                    ));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(
                                          widget.isPreviousMessageSameAuthor && !isMyMessage
                                              ? 5
                                              : 18),
                                      topRight: Radius.circular(
                                          widget.isPreviousMessageSameAuthor && isMyMessage
                                              ? 5
                                              : 18),
                                      bottomLeft: isImageMessage &&
                                              widget.message.text.isNotEmpty
                                          ? Radius.circular(5)
                                          : isMyMessage
                                              ? const Radius.circular(20)
                                              : Radius.circular(
                                                  widget.isNextMessageSameAuthor
                                                      ? 5
                                                      : 18),
                                      bottomRight: isImageMessage &&
                                              widget.message.text.isNotEmpty
                                          ? Radius.circular(5)
                                          : isMyMessage
                                              ? Radius.circular(
                                                  widget.isPreviousMessageSameAuthor &&
                                                          !widget.isNextMessageSameAuthor
                                                      ? 20
                                                      : 5)
                                              : const Radius.circular(20)),
                                  child: Image.network(
                                    widget.message.imageUrls.first,
                                    height: 125,
                                    width: 400,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      }
                                      return Center(
                                        child: SizedBox(
                                          height: 125,
                                          width: 400,
                                          child: LinearProgressIndicator(
                                            color: Palette.themeColor,
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                                right: isMyMessage ? null : 10,
                                left: isMyMessage ? 10 : null,
                                bottom: 8,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 3, vertical: 1),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Palette.darkGreyColor2
                                              .withOpacity(0.6)),
                                      child: Text(
                                        formattedDate(widget.message.createdAt),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            inherit: false,
                                            fontFamily: 'SFProDisplayRegular',
                                            fontSize: 13),
                                      ),
                                    ),
                                    // Icon(UniconsLine.check)
                                  ],
                                ))
                          ],
                        ),
                      if (widget.message.link.isNotEmpty &&
                          widget.message.link.contains('defter.web.app/note/'))
                        GestureDetector(
                          onTap: () {
                            final link = widget.message.link;
                            if (link.contains('defter.web.app/note/')) {
                              Get.to(() => NoteDetails(noteId: noteId));
                            }
                          },
                          child: ref.watch(getNoteByIdProvider(noteId)).when(
                                data: (note) => Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: Palette.darkGreyColor,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          width: 0.45,
                                          color: Palette.darkGreyColor2)),
                                  child: Column(
                                    children: [
                                      ref
                                          .watch(getUserDataProvider(note.uid))
                                          .when(
                                            data: (author) => Row(
                                              children: [
                                                Container(
                                                    height: 25,
                                                    width: 25,
                                                    decoration: BoxDecoration(
                                                        color: Palette
                                                            .iconBackgroundColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(7),
                                                        image: DecorationImage(
                                                          image: NetworkImage(
                                                            author.profilePic,
                                                          ),
                                                          onError: (exception,
                                                              stackTrace) {
                                                            // Handle error and display a placeholder image
                                                            // You can set a state or log the error here
                                                            print(
                                                                'Error loading image: $exception');
                                                          },
                                                          fit: BoxFit.cover,
                                                        )),
                                                    child: SizedBox()),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "@" + author.username,
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontFamily:
                                                          'SFProDisplayBold'),
                                                ),
                                              ],
                                            ),
                                            error: (error, stackTrace) =>
                                                Text(error.toString()),
                                            loading: () =>
                                                CupertinoActivityIndicator(),
                                          ),
                                      SizedBox(
                                        height: 7,
                                      ),
                                      Text(note.content),
                                      SizedBox(
                                        height: 7,
                                      ),
                                      if (note.imageLinks.isNotEmpty)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 10.0,
                                              bottom: 5.0,
                                              top: 5.0),
                                          child: Wrap(
                                            spacing: 7.0,
                                            runSpacing: 7.0,
                                            children: note.imageLinks
                                                .map((imageLink) {
                                              return GestureDetector(
                                                onTap: () => Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ImageView(
                                                            imageUrls:
                                                                note.imageLinks,
                                                            imageFiles: const [],
                                                            index: note
                                                                .imageLinks
                                                                .indexOf(
                                                                    imageLink)),
                                                  ),
                                                ),
                                                child: Container(
                                                  height:
                                                      note.imageLinks.length ==
                                                              1
                                                          ? 200.0
                                                          : 130.0,
                                                  width: note.imageLinks
                                                              .length ==
                                                          1
                                                      ? MediaQuery.of(context)
                                                          .size
                                                          .width
                                                      : 130.0,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        Palette.textFieldColor,
                                                    border: Border.all(
                                                        width: 0.2,
                                                        color: Colors.grey),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: Image.network(
                                                      imageLink,
                                                      fit: BoxFit.cover,
                                                      // loadingBuilder: (BuildContext
                                                      //         context,
                                                      //     Widget child,
                                                      //     ImageChunkEvent?
                                                      //         loadingProgress) {
                                                      //   if (loadingProgress ==
                                                      //       null) {
                                                      //     return child;
                                                      //   }
                                                      //   return Center(
                                                      //     child: SizedBox(
                                                      //       height: widget
                                                      //                   .note
                                                      //                   .imageLinks
                                                      //                   .length ==
                                                      //               1
                                                      //           ? 200.0
                                                      //           : 130.0,
                                                      //       width: widget
                                                      //                   .note
                                                      //                   .imageLinks
                                                      //                   .length ==
                                                      //               1
                                                      //           ? MediaQuery.of(
                                                      //                   context)
                                                      //               .size
                                                      //               .width
                                                      //           : 130.0,
                                                      //       child:
                                                      //           LinearProgressIndicator(
                                                      //         color: Palette
                                                      //             .themeColor,
                                                      //         value: loadingProgress
                                                      //                     .expectedTotalBytes !=
                                                      //                 null
                                                      //             ? loadingProgress
                                                      //                     .cumulativeBytesLoaded /
                                                      //                 loadingProgress
                                                      //                     .expectedTotalBytes!
                                                      //             : null,
                                                      //       ),
                                                      //     ),
                                                      //   );
                                                      // },
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                error: (error, stackTrace) =>
                                    Text(error.toString()),
                                loading: () => CupertinoActivityIndicator(),
                              ),
                        )
                      else if (widget.message.link.isNotEmpty)
                        AnyLinkPreview(
                          backgroundColor: Colors.grey.withOpacity(0.3),
                          removeElevation: true,
                          displayDirection: UIDirection.uiDirectionVertical,
                          errorImage: '',
                          previewHeight: 100,
                          link: widget.message.link,
                        ),
                      if (widget.message.text.isNotEmpty)
                        Padding(
                          padding: isImageMessage
                              ? EdgeInsets.symmetric(
                                  horizontal: 7,
                                ).copyWith(bottom: 7, top: 5)
                              : EdgeInsets.zero,
                          child: Text(
                            messageText,
                            style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'SFProDisplayRegular',
                                fontSize: 16,
                                inherit: false),
                          ),
                        ),
                      if (!isImageMessage)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              formattedDate(widget.message.createdAt),
                              style: TextStyle(
                                  color: isMyMessage
                                      ? Colors.grey[700]
                                      : Palette.lightGreyColor,
                                  inherit: false,
                                  fontFamily: 'SFProDisplayRegular',
                                  fontSize: 12),
                            ),
                            // Icon(UniconsLine.check)
                          ],
                        )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          // the position where to show your reaction
          bottom: 7,
          right: isMyMessage ? 5 : null,
          left: isMyMessage ? null : 5,
          child: GestureDetector(
            onTap: () {
              showModalBottomSheet(
                  useSafeArea: true,
                  isScrollControlled: true,
                  backgroundColor: Palette.darkGreyColor,
                  context: context,
                  builder: (BuildContext context) {
                    return FractionallySizedBox(
                        heightFactor: 0.6,
                        widthFactor: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              largeText('ifadeler', false),
                              Expanded(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: widget.message.reactions.length,
                                  itemBuilder: (context, index) {
                                    return ref
                                        .watch(getUserDataProvider(widget
                                            .message.reactions[index]['uid']))
                                        .when(
                                          data: (user) => ListTile(
                                              contentPadding: EdgeInsets.zero,
                                              leading: CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    user.profilePic),
                                              ),
                                              title: Text(
                                                  user.uid == currentUser.uid
                                                      ? "sen"
                                                      : user.name),
                                              subtitle: user.uid ==
                                                      currentUser.uid
                                                  ? Text(
                                                      "geri almak için dokunun",
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 12),
                                                    )
                                                  : null,
                                              trailing: Text(
                                                widget.message.reactions[index]
                                                    ['reaction'],
                                                style: TextStyle(fontSize: 20),
                                              ),
                                              onTap: () {
                                                if (user.uid ==
                                                    currentUser.uid) {
                                                  removeReaction(
                                                      currentUser,
                                                      widget.message,
                                                      widget.message
                                                              .reactions[index]
                                                          ['reaction']);
                                                } else {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            UserProfileScreen(
                                                                uid: widget
                                                                        .message
                                                                        .reactions[
                                                                    index]['uid']),
                                                      ));
                                                }
                                              }),
                                          error: (error, stackTrace) =>
                                              Text(error.toString()),
                                          loading: () => Loader(),
                                        );
                                  },
                                ),
                              )
                            ],
                          ),
                        ));
                  });
            },
            child: StackedReactions(
              isMyMessage: isMyMessage,
              // reactions widget
              reactions: widget.message.reactions, // list of reaction strings

              stackedValue:
                  0.01, // Value used to calculate the horizontal offset of each reaction
            ),
          ),
        )
      ],
    );
  }
}
