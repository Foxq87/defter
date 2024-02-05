import 'package:acc/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/commons/error_text.dart';
import '../../../core/commons/loader.dart';
// import 'package:acc/core/common/post_card.dart';
import '../../../core/commons/nav_bar_button.dart';
import '../../../core/commons/post_card.dart';
import '../../../features/auth/controller/auth_controller.dart';
import '../../../theme/palette.dart';
import 'package:routemaster/routemaster.dart';

import '../controller/user_profile_controller.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  final String uid;
  const UserProfileScreen({super.key, required this.uid});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  void navigateToEditUser(BuildContext context) {
    Routemaster.of(context)
        .push('/user-profile/${widget.uid}/edit-profile/${widget.uid}');
  }

  List contentItems = [
    ['posts', true],
    ['articles', false],
    ['school', false],
  ];
  void selectAndUnselectOthers(int index) {
    for (var element in contentItems) {
      setState(() {
        element[1] = false;
        contentItems[index][1] = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserModel currentUser = ref.watch(userProvider)!;
    return Scaffold(
      //build edit profile

      body: ref.watch(getUserDataProvider(widget.uid)).when(
            data: (user) => ListView(children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: AspectRatio(
                          aspectRatio: 10 / 3.5,
                          child: Image.network(
                            user.banner,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: JustIconButton(
                      icon: CupertinoIcons.back,
                      onPressed: () {
                        Routemaster.of(context).pop();
                      },
                    ),
                  ),
                  Positioned(
                      top: 10,
                      right: 10,
                      child: JustIconButton(
                          icon: CupertinoIcons.ellipsis,
                          onPressed: () {
                            Routemaster.of(context).pop();
                          })),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0).copyWith(top: 0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        user.profilePic,
                        fit: BoxFit.cover,
                        height: 80,
                        width: 80,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: const TextStyle(
                                fontSize: 20,
                                fontFamily: 'JetBrainsMonoExtraBold'),
                          ),
                          Text(
                            '@${user.username}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Palette.placeholderColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              buildFollowerAndFollowingCount(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: user.uid == currentUser.uid
                      ? [
                          buildActionButton(
                            onPressed: () => navigateToEditUser(context),
                            text: 'Edit Profile',
                            color: Palette.textfieldColor,
                          )
                        ]
                      : [
                          buildActionButton(
                              onPressed: () {},
                              text: 'Follow',
                              color: Palette.themeColor),
                          const SizedBox(
                            width: 10,
                          ),
                          buildActionButton(
                            onPressed: () {},
                            text: 'Message',
                            color: Palette.textfieldColor,
                          ),
                        ],
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 10),
              //   child: Text(
              //     '${user.karma} karma',
              //   ),
              // ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(contentItems.length, (index) {
                    return CupertinoButton(
                      onPressed: () => selectAndUnselectOthers(index),
                      padding: EdgeInsets.zero,
                      child: buildContentItem(
                          text: contentItems[index][0],
                          isSelected: contentItems[index][1]),
                    );
                  })),

              const Divider(
                thickness: 0.6,
                height: 0,
              ),
              ref.watch(getUserPostsProvider(user.uid)).when(
                    data: (data) {
                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          final post = data[index];
                          return PostCard(post: post);
                        },
                      );
                    },
                    error: (error, stackTrace) {
                      return ErrorText(error: error.toString());
                    },
                    loading: () => const Loader(),
                  ),
            ]
                //   body: ref.watch(getUserPostsProvider(uid)).when(
                //         data: (data) {
                //           return ListView.builder(
                //             itemCount: data.length,
                //             itemBuilder: (BuildContext context, int index) {
                //               final post = data[index];
                //               return PostCard(post: post);
                //             },
                //           );
                //         },
                //         error: (error, stackTrace) {
                //           return ErrorText(error: error.toString());
                //         },
                //         loading: () => const Loader(),
                //       ),
                ),
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }

  Container buildEditProfile(BuildContext context) {
    return Container(
      alignment: Alignment.bottomLeft,
      padding: const EdgeInsets.all(20),
      child: OutlinedButton(
        onPressed: () => navigateToEditUser(context),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 25),
        ),
        child: const Text('Edit Profile'),
      ),
    );
  }

  Padding buildFollowerAndFollowingCount() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
        child: GestureDetector(
          onTap: () {
            // Routemaster.of(context).push();
          },
          child: RichText(
              text: const TextSpan(children: [
            TextSpan(
                text: '1.8M',
                style: TextStyle(fontFamily: 'JetBrainsMonoRegular')),
            TextSpan(
                text: ' followers',
                style: TextStyle(
                    color: Palette.placeholderColor,
                    fontFamily: 'JetBrainsMonoRegular')),
            TextSpan(
                text: '\t87',
                style: TextStyle(fontFamily: 'JetBrainsMonoRegular')),
            TextSpan(
                text: ' following',
                style: TextStyle(
                    color: Palette.placeholderColor,
                    fontFamily: 'JetBrainsMonoRegular')),
          ])),
        ));
  }

  Expanded buildActionButton({
    required VoidCallback onPressed,
    required String text,
    required Color color,
  }) {
    return Expanded(
      child: SizedBox(
        height: 40,
        child: CupertinoButton(
            borderRadius: BorderRadius.circular(10),
            color: color,
            padding: EdgeInsets.zero,
            onPressed: onPressed,
            child: Text(
              text,
              style: const TextStyle(
                  color: Colors.white, fontFamily: 'JetBrainsMonoBold'),
            )),
      ),
    );
  }

  Padding buildContentItem({required String text, required bool isSelected}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 15.0, 8.0, 0.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  width: 4,
                  color: isSelected ? Palette.themeColor : Colors.transparent)),
        ),
        child: Text(
          text,
          style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontFamily: 'JetBrainsMonoBold'),
        ),
      ),
    );
  }
}
