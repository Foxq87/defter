import 'package:acc/core/commons/loader.dart';
import 'package:acc/features/auth/controller/auth_controller.dart';
import 'package:acc/features/chats/controller/chat_controller.dart';
import 'package:acc/models/chat_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/commons/large_text.dart';
import '../../../core/commons/nav_bar_button.dart';
import '../../../models/user_model.dart';
import '../../../theme/palette.dart';
import '../../user_profile/screens/user_profile_screen.dart';

class ChatDetails extends ConsumerStatefulWidget {
  final ChatModel chat;
  const ChatDetails({super.key, required this.chat});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatDetailsState();
}

class _ChatDetailsState extends ConsumerState<ChatDetails> {
  void leaveGroup(UserModel currentUser, ChatModel chat) {
    ref
        .read(chatControllerProvider.notifier)
        .leaveGroup(currentUser, chat, context);
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.read(userProvider)!;
    return Scaffold(
        appBar: CupertinoNavigationBar(
          backgroundColor: Colors.transparent,
          border: Border(
              bottom: BorderSide(width: 0.5, color: Palette.darkGreyColor2)),
          leading: JustIconButton(
              icon: CupertinoIcons.back,
              onPressed: () => Navigator.of(context).pop()),
          middle: largeText('grup detayı', false),
          trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              child: Text(
                'düzenle',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'JetBrainsMonoRegular',
                    fontSize: 16),
              ),
              onPressed: () {}),
        ),
        body: ref
            .watch(getUserDataProvider(widget.chat.members
                    .where((uid) => uid != currentUser.uid)
                    .isEmpty
                ? currentUser.uid
                : widget.chat.members
                    .where((uid) => uid != currentUser.uid)
                    .first))
            .when(
                data: (user) => ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25.0, vertical: 20),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: Image.network(
                                  widget.chat.isDM
                                      ? user.profilePic
                                      : widget.chat.profilePic,
                                  height: 80,
                                  width: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              largeText(
                                  widget.chat.isDM
                                      ? user.username
                                      : widget.chat.title,
                                  false),
                              if (!widget.chat.isDM)
                                Text(
                                  widget.chat.members.length.toString() +
                                      " üye",
                                  style: TextStyle(
                                      color: Palette.justGrayColor,
                                      fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                widget.chat.description,
                                style: TextStyle(
                                    color: Palette.justGrayColor, fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              if (!widget.chat.isDM)
                                Row(
                                  children: [
                                    largeText('üyeler', false),
                                  ],
                                ),
                            ],
                          ),
                        ),
                        if (!widget.chat.isDM)
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: widget.chat.members.length,
                            itemBuilder: (context, index) {
                              return ref
                                  .watch(getUserDataProvider(
                                      widget.chat.members[index]))
                                  .when(
                                    data: (user) => ListTile(
                                        leading: CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(user.profilePic),
                                        ),
                                        title: Text(user.name),
                                        subtitle: Text('@' + user.username),
                                        onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  UserProfileScreen(
                                                      uid: widget
                                                          .chat.members[index]),
                                            ))),
                                    error: (error, stackTrace) =>
                                        Text(error.toString()),
                                    loading: () => Loader(),
                                  );
                            },
                          ),
                        if (!widget.chat.isDM)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 20),
                            child: CupertinoButton(
                              color: Palette.darkGreyColor,
                              child: Text(
                                'gruptan çık',
                                style: TextStyle(color: Palette.redColor),
                              ),
                              onPressed: () =>
                                  leaveGroup(currentUser, widget.chat),
                            ),
                          ),
                      ],
                    ),
                error: (error, stackTrace) => Text(error.toString()),
                loading: () => CupertinoActivityIndicator()));
  }
}
