import 'package:acc/core/commons/commons.dart';
import 'package:acc/core/commons/loader.dart';
import 'package:acc/features/auth/controller/auth_controller.dart';
import 'package:acc/features/notifications/controller/notification_controller.dart';
import 'package:acc/models/notification_model.dart';
import 'package:acc/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../theme/palette.dart';
import '../widgets/notification_card.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    final UserModel user = ref.read(userProvider)!;
    return Scaffold(
      appBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        backgroundColor: Colors.transparent,
        border: const Border(
            bottom: BorderSide(width: 0.5, color: Palette.darkGreyColor2)),
        middle: largeText('bildirimler', false),
        trailing: smallTextButton(
          title: 'temizle',
          color: Palette.orangeColor,
          fontSize: 16,
          onPressed: () => showCupertinoDialog(
              barrierDismissible: true,
              context: context,
              builder: (context) => CupertinoAlertDialog(
                    title: Text(
                      "emin misin?",
                      style: TextStyle(fontFamily: 'SFProDisplayRegular'),
                    ),
                    content: Text(
                      "sana gelen bütün bildirimleri silmek üzeresin",
                      style: TextStyle(fontFamily: 'SFProDisplayRegular'),
                    ),
                    actions: [
                      CupertinoDialogAction(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'geri',
                          style: TextStyle(
                            color: Palette.themeColor,
                            fontSize: 19,
                            fontFamily: 'SFProDisplayBold',
                          ),
                        ),
                      ),
                      CupertinoDialogAction(
                        onPressed: () {
                          ref
                              .read(notificationControllerProvider.notifier)
                              .clearNotifications(user.uid, context);
                        },
                        child: const Text(
                          'sil',
                          style: TextStyle(
                            color: Palette.redColor,
                            fontSize: 19,
                            fontFamily: 'SFProDisplayBold',
                          ),
                        ),
                      ),
                    ],
                  )),
        ),
      ),
      body: ref.watch(getUserNotificationsProvider(user.uid)).when(
            data: (data) => Scrollbar(
              scrollbarOrientation: ScrollbarOrientation.right,
              thumbVisibility: true,
              trackVisibility: true,
              controller: scrollController,
              child: ListView.builder(
                controller: scrollController,
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  final NotificationModel notification = data[index];
                  return NotificationCard(notification: notification);
                },
              ),
            ),
            error: (error, stackTrace) => Text(error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
