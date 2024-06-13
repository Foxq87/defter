import 'package:acc/core/commons/error_text.dart';
import 'package:acc/core/commons/loader.dart';
import 'package:acc/core/constants/constants.dart';
import 'package:acc/features/auth/controller/auth_controller.dart';
import 'package:acc/features/notifications/controller/notification_controller.dart';
import 'package:acc/features/notes/widgets/detailed_note_card.dart';
import 'package:acc/features/notes/controller/note_controller.dart';
import 'package:acc/features/notes/widgets/note_card.dart';
import 'package:acc/theme/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/commons/nav_bar_button.dart';
import '../../../core/utils.dart';

class NoteDetails extends ConsumerStatefulWidget {
  final String noteId;
  const NoteDetails({super.key, required this.noteId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NoteDetailsState();
}

class _NoteDetailsState extends ConsumerState<NoteDetails> {
  Future<bool> _onWillPop(BuildContext context) async {
    bool? exitResult = await showDialog(
      context: context,
      builder: (context) => _buildExitDialog(context),
    );
    return exitResult ?? false;
  }

  Future<bool?> _showExitDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => _buildExitDialog(context),
    );
  }

  AlertDialog _buildExitDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Please confirm'),
      content: const Text('Do you want to exit the app?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text('No'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text('Yes'),
        ),
      ],
    );
  }

  ScrollController scrollController = ScrollController();
  TextEditingController commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ref.watch(getNoteByIdProvider(widget.noteId)).when(
          data: (note) => SafeArea(
            child: PopScope(
              // onPopInvoked: (didPop) => _onWillPop(context),
              child: Scaffold(
                appBar: CupertinoNavigationBar(
                  transitionBetweenRoutes: false,
                  backgroundColor: Colors.black,
                  middle: const Text(
                    'not',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'SFProDisplayRegular',
                        fontSize: 18),
                  ),
                  leading: JustIconButton(
                      icon: CupertinoIcons.back,
                      onPressed: () => Routemaster.of(context).pop()),
                  border: Border(
                      bottom: BorderSide(
                          width: 0.5, color: Palette.darkGreyColor2)),
                  // trailing: JustIconButton(icon: Icons.more_horiz, onPressed: () {}),
                ),
                body: ListView(
                  padding: EdgeInsets.only(bottom: 60),
                  children: [
                    DetailedNoteCard(note: note),
                    SizedBox(
                      height: 10,
                    ),
                    ref.watch(getNoteCommentsProvider(widget.noteId)).when(
                          data: (data) {
                            return ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: data.length,
                              itemBuilder: (BuildContext context, int index) {
                                final note = data[index];
                                return NoteCard(note: note);
                              },
                            );
                          },
                          error: (error, stackTrace) {
                            return ErrorText(
                              error: error.toString(),
                            );
                          },
                          loading: () => const Loader(),
                        ),
                  ],
                ),
                bottomSheet: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: const BoxDecoration(
                      color: Colors.black,
                      border: Border(
                          top: BorderSide(
                              width: 0.5, color: Palette.darkGreyColor2))),
                  child: Row(
                    children: [
                      Form(
                        child: Expanded(
                          child: Scrollbar(
                            scrollbarOrientation: ScrollbarOrientation.right,
                            thumbVisibility: true,
                            trackVisibility: true,
                            controller: scrollController,
                            child: CupertinoTextField(
                              cursorColor: Palette.themeColor,
                              scrollController: scrollController,
                              maxLines: 4,
                              minLines: 1,
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'SFProDisplayRegular',
                              ),
                              controller: commentController,
                              placeholder: "yorum at",
                              placeholderStyle: const TextStyle(
                                fontFamily: 'SFProDisplayRegular',
                                color: Palette.placeholderColor,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 6.0,
                      ),
                      SizedBox(
                        width: 35,
                        height: 35,
                        child: CupertinoButton(
                          borderRadius: BorderRadius.circular(130.0),
                          padding: EdgeInsets.zero,
                          color: Palette.themeColor,
                          onPressed: () {
                            final currentUser = ref.read(userProvider)!;
                            String currentUserUid = currentUser.uid;
                            if (commentController.text.trim().isNotEmpty) {
                              String link = getLinkFromText(
                                  commentController.text.trim());
                              if (note.uid != currentUserUid) {
                                ref
                                    .read(
                                        notificationControllerProvider.notifier)
                                    .sendNotification(
                                      context: context,
                                      content:
                                          "${currentUser.username} notuna yorum bıraktı",
                                      type: "comment",
                                      id: "${note.id}-comment",
                                      receiverUid: note.uid,
                                      senderId: currentUserUid,
                                      noteId: note.id,
                                    );
                              }
                              ref
                                  .read(noteControllerProvider.notifier)
                                  .shareTextNote(
                                    context: context,
                                    schoolId: note.schoolName,
                                    content: commentController.text.trim(),
                                    link: link,
                                    repliedTo: widget.noteId,
                                  );
                            }
                            commentController.clear();
                          },
                          child: SvgPicture.asset(
                            Constants.send,
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                            height: 20,
                            width: 20,
                            colorFilter: const ColorFilter.mode(
                                Colors.black, BlendMode.srcIn),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          error: (error, stackTrace) => Text(error.toString()),
          loading: () => const Loader(),
        );
  }
}
