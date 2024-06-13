import 'package:acc/features/auth/controller/auth_controller.dart';
import 'package:acc/theme/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/commons/large_text.dart';

class SettingsView extends ConsumerStatefulWidget {
  const SettingsView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsViewState();
}

class _SettingsViewState extends ConsumerState<SettingsView> {
  @override
  Widget build(BuildContext context) {
    final currentUser = ref.read(userProvider)!;
    return Scaffold(
      appBar: CupertinoNavigationBar(
        automaticallyImplyLeading: false,
        transitionBetweenRoutes: false,
        backgroundColor: Colors.transparent,
        border: const Border(
            bottom: BorderSide(width: 0.5, color: Palette.darkGreyColor2)),
        middle: largeText('ayarlar', false),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Palette.darkGreyColor2,
                    title: Text('hesabımı sil'),
                    content:
                        Text('hesabınızı silmek istediğinizden emin misiniz?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Palette.darkGreyColor2,
                                title: Text('geri alınamaz emir'),
                                content: Text(
                                  'bu işlem geri alınamaz. hesabınızı silmeyi onaylıyor musunuz?',
                                  style: TextStyle(color: Palette.redColor),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('iptal',
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      ref
                                          .read(authControllerProvider.notifier)
                                          .deleteAccount(
                                              currentUser.uid, context);
                                      Navigator.pop(context);
                                    },
                                    child: Text('hesabımı kalıcı olarak sil',
                                        style:
                                            TextStyle(color: Palette.redColor)),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text('Yes',
                            style: TextStyle(color: Palette.redColor)),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child:
                            Text('No', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  );
                },
              );
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              padding: EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Palette.darkGreyColor,
                  border:
                      Border.all(width: 0.45, color: Palette.darkGreyColor2)),
              child: Column(
                children: [
                  Column(
                    children: [
                      // GestureDetector(
                      //   onTap: () async {
                      //     Navigator.pop(context);
                      //     Navigator.pop(context);
                      //   },
                      //   child: Column(
                      //     children: [
                      //       SizedBox(
                      //         height: 5,
                      //       ),
                      //       Padding(
                      //         padding: EdgeInsets.symmetric(horizontal: 10),
                      //         child: Row(
                      //           children: [
                      //             Text('hesabı engelle'),
                      //             Spacer(),
                      //             Icon(CupertinoIcons.nosign)
                      //           ],
                      //         ),
                      //       ),
                      //       SizedBox(
                      //         height: 10,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // Divider(
                      //   height: 0,
                      //   indent: 0,
                      //   endIndent: 0,
                      //   thickness: 0.25,
                      //   color: Palette.darkGreyColor2,
                      // ),
                      Column(
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                Text(
                                  'hesabımı sil',
                                  style: TextStyle(color: Palette.redColor),
                                ),
                                Spacer(),
                                Icon(CupertinoIcons.delete,
                                    color: Palette.redColor)
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
