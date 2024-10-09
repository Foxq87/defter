import 'package:acc/core/commons/large_text.dart';
import 'package:acc/core/commons/loader.dart';
import 'package:acc/features/auth/controller/auth_controller.dart';
import 'package:acc/features/chats/controller/chat_controller.dart';
import 'package:acc/features/chats/widgets/chat_card.dart';
import 'package:acc/features/search/screens/search_screen.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../theme/palette.dart';

class ChatsScreen extends ConsumerStatefulWidget {
  const ChatsScreen({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends ConsumerState<ChatsScreen> {
  int segmentedValue = 1;
  @override
  Widget build(BuildContext context) {
    final currentUser = ref.read(userProvider)!;
    return Scaffold(
      appBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        backgroundColor: Colors.transparent,
        border: const Border(
            bottom: BorderSide(width: 0.5, color: Palette.darkGreyColor2)),
        middle: largeText('mesajlar', false),
      ),
      body: segmentedValue == 2
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    Icon(
                      CupertinoIcons.alarm,
                      color: Palette.orangeColor,
                      size: 50,
                    ),
                    Text(
                      'etkinlikler özelliği henüz hazır değil, hazır olduğunda sana haber vereceğiz.',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      height: 40,
                      child: CupertinoButton(
                          padding: EdgeInsets.symmetric(horizontal: 60),
                          borderRadius: BorderRadius.circular(100),
                          color: Palette.themeColor,
                          child: Text(
                            'tamam',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'SFProDisplayRegular',
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              segmentedValue = 1;
                            });
                          }),
                    )
                  ],
                ),
              ),
            )
          : ref.watch(getUserChatsProvider(currentUser.uid)).when(
                data: (chats) {
                  return ListView.builder(
                    padding: EdgeInsets.only(bottom: 70),
                    // physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: chats.length,
                    itemBuilder: (BuildContext context, int index) {
                      final chat = chats[index];
                      return Column(
                        children: [
                          ChatCard(chat: chat),
                          if (index != chats.length - 1)
                            Divider(
                                height: 0,
                                indent: 16 + 50 + 7,
                                thickness: 0.5,
                                color: Palette.darkGreyColor2),
                        ],
                      );
                    },
                  );
                },
                error: (error, stackTrace) {
                  print(error.toString());
                  return Text(error.toString());
                },
                loading: () => const Loader(),
              ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomSlidingSegmentedControl<int>(
              initialValue: segmentedValue,
              children: {
                1: const Text(
                  'sohbet',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontFamily: "SFProDisplayMedium",
                  ),
                ),
                2: Text(
                  'etkinlik',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontFamily: "SFProDisplayMedium",
                  ),
                ),
              },
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white12),
                color: CupertinoColors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(100),
              ),
              thumbDecoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.3),
                    blurRadius: 4.0,
                    spreadRadius: 1.0,
                    offset: const Offset(
                      0.0,
                      2.0,
                    ),
                  ),
                ],
              ),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              onValueChanged: (v) {
                setState(() {
                  segmentedValue = v;
                });
              },
            ),
            const SizedBox(
              width: 4,
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white12)),
                child: const Icon(
                  CupertinoIcons.add,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                showModalBottomSheet(
                  useSafeArea: true,
                  isScrollControlled: true,
                  backgroundColor: Palette.darkGreyColor2,
                  context: context,
                  builder: (BuildContext context) {
                    return FractionallySizedBox(
                        heightFactor: 0.98,
                        child: SearchScreen(isForChat: true));
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
