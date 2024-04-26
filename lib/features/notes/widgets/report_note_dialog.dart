import 'package:acc/features/auth/controller/auth_controller.dart';
import 'package:acc/features/notes/controller/note_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../theme/palette.dart';

class ReportDialog extends ConsumerStatefulWidget {
  final String noteId;
  final String accountId;
  const ReportDialog({
    super.key,
    required this.noteId,
    required this.accountId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ReportNoteDialogState();
}

class _ReportNoteDialogState extends ConsumerState<ReportDialog> {
  TextEditingController detailController = TextEditingController();
  String selectedReason = '';
  void selectAndUnselectOthers(int index) {
    for (var element in reportReasons) {
      setState(() {
        element[1] = false;
        reportReasons[index][1] = true;
      });
    }
  }

  List<dynamic> reportReasons = [
    ['nefret', true],
    ['şiddet söylemi', false],
    ['spam', false],
    ['hassas veya rahatsız edici medya', false],
    ['aldatıcı kimlikler', false],
    ['diğer', false],
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.all(15.0),
      contentPadding: EdgeInsets.all(10).copyWith(top: 0),
      title: Text(
        widget.accountId.isEmpty
            ? 'notu' + ' şikayet et'
            : 'hesabı' + ' şikayet et',
        style: TextStyle(),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                  reportReasons.length,
                  (index) => GestureDetector(
                        onTap: () => selectAndUnselectOthers(index),
                        child: Container(
                          margin: index != reportReasons.length
                              ? EdgeInsets.only(right: 7.0)
                              : null,
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: reportReasons[index][1]
                                ? Palette.themeColor
                                : Palette.iconBackgroundColor,
                            borderRadius: BorderRadius.circular(200),
                          ),
                          child: Text(
                            reportReasons[index][0],
                            style: TextStyle(
                              color: reportReasons[index][1]
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                        ),
                      )),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          CupertinoTextField(
            controller: detailController,
            maxLength: 300,
            textAlignVertical: TextAlignVertical.top,
            minLines: 3,
            maxLines: null,
            style: TextStyle(
                fontFamily: 'JetBrainsMonoRegular', color: Colors.white),
            placeholder: 'detay',
            placeholderStyle: TextStyle(
                fontFamily: 'JetBrainsMonoRegular', color: Colors.grey),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Palette.iconBackgroundColor,
              border: Border.all(
                width: 0.25,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
      actions: [
        CupertinoButton(
          borderRadius: BorderRadius.circular(20.0),
          color: Palette.orangeColor,
          child: Text(
            'gönder',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'JetBrainsMonoBold',
            ),
          ),
          onPressed: () {
            final String uid = ref.read(userProvider)!.uid;
            ref.read(noteControllerProvider.notifier).reportNote(
                  context: context,
                  uid: uid,
                  noteId: widget.noteId,
                  accountId: widget.accountId,
                  reason: selectedReason,
                  detail: detailController.text.trim(),
                );
          },
        ),
      ],
    );
  }
}
