import 'package:acc/core/commons/error_text.dart';
import 'package:acc/core/commons/image_view.dart';
import 'package:acc/core/commons/loader.dart';
import 'package:acc/core/constants/constants.dart';
import 'package:acc/models/note_model.dart';
import 'package:acc/models/school_model.dart';
import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  void deletePost(WidgetRef ref, BuildContext context) async {
    ref.read(postControllerProvider.notifier).deletePost(widget.note, context);
  }

  void likePost(WidgetRef ref) async {
    ref.read(postControllerProvider.notifier).like(widget.note, context);
  }

  void navigateToUser(BuildContext context) {
    Routemaster.of(context).push('/user-profile/${widget.note.uid}');
  }

  void navigateToSchool(BuildContext context) {
    Routemaster.of(context).push('/school-profile/${widget.note.schoolName}');
  }

  void navigateToPost(BuildContext context) {
    Routemaster.of(context).push('/note/${widget.note.id}/details');
  }

  bool isThread() {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final isTypeImage = widget.note.type == 'image';
    final UserModel user = ref.watch(userProvider)!;
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
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () =>
                                                navigateToUser(context),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  height: 50,
                                                  width: 50,
                                                  child: GestureDetector(
                                                    onTap: () =>
                                                        navigateToUser(context),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              13.0),
                                                      child: ref
                                                          .watch(
                                                              getUserDataProvider(
                                                                  widget.note
                                                                      .uid))
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
                                          if (widget.note.schoolName.isNotEmpty)
                                            GestureDetector(
                                              onTap: () =>
                                                  navigateToSchool(context),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    " • ",
                                                    style: const TextStyle(
                                                        fontFamily:
                                                            'JetBrainsMonoExtraBold'),
                                                  ),
                                                  SizedBox(
                                                    height: 20.0,
                                                    width: 20.0,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0),
                                                      child: ref.read(getSchoolByIdProvider(widget.note.schoolName)).when(
                                                          data: (School
                                                                  school) =>
                                                              Image.network(
                                                                  school.avatar,
                                                                  fit: BoxFit
                                                                      .cover),
                                                          error: (error,
                                                                  stackTrace) =>
                                                              ErrorText(
                                                                  error: error
                                                                      .toString()),
                                                          loading: () =>
                                                              const Loader()),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                        ],
                                      ),
                                      Text(
                                        " • ${timeago.format(widget.note.createdAt, locale: 'en_short')}",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    child: const Icon(
                                      CupertinoIcons.ellipsis,
                                    ),
                                    onTap: () {
                                      showMoreNoteActions(context, user);
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
              ],
            ),
          ),
          // widget.note actions
          Container(
            height: 42,
            margin: const EdgeInsets.only(top: 5.0),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: const BoxDecoration(
                border: Border(
              top: BorderSide(width: 0.25, color: Palette.postIconColor),
              bottom: BorderSide(width: 0.25, color: Palette.postIconColor),
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
                            Palette.postIconColor, BlendMode.srcIn),
                        fit: BoxFit.cover,
                        width: 22,
                        height: 22,
                      ),
                    ),
                    ref.watch(getPostCommentsProvider(widget.note.id)).when(
                          data: (comments) => Text(
                            '${comments.length}',
                            style: const TextStyle(fontSize: 17),
                          ),
                          error: (error, stackTrace) => ErrorText(
                            error: error.toString(),
                          ),
                          loading: () => const Loader(),
                        )
                  ],
                ),
                LikeButton(
                  countBuilder: (likeCount, isLiked, text) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Text(
                        '${likeCount == 0 ? '0' : likeCount}',
                        style: const TextStyle(fontSize: 17),
                      ),
                    );
                  },
                  onTap: (isLiked) async {
                    likePost(ref);
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
                            isLiked ? Palette.redColor : Palette.postIconColor,
                            BlendMode.srcIn),
                      ),
                    );
                  },
                  isLiked: widget.note.likes.contains(user.uid),
                  likeCount: widget.note.likes.length,
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
                        Palette.postIconColor, BlendMode.srcIn),
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
                            Palette.postIconColor, BlendMode.srcIn))),
                if (widget.note.schoolName.isNotEmpty)
                  ref.watch(getSchoolByIdProvider(widget.note.schoolName)).when(
                        data: (data) {
                          if (data.mods.contains(user.uid)) {
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
                                          deletePost(ref, context);
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

  Future<dynamic> showMoreNoteActions(
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
                height: 20,
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
                        padding: EdgeInsets.symmetric(vertical: 7),
                        color: Palette.textFieldColor,
                        onPressed: () {
                          deletePost(ref, context);
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
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: CupertinoButton(
                      padding: EdgeInsets.symmetric(vertical: 7),
                      color: Palette.textFieldColor,
                      onPressed: () {
                        // Share logic here
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
