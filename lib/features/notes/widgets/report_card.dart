import 'package:acc/core/commons/large_text.dart';
import 'package:acc/features/auth/controller/auth_controller.dart';
import 'package:acc/features/home/drawers/drawer.dart';
import 'package:acc/features/notes/controller/note_controller.dart';
import 'package:acc/features/notes/widgets/note_card.dart';
import 'package:acc/features/notes/widgets/notes_loading_view.dart';
import 'package:acc/models/report_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../theme/palette.dart';

class ReportCard extends ConsumerStatefulWidget {
  final Report report;
  const ReportCard({super.key, required this.report});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReportCardState();
}

class _ReportCardState extends ConsumerState<ReportCard> {
  buildReportedContent() {
    return ref.watch(getNoteByIdProvider(widget.report.noteId)).when(
        data: (data) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(width: 2, color: Palette.redColor)),
                    child: NoteCard(note: data)),
                ElevatedButton(
                  child: Text('Delete Reported Content and Warn Author'),
                  onPressed: () {
                    ref.read(noteControllerProvider.notifier).deleteNote(
                          data,
                          context,
                        );
                    ref.read(authControllerProvider.notifier).warnUser(
                          widget.report.reportedUid,
                          context,
                        );
                  },
                ),
              ],
            ),
        error: (error, stackTrace) => Text(error.toString()),
        loading: () => noteCard());
  }

  buildReportedUser() {
    return ref.watch(getUserDataProvider(widget.report.reportedUid)).when(
        data: (data) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                largeText('şikayet edilen kullanıcı', false),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(
                      data.profilePic,
                      height: 40,
                      width: 40,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(data.name),
                  subtitle: Text(
                    "@" + data.username,
                    style: TextStyle(color: Palette.placeholderColor),
                  ),
                  onTap: () {
                    navigateToProfile(context, data);
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (data.roles.contains('appbeyoglu-user'))
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.asset(
                            'assets/appbeyoglu-icon.png',
                            height: 35,
                            width: 35,
                            fit: BoxFit.cover,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
        error: (error, stackTrace) => Text(error.toString()),
        loading: () => Text('loading...'));
  }

  buildReportingUser() {
    return ref.watch(getUserDataProvider(widget.report.reportingUid)).when(
        data: (data) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                largeText('şikayet eden kullanıcı', false),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(
                      data.profilePic,
                      height: 40,
                      width: 40,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(data.name),
                  subtitle: Text(
                    "@" + data.username,
                    style: TextStyle(color: Palette.placeholderColor),
                  ),
                  onTap: () {
                    navigateToProfile(context, data);
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (data.roles.contains('appbeyoglu-user'))
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.asset(
                            'assets/appbeyoglu-icon.png',
                            height: 35,
                            width: 35,
                            fit: BoxFit.cover,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
        error: (error, stackTrace) => Text(error.toString()),
        loading: () => Text('loading...'));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: <Widget>[
        buildReportedUser(),
        buildReportingUser(),
        buildReportReasonAndDetails(),
        if (widget.report.noteId.isNotEmpty) buildReportedContent(),
        Text(
          widget.report.createdAt.toString(),
          style: TextStyle(color: Palette.placeholderColor),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          child: Text('Ban Reported User'),
          onPressed: () {
            ref
                .read(authControllerProvider.notifier)
                .suspendAccount(widget.report.reportedUid, context);
            // Add your code to ban the reported user
          },
        ),
        ElevatedButton(
          child: Text('Dismiss'),
          onPressed: () {
            ref.read(noteControllerProvider.notifier).reportUserOrContent(
                  context: context,
                  uid: widget.report.reportingUid,
                  noteId: widget.report.noteId,
                  accountId: widget.report.reportedUid,
                  reason: widget.report.reason,
                  detail: widget.report.detail,
                  isEvaluated: true,
                  reportId: widget.report.id,
                );
            // Add your code to ban the reported user
          },
        ),
      ],
    );
  }

  Column buildReportReasonAndDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            padding: EdgeInsets.symmetric(vertical: 3, horizontal: 7),
            decoration: BoxDecoration(
                color: Palette.darkGreyColor2,
                borderRadius: BorderRadius.circular(8)),
            child: Text(widget.report.reason)),
        if (widget.report.detail.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 7,
              ),
              Text(
                'not:',
                style: TextStyle(color: Colors.white),
              ),
              Container(
                  margin: EdgeInsets.only(top: 2),
                  padding: EdgeInsets.symmetric(vertical: 3, horizontal: 7),
                  decoration: BoxDecoration(
                      color: Palette.darkGreyColor2,
                      borderRadius: BorderRadius.circular(8)),
                  child: Text(widget.report.detail)),
            ],
          ),
      ],
    );
  }
}
