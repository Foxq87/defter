import 'package:acc/core/commons/error_text.dart';
import 'package:acc/core/commons/image_view.dart';
import 'package:acc/core/commons/loader.dart';
import 'package:acc/core/commons/view_users_by_uids.dart';
import 'package:acc/core/constants/constants.dart';
import 'package:acc/features/notes/widgets/report_note_dialog.dart';

import 'package:acc/models/note_model.dart';
import 'package:acc/models/school_model.dart';
import 'package:any_link_preview/any_link_preview.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:routemaster/routemaster.dart';
import '../../../core/utils.dart';
import '../../auth/controller/auth_controller.dart';

import '../controller/note_controller.dart';
import '../../school/controller/school_controller.dart';
import '../../../models/user_model.dart';
import '../../../theme/palette.dart';
import 'package:timeago/timeago.dart' as timeago;

class DetailedNoteCard extends ConsumerStatefulWidget {
  final Note note;
  const DetailedNoteCard({
    super.key,
    required this.note,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DetailedNoteCardState();
}

class _DetailedNoteCardState extends ConsumerState<DetailedNoteCard> {
  void deleteNote(
      WidgetRef ref, String currentUid, BuildContext context) async {
    ref
        .read(noteControllerProvider.notifier)
        .deleteNote(widget.note, currentUid, context);
  }

  void likeNote(WidgetRef ref) async {
    ref.read(noteControllerProvider.notifier).like(widget.note, context);
  }

  void navigateToUser(BuildContext context) {
    Routemaster.of(context).push('/user-profile/${widget.note.uid}');
  }

  void navigateToSchool(String schoolId, BuildContext context) {
    Routemaster.of(context).push('/school-profile/$schoolId');
  }

  void navigateToNote(BuildContext context) {
    Routemaster.of(context).push('/note/${widget.note.id}/details');
  }

  bool isThread() {
    return false;
  }

  String formattedDate(DateTime date) {
    final DateFormat formatter = DateFormat('HH:mm · dd.MM.yyyy');
    final String formatted = formatter.format(date);
    return formatted; // something like 2013-04-20
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timeago.setLocaleMessages('tr_short', timeago.TrShortMessages());
  }

  @override
  Widget build(BuildContext context) {
    final isTypeImage = widget.note.type == 'image';
    final UserModel currentUser = ref.watch(userProvider)!;
    // final currentTheme = ref.watch(themeNotifierProvider);

    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 10.0, right: 10),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () => navigateToUser(context),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              height: 40,
                                              width: 40,
                                              child: GestureDetector(
                                                onTap: () =>
                                                    navigateToUser(context),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  child: ref
                                                      .watch(
                                                          getUserDataProvider(
                                                              widget.note.uid))
                                                      .when(
                                                        data: (user) =>
                                                            Image.network(
                                                          user.profilePic,
                                                          fit: BoxFit.cover,
                                                        ),
                                                        error: (error,
                                                                stackTrace) =>
                                                            ErrorText(
                                                                error: error
                                                                    .toString()),
                                                        loading: () =>
                                                            const CupertinoActivityIndicator(),
                                                      ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            ref
                                                .watch(getUserDataProvider(
                                                    widget.note.uid))
                                                .when(
                                                    data: (user) => Text(
                                                          user.username,
                                                          style: const TextStyle(
                                                              fontSize: 16,
                                                              fontFamily:
                                                                  'JetBrainsMonoExtraBold'),
                                                        ),
                                                    error: (error,
                                                            stackTrace) =>
                                                        ErrorText(
                                                            error: error
                                                                .toString()),
                                                    loading: () =>
                                                        const Loader()),
                                          ],
                                        ),
                                      ),
                                      if (widget.note.schoolName.isEmpty)
                                        ref
                                            .read(getUserDataProvider(
                                                widget.note.uid))
                                            .when(
                                                data: (UserModel user) =>
                                                    TextButton(
                                                      onPressed: () =>
                                                          navigateToSchool(
                                                              user.schoolId,
                                                              context),
                                                      child: Text(
                                                        "/" + user.schoolId,
                                                        style: TextStyle(
                                                            color: Palette
                                                                .themeColor,
                                                            fontSize: 13),
                                                      ),
                                                    ),
                                                error: (error, stackTrace) =>
                                                    ErrorText(
                                                        error:
                                                            error.toString()),
                                                loading: () => const Loader()),
                                    ],
                                  ),
                                  Spacer(),
                                  Container(
                                    margin: EdgeInsets.only(right: 5.0),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 2.0),
                                    decoration: BoxDecoration(
                                      color: Palette.iconBackgroundColor,
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child: Text(
                                      "${timeago.format(widget.note.createdAt, locale: 'tr_short')}",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  GestureDetector(
                                    child: const Icon(
                                      CupertinoIcons.ellipsis,
                                    ),
                                    onTap: () {
                                      showMorenoteActions(context, currentUser);
                                    },
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                              if (widget.note.content.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Text(
                                    widget.note.content,
                                    style: const TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                )
                              else
                                const SizedBox(
                                  height: 10,
                                ),
                              if (isTypeImage)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Wrap(
                                    spacing: 7,
                                    runSpacing: 7,
                                    direction: Axis.horizontal,
                                    children:
                                        widget.note.imageLinks.map((imageLink) {
                                      return GestureDetector(
                                        onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ImageView(
                                              imageUrls: widget.note.imageLinks,
                                              imageFiles: const [],
                                              index: widget.note.imageLinks
                                                  .indexOf(imageLink),
                                            ),
                                          ),
                                        ),
                                        child: SizedBox(
                                          height:
                                              widget.note.imageLinks.length == 1
                                                  ? 200.0
                                                  : MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          2 -
                                                      20,
                                          width:
                                              widget.note.imageLinks.length == 1
                                                  ? MediaQuery.of(context)
                                                      .size
                                                      .width
                                                  : MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          2 -
                                                      20,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.network(imageLink,
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              if (widget.note.link.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(right: 18),
                                  child: AnyLinkPreview(
                                    displayDirection:
                                        UIDirection.uiDirectionHorizontal,
                                    link: widget.note.link,
                                  ),
                                ),
                              const SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    //Comment count
                    RichText(
                        text: TextSpan(
                      children: [
                        ref.watch(getNoteCommentsProvider(widget.note.id)).when(
                              data: (comments) => TextSpan(
                                text: '${comments.length}\t',
                                style: const TextStyle(
                                    fontSize: 17,
                                    fontFamily: 'JetBrainsMonoBold'),
                              ),
                              error: (error, stackTrace) => TextSpan(
                                text: error.toString(),
                              ),
                              loading: () => TextSpan(
                                text: '.\t',
                              ),
                            ),
                        TextSpan(
                          text: 'yorum',
                          style: const TextStyle(
                              color: Palette.placeholderColor,
                              fontSize: 14,
                              fontFamily: 'JetBrainsMonoRegular'),
                        ),
                      ],
                    )),
                    SizedBox(
                      width: 10.0,
                    ),
                    //Like Count

                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          backgroundColor: Palette.darkGreyColor,
                          context: context,
                          builder: (BuildContext context) {
                            return ViewUsersByUids(
                              uids: widget.note.likes,
                              isLiker: true,
                            );
                          },
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${widget.note.likes.length}\t',
                              style: const TextStyle(
                                fontSize: 17,
                                fontFamily: 'JetBrainsMonoBold',
                              ),
                            ),
                            TextSpan(
                              text: 'beğeni',
                              style: const TextStyle(
                                color: Palette.placeholderColor,
                                fontSize: 14,
                                fontFamily: 'JetBrainsMonoRegular',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Spacer(),
                    Text(
                      "\t ${formattedDate(widget.note.createdAt)}",
                      style: const TextStyle(
                        color: Palette.placeholderColor,
                        fontSize: 14,
                        fontFamily: 'JetBrainsMonoRegular',
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),

          //Note actions
          Container(
            height: 42,
            margin: const EdgeInsets.only(top: 5.0),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: const BoxDecoration(
                border: Border(
              top: BorderSide(width: 0.25, color: Palette.noteIconColor),
              bottom: BorderSide(width: 0.25, color: Palette.noteIconColor),
            )),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {},
                      icon: SvgPicture.asset(
                        Constants.comment,
                        colorFilter: const ColorFilter.mode(
                            Palette.noteIconColor, BlendMode.srcIn),
                        fit: BoxFit.cover,
                        width: 22,
                        height: 22,
                      ),
                    ),
                    // ref.watch(getNoteCommentsProvider(widget.note.id)).when(
                    //       data: (comments) => Text(
                    //         '${comments.length}',
                    //         style: const TextStyle(fontSize: 17),
                    //       ),
                    //       error: (error, stackTrace) => ErrorText(
                    //         error: error.toString(),
                    //       ),
                    //       loading: () => const Loader(),
                    //     )
                  ],
                ),
                LikeButton(
                  // countBuilder: (likeCount, isLiked, text) {
                  //   return Padding(
                  //     padding: const EdgeInsets.only(left: 5.0),
                  //     child: Text(
                  //       '${likeCount == 0 ? '0' : likeCount}',
                  //       style: const TextStyle(fontSize: 17),
                  //     ),
                  //   );
                  // },
                  onTap: (isLiked) async {
                    likeNote(ref);
                    return !isLiked;
                  },
                  likeBuilder: (isLiked) {
                    return SizedBox(
                      width: 22,
                      height: 22,
                      child: SvgPicture.asset(
                        isLiked
                            ? Constants.heartFilled
                            : Constants.heartOutlined,
                        fit: BoxFit.contain,
                        colorFilter: ColorFilter.mode(
                            isLiked ? Palette.redColor : Palette.noteIconColor,
                            BlendMode.srcIn),
                      ),
                    );
                  },
                  isLiked: widget.note.likes.contains(currentUser.uid),
                  // likeCount: widget.note.likes.length,
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    alertNotAvailable(context);
                  },
                  icon: SvgPicture.asset(
                    Constants.upload,
                    width: 22,
                    height: 22,
                    fit: BoxFit.cover,
                    colorFilter: const ColorFilter.mode(
                        Palette.noteIconColor, BlendMode.srcIn),
                  ),
                ),
                IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      alertNotAvailable(context);
                    },
                    icon: SvgPicture.asset(Constants.bookmarkFilled,
                        width: 22,
                        height: 22,
                        fit: BoxFit.cover,
                        colorFilter: const ColorFilter.mode(
                            Palette.noteIconColor, BlendMode.srcIn))),
                if (widget.note.schoolName.isNotEmpty)
                  ref.watch(getSchoolByIdProvider(widget.note.schoolName)).when(
                        data: (data) {
                          if (data.mods.contains(currentUser.uid)) {
                            return IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                showCupertinoDialog(
                                  barrierDismissible: true,
                                  context: context,
                                  builder: (context) => CupertinoAlertDialog(
                                    title: const Text(
                                      "emin misin?",
                                      style: TextStyle(
                                          fontFamily: 'JetBrainsMonoExtraBold'),
                                    ),
                                    content: const Text(
                                      'bu notu siliyorsun',
                                      style: TextStyle(
                                        fontFamily: 'JetBrainsMonoBold',
                                        color: Palette.redColor,
                                      ),
                                    ),
                                    actions: <CupertinoDialogAction>[
                                      CupertinoDialogAction(
                                        isDefaultAction: true,
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          'hayır',
                                          style: TextStyle(
                                            color: Palette.themeColor,
                                            fontFamily: 'JetBrainsMonoRegular',
                                          ),
                                        ),
                                      ),
                                      CupertinoDialogAction(
                                        isDestructiveAction: true,
                                        onPressed: () {
                                          deleteNote(
                                              ref, currentUser.uid, context);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          'evet',
                                          style: TextStyle(
                                            color: Palette.themeColor,
                                            fontFamily: 'JetBrainsMonoRegular',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              icon: const Icon(
                                CupertinoIcons.command,
                                color: Palette.themeColor,
                              ),
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                        error: (error, stackTrace) => ErrorText(
                          error: error.toString(),
                        ),
                        loading: () => const Loader(),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> showMorenoteActions(
      BuildContext context, UserModel currentUser) {
    return showModalBottomSheet(
      backgroundColor: Palette.darkGreyColor,
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  if (widget.note.uid == currentUser.uid)
                    Expanded(
                      child: CupertinoButton(
                        borderRadius: BorderRadius.circular(17),
                        padding: EdgeInsets.symmetric(vertical: 7),
                        color: Palette.textFieldColor,
                        onPressed: () {
                          showCupertinoDialog(
                            barrierDismissible: true,
                            context: context,
                            builder: (context) => CupertinoAlertDialog(
                              title: const Text(
                                "emin misin?",
                                style: TextStyle(
                                    fontFamily: 'JetBrainsMonoExtraBold'),
                              ),
                              content: const Text(
                                'bu notu siliyorsun',
                                style:
                                    TextStyle(fontFamily: 'JetBrainsMonoBold'),
                              ),
                              actions: <CupertinoDialogAction>[
                                CupertinoDialogAction(
                                  isDefaultAction: true,
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    'hayır',
                                    style: TextStyle(
                                      color: Palette.themeColor,
                                      fontFamily: 'JetBrainsMonoRegular',
                                    ),
                                  ),
                                ),
                                CupertinoDialogAction(
                                  isDestructiveAction: true,
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    deleteNote(ref, currentUser.uid, context);
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    'evet',
                                    style: TextStyle(
                                      color: Palette.redColor,
                                      fontFamily: 'JetBrainsMonoRegular',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              CupertinoIcons.delete,
                              color: Palette.redColor,
                              size: 22,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'notu sil',
                              style: TextStyle(color: Palette.redColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (widget.note.uid == currentUser.uid)
                    SizedBox(
                      width: 10,
                    ),
                  Expanded(
                    child: CupertinoButton(
                      padding: EdgeInsets.symmetric(vertical: 7),
                      color: Palette.textFieldColor,
                      borderRadius: BorderRadius.circular(17),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => ReportDialog(
                            noteId: widget.note.id,
                            accountId: '',
                          ),
                        );
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.report_gmailerrorred_outlined,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'notu şikayet et',
                            style: TextStyle(color: Colors.white),
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
  }
}
