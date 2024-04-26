import 'package:acc/core/commons/image_view.dart';
import 'package:acc/core/utils.dart';
import 'package:acc/features/notes/widgets/report_note_dialog.dart';
import 'package:acc/features/school/controller/school_controller.dart';
import 'package:acc/features/user_profile/follower_following_details.dart';
import 'package:acc/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unicons/unicons.dart';
import '../../../core/commons/error_text.dart';
import '../../../core/commons/loader.dart';
// import 'package:acc/core/common/Note_card.dart';
import '../../../core/commons/nav_bar_button.dart';
import '../../../core/commons/not_available_card.dart';
import '../../notes/widgets/note_card.dart';
import '../../../features/auth/controller/auth_controller.dart';
import '../../../models/school_model.dart';
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
    ['notlar', true],
    ['gazeteler', false],
    ['okul', false],
  ];
  void selectAndUnselectOthers(int index) {
    for (var element in contentItems) {
      setState(() {
        element[1] = false;
        contentItems[index][1] = true;
      });
    }
  }

  void suspendAccount(String uid, BuildContext context) {
    AuthController authController = ref.read(authControllerProvider.notifier);
    authController.suspendAccount(uid, context);
  }

  @override
  Widget build(BuildContext context) {
    final UserModel currentUser = ref.watch(userProvider)!;
    return Scaffold(
      //build edit profile

      body: ref.watch(getUserDataProvider(widget.uid)).when(
            data: (user) => ListView(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => ImageView(
                                    imageUrls: [user.banner],
                                    imageFiles: [],
                                    index: 0))),
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
                            showModalBottomSheet(
                              backgroundColor: Palette.darkGreyColor,
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          SizedBox(
                                            width: 15,
                                          ),
                                          if (currentUser.roles
                                              .contains('admin'))
                                            Expanded(
                                              child: CupertinoButton(
                                                borderRadius:
                                                    BorderRadius.circular(17),
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 7),
                                                color: Palette.textFieldColor,
                                                onPressed: () {
                                                  showCupertinoDialog(
                                                    barrierDismissible: true,
                                                    context: context,
                                                    builder: (context) =>
                                                        CupertinoAlertDialog(
                                                      title: const Text(
                                                        "emin misin?",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'JetBrainsMonoExtraBold'),
                                                      ),
                                                      content: const Text(
                                                        'bu hesabı askıya alıyorsun',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'JetBrainsMonoBold'),
                                                      ),
                                                      actions: <CupertinoDialogAction>[
                                                        CupertinoDialogAction(
                                                          isDefaultAction: true,
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: const Text(
                                                            'geri',
                                                            style: TextStyle(
                                                              color: Palette
                                                                  .themeColor,
                                                              fontFamily:
                                                                  'JetBrainsMonoRegular',
                                                            ),
                                                          ),
                                                        ),
                                                        CupertinoDialogAction(
                                                          isDestructiveAction:
                                                              true,
                                                          onPressed: () async {
                                                            suspendAccount(
                                                              user.uid,
                                                              context,
                                                            );
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: const Text(
                                                            'evet',
                                                            style: TextStyle(
                                                              color: Palette
                                                                  .redColor,
                                                              fontFamily:
                                                                  'JetBrainsMonoRegular',
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .report_gmailerrorred_outlined,
                                                      color: Palette.redColor,
                                                      size: 22,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      'hesabı askıya al',
                                                      style: TextStyle(
                                                          color:
                                                              Palette.redColor),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          if (currentUser.roles
                                              .contains('admin'))
                                            SizedBox(
                                              width: 10,
                                            ),
                                          Expanded(
                                            child: CupertinoButton(
                                              borderRadius:
                                                  BorderRadius.circular(17),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 7),
                                              color: Palette.textFieldColor,
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      ReportDialog(
                                                    noteId: '',
                                                    accountId: widget.uid,
                                                  ),
                                                );
                                              },
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    UniconsLine.megaphone,
                                                    color: Colors.white,
                                                    size: 19,
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    'hesabı şikayet et',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 50,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        )),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.all(8.0).copyWith(top: 0, bottom: 4),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => ImageView(
                                    imageUrls: [user.profilePic],
                                    imageFiles: [],
                                    index: 0))),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            user.profilePic,
                            fit: BoxFit.cover,
                            height: 80,
                            width: 80,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      user.name,
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'JetBrainsMonoExtraBold'),
                                    ),
                                  ),
                                ],
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
                      ),
                    ],
                  ),
                ),
                buildFollowerAndFollowingCount(user),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: user.uid == currentUser.uid
                      ? Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 40,
                                child: CupertinoButton(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Palette.textFieldColor,
                                    padding: EdgeInsets.zero,
                                    onPressed: () =>
                                        navigateToEditUser(context),
                                    child: const Text(
                                      'Edit Profile',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'JetBrainsMonoBold'),
                                    )),
                              ),
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 40,
                                child: CupertinoButton(
                                    borderRadius: BorderRadius.circular(10),
                                    color:
                                        user.followers.contains(currentUser.uid)
                                            ? Palette.redColor
                                            : Palette.themeColor,
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      print(
                                          "${currentUser.following.contains(user.uid)} sa" +
                                              widget.uid +
                                              user.uid);
                                      ref
                                          .read(userProfileControllerProvider
                                              .notifier)
                                          .followUser(
                                              context, user, currentUser, ref);
                                    },
                                    child: Text(
                                      user.followers.contains(currentUser.uid)
                                          ? 'takipten çık'
                                          : 'takip et',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'JetBrainsMonoBold'),
                                    )),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: SizedBox(
                                height: 40,
                                child: CupertinoButton(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Palette.textFieldColor,
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      alertNotAvailable(context);
                                    },
                                    child: const Text(
                                      'mesaj at',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'JetBrainsMonoBold'),
                                    )),
                              ),
                            ),
                          ],
                        ),
                ),
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
                if (contentItems[0][1])
                  ref.watch(getUserNotesProvider(user.uid)).when(
                        data: (data) {
                          return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: data.length,
                            itemBuilder: (BuildContext context, int index) {
                              final note = data[index];
                              return NoteCard(note: note);
                            },
                          );
                        },
                        error: (error, stackTrace) {
                          return ErrorText(error: error.toString());
                        },
                        loading: () => const Loader(),
                      )
                else if (contentItems[1][1])
                  const NotAvailable()
                else
                  ref.read(getSchoolByIdProvider(user.schoolId)).when(
                        data: (School school) => GestureDetector(
                          onTap: () {},
                          child: GestureDetector(
                            onTap: () {
                              Routemaster.of(context)
                                  .push('/school-profile/${school.id}/');
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    width: 0.35,
                                    color: Palette.noteIconColor,
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(13),
                                          child: Image.network(
                                            school.avatar,
                                            height: 50,
                                            width: 50,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 15.0,
                                        ),
                                        Expanded(
                                            child: Text(
                                          "${school.title} • ${school.id}",
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontFamily:
                                                  'JetBrainsMonoExtraBold'),
                                        )),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    RichText(
                                      text: TextSpan(children: [
                                        TextSpan(
                                            text: school.students.length
                                                .toString(),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'JetBrainsMonoBold',
                                            )),
                                        TextSpan(
                                            text: "\tkayıtlı öğrenci",
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'JetBrainsMonoBold',
                                                color:
                                                    Palette.placeholderColor)),
                                      ]),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        error: (error, stackTrace) =>
                            ErrorText(error: error.toString()),
                        loading: () => const Loader(),
                      ),
              ],
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

  Padding buildFollowerAndFollowingCount(UserModel user) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.bio),
            SizedBox(
              height: 20,
              child: Row(
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => FollowerFollowingDetails(
                                    followerUids: user.followers,
                                    followingUids: user.following,
                                    initialPage: 0,
                                  )));
                    },
                    child: RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: user.followers.length.toString(),
                          style: const TextStyle(
                              fontFamily: 'JetBrainsMonoRegular')),
                      const TextSpan(
                          text: ' takipçi',
                          style: TextStyle(
                              color: Palette.placeholderColor,
                              fontFamily: 'JetBrainsMonoRegular')),
                    ])),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => FollowerFollowingDetails(
                                    followerUids: user.followers,
                                    followingUids: user.following,
                                    initialPage: 1,
                                  )));
                    },
                    child: RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: '\t${user.following.length}',
                          style: const TextStyle(
                              fontFamily: 'JetBrainsMonoRegular')),
                      const TextSpan(
                          text: ' takip edilen',
                          style: TextStyle(
                              color: Palette.placeholderColor,
                              fontFamily: 'JetBrainsMonoRegular')),
                    ])),
                  ),
                ],
              ),
            ),
          ],
        ));
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
