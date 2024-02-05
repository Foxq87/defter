import 'dart:io';
import 'package:acc/models/school_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:acc/core/enums/enums.dart';
// import 'package:acc/core/providers/storage_repository_provider.dart';
import 'package:acc/core/utils.dart';
// import 'package:acc/features/auth/controlller/auth_controller.dart';
// import 'package:acc/features/post/repository/post_repository.dart';
// import 'package:acc/models/comment_model.dart';
import 'package:acc/models/post_model.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

import '../../../core/providers/storage_providers.dart';
import '../../auth/controller/auth_controller.dart';
import '../repository/post_repository.dart';

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

// final getPostByIdProvider = StreamProvider.family((ref, String postId) {
//   final postController = ref.watch(postControllerProvider.notifier);
//   return postController.getPostById(postId);
// });

// final getPostCommentsProvider = StreamProvider.family((ref, String postId) {
//   final postController = ref.watch(postControllerProvider.notifier);
//   return postController.fetchPostComments(postId);
// });

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

  Stream<List<Post>> fetchUserPosts(List<School> communities) {
    if (communities.isNotEmpty) {
      return _postRepository.fetchUserPosts(communities);
    }
    return Stream.value([]);
  }

  Stream<List<Post>> fetchGuestPosts() {
    return _postRepository.fetchGuestPosts();
  }

  void deletePost(Post post, BuildContext context) async {
    final res = await _postRepository.deletePost(post);

    res.fold((l) => null,
        (r) => showSnackBar(context, 'Post Deleted successfully!'));
  }

  void like(Post post) async {
    final uid = _ref.read(userProvider)!.uid;
    _postRepository.like(post, uid);
  }

  Stream<Post> getPostById(String postId) {
    return _postRepository.getPostById(postId);
  }

  void shareTextPost({
    required BuildContext context,
    required String selectedSchoolId,
    required String content,
    required String link,
    required School school,
  }) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;

    final Post post = Post(
      id: postId,
      schoolName: user.schoolId,
      imageLinks: [],
      likes: [],
      commentCount: 0,
      username: user.name,
      uid: user.uid,
      type: 'text',
      createdAt: DateTime.now(),
      content: content,
      link: link,
      schoolProfilePic: school.avatar,
    );

    final res = await _postRepository.addPost(post);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Posted successfully!');
      Routemaster.of(context).pop();
    });
  }

  void shareImagePost({
    required BuildContext context,
    required String selectedSchoolId,
    required String content,
    required List<File> files,
    required School school,
    // required List<Uint8List> webFiles,
    required String link,
  }) async {
    int errorCounter = 0;
    List<String> imageLinks = [];
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;

    for (var file in files) {
      final imageRes = await _storageRepository.storeFile(
        path: 'posts/${user.schoolId}',
        id: postId,
        file: file,
      );

      imageRes.fold((l) => showSnackBar(context, l.message), (r) {
        imageLinks.add(r);
        errorCounter++;
      });
    }

    if (errorCounter == imageLinks.length) {
      final Post post = Post(
        content: content,
        id: postId,
        schoolName: user.schoolId,
        likes: [],
        imageLinks: imageLinks,
        commentCount: 0,
        username: user.name,
        uid: user.uid,
        type: 'image',
        createdAt: DateTime.now(),
        link: link,
        schoolProfilePic: school.avatar,
      );
      final res = await _postRepository.addPost(post);

      state = false;
      res.fold((l) => showSnackBar(context, l.message), (r) {
        showSnackBar(context, 'Posted successfully!');
        Routemaster.of(context).pop();
      });
    }

    // void addComment({
    //   required BuildContext context,
    //   required String text,
    //   required Post post,
    // }) async {
    //   final user = _ref.read(userProvider)!;
    //   String commentId = const Uuid().v1();
    //   Comment comment = Comment(
    //     id: commentId,
    //     text: text,
    //     createdAt: DateTime.now(),
    //     postId: post.id,
    //     username: user.name,
    //     profilePic: user.profilePic,
    //   );
    //   final res = await _postRepository.addComment(comment);

    //   res.fold((l) => showSnackBar(context, l.message), (r) => null);
    // }

    // void awardPost({
    //   required Post post,
    //   required String award,
    //   required BuildContext context,
    // }) async {
    //   final user = _ref.read(userProvider)!;

    //   final res = await _postRepository.awardPost(post, award, user.uid);

    //   res.fold((l) => showSnackBar(context, l.message), (r) {
    //     _ref
    //         .read(userProfileControllerProvider.notifier)
    //         .updateUserKarma(UserKarma.awardPost);
    //     _ref.read(userProvider.notifier).update((state) {
    //       state?.awards.remove(award);
    //       return state;
    //     });
    //     Routemaster.of(context).pop();
    //   });
    // }

    // Stream<List<Comment>> fetchPostComments(String postId) {
    //   return _postRepository.getCommentsOfPost(postId);
    // }
  }
}
