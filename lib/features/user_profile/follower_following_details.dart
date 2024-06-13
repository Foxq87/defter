import 'package:acc/core/commons/commons.dart';
import 'package:acc/core/commons/error_text.dart';
import 'package:acc/core/commons/loader.dart';
import 'package:acc/core/commons/nav_bar_button.dart';
import 'package:acc/features/auth/controller/auth_controller.dart';
import 'package:acc/features/user_profile/controller/user_profile_controller.dart';
import 'package:acc/features/user_profile/screens/user_profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../../theme/palette.dart';

class FollowerFollowingDetails extends ConsumerStatefulWidget {
  final List<String> followerUids;
  final List<String> followingUids;
  final int initialPage;
  const FollowerFollowingDetails({
    super.key,
    required this.followerUids,
    required this.followingUids,
    required this.initialPage,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FollowerFollowingDetailsState();
}

class _FollowerFollowingDetailsState
    extends ConsumerState<FollowerFollowingDetails> {
  PageController pageController = PageController();
  List contentItems = [
    ['takipçiler', true],
    ['takip edilenler', false],
  ];

  void selectAndUnselectOthers(int index) {
    pageController.animateToPage(index,
        duration: Duration(milliseconds: 200), curve: Curves.bounceInOut);
    for (var element in contentItems) {
      setState(() {
        element[1] = false;
        contentItems[index][1] = true;
      });
    }
  }

  @override
  void initState() {
    pageController = PageController(initialPage: widget.initialPage);

    contentItems = List.generate(
        2,
        (index) => [
              contentItems[index][0],
              index == widget.initialPage ? true : false
            ]);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CupertinoNavigationBar(
          backgroundColor: Colors.transparent,
          border: const Border(
              bottom: BorderSide(color: Palette.noteIconColor, width: 0.25)),
          leading: JustIconButton(
              icon: CupertinoIcons.back,
              onPressed: () => Navigator.of(context).pop()),
          middle: Row(
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
        ),
        body: PageView(
          controller: pageController,
          onPageChanged: (val) => setState(() => selectAndUnselectOthers(val)),
          scrollDirection: Axis.horizontal,
          children: [
            ref.watch(getUserFollowersProvider(widget.followerUids)).when(
                data: (followers) {
                  return ListView.builder(
                    itemCount: followers.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(followers[index].profilePic),
                          ),
                          title: Text(followers[index].name),
                          subtitle: Text('@' + followers[index].username),
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserProfileScreen(
                                    uid: followers[index].uid),
                              )));
                    },
                  );
                },
                error: (error, stackTrace) => Text(error.toString()),
                loading: () => Loader()),
            ref.watch(getUserFollowingsProvider(widget.followingUids)).when(
                data: (followers) {
                  return ListView.builder(
                    itemCount: followers.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(followers[index].profilePic),
                          ),
                          title: Text(followers[index].name),
                          subtitle: Text('@' + followers[index].username),
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserProfileScreen(
                                    uid: followers[index].uid),
                              )));
                    },
                  );
                },
                error: (error, stackTrace) => Text(error.toString()),
                loading: () => Loader())
          ],
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
              fontSize: 15,
              color: Colors.white,
              fontFamily: 'SFProDisplayMedium'),
        ),
      ),
    );
  }
}
