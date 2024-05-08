import 'package:acc/core/commons/image_view.dart';
import 'package:acc/features/auth/controller/auth_controller.dart';
import 'package:acc/features/chats/widgets/stacked_reactions_my.dart';
import 'package:acc/models/message_model.dart';
import 'package:acc/theme/palette.dart';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:unicons/unicons.dart';

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
                                            fontFamily: 'JetBrainsMonoRegular',
                                            fontSize: 13),
                                      ),
                                    ),
                                    // Icon(UniconsLine.check)
                                  ],
                                ))
                          ],
                        ),
                      if (widget.message.text.isNotEmpty)
                        Padding(
                          padding: isImageMessage
                              ? EdgeInsets.symmetric(
                                  horizontal: 7,
                                ).copyWith(bottom: 7, top: 5)
                              : EdgeInsets.zero,
                          child: Text(
                            widget.message.text,
                            style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'JetBrainsMonoRegular',
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
                                      : Palette.justGrayColor,
                                  inherit: false,
                                  fontFamily: 'JetBrainsMonoRegular',
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
          child: StackedReactions(
            isMyMessage: isMyMessage,
            // reactions widget
            reactions: widget.message.reactions, // list of reaction strings

            stackedValue:
                0.01, // Value used to calculate the horizontal offset of each reaction
          ),
        )
      ],
    );
  }
}
