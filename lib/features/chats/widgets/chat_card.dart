import 'package:acc/features/chats/screens/chat_screen.dart';
import 'package:acc/models/chat_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../theme/palette.dart';

class ChatCard extends ConsumerStatefulWidget {
  final ChatModel chat;
  const ChatCard({super.key, required this.chat});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatCardState();
}

class _ChatCardState extends ConsumerState<ChatCard> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Image.network(
            widget.chat.profilePic,
            height: 50,
            width: 50,
            fit: BoxFit.cover,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                widget.chat.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        subtitle: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Text(
                widget.chat.latest,
                style: TextStyle(color: Palette.placeholderColor),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => ChatScreen(
                        chat: widget.chat,
                      )));
        });
  }
}
