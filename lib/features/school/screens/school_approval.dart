import 'package:acc/core/commons/error_text.dart';
import 'package:acc/core/commons/loader.dart';
import 'package:acc/features/auth/controller/auth_controller.dart';
import 'package:acc/features/marketplace/controller/marketplace_controller.dart';
import 'package:acc/features/marketplace/screens/create_product_screen.dart';
import 'package:acc/features/school/controller/school_controller.dart';
import 'package:acc/models/product_model.dart';
import 'package:acc/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/commons/large_text.dart';
import '../../../theme/palette.dart';
import '../../user_profile/screens/user_profile_screen.dart';

class SchoolApprovalView extends ConsumerStatefulWidget {
  final String schoolId;
  const SchoolApprovalView({super.key, required this.schoolId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SchoolApprovalViewState();
}

class _SchoolApprovalViewState extends ConsumerState<SchoolApprovalView> {
  PageController pageController = PageController();
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.read(userProvider)!;
    return ref.watch(getSchoolAppliersProvider(widget.schoolId)).when(
        data: (users) => Scaffold(
              appBar: users.isEmpty
                  ? null
                  : CupertinoNavigationBar(
                      leading: CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: Icon(
                          CupertinoIcons.back,
                          color: Colors.white,
                          size: 27,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      backgroundColor: Colors.transparent,
                      middle: largeText(
                        'ürün onay',
                        false,
                      ),
                    ),
              body: SafeArea(
                child: users.isEmpty
                    ? Center(
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.check_mark_circled,
                            color: Palette.themeColor,
                            size: 50,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'tüm ürünler kontrol edildi!',
                            style: TextStyle(fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ))
                    : Column(
                        children: [
                          Wrap(
                              spacing: 10,
                              direction: Axis.horizontal,
                              children: List.generate(
                                users.length,
                                (i) => SizedBox(
                                    height: 30,
                                    child: CupertinoButton(
                                      padding: EdgeInsets.zero,
                                      borderRadius: BorderRadius.circular(100),
                                      color: currentPageIndex != i
                                          ? Palette.iconBackgroundColor
                                          : Palette.themeColor,
                                      onPressed: () {
                                        pageController.animateToPage(i,
                                            duration:
                                                Duration(milliseconds: 200),
                                            curve: Curves.bounceInOut);
                                      },
                                      child: Text(
                                        (i + 1).toString(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'SFProDisplayRegular'),
                                      ),
                                    )),
                              )),
                          Expanded(
                            child: ListView.builder(
                                controller: pageController,
                                itemCount: users.length,
                                itemBuilder: (context, index) {
                                  UserModel user = users[index];
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ListTile(
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
                                                        uid: user.uid),
                                              ))),
                                      Text(user.bio),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Expanded(
                                              child: CupertinoButton(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Palette.redColor,
                                            child: Text(
                                              'reddet',
                                              style: TextStyle(
                                                  fontFamily:
                                                      'SFPRODISPLAYBOLD',
                                                  color: Colors.white),
                                            ),
                                            onPressed: () {
                                              ref
                                                  .read(schoolControllerProvider
                                                      .notifier)
                                                  .userSchoolAction(
                                                      widget.schoolId,
                                                      user.uid,
                                                      context,
                                                      false);
                                            },
                                          )),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Expanded(
                                              child: CupertinoButton(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Palette.themeColor,
                                            child: Text(
                                              'onayla',
                                              style: TextStyle(
                                                  fontFamily:
                                                      'SFPRODISPLAYBOLD',
                                                  color: Colors.white),
                                            ),
                                            onPressed: () {
                                              ref
                                                  .read(schoolControllerProvider
                                                      .notifier)
                                                  .userSchoolAction(
                                                      widget.schoolId,
                                                      user.uid,
                                                      context,
                                                      true);
                                            },
                                          )),
                                          SizedBox(
                                            width: 15,
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        thickness: 0.65,
                                        color: Palette.darkGreyColor2,
                                      ),
                                    ],
                                  );
                                }),
                          ),
                        ],
                      ),
              ),
            ),
        error: (error, stackTrace) {
          print(error.toString());
          return Text(error.toString());
        },
        loading: () => Loader());
  }
}
