import 'package:acc/core/commons/error_text.dart';
import 'package:acc/core/commons/loader.dart';
import 'package:acc/features/notifications/controller/notification_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import '../../../models/notification_model.dart';
import '../../auth/controller/auth_controller.dart';
import '../../../theme/palette.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationCard extends ConsumerStatefulWidget {
  final NotificationModel notification;
  const NotificationCard({
    super.key,
    required this.notification,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NotificationCardState();
}

class _NotificationCardState extends ConsumerState<NotificationCard> {
  void deletePost(BuildContext context) async {
    ref
        .read(notificationControllerProvider.notifier)
        .deleteNotification(widget.notification, context);
  }

  void navigateToUser(BuildContext context, String uid) {
    Routemaster.of(context).push('/user-profile/$uid');
  }

  // void navigateToSchool(BuildContext context) {
  //   Routemaster.of(context).push('/school-profile/${widget.note.schoolName}');
  // }

  void navigateToPost(BuildContext context, String postId) {
    Routemaster.of(context).push('/note/$postId/details');
  }

  @override
  Widget build(BuildContext context) {
    final isTypeFollow = widget.notification.type == 'follow';
    final isTypeLike = widget.notification.type == 'like';
    final isTypeComment = widget.notification.type == 'comment';
    final isTypeEmpty = widget.notification.type.isEmpty;

    return ref.watch(getUserDataProvider(widget.notification.senderUid)).when(
          data: (senderUser) => ListTile(
            onTap: () {
              if (isTypeFollow) {
                navigateToUser(context, widget.notification.senderUid);
              } else if (isTypeLike) {
                navigateToPost(context, widget.notification.postId);
              } else if (isTypeComment) {
                navigateToPost(context, widget.notification.postId);
              }
            },
            leading: Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    senderUser.profilePic,
                    fit: BoxFit.cover,
                    height: 40.0,
                    width: 40.0,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.only(top: 2, left: 2),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(5)),
                    ),
                    child: Icon(
                      isTypeEmpty
                          ? CupertinoIcons.app
                          : isTypeFollow
                              ? CupertinoIcons.person_solid
                              : isTypeLike
                                  ? CupertinoIcons.heart_fill
                                  : isTypeComment
                                      ? CupertinoIcons.bubble_left_fill
                                      : CupertinoIcons.alarm,
                      color: isTypeFollow || isTypeEmpty
                          ? Palette.themeColor
                          : isTypeLike
                              ? Palette.redColor
                              : isTypeComment
                                  ? Colors.blue
                                  : Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
            titleAlignment: ListTileTitleAlignment.center,
            title: Text(
              widget.notification.content,
              style: TextStyle(fontSize: 15),
            ),
            subtitle: Text(
              "${timeago.format(widget.notification.createdAt, locale: 'en_short')}",
              style: TextStyle(color: Colors.grey),
            ),
            trailing: CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Icon(
                  CupertinoIcons.clear,
                  size: 22,
                  color: Palette.postIconColor,
                ),
                onPressed: () {
                  deletePost(context);
                }),
          ),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
