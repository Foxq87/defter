import 'dart:io';
import 'package:acc/features/notifications/controller/notification_controller.dart';
import 'package:acc/models/school_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:acc/core/enums/enums.dart';
// import 'package:acc/core/providers/storage_repository_provider.dart';
import 'package:acc/core/utils.dart';
// import 'package:acc/features/auth/controlller/auth_controller.dart';
// import 'package:acc/features/note/repository/post_repository.dart';
// import 'package:acc/models/comment_model.dart';
import 'package:acc/models/note_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

import '../../../core/providers/storage_providers.dart';
import '../../auth/controller/auth_controller.dart';
import '../repository/note_repository.dart';

final postControllerProvider =
    StateNotifierProvider<PostController, bool>((ref) {
  final postRepository = ref.watch(postRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return PostController(
    postRepository: postRepository,
    storageRepository: storageRepository,
    ref: ref,
  );
});

// final userPostsProvider =
//     StreamProvider.family((ref, List<School> schools) {
//   final postController = ref.watch(postControllerProvider.notifier);
//   return postController.fetchUserPosts(schools);
// });

// final guestPostsProvider = StreamProvider((ref) {
//   final postController = ref.watch(postControllerProvider.notifier);
//   return postController.fetchGuestPosts();
// });

final getPostByIdProvider = StreamProvider.family((ref, String postId) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.getPostById(postId);
});

final getPostCommentsProvider = StreamProvider.family((ref, String postId) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.fetchPostComments(postId);
});

class PostController extends StateNotifier<bool> {
  final PostRepository _postRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;
  PostController({
    required PostRepository postRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _postRepository = postRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  // Stream<List<Note>> fetchUserPosts(List<School> communities) {
  //   if (communities.isNotEmpty) {
  //     return _postRepository.fetchUserPosts(communities);
  //   }
  //   return Stream.value([]);
  // }

  // Stream<List<Note>> fetchGuestPosts() {
  //   return _postRepository.fetchGuestPosts();
  // }

  bool isThread(Note note) {
    return _postRepository.isThread(note);
  }

  void deletePost(Note note, BuildContext context) async {
    try {
      await _postRepository.deleteNote(note);
      if (note.type == "image") {
        await _storageRepository.deletePostImages(note: note);
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
            postId: note.id,
            id: "${note.id}-${currentUser.uid}-like",
            receiverUid: note.uid,
            senderId: currentUser.uid,
          );
    }

    _postRepository.like(note, currentUser.uid);
  }

  Stream<Note> getPostById(String postId) {
    return _postRepository.getPostById(postId);
  }

  void shareTextPost({
    required BuildContext context,
    required String selectedSchoolId,
    required String content,
    required String link,
    required String repliedTo,
  }) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;

    final Note note = Note(
      id: postId,
      schoolName: selectedSchoolId,
      imageLinks: [],
      likes: [],
      commentCount: 0,
      uid: user.uid,
      type: 'text',
      createdAt: DateTime.now(),
      content: content,
      link: link,
      repliedTo: repliedTo,
    );

    final res = await _postRepository.addPost(note);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      // showSnackBar(context, 'Posted successfully!');
      if (repliedTo.isEmpty) {
        Routemaster.of(context).pop();
      }
    });
  }

  Stream<List<Note>> fetchPostComments(String postId) {
    return _postRepository.getCommentsOfPost(postId);
  }

  void shareImagePost({
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
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;
    Either imageRes;
    for (int i = 0; i < files.length; i++) {
      var file = files[i];
      String imageId = const Uuid().v4();

      imageRes = await _storageRepository.storeFile(
        path: 'posts/${user.schoolId}/$postId',
        id: imageId,
        file: await compressImage(postId, file, i),
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
        id: postId,
        schoolName: selectedSchoolId,
        likes: [],
        imageLinks: imageLinks,
        commentCount: 0,
        uid: user.uid,
        type: 'image',
        createdAt: DateTime.now(),
        link: link,
        repliedTo: repliedTo,
      );
      final res = await _postRepository.addPost(note);

      state = false;
      res.fold((l) => showSnackBar(context, l.message), (r) {
        // showSnackBar(context, 'Posted successfully!');
        Routemaster.of(context).pop();
      });
    }
  }
}
