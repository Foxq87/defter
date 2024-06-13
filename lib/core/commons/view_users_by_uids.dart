import 'package:acc/core/commons/loader.dart';
import 'package:acc/core/commons/nav_bar_button.dart';
import 'package:acc/features/auth/controller/auth_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/user_profile/controller/user_profile_controller.dart';
import '../../theme/palette.dart';
import '../../features/notes/controller/note_controller.dart';
import '../../features/user_profile/screens/user_profile_screen.dart';

class ViewUsersByUids extends ConsumerStatefulWidget {
  final List<String> uids;
  final bool isLiker;
  const ViewUsersByUids({
    super.key,
    required this.uids,
    required this.isLiker,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ViewUsersByUidsState();
}

class _ViewUsersByUidsState extends ConsumerState<ViewUsersByUids> {
  @override
  Widget build(BuildContext context) {
    final currentUser = ref.read(userProvider)!;
    return ref.watch(getNoteLikersProvider(widget.uids)).when(
          data: (likers) => Scaffold(
            backgroundColor: Palette.backgroundColor,
            appBar: widget.isLiker
                ? null
                : CupertinoNavigationBar(
                    backgroundColor: Colors.transparent,
                    border: const Border(
                        bottom: BorderSide(
                            color: Palette.noteIconColor, width: 0.25)),
                    leading: JustIconButton(
                        icon: CupertinoIcons.back,
                        onPressed: () => Navigator.of(context).pop()),
                    middle: Text(
                      widget.isLiker
                          ? widget.uids.isEmpty
                              ? "beğenen yok ;("
                              : "beğenenler"
                          : widget.uids.isEmpty
                              ? "henüz öğrenci yok ;("
                              : "öğrenciler",
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'SFProDisplayMedium',
                          color: Colors.white),
                    ),
                  ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.isLiker)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 10),
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Palette.placeholderColor,
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 15.0,
                          top: 5.0,
                        ),
                        child: Text(
                          widget.isLiker
                              ? widget.uids.isEmpty
                                  ? "beğenen yok ;("
                                  : "beğenenler"
                              : widget.uids.isEmpty
                                  ? "henüz öğrenci yok ;("
                                  : "öğrenciler",
                          style: TextStyle(
                              fontSize: 20, fontFamily: 'SFProDisplayMedium'),
                        ),
                      ),
                    ],
                  ),
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.uids.length,
                    itemBuilder: (context, index) {
                      final liker = likers[index];
                      return ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(likers[index].profilePic),
                          ),
                          title: Text(likers[index].name),
                          subtitle: Text('@' + likers[index].username),
                          trailing: liker.uid == currentUser.uid
                              ? SizedBox()
                              : SizedBox(
                                  height: 30,
                                  child: CupertinoButton(
                                      borderRadius: BorderRadius.circular(20),
                                      color: currentUser.following
                                              .contains(liker.uid)
                                          ? Palette.darkGreyColor2
                                          : Colors.white,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      onPressed: () {
                                        // print(
                                        //     "${currentUser.following.contains(user.uid)} sa" +
                                        //         widget.uid +
                                        //         user.uid);

                                        ref
                                            .read(userProfileControllerProvider
                                                .notifier)
                                            .followUser(
                                                context, liker, currentUser);
                                        if (liker.followers
                                            .contains(currentUser.uid)) {
                                          setState(() {
                                            liker.followers
                                                .remove(currentUser.uid);
                                          });
                                        } else {
                                          setState(() {
                                            liker.followers
                                                .add(currentUser.uid);
                                          });
                                        }
                                      },
                                      child: Text(
                                        currentUser.following
                                                .contains(liker.uid)
                                            ? 'takip ediliyor'
                                            : 'takip et',
                                        style: TextStyle(
                                            color: currentUser.following
                                                    .contains(liker.uid)
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 14,
                                            fontFamily: 'SFProDisplayMedium'),
                                      )),
                                ),
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    UserProfileScreen(uid: widget.uids[index]),
                              )));
                    },
                  ),
                ),
              ],
            ),
          ),
          error: (error, stackTrace) => Text(error.toString()),
          loading: () => Loader(),
        );
  }
}
