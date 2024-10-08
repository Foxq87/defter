import 'package:acc/features/auth/controller/auth_controller.dart';
import 'package:acc/features/chats/controller/chat_controller.dart';
import 'package:acc/features/chats/screens/chat_screen.dart';
import 'package:acc/features/chats/widgets/message_card.dart';
import 'package:acc/models/chat_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../../../theme/palette.dart';

class ChatCard extends ConsumerStatefulWidget {
  final ChatModel chat;
  const ChatCard({super.key, required this.chat});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatCardState();
}

class _ChatCardState extends ConsumerState<ChatCard> {
  void deleteNotification(BuildContext context) async {
    ref.read(chatControllerProvider.notifier).deleteChat(widget.chat, context);
  }

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
                    trailing: user.username == "Kerem"
                        ? Container(
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                              color: Palette.orangeColor,
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Center(
                                child: Text(
                              '1',
                              style: TextStyle(
                                  fontFamily: 'SFProDisplayBold', fontSize: 15),
                            )),
                          )
                        : SizedBox(),
                    leading: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(
                              width: 0.45, color: Palette.darkGreyColor2)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Image.network(
                          user.profilePic,
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                        ),
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
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => ChatScreen(
                      //               chat: widget.chat,
                      //             )));
                      print(widget.chat.members.toString());
                      print(widget.chat.id);
                      Routemaster.of(context).push('/chat/${widget.chat.id}/false');
                    }),
                error: (error, stackTrace) => ListTile(
                    leading: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(
                              width: 0.45, color: Palette.darkGreyColor2)),
                      child: SizedBox(
                          width: 50,
                          height: 50,
                          child: Icon(
                            CupertinoIcons.clear,
                            color: Palette.redColor,
                          )),
                    ),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'silinmiş kullanıcı',
                            style: TextStyle(
                              color: Palette.redColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    trailing: CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: const Icon(
                          CupertinoIcons.delete,
                          size: 22,
                          color: Palette.redColor,
                        ),
                        onPressed: () {
                          deleteNotification(context);
                        }),
                    onTap: () {}),
                loading: () => CupertinoActivityIndicator())
        : ListTile(
            leading: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  border:
                      Border.all(width: 0.45, color: Palette.darkGreyColor2)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image.network(
                  widget.chat.profilePic,
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                ),
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
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            onTap: () {
              Routemaster.of(context).push('/chat/${widget.chat.id}/false');
            });
  }
}
