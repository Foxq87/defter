import 'package:acc/core/commons/loader.dart';
import 'package:acc/features/marketplace/screens/product_details.dart';
import 'package:acc/features/notes/screens/note_details.dart';
import 'package:acc/features/notifications/controller/notification_controller.dart';
import 'package:acc/features/user_profile/screens/user_profile_screen.dart';
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
  void deleteNotification(BuildContext context) async {
    ref
        .read(notificationControllerProvider.notifier)
        .deleteNotification(widget.notification, context);
  }

  void navigateToUser(BuildContext context, String uid) =>
      Routemaster.of(context).push('/user-profile/$uid');

  // Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => UserProfileScreen(uid: uid)));

  //  {

  // }

  // void navigateToSchool(BuildContext context) {
  //   Routemaster.of(context).push('/school-profile/${widget.note.schoolName}');
  // }

  void navigateToNote(BuildContext context, String noteId) =>
      Routemaster.of(context).push('/note/$noteId');
  void navigateToChat(BuildContext context, String uid) =>
      Routemaster.of(context).push('/chat/$uid/true');

  //  {
  //   Routemaster.of(context).push('/note/$noteId/details');
  // }

  void navigateToProduct(BuildContext context, String productId) =>
      Routemaster.of(context).push('/product/$productId');

  @override
  void initState() {
    super.initState();
    timeago.setLocaleMessages('tr_short', timeago.TrShortMessages());
  }

  @override
  Widget build(BuildContext context) {
    final isTypeFollow = widget.notification.type == 'follow';
    final isTypeLike = widget.notification.type == 'like';
    final isTypeComment = widget.notification.type == 'comment';
    final isTypeProductApproval =
        widget.notification.type == 'product-approval';
    final isTypeProductRejection =
        widget.notification.type == 'product-rejection';
    final isTypeMessage = widget.notification.type == 'message';
    final isTypeEmpty = widget.notification.type.isEmpty;

    return ref.watch(getUserDataProvider(widget.notification.senderUid)).when(
          data: (senderUser) => ListTile(
            onTap: () {
              if (isTypeFollow) {
                navigateToUser(context, widget.notification.senderUid);
              } else if (isTypeLike) {
                navigateToNote(context, widget.notification.postId!);
              } else if (isTypeComment) {
                navigateToNote(context, widget.notification.postId!);
              } else if (isTypeProductApproval || isTypeProductRejection) {
                print(widget.notification.productId);
                navigateToProduct(context, widget.notification.productId!);
              } else if (isTypeMessage) {
                navigateToChat(context, widget.notification.senderUid);
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
                      color: Palette.backgroundColor,
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(5)),
                    ),
                    child: Icon(
                      isTypeEmpty
                          ? CupertinoIcons.app
                          : isTypeProductRejection
                              ? CupertinoIcons.clear
                              : isTypeProductApproval
                                  ? CupertinoIcons.checkmark
                                  : isTypeFollow
                                      ? CupertinoIcons.person_solid
                                      : isTypeLike
                                          ? CupertinoIcons.heart_fill
                                          : isTypeComment
                                              ? CupertinoIcons.bubble_left_fill
                                              : CupertinoIcons.mail,
                      color:
                          isTypeFollow || isTypeEmpty || isTypeProductApproval
                              ? Palette.themeColor
                              : isTypeLike || isTypeProductRejection
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
              "${timeago.format(widget.notification.createdAt, locale: 'tr_short')}",
              style: TextStyle(color: Colors.grey),
            ),
            trailing: CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Icon(
                  CupertinoIcons.clear,
                  size: 22,
                  color: Palette.noteIconColor,
                ),
                onPressed: () {
                  deleteNotification(context);
                }),
          ),
          error: (error, stackTrace) => ListTile(
            onTap: () {
              if (isTypeFollow) {
                navigateToUser(context, widget.notification.senderUid);
              } else if (isTypeLike) {
                navigateToNote(context, widget.notification.postId!);
              } else if (isTypeComment) {
                navigateToNote(context, widget.notification.postId!);
              } else if (isTypeProductApproval || isTypeProductRejection) {
                print(widget.notification.productId);
                navigateToProduct(context, widget.notification.productId!);
              } else if (isTypeMessage) {
                navigateToChat(context, widget.notification.senderUid);
              }
            },
            leading: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  border:
                      Border.all(width: 0.45, color: Palette.darkGreyColor2)),
              child: SizedBox(
                  width: 40,
                  height: 40,
                  child: Icon(
                    CupertinoIcons.clear,
                    color: Palette.redColor,
                  )),
            ),
            titleAlignment: ListTileTitleAlignment.center,
            title: Text(
              'silinmiş bildirim',
              style: TextStyle(fontSize: 15),
            ),
            subtitle: Text(
              "${timeago.format(widget.notification.createdAt, locale: 'tr_short')}",
              style: TextStyle(color: Colors.grey),
            ),
            trailing: CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Icon(
                  CupertinoIcons.clear,
                  size: 22,
                  color: Palette.noteIconColor,
                ),
                onPressed: () {
                  deleteNotification(context);
                }),
          ),
          loading: () => const Loader(),
        );
  }
}
