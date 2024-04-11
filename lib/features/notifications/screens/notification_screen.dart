import 'package:acc/core/commons/commons.dart';
import 'package:acc/core/commons/error_text.dart';
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
  @override
  Widget build(BuildContext context) {
    final UserModel user = ref.read(userProvider)!;
    return Scaffold(
      appBar: CupertinoNavigationBar(
        backgroundColor: Colors.transparent,
        border: const Border(
            bottom: BorderSide(width: 1, color: Palette.textFieldColor)),
        middle: largeText('bildirimler', false),
      ),
      body: ref.watch(getUserNotificationsProvider(user.uid)).when(
            data: (data) => ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                final NotificationModel notification = data[index];
                return NotificationCard(notification: notification);
              },
            ),
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
