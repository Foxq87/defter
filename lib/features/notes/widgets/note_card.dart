import 'package:acc/core/commons/error_text.dart';
import 'package:acc/core/commons/image_view.dart';
import 'package:acc/core/commons/loader.dart';
import 'package:acc/core/constants/constants.dart';
import 'package:acc/core/utils.dart';
import 'package:acc/features/bookmarks/controller/bookmark_controller.dart';
import 'package:acc/features/notes/screens/note_details.dart';
import 'package:acc/features/notes/widgets/report_note_dialog.dart';
import 'package:acc/models/note_model.dart';
import 'package:any_link_preview/any_link_preview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:like_button/like_button.dart';
import 'package:routemaster/routemaster.dart';
import '../../auth/controller/auth_controller.dart';
import '../../user_profile/controller/user_profile_controller.dart';
import '../controller/note_controller.dart';
import '../../school/controller/school_controller.dart';
import '../../../models/user_model.dart';
import '../../../theme/palette.dart';
import 'package:timeago/timeago.dart' as timeago;

class NoteCard extends ConsumerStatefulWidget {
  final Note note;
  final bool? isComment;
  const NoteCard({super.key, required this.note, this.isComment = true});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NoteCardState();
}

class _NoteCardState extends ConsumerState<NoteCard> {
  // List subComments = [];
  // bool result = false;
  // doesReplyExists(UserModel currentUser) {
  //   if (false) {
  //     setState(() {
  //       result = false;
  //     });
  //   } else if (true) {
  //     FirebaseFirestore.instance.collection('posts')
  //         .where('uid', isEqualTo: currentUser.uid)
  //         .where(
  //           'attachedScaleId',
  //           arrayContains: widget.scaleId,
  //         )
  //         .limit(1)
  //         .get()
  //         .then((doc) {
  //       if (doc.docs.isNotEmpty) {
  //         setState(() {
  //           setState(() {
  //             subComments = doc.docs
  //                 .map((doc) => Scale(
  //                       writerId: doc['writerId'],
  //                       content: doc['content'],
  //                       likes: doc['likes'],
  //                       timestamp: doc['timestamp'],
  //                       scaleId: doc['scaleId'],
  //                       mediaUrl: doc['mediaUrl'],
  //                       postId: doc['postId'],
  //                       attachedScaleId: doc['attachedScaleId'],
  //                       isReply: doc['isReply'],
  //                       repostedScaleId: doc['repostedScaleId'],
  //                       currentScreen: widget.currentScreen,
  //                     ))
  //                 .toList();
  //             result = true;
  //           });
  //         });
  //       } else {
  //         setState(() {
  //           result = false;
  //         });
  //       }
  //     });
  //   } else {
  //     scalesRef
  //         .where(
  //           'attachedScaleId',
  //           arrayContains: widget.scaleId,
  //         )
  //         .limit(1)
  //         .get()
  //         .then((doc) {
  //       if (doc.docs.isNotEmpty) {
  //         setState(() {
  //           result = true;

  //           subComments = doc.docs
  //               .map((doc) => Scale(
  //                     writerId: doc['writerId'],
  //                     content: doc['content'],
  //                     likes: doc['likes'],
  //                     timestamp: doc['timestamp'],
  //                     scaleId: doc['scaleId'],
  //                     mediaUrl: doc['mediaUrl'],
  //                     postId: doc['postId'],
  //                     attachedScaleId: doc['attachedScaleId'],
  //                     isReply: doc['isReply'],
  //                     repostedScaleId: doc['repostedScaleId'],
  //                     currentScreen: widget.currentScreen,
  //                   ))
  //               .toList();
  //         });
  //       } else {
  //         setState(() {
  //           result = false;
  //         });
  //       }
  //     });
  //   }
  // }

  void deleteNote(String currentUid, BuildContext context) async {
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
    Routemaster.of(context).push('/school-profile/${schoolId}');
  }

  void navigateToNote(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => NoteDetails(noteId: widget.note.id),
    ));
