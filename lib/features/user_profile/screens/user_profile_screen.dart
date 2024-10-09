import 'package:acc/core/commons/image_view.dart';
import 'package:acc/core/commons/share_bottom_sheet.dart';
import 'package:acc/core/constants/constants.dart';
import 'package:acc/features/chats/controller/chat_controller.dart';
import 'package:acc/features/notes/widgets/report_note_dialog.dart';
import 'package:acc/features/school/controller/school_controller.dart';
import 'package:acc/features/user_profile/follower_following_details.dart';
import 'package:acc/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
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
    Routemaster.of(context).push('/user-profile/${widget.uid}/edit-profile');
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

  void blockAccount(String uid, BuildContext context) {
    AuthController authController = ref.read(authControllerProvider.notifier);
    authController.blockAccount(uid, context);
  }

  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    final UserModel currentUser = ref.watch(userProvider)!;
    return Scaffold(
      //build edit profile

      body: ref.watch(getUserDataProvider(widget.uid)).when(
            data: (user) => Scrollbar(
              scrollbarOrientation: ScrollbarOrientation.right,
              thumbVisibility: true,
              trackVisibility: true,
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: ListView(
                  controller: scrollController,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
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
                              Navigator.of(context).pop();
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
                                  backgroundColor: Palette.backgroundColor,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Center(
                                            child: Container(
                                              margin: EdgeInsets.only(top: 10),
                                              width: 40,
                                              height: 4,
                                              decoration: BoxDecoration(
                                                color: Palette.placeholderColor,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        100.0),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 15),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color: Palette.darkGreyColor,
                                                border: Border.all(
                                                    width: 0.45,
                                                    color: Palette
                                                        .darkGreyColor2)),
                                            child: Column(
                                              children: [
                                                Column(
                                                  children: [
                                                    if (widget.uid !=
                                                        currentUser.uid)
                                                      Column(
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () async {
                                                              blockAccount(
                                                                  widget.uid,
                                                                  context);
                                                              Navigator.pop(
                                                                  context);
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Column(
                                                              children: [
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              10),
                                                                  child: Row(
                                                                    children: [
                                                                      Text(
                                                                          'hesabı engelle'),
                                                                      Spacer(),
                                                                      Icon(CupertinoIcons
                                                                          .nosign)
                                                                    ],
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Divider(
                                                            height: 0,
                                                            indent: 0,
                                                            endIndent: 0,
                                                            thickness: 0.25,
                                                            color: Palette
                                                                .darkGreyColor2,
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) =>
                                                                        ReportDialog(
                                                                  noteId: '',
                                                                  accountId:
                                                                      widget
                                                                          .uid,
                                                                ),
                                                              );
                                                            },
                                                            child: Column(
                                                              children: [
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              10),
                                                                  child: Row(
                                                                    children: [
                                                                      Text(
                                                                          'hesabı şikayet et'),
                                                                      Spacer(),
                                                                      Icon(CupertinoIcons
                                                                          .flag)
                                                                    ],
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Divider(
                                                            height: 0,
                                                            indent: 0,
                                                            endIndent: 0,
                                                            thickness: 0.25,
                                                            color: Palette
                                                                .darkGreyColor2,
                                                          ),
                                                        ],
                                                      ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        showShareModalBottomSheet(
                                                            context,
                                                            'https://defter.web.app/user-profile/${widget.uid}');
                                                      },
                                                      child: Column(
                                                        children: [
                                                          widget.uid !=
                                                                  currentUser
                                                                      .uid
                                                              ? SizedBox(
                                                                  height: 10,
                                                                )
                                                              : SizedBox(
                                                                  height: 5,
                                                                ),
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        10),
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                    'profili paylaş'),
                                                                Spacer(),
                                                                SvgPicture
                                                                    .asset(
                                                                  Constants
                                                                      .upload,
                                                                  colorFilter:
                                                                      ColorFilter
                                                                          .mode(
                                                                    Colors
                                                                        .white,
                                                                    BlendMode
                                                                        .srcIn,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          if (currentUser.roles
                                              .contains('admin'))
                                            GestureDetector(
                                              onTap: () {
                                                showCupertinoDialog(
                                                  barrierDismissible: true,
                                                  context: context,
                                                  builder: (context) =>
                                                      CupertinoAlertDialog(
                                                    title: const Text(
                                                      "emin misin?",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'SFProDisplayBold'),
                                                    ),
                                                    content: const Text(
                                                      'bu hesabı askıya alıyorsun',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'SFProDisplayMedium'),
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
                                                                'SFProDisplayRegular',
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
                                                                'SFProDisplayRegular',
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 15),
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 5),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    color:
                                                        Palette.darkGreyColor,
                                                    border: Border.all(
                                                        width: 0.45,
                                                        color: Palette
                                                            .darkGreyColor2)),
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            'hesabı askıya al',
                                                            style: TextStyle(
                                                                color: Palette
                                                                    .redColor),
                                                          ),
                                                          Spacer(),
                                                          Icon(
                                                              CupertinoIcons
                                                                  .xmark_shield,
                                                              color: Palette
                                                                  .redColor)
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          SizedBox(
                                            height: 30,
                                          ),
                                          // SizedBox(
                                          //   height: 20,
                                          // ),
                                          // SizedBox(
                                          //   width: 15,
                                          // ),
                                          // if (currentUser.roles
                                          //     .contains('admin'))
                                          //   Padding(
                                          //     padding:
                                          //         const EdgeInsets.all(15.0)
                                          //             .copyWith(top: 10),
                                          //     child: Row(
                                          //       children: [
                                          //         Expanded(
                                          //           child: CupertinoButton(
                                          //             borderRadius:
                                          //                 BorderRadius.circular(
                                          //                     17),
                                          //             padding:
                                          //                 EdgeInsets.symmetric(
                                          //                     vertical: 7),
                                          //             color: Palette
                                          //                 .textFieldColor,
                                          //             onPressed: () {
                                          // showCupertinoDialog(
                                          //   barrierDismissible:
                                          //       true,
                                          //   context: context,
                                          //   builder: (context) =>
                                          //       CupertinoAlertDialog(
                                          //     title: const Text(
                                          //       "emin misin?",
                                          //       style: TextStyle(
                                          //           fontFamily:
                                          //               'SFProDisplayBold'),
                                          //     ),
                                          //     content: const Text(
                                          //       'bu hesabı askıya alıyorsun',
                                          //       style: TextStyle(
                                          //           fontFamily:
                                          //               'SFProDisplayMedium'),
                                          //     ),
                                          //     actions: <CupertinoDialogAction>[
                                          //       CupertinoDialogAction(
                                          //         isDefaultAction:
                                          //             true,
                                          //         onPressed: () {
                                          //           Navigator.pop(
                                          //               context);
                                          //         },
                                          //         child:
                                          //             const Text(
                                          //           'geri',
                                          //           style:
                                          //               TextStyle(
                                          //             color: Palette
                                          //                 .themeColor,
                                          //             fontFamily:
                                          //                 'SFProDisplayRegular',
                                          //           ),
                                          //         ),
                                          //       ),
                                          //       CupertinoDialogAction(
                                          //         isDestructiveAction:
                                          //             true,
                                          //         onPressed:
                                          //             () async {
                                          //           suspendAccount(
                                          //             user.uid,
                                          //             context,
                                          //           );
                                          //           Navigator.pop(
                                          //               context);
                                          //         },
                                          //         child:
                                          //             const Text(
                                          //           'evet',
                                          //           style:
                                          //               TextStyle(
                                          //             color: Palette
                                          //                 .redColor,
                                          //             fontFamily:
                                          //                 'SFProDisplayRegular',
                                          //           ),
                                          //         ),
                                          //       ),
                                          //     ],
                                          //   ),
                                          // );
                                          // },
                                          //             child: Column(
                                          //               mainAxisSize:
                                          //                   MainAxisSize.min,
                                          //               children: [
                                          //                 Icon(
                                          //                   Icons
                                          //                       .report_gmailerrorred_outlined,
                                          //                   color: Palette
                                          //                       .redColor,
                                          //                   size: 22,
                                          //                 ),
                                          //                 SizedBox(
                                          //                   width: 5,
                                          //                 ),
                                          //                 Text(
                                          //                   'hesabı askıya al',
                                          //                   style: TextStyle(
                                          //                       color: Palette
                                          //                           .redColor),
                                          //                 ),
                                          //               ],
                                          //             ),
                                          //           ),
                                          //         ),
                                          //       ],
                                          //     ),
                                          //   ),
                                          // SizedBox(
                                          //   width: 10,
                                          // ),
                                          // Padding(
                                          //   padding: const EdgeInsets.all(15.0)
                                          //       .copyWith(top: 0),
                                          //   child: Row(
                                          //     children: [
                                          //       Expanded(
                                          //         child: CupertinoButton(
                                          //           borderRadius:
                                          //               BorderRadius.circular(
                                          //                   17),
                                          //           padding:
                                          //               EdgeInsets.symmetric(
                                          //                   vertical: 7),
                                          //           color:
                                          //               Palette.textFieldColor,
                                          //           onPressed: () {
                                          // showDialog(
                                          //   context: context,
                                          //   builder: (context) =>
                                          //       ReportDialog(
                                          //     noteId: '',
                                          //     accountId: widget.uid,
                                          //   ),
                                          // );
                                          //           },
                                          //           child: Column(
                                          //             mainAxisSize:
                                          //                 MainAxisSize.min,
                                          //             children: [
                                          //               Icon(
                                          //                 UniconsLine.megaphone,
                                          //                 color: Colors.white,
                                          //                 size: 19,
                                          //               ),
                                          //               SizedBox(
                                          //                 height: 5,
                                          //               ),
                                          //               Text(
                                          //                 'hesabı şikayet et',
                                          //                 style: TextStyle(
                                          //                     color:
                                          //                         Colors.white),
                                          //               ),
                                          //             ],
                                          //           ),
                                          //         ),
                                          //       ),
                                          //     ],
                                          //   ),
                                          // ),
                                          // SizedBox(
                                          //   width: 15,
                                          // ),
                                          // Padding(
                                          //   padding: const EdgeInsets.all(15.0)
                                          //       .copyWith(top: 10),
                                          //   child: Row(
                                          //     children: [
                                          //       Expanded(
                                          //         child: CupertinoButton(
                                          //           borderRadius:
                                          //               BorderRadius.circular(
                                          //                   17),
                                          //           padding:
                                          //               EdgeInsets.symmetric(
                                          //                   vertical: 7),
                                          //           color:
                                          //               Palette.textFieldColor,
                                          //           onPressed: () {
                                          //             showDialog(
                                          //               context: context,
                                          //               builder: (context) =>
                                          //                   ReportDialog(
                                          //                 noteId: '',
                                          //                 accountId: widget.uid,
                                          //               ),
                                          //             );
                                          //           },
                                          //           child: Column(
                                          //             mainAxisSize:
                                          //                 MainAxisSize.min,
                                          //             children: [
                                          //               Icon(
                                          //                 UniconsLine.megaphone,
                                          //                 color: Colors.white,
                                          //                 size: 19,
                                          //               ),
                                          //               SizedBox(
                                          //                 height: 5,
                                          //               ),
                                          //               Text(
                                          //                 'hesabı engelle',
                                          //                 style: TextStyle(
                                          //                     color:
                                          //                         Colors.white),
                                          //               ),
                                          //             ],
                                          //           ),
                                          //         ),
                                          //       ),
                                          //     ],
                                          //   ),
                                          // ),
                                          // SizedBox(
                                          //   height: 50,
                                          // ),
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
                                MaterialPageRoute(
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
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
                                              fontFamily: 'SFProDisplayBold'),
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
                                          'profili düzenle',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'SFProDisplayMedium'),
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
                                        color: user.followers
                                                .contains(currentUser.uid)
                                            ? Palette.redColor
                                            : Palette.themeColor,
                                        padding: EdgeInsets.zero,
                                        onPressed: () {
                                          print(
                                              "${currentUser.following.contains(user.uid)} sa" +
                                                  widget.uid +
                                                  user.uid);
                                          ref
                                              .read(
                                                  userProfileControllerProvider
                                                      .notifier)
                                              .followUser(
                                                  context, user, currentUser);
                                        },
                                        child: Text(
                                          user.followers
                                                  .contains(currentUser.uid)
                                              ? 'takipten çık'
                                              : 'takip et',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'SFProDisplayMedium'),
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
                                          ref
                                              .read(chatControllerProvider
                                                  .notifier)
                                              .startChat(
                                                  uids: [user.uid],
                                                  title: '',
                                                  description: '',
                                                  profilePic: null,
                                                  context: context,
                                                  isDM: true);
                                        },
                                        child: const Text(
                                          'mesaj at',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'SFProDisplayMedium'),
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
                                  return NoteCard(
                                    note: note,
                                    isComment: false,
                                  );
                                },
                              );
                            },
                            error: (error, stackTrace) {
                              return Text(error.toString());
                            },
                            loading: () => const Loader(),
                          )
                    else if (contentItems[1][1])
                      const NotAvailable()
                    else
                      ref.watch(getSchoolByIdProvider(user.schoolId)).when(
                            data: (School school) {
                              if (user.schoolId.contains('onay bekliyor:')) {
                                return Container(
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'onay bekliyor ... ',
                                          style: TextStyle(
                                              color: Palette.redColor),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
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
                                                      'SFProDisplayBold'),
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
                                                  fontFamily:
                                                      'SFProDisplayMedium',
                                                )),
                                            TextSpan(
                                                text: "\tkayıtlı öğrenci",
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontFamily:
                                                        'SFProDisplayMedium',
                                                    color: Palette
                                                        .placeholderColor)),
                                          ]),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                return GestureDetector(
                                  onTap: () {},
                                  child: GestureDetector(
                                    onTap: () {
                                      Routemaster.of(context).push(
                                          '/school-profile/${school.id}/');
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                                          'SFProDisplayBold'),
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
                                                      fontFamily:
                                                          'SFProDisplayMedium',
                                                    )),
                                                TextSpan(
                                                    text: "\tkayıtlı öğrenci",
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        fontFamily:
                                                            'SFProDisplayMedium',
                                                        color: Palette
                                                            .placeholderColor)),
                                              ]),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                            error: (error, stackTrace) =>
                                Text(error.toString()),
                            loading: () => const Loader(),
                          ),
                  ],
                ),
              ),
            ),
            error: (error, stackTrace) => Text(error.toString()),
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
                          MaterialPageRoute(
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
                              fontFamily: 'SFProDisplayRegular')),
                      const TextSpan(
                          text: ' takipçi',
                          style: TextStyle(
                              color: Palette.placeholderColor,
                              fontFamily: 'SFProDisplayRegular')),
                    ])),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
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
                              fontFamily: 'SFProDisplayRegular')),
                      const TextSpan(
                          text: ' takip edilen',
                          style: TextStyle(
                              color: Palette.placeholderColor,
                              fontFamily: 'SFProDisplayRegular')),
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
              fontFamily: 'SFProDisplayMedium'),
        ),
      ),
    );
  }
}
