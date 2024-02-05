import 'package:acc/core/commons/nav_bar_button.dart';
import 'package:acc/features/auth/controller/auth_controller.dart';
import 'package:acc/models/user_model.dart';
import 'package:acc/theme/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/commons/error_text.dart';
import '../../../core/commons/loader.dart';
import '../../../core/commons/post_card.dart';
import '../controller/user_profile_controller.dart';

class Profile extends ConsumerStatefulWidget {
  // final UserModel user;
  const Profile({
    // required this.user,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> {
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
    UserModel user = ref.watch(userProvider)!;
    return Scaffold(
        body: ListView(children: [
      Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            child: buildBanner(user),
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
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            buildProfilePicture(user),
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
                        fontSize: 20, fontFamily: 'JetBrainsMonoExtraBold'),
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
      Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0.0),
        child: Text(
          user.bio,
        ),
      ),
      buildFollowerAndFollowingCount(),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            buildActionButton('Follow', Palette.themeColor),
            const SizedBox(
              width: 10,
            ),
            buildActionButton('Message', Palette.textfieldColor),
          ],
        ),
      ),
      //
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
        height: 0,
        thickness: 0.6,
      ),

      ref.watch(getUserPostsProvider(user.uid)).when(
            data: (data) {
              return ListView.builder(
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
    ]));
  }

  ClipRRect buildProfilePicture(UserModel user) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        user.profilePic,
        fit: BoxFit.cover,
        height: 80,
        width: 80,
      ),
    );
  }

  Padding buildBanner(UserModel user) {
    return Padding(
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

  Expanded buildActionButton(String text, Color color) {
    return Expanded(
      child: SizedBox(
        height: 40,
        child: CupertinoButton(
            borderRadius: BorderRadius.circular(10),
            color: color,
            padding: EdgeInsets.zero,
            child: Text(
              text,
              style: const TextStyle(
                  color: Colors.white, fontFamily: 'JetBrainsMonoBold'),
            ),
            onPressed: () {}),
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
}