//  NoteDetails(noteId: widget.note.id),

    // Routemaster.of(context).push('/note/${widget.note.id}/details');
  }

  int threadCounter = 0;

  // threads(Note note) {
  //   return ref.read(getNoteThreads(note.id)).when(
  //       data: (data) => data,
  //       error: (error, stackTrace) => Text(error.toString()),
  //       loading: () => CupertinoActivityIndicator());
  // }

  void followUser(BuildContext context, UserModel currentUser, UserModel user) {
    ref
        .read(userProfileControllerProvider.notifier)
        .followUser(context, user, currentUser);
    showSnackBar(context, "${user.username}'i takip ediyorsun");
  }

  @override
  void initState() {
    super.initState();
    timeago.setLocaleMessages('tr_short', timeago.TrShortMessages());
  }

  @override
  Widget build(BuildContext context) {
    final isTypeImage = widget.note.type == 'image';
    final UserModel currentUser = ref.watch(userProvider)!;
    bool isLiked = widget.note.likes.contains(currentUser.uid);
    bool isBookmarked = widget.note.bookmarks.contains(currentUser.uid);

    // final currentTheme = ref.watch(themeNotifierProvider);

    return ref
        .watch(getNoteThreads(widget.note.id + '+' + widget.note.uid))
        .when(
            data: (threads) {
              return Column(
                children: [
                  GestureDetector(
                    onTap: () => navigateToNote(context),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: threads.isEmpty
                                  ? BorderSide(
                                      width: 0.25, color: Palette.noteIconColor)
                                  : BorderSide())),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 10.0,
                            top: threads.isEmpty || !widget.isComment!
                                ? 10.0
                                : 2.0,
                            right: 10),
                        child: IntrinsicHeight(
                            child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                ref
                                    .watch(getUserDataProvider(widget.note.uid))
                                    .when(
                                      data: (user) => GestureDetector(
                                        onTap: () => followUser,
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                if (!user.followers.contains(
                                                    currentUser.uid)) {
                                                  followUser(context,
                                                      currentUser, user);
                                                } else {
                                                  navigateToUser(context);
                                                }
                                              },
                                              child: Container(
                                                  height: 40,
                                                  width: 40,
                                                  decoration: BoxDecoration(
                                                      color: Palette
                                                          .iconBackgroundColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      image: DecorationImage(
                                                        image: NetworkImage(
                                                          user.profilePic,
                                                        ),
                                                        fit: BoxFit.cover,
                                                      )),
                                                  child: SizedBox()),
                                            ),
                                            if (!user.followers.contains(
                                                    currentUser.uid) &&
                                                currentUser.uid != user.uid)
                                              Positioned(
                                                bottom: -5.5,
                                                right: -8.5,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    if (!currentUser.following
                                                            .contains(
                                                                user.uid) &&
                                                        currentUser.uid !=
                                                            user.uid) {
                                                      followUser(context,
                                                          currentUser, user);
                                                    } else {
                                                      navigateToUser(context);
                                                    }
                                                  },
                                                  child: Container(
                                                    height: 17,
                                                    width: 17,
                                                    margin: EdgeInsets.only(
                                                        right: 5.0),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 2.0),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          width: 1.5,
                                                          color: Colors.black),
                                                      color:
                                                          Palette.orangeColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0),
                                                    ),
                                                    child: Center(
                                                      child: Icon(
                                                        CupertinoIcons.add,
                                                        size: 12,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                          ],
                                        ),
                                      ),
                                      error: (error, stackTrace) => SizedBox(),
                                      loading: () => SizedBox(),
                                    ),
                                const SizedBox(
                                  height: 5,
                                ),
                                if (threads.isNotEmpty)
                                  Flexible(
                                    child: VerticalDivider(
                                      color: Colors.grey[850],
                                      thickness: 2,
                                    ),
                                  )

                                //GOAT
                                // Flexible(
                                //   child: VerticalDivider(
                                //     color: Colors.grey[850],
                                //     thickness: 2,
                                //   ),
                                // ),
                                // NoteCard(note: widget.note)
                              ],
                            ),
                            Flexible(
                              child: Column(
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                        // color: currentTheme.drawerTheme.backgroundColor,
                                        ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.only(
                                                  left: 10,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () =>
                                                                  navigateToUser(
                                                                      context),
                                                              child: ref
                                                                  .watch(getUserDataProvider(
                                                                      widget
                                                                          .note
                                                                          .uid))
                                                                  .when(
                                                                      data: (user) =>
                                                                          Text(
                                                                            user.username,
                                                                            style:
                                                                                const TextStyle(fontSize: 15, fontFamily: 'JetBrainsMonoBold'),
                                                                          ),
                                                                      error: (error,
                                                                              stackTrace) =>
                                                                          ErrorText(
                                                                              error: error
                                                                                  .toString()),
                                                                      loading: () =>
                                                                          const Loader()),
                                                            ),
                                                          ],
                                                        ),
                                                        if (widget.note
                                                            .schoolName.isEmpty)
                                                          ref
                                                              .read(
                                                                  getUserDataProvider(
                                                                      widget.note
                                                                          .uid))
                                                              .when(
                                                                  data: (UserModel
                                                                          user) =>
                                                                      GestureDetector(
                                                                        onTap: () => navigateToSchool(
                                                                            user.schoolId,
                                                                            context),
                                                                        child:
                                                                            Text(
                                                                          "\t/" +
                                                                              user.schoolId,
                                                                          style: TextStyle(
                                                                              color: Palette.themeColor,
                                                                              fontSize: 12),
                                                                        ),
                                                                      ),
                                                                  error: (error,
                                                                          stackTrace) =>
                                                                      ErrorText(
                                                                          error: error
                                                                              .toString()),
                                                                  loading: () =>
                                                                      const Loader()),
                                                        const Spacer(),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right: 5.0),
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      2.0),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Palette
                                                                .iconBackgroundColor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.0),
                                                          ),
                                                          child: Text(
                                                            "${timeago.format(widget.note.createdAt, locale: 'tr_short')}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          child: const Icon(
                                                            CupertinoIcons
                                                                .ellipsis,
                                                            size: 18,
                                                          ),
                                                          onTap: () {
                                                            showMorenoteActions(
                                                                context,
                                                                currentUser);
                                                          },
                                                        ),
                                                      ],
                                                    ),

                                                    if (widget.note.content
                                                        .isNotEmpty)
                                                      Text(
                                                        widget.note.content,
                                                        style: const TextStyle(
                                                          fontSize: 15,
                                                        ),
                                                      )
                                                    else
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                    if (isTypeImage)
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                right: 10.0,
                                                                bottom: 5.0,
                                                                top: 5.0),
                                                        child: Wrap(
                                                          spacing: 7.0,
                                                          runSpacing: 7.0,
                                                          children: widget
                                                              .note.imageLinks
                                                              .map((imageLink) {
                                                            return GestureDetector(
                                                              onTap: () =>
                                                                  Navigator
                                                                      .push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) => ImageView(
                                                                      imageUrls: widget
                                                                          .note
                                                                          .imageLinks,
                                                                      imageFiles: const [],
                                                                      index: widget
                                                                          .note
                                                                          .imageLinks
                                                                          .indexOf(
                                                                              imageLink)),
                                                                ),
                                                              ),
                                                              child: Container(
                                                                height: widget
                                                                            .note
                                                                            .imageLinks
                                                                            .length ==
                                                                        1
                                                                    ? 200.0
                                                                    : 130.0,
                                                                width: widget
                                                                            .note
                                                                            .imageLinks
                                                                            .length ==
                                                                        1
                                                                    ? MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width
                                                                    : 130.0,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Palette
                                                                      .textFieldColor,
                                                                  border: Border.all(
                                                                      width:
                                                                          0.2,
                                                                      color: Colors
                                                                          .grey),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                ),
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  child: Image
                                                                      .network(
                                                                    imageLink,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    // loadingBuilder: (BuildContext
                                                                    //         context,
                                                                    //     Widget child,
                                                                    //     ImageChunkEvent?
                                                                    //         loadingProgress) {
                                                                    //   if (loadingProgress ==
                                                                    //       null) {
                                                                    //     return child;
                                                                    //   }
                                                                    //   return Center(
                                                                    //     child: SizedBox(
                                                                    //       height: widget
                                                                    //                   .note
                                                                    //                   .imageLinks
                                                                    //                   .length ==
                                                                    //               1
                                                                    //           ? 200.0
                                                                    //           : 130.0,
                                                                    //       width: widget
                                                                    //                   .note
                                                                    //                   .imageLinks
                                                                    //                   .length ==
                                                                    //               1
                                                                    //           ? MediaQuery.of(
                                                                    //                   context)
                                                                    //               .size
                                                                    //               .width
                                                                    //           : 130.0,
                                                                    //       child:
                                                                    //           LinearProgressIndicator(
                                                                    //         color: Palette
                                                                    //             .themeColor,
                                                                    //         value: loadingProgress
                                                                    //                     .expectedTotalBytes !=
                                                                    //                 null
                                                                    //             ? loadingProgress
                                                                    //                     .cumulativeBytesLoaded /
                                                                    //                 loadingProgress
                                                                    //                     .expectedTotalBytes!
                                                                    //             : null,
                                                                    //       ),
                                                                    //     ),
                                                                    //   );
                                                                    // },
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          }).toList(),
                                                        ),
                                                      ),

                                                    if (widget
                                                        .note.link.isNotEmpty)
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                right: 18,
                                                                top: 5),
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                              color: Palette
                                                                  .noteIconColor,
                                                              width: 0.5,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12.0),
                                                          ),
                                                          child: AnyLinkPreview(
                                                            removeElevation:
                                                                true,
                                                            errorBody:
                                                                'öğrenci sosyal medya platformu',
                                                            errorImage:
                                                                'https://firebasestorage.googleapis.com/v0/b/appbeyoglu.appspot.com/o/defter-logo.png?alt=media&token=25fdfec5-ca45-4c37-b4ed-e5a09cae249e',
                                                            displayDirection:
                                                                UIDirection
                                                                    .uiDirectionHorizontal,
                                                            link: widget
                                                                .note.link,
                                                          ),
                                                        ),
                                                      ),

                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    // widget.note actions
                                                    SizedBox(
                                                      height: 20,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              IconButton(
                                                                padding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                onPressed: () =>
                                                                    navigateToNote(
                                                                        context),
                                                                icon: SvgPicture
                                                                    .asset(
                                                                  Constants
                                                                      .comment,
                                                                  colorFilter: const ColorFilter
                                                                      .mode(
                                                                      Palette
                                                                          .noteIconColor,
                                                                      BlendMode
                                                                          .srcIn),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  width: 20,
                                                                  height: 20,
                                                                ),
                                                              ),
                                                              ref
                                                                  .watch(getNoteCommentsProvider(
                                                                      widget
                                                                          .note
                                                                          .id))
                                                                  .when(
                                                                    data:
                                                                        (comments) =>
                                                                            Text(
                                                                      '${comments.length}',
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              15),
                                                                    ),
                                                                    error: (error,
                                                                            stackTrace) =>
                                                                        ErrorText(
                                                                      error: error
                                                                          .toString(),
                                                                    ),
                                                                    loading: () =>
                                                                        const Text(
                                                                      '0',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              15),
                                                                    ),
                                                                  )
                                                            ],
                                                          ),
                                                          LikeButton(
                                                            countBuilder:
                                                                (likeCount,
                                                                    isLiked,
                                                                    text) {
                                                              return Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            5.0),
                                                                child: Text(
                                                                  '${likeCount == 0 ? '0' : likeCount}',
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          15),
                                                                ),
                                                              );
                                                            },
                                                            onTap:
                                                                (isLiked) async {
                                                              likeNote(ref);
                                                              return !isLiked;
                                                            },
                                                            likeBuilder:
                                                                (isLiked) {
                                                              return SizedBox(
                                                                width: 20,
                                                                height: 20,
                                                                child:
                                                                    SvgPicture
                                                                        .asset(
                                                                  isLiked
                                                                      ? Constants
                                                                          .heartFilled
                                                                      : Constants
                                                                          .heartOutlined,
                                                                  fit: BoxFit
                                                                      .contain,
                                                                  colorFilter: ColorFilter.mode(
                                                                      isLiked
                                                                          ? Palette
                                                                              .redColor
                                                                          : Palette
                                                                              .noteIconColor,
                                                                      BlendMode
                                                                          .srcIn),
                                                                ),
                                                              );
                                                            },
                                                            isLiked: isLiked,
                                                            likeCount: widget
                                                                .note
                                                                .likes
                                                                .length,
                                                          ),
                                                          IconButton(
                                                            padding:
                                                                EdgeInsets.zero,
                                                            onPressed: () {
                                                              alertNotAvailable(
                                                                  context);
                                                            },
                                                            icon: SvgPicture
                                                                .asset(
                                                              Constants.upload,
                                                              width: 20,
                                                              height: 20,
                                                              fit: BoxFit.cover,
                                                              colorFilter:
                                                                  const ColorFilter
                                                                      .mode(
                                                                      Palette
                                                                          .noteIconColor,
                                                                      BlendMode
                                                                          .srcIn),
                                                            ),
                                                          ),
                                                          IconButton(
                                                            padding:
                                                                EdgeInsets.zero,
                                                            onPressed: () {
                                                              ref
                                                                  .read(bookmarkControllerProvider
                                                                      .notifier)
                                                                  .bookmarkNote(
                                                                      widget
                                                                          .note,
                                                                      context);
                                                            },
                                                            icon: SvgPicture
                                                                .asset(
                                                              isBookmarked
                                                                  ? Constants
                                                                      .bookmarkFilled
                                                                  : Constants
                                                                      .bookmarkOutlined,
                                                              width: 20,
                                                              height: 20,
                                                              fit: BoxFit.cover,
                                                              colorFilter: ColorFilter.mode(
                                                                  isBookmarked
                                                                      ? Palette
                                                                          .themeColor
                                                                      : Palette
                                                                          .noteIconColor,
                                                                  BlendMode
                                                                      .srcIn),
                                                            ),
                                                          ),
                                                          if (widget
                                                                  .note
                                                                  .schoolName
                                                                  .isNotEmpty &&
                                                              !widget.note
                                                                  .schoolName
                                                                  .contains(
                                                                      'closeFriends-'))
                                                            ref
                                                                .watch(getSchoolByIdProvider(
                                                                    widget.note
                                                                        .schoolName))
                                                                .when(
                                                                  data: (data) {
                                                                    if (data
                                                                        .mods
                                                                        .contains(
                                                                            currentUser.uid)) {
                                                                      return IconButton(
                                                                        padding:
                                                                            EdgeInsets.zero,
                                                                        onPressed:
                                                                            () {
                                                                          showCupertinoDialog(
                                                                            barrierDismissible:
                                                                                true,
                                                                            context:
                                                                                context,
                                                                            builder: (context) =>
                                                                                CupertinoAlertDialog(
                                                                              title: const Text(
                                                                                "emin misin?",
                                                                                style: TextStyle(fontFamily: 'JetBrainsMonoExtraBold'),
                                                                              ),
                                                                              content: const Text(
                                                                                'bu notu siliyorsun',
                                                                                style: TextStyle(fontFamily: 'JetBrainsMonoBold'),
                                                                              ),
                                                                              actions: <CupertinoDialogAction>[
                                                                                CupertinoDialogAction(
                                                                                  isDefaultAction: true,
                                                                                  onPressed: () {
                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                  child: const Text(
                                                                                    'hayır',
                                                                                    style: TextStyle(color: Palette.themeColor),
                                                                                  ),
                                                                                ),
                                                                                CupertinoDialogAction(
                                                                                  isDestructiveAction: true,
                                                                                  onPressed: () {
                                                                                    deleteNote(currentUser.uid, context);
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
                                                                        icon:
                                                                            const Icon(
                                                                          CupertinoIcons
                                                                              .command,
                                                                          color:
                                                                              Palette.themeColor,
                                                                        ),
                                                                      );
                                                                    } else {
                                                                      return const SizedBox();
                                                                    }
                                                                  },
                                                                  error: (error,
                                                                          stackTrace) =>
                                                                      ErrorText(
                                                                    error: error
                                                                        .toString(),
                                                                  ),
                                                                  loading: () =>
                                                                      const Loader(),
                                                                ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ],
                        )),
                      ),
                    ),
                  ),
                  if (threads.isNotEmpty && widget.isComment!)
                    buildThread(threads)
                  else if (threads.isNotEmpty)
                    Column(
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            height: 17,
                            child: CupertinoButton(
                              padding: EdgeInsets.only(
                                left: 15,
                              ),
                              child: Text(
                                'zinciri gör',
                                style: TextStyle(
                                    color: Palette.themeColor,
                                    fontFamily: 'JetBrainsMonoRegular',
                                    fontSize: 14),
                              ),
                              onPressed: () => navigateToNote(context),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(
                          thickness: 0.25,
                          color: Palette.noteIconColor,
                          height: 0,
                        ),
                      ],
                    )
                ],
              );
            },
            error: (error, stackTrace) => Text(error.toString() + 'error'),
            loading: () => CupertinoActivityIndicator());
  }

  NoteCard buildThread(List<Note> threads) {
    setState(() {
      threadCounter++;
    });
    print(threadCounter);
    return NoteCard(note: threads[0]);
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
                        padding: EdgeInsets.symmetric(vertical: 10),
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
                                    deleteNote(currentUser.uid, context);
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
                      borderRadius: BorderRadius.circular(17),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      color: Palette.textFieldColor,
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
