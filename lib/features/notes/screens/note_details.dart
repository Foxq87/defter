import 'package:acc/core/commons/error_text.dart';
import 'package:acc/core/commons/loader.dart';
import 'package:acc/features/auth/controller/auth_controller.dart';
import 'package:acc/features/notifications/controller/notification_controller.dart';
import 'package:acc/features/notes/widgets/detailed_note_card.dart';
import 'package:acc/features/notes/controller/note_controller.dart';
import 'package:acc/features/notes/widgets/note_card.dart';
import 'package:acc/theme/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  TextEditingController commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ref.watch(getNoteByIdProvider(widget.noteId)).when(
          data: (note) => Scaffold(
            appBar: CupertinoNavigationBar(
              transitionBetweenRoutes: false,
              backgroundColor: Palette.backgroundColor,
              middle: const Text(
                'not',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'JetBrainsMonoRegular',
                    fontSize: 18),
              ),
              leading: JustIconButton(
                  icon: CupertinoIcons.back,
                  onPressed: () => Routemaster.of(context).pop(context)),
              // trailing: JustIconButton(icon: Icons.more_horiz, onPressed: () {}),
            ),
            body: ListView(
              padding: EdgeInsets.only(bottom: 60),
              children: [
                DetailedNoteCard(note: note),
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
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: const BoxDecoration(
                  color: Palette.darkGreyColor,
                  border:
                      Border(top: BorderSide(width: 0.1, color: Colors.grey))),
              child: SizedBox(
                height: 35,
                child: Row(
                  children: [
                    Form(
                      child: Expanded(
                        child: CupertinoTextField(
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'JetBrainsMonoRegular',
                          ),
                          controller: commentController,
                          placeholder: "Write your reply",
                          placeholderStyle: const TextStyle(
                            fontFamily: 'JetBrainsMonoRegular',
                            color: Palette.placeholderColor,
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(13.0),
                              border: Border.all(
                                  width: 0.6, color: Palette.noteIconColor),
                              color: Palette.darkGreyColor),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 6.0,
                    ),
                    CupertinoButton(
                        borderRadius: BorderRadius.circular(13.0),
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        color: Palette.themeColor,
                        onPressed: () {
                          final currentUser = ref.read(userProvider)!;
                          String currentUserUid = currentUser.uid;
                          if (commentController.text.trim().isNotEmpty) {
                            String link =
                                getLinkFromText(commentController.text.trim());
                            if (note.uid != currentUserUid) {
                              ref
                                  .read(notificationControllerProvider.notifier)
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
                                  selectedSchoolId: note.schoolName,
                                  content: commentController.text.trim(),
                                  link: link,
                                  repliedTo: widget.noteId,
                                );
                          }
                          commentController.clear();
                        },
                        child: const Text(
                          'ok',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'JetBrainsMonoBold'),
                        )),
                  ],
                ),
              ),
            ),
          ),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
