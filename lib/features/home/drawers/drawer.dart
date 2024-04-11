import 'package:acc/core/constants/constants.dart';
import 'package:acc/core/utils.dart';
import 'package:acc/features/auth/controller/auth_controller.dart';
import 'package:acc/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:routemaster/routemaster.dart';
import '../../../theme/palette.dart';

void navigateToProfile(BuildContext context, UserModel user) {
  Routemaster.of(context).push('/user-profile/${user.uid}');
}

void navigateToSchool(BuildContext context, String schoolId) {
  Routemaster.of(context).push('/school-profile/$schoolId');
}

class DrawerView extends ConsumerWidget {
  const DrawerView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserModel user = ref.watch(userProvider)!;
    return Container(
      decoration: BoxDecoration(
          border:
              Border(right: BorderSide(width: 1.5, color: Colors.grey[900]!))),
      child: Drawer(
        backgroundColor: Colors.black,
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(25.0, 40, 10, 0),
              child: GestureDetector(
                onTap: () => navigateToProfile(context, user),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            user.profilePic,
                            height: 55,
                            width: 55,
                            fit: BoxFit.cover,
                          ),
                        ),
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: const Icon(
                            CupertinoIcons.ellipsis_circle,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            showCupertinoModalPopup(
                              context: context,
                              builder: (context) => CupertinoTheme(
                                data: const CupertinoThemeData(
                                    brightness: Brightness.dark),
                                child: CupertinoActionSheet(
                                  cancelButton: CupertinoActionSheetAction(
                                      child: const Text('Back'),
                                      onPressed: () {
                                        Routemaster.of(context).pop();
                                      }),
                                  actions: [
                                    CupertinoActionSheetAction(
                                        child: const Text(
                                          'Sign Out',
                                          style: TextStyle(
                                              color: Palette.redColor),
                                        ),
                                        onPressed: () {
                                          Routemaster.of(context).pop();
                                          ref
                                              .read(authControllerProvider
                                                  .notifier)
                                              .logout();
                                        })
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      user.name,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 17),
                    ),
                    Text(
                      '@${user.username}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 17),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Text(user.email,
                        style: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                            fontSize: 15)),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.pop(context);
                navigateToProfile(context, user);
              },
              child: const ListTile(
                leading:
                    Icon(CupertinoIcons.person, color: Colors.white, size: 25),
                title: Text(
                  'profil',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                alertNotAvailable(context);
              },
              child: ListTile(
                leading: SvgPicture.asset(
                  Constants.bookmarkFilled,
                  height: 25,
                  width: 25,
                  colorFilter:
                      const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                ),
                title: const Text(
                  'kaydedilenler',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),

//***********DOES NOT EXIST IN  V1*************
            // //c) events
            // CupertinoButton(
            //   padding: EdgeInsets.zero,
            //   onPressed: () {},
            //   child: const ListTile(
            //     leading: Icon(CupertinoIcons.calendar,
            //         color: Colors.white, size: 25),
            //     title: Text(
            //       'events',
            //       style: TextStyle(
            //         fontSize: 20,
            //         color: Colors.white,
            //       ),
            //     ),
            //   ),
            // ),

            // //d) articles
            // CupertinoButton(
            //   padding: EdgeInsets.zero,
            //   onPressed: () {},
            //   child: const ListTile(
            //     leading:
            //         Icon(CupertinoIcons.doc, color: Colors.white, size: 25),
            //     title: Text(
            //       'gazeteler',
            //       style: TextStyle(
            //         fontSize: 20,
            //         color: Colors.white,
            //       ),
            //     ),
            //   ),
            // ),
            // CupertinoButton(
            //   padding: EdgeInsets.zero,
            //   onPressed: () {},
            //   child: const ListTile(
            //     leading: Icon(CupertinoIcons.bubble_left_bubble_right,
            //         color: Colors.white, size: 25),
            //     title: Text(
            //       'collaborate',
            //       style: TextStyle(
            //         fontSize: 20,
            //         color: Colors.white,
            //       ),
            //     ),
            //   ),
            // ),
            // const SizedBox(
            //   height: 10,
            // ),
            Divider(
              color: Colors.grey[900],
              thickness: 1.2,
              endIndent: 15,
              indent: 15,
            ),
            user.schoolId.isEmpty
                ? const SizedBox()
                : Column(
                    children: [
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () async {
                          //  final school = School(
                          //     id: "BAIHL",
                          //     title: "Beyoğlu Anadolu İmam-Hatip Lisesi",
                          //     banner: Constants.bannerDefault,
                          //     avatar: Constants.avatarDefault,
                          //     students: [user.uid] as List<String>,
                          //     mods: [user.uid] as List<String>);
                          // FirebaseFirestore.instance
                          //     .collection(FirebaseConstants.schoolsCollection)
                          //     .doc("BAIHL")
                          //     .set(school.toMap());
                          // FirebaseFirestore.instance
                          //     .collection(FirebaseConstants.usersCollection).get()
                          // FirebaseFirestore.instance
                          //     .collection(FirebaseConstants.usersCollection)
                          //     .get()
                          //     .then((doc) {
                          //   for (var element in doc.docs) {
                          //     element.reference
                          //         .update({'name': element.get('username')});
                          //   }
                          // });

                          Navigator.pop(context);
                          navigateToSchool(context, user.schoolId);
                        },
                        child: ListTile(
                          leading: const Icon(CupertinoIcons.book,
                              color: Palette.themeColor, size: 25),
                          title: Text(
                            user.schoolId,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Palette.themeColor,
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.grey[900],
                        thickness: 1.2,
                        endIndent: 15,
                        indent: 15,
                      ),
                    ],
                  ),
            if (user.roles.contains('developer'))
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection('users')
                      .get()
                      .then((querySnapshot) {
                    querySnapshot.docs.forEach((doc) {
                      final name = doc.get('name');
                      final username = doc.get('username');
                      final nameInsensitive = name.toLowerCase();
                      final usernameInsensitive = username.toLowerCase();

                      doc.reference.update({
                        'name_insensitive': nameInsensitive,
                        'username_insensitive': usernameInsensitive,
                      });
                    });
                  });
                },
                child: ListTile(
                  leading: const Icon(
                      CupertinoIcons.antenna_radiowaves_left_right,
                      color: Palette.themeColor,
                      size: 25),
                  title: Text(
                    "Action Button",
                    style: const TextStyle(
                      fontSize: 20,
                      color: Palette.themeColor,
                    ),
                  ),
                ),
              ),

            // ToggleList(
            //     innerPadding: const EdgeInsets.symmetric(horizontal: 15),
            //     scrollPhysics: const NeverScrollableScrollPhysics(),
            //     scrollPosition: AutoScrollPosition.end,
            //     shrinkWrap: true,
            //     toggleAnimationDuration: const Duration(milliseconds: 200),
            //     scrollDuration: const Duration(milliseconds: 20),
            //     trailing: const Padding(
            //       padding: EdgeInsets.all(10),
            //       child: Icon(
            //         CupertinoIcons.chevron_down,
            //         color: Colors.white,
            //       ),
            //     ),
            //     children: [
            //       ToggleListItem(
            //         title: const Text(
            //           'School Related',
            //           style: TextStyle(
            //               color: Colors.white,
            //               fontSize: 18,
            //               fontWeight: FontWeight.bold),
            //         ),
            //         content: Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             const SizedBox(
            //               height: 10,
            //             ),
            //             CupertinoButton(
            //               padding: EdgeInsets.zero,
            //               onPressed: () {
            //                 // Get.to(() => Tests(
            //                 //       previousPageTitle: 'Home',
            //                 //     ));
            //               },
            //               child: const Row(
            //                 children: [
            //                   Icon(
            //                     CupertinoIcons.book,
            //                     color: Colors.white,
            //                   ),
            //                   SizedBox(
            //                     width: 20,
            //                   ),
            //                   Text(
            //                     'Tests',
            //                     style:
            //                         TextStyle(color: Colors.white, fontSize: 18),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //             CupertinoButton(
            //               padding: EdgeInsets.zero,
            //               onPressed: () {},
            //               child: const Row(
            //                 children: [
            //                   // Icon(
            //                   //   Icons.notebooks,
            //                   //   color: Colors.white,
            //                   // ),
            //                   SizedBox(
            //                     width: 20,
            //                   ),
            //                   Text(
            //                     'Notes',
            //                     style:
            //                         TextStyle(color: Colors.white, fontSize: 18),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ]),
          ],
        ),
      ),
    );
  }
}
