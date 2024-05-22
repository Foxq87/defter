import 'package:acc/core/constants/constants.dart';
import 'package:acc/features/auth/controller/auth_controller.dart';
import 'package:acc/features/chats/screens/chat_screen.dart';
import 'package:acc/models/chat_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

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
    final currentUser = ref.read(userProvider)!;
    return widget.chat.isDM
        ? ref
            .watch(getUserDataProvider(widget.chat.members
                    .where((uid) => uid != currentUser.uid)
                    .isEmpty
                ? currentUser.uid
                : widget.chat.members
                    .where((uid) => uid != currentUser.uid)
                    .first))
            .when(
                data: (user) => ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Image.network(
                        user.profilePic,
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            user.username,
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
                          MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                    chat: widget.chat,
                                  )));
                    }),
                error: (error, stackTrace) => Text(error.toString()),
                loading: () => CupertinoActivityIndicator())
        : ListTile(
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
                  MaterialPageRoute(
                      builder: (context) => ChatScreen(
                            chat: widget.chat,
                          )));
            });
  }
}
