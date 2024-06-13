import 'dart:io';
import 'package:acc/features/notifications/controller/notification_controller.dart';
import 'package:acc/models/report_model.dart';
import 'package:acc/models/school_model.dart';
import 'package:acc/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:acc/core/enums/enums.dart';
// import 'package:acc/core/providers/storage_repository_provider.dart';
import 'package:acc/core/utils.dart';
// import 'package:acc/features/auth/controlller/auth_controller.dart';
// import 'package:acc/features/note/repository/note_repository.dart';
// import 'package:acc/models/comment_model.dart';
import 'package:acc/models/note_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

import '../../../core/providers/storage_providers.dart';
import '../../auth/controller/auth_controller.dart';
import '../repository/note_repository.dart';

final noteControllerProvider =
    StateNotifierProvider<NoteController, bool>((ref) {
  final noteRepository = ref.watch(noteRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return NoteController(
    noteRepository: noteRepository,
    storageRepository: storageRepository,
    ref: ref,
  );
});

// final userNotesProvider =
//     StreamProvider.family((ref, List<School> schools) {
//   final noteController = ref.watch(noteControllerProvider.notifier);
//   return noteController.fetchUserNotes(schools);
// });

// final guestNotesProvider = StreamProvider((ref) {
//   final noteController = ref.watch(noteControllerProvider.notifier);
//   return noteController.fetchGuestNotes();
// });

final getNoteByIdProvider = StreamProvider.family((ref, String noteId) {
  final noteController = ref.watch(noteControllerProvider.notifier);
  return noteController.getNoteById(noteId);
});
final getNoteThreads = StreamProvider.family((ref, String noteId) {
  final noteController = ref.watch(noteControllerProvider.notifier);
  return noteController.threads(noteId);
});

final getNoteCommentsProvider = StreamProvider.family((ref, String noteId) {
  final noteController = ref.watch(noteControllerProvider.notifier);
  return noteController.getNoteComments(noteId);
});
final getReportsProvider = StreamProvider((ref) {
  final noteController = ref.watch(noteControllerProvider.notifier);
  return noteController.getReports();
});

final getNoteLikersProvider =
    StreamProvider.family((ref, List<String> likerUids) {
  final noteController = ref.watch(noteControllerProvider.notifier);
  return noteController.getNoteLikers(likerUids);
});

class NoteController extends StateNotifier<bool> {
  final NoteRepository _noteRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;
  NoteController({
    required NoteRepository noteRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _noteRepository = noteRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  // Stream<List<Note>> fetchUserNotes(List<School> communities) {
  //   if (communities.isNotEmpty) {
  //     return _noteRepository.fetchUserNotes(communities);
  //   }
  //   return Stream.value([]);
  // }

  // Stream<List<Note>> fetchGuestNotes() {
  //   return _noteRepository.fetchGuestNotes();
  // }

  Stream<List<Note>> threads(String noteIdAndNoteUid) {
    final splitted = noteIdAndNoteUid.split('+');
    print(splitted);
    return _noteRepository.threads(splitted.first, splitted[1]);
  }

  void deleteNote(Note note, BuildContext context) async {
    try {
      await _noteRepository.deleteNote(note);
      if (note.type == "image") {
        await _storageRepository.deleteNoteImages(note: note);
      }
    } catch (e) {
      showSnackBar(context, 'hata oluştu, lütfen daha sonra tekrar deneyin');
    }
  }

  void like(Note note, BuildContext context) async {
    final currentUser = _ref.read(userProvider)!;
    if (note.uid != currentUser.uid) {
      _ref.read(notificationControllerProvider.notifier).sendNotification(
            context: context,
            content: "${currentUser.username} notunu beğendi",
            type: 'like',
            noteId: note.id,
            id: "${note.id}-like",
            receiverUid: note.uid,
            senderId: currentUser.uid,
          );
    }

    _noteRepository.like(note, currentUser.uid);
  }

  Stream<Note> getNoteById(String noteId) {
    return _noteRepository.getNoteById(noteId);
  }

  void reportUserOrContent({
    required BuildContext context,
    required String uid,
    required String noteId,
    required String accountId,
    required String reason,
    required String detail,
    required String reportId,
    bool? isEvaluated = false,
  }) async {
    state = true;

    final Report report = Report(
      id: reportId,
      reportingUid: uid,
      noteId: noteId,
      reportedUid: accountId,
      reason: reason,
      detail: detail,
      isEvaluated: isEvaluated,
      createdAt: DateTime.now(),
    );

    final res = await _noteRepository.addReport(report);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      if (!isEvaluated!) {
        Navigator.pop(context);
        Navigator.pop(context);
        showSnackBar(context, 'şikayetin için teşekkürler, ilgileneceğiz.');
      }
    });
  }

  void shareTextNote({
    required BuildContext context,
    required String schoolId,
    required String content,
    required String link,
    required String repliedTo,
  }) async {
    state = true;
    String noteId = const Uuid().v1();
    final currentUser = _ref.read(userProvider)!;

    final Note note = Note(
      id: noteId,
      schoolName: schoolId,
      imageLinks: [],
      likes: [],
      bookmarks: [],
      commentCount: 0,
      uid: currentUser.uid,
      type: 'text',
      createdAt: DateTime.now(),
      content: content,
      link: link,
      repliedTo: repliedTo,
    );

    final res = await _noteRepository.addNote(note, currentUser);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      // showSnackBar(context, 'Noteed successfully!');
      if (repliedTo.isEmpty) {
        Navigator.of(context).pop();
      }
    });
  }

  Stream<List<Note>> getNoteComments(String noteId) {
    return _noteRepository.getCommentsOfNote(noteId);
  }

  Stream<List<Report>> getReports() {
    return _noteRepository.getReports();
  }

  Stream<List<UserModel>> getNoteLikers(List<String> likerUids) {
    return _noteRepository.getNoteLikers(likerUids);
  }

  void shareImageNote({
    required BuildContext context,
    required String selectedSchoolId,
    required String content,
    required List<File> files,
    required School school,
    required String repliedTo,
    // required List<Uint8List> webFiles,
    required String link,
  }) async {
    int errorCounter = 0;
    List<String> imageLinks = [];
    state = true;
    String noteId = const Uuid().v1();
    final user = _ref.read(userProvider)!;
    Either imageRes;
    for (int i = 0; i < files.length; i++) {
      var file = files[i];
      String imageId = const Uuid().v4();

      imageRes = await _storageRepository.storeFile(
        path: 'notes/${user.schoolId}/$noteId',
        id: imageId,
        file: file,
      );

      imageRes.fold((l) => showSnackBar(context, l.message), (r) {
        imageLinks.add(r);
        errorCounter++;
      });
      print(imageLinks);
    }

    if (errorCounter == imageLinks.length) {
      final Note note = Note(
        content: content,
        id: noteId,
        schoolName: selectedSchoolId,
        likes: [],
        bookmarks: [],
        imageLinks: imageLinks,
        commentCount: 0,
        uid: user.uid,
        type: 'image',
        createdAt: DateTime.now(),
        link: link,
        repliedTo: repliedTo,
      );
      final res = await _noteRepository.addNote(note, user);

      state = false;
      res.fold((l) => showSnackBar(context, l.message), (r) {
        // showSnackBar(context, 'Noteed successfully!');
        Navigator.of(context).pop();
      });
    }
  }
}
