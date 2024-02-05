import 'package:acc/core/commons/error_text.dart';
import 'package:acc/core/commons/image_view.dart';
import 'package:acc/core/commons/loader.dart';
import 'package:acc/core/constants/constants.dart';
import 'package:acc/models/post_model.dart';
import 'package:any_link_preview/any_link_preview.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:like_button/like_button.dart';
import 'package:routemaster/routemaster.dart';
import '../../features/auth/controller/auth_controller.dart';
import '../../features/posts/controller/post_controller.dart';
import '../../features/school/controller/school_controller.dart';
import '../../theme/palette.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostCard extends ConsumerWidget {
  final Post post;
  const PostCard({
    super.key,
    required this.post,
  });

  void deletePost(WidgetRef ref, BuildContext context) async {
    ref.read(postControllerProvider.notifier).deletePost(post, context);
  }

  void likePost(WidgetRef ref) async {
    ref.read(postControllerProvider.notifier).like(post);
  }

  void awardPost(WidgetRef ref, String award, BuildContext context) async {}

  void navigateToUser(BuildContext context) {
    Routemaster.of(context).push('/user-profile/${post.uid}');
  }

  void navigateToSchool(BuildContext context) {
    Routemaster.of(context).push('/school-profile/${post.schoolName}');
  }

  void navigateToComments(BuildContext context) {
    Routemaster.of(context).push('/post/${post.id}/comments');
  }

  bool isThread() {
    return false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTypeImage = post.type == 'image';
    final user = ref.watch(userProvider)!;

    // final currentTheme = ref.watch(themeNotifierProvider);

    return Container(
      margin: const EdgeInsets.only(left: 10.0, top: 10.0),
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(width: 0.5, color: Palette.postIconColor))),
      child: IntrinsicHeight(
          child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              SizedBox(
                height: 40,
                width: 40,
                child: GestureDetector(
                  onTap: () => navigateToUser(context),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(
                      user.profilePic,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              if (isThread())
                Flexible(
                  child: VerticalDivider(
                    color: Colors.grey[850],
                    thickness: 2,
                  ),
                ),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(
                                left: 10,
                              ),
                              child: Column(
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
                                                child: Text(
                                                  "${post.username} • ",
                                                  style: const TextStyle(
                                                      fontSize: 17,
                                                      fontFamily:
                                                          'JetBrainsMonoExtraBold'),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () =>
                                                    navigateToSchool(context),
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      height: 20.0,
                                                      width: 20.0,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0),
                                                        child: Image.network(
                                                          post.schoolProfilePic,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      "${post.schoolName} • ${timeago.format(
                                                        post.createdAt,
                                                      )}",
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  if (post.content.isNotEmpty)
                                    Text(
                                      post.content,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  else
                                    const SizedBox(
                                      height: 5,
                                    ),
                                  if (isTypeImage)
                                    CarouselSlider(
                                        items: post.imageLinks.map((imageLink) {
                                          return GestureDetector(
                                            onTap: () => Navigator.push(
                                              context,
                                              CupertinoPageRoute(
                                                builder: (context) => ImageView(
                                                  imageUrls: post.imageLinks,
                                                  imageFiles: const [],
                                                ),
                                              ),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  right: 8.0,
                                                  top: post.content.isEmpty
                                                      ? 0.0
                                                      : 5.0),
                                              child: Container(
                                                height: 120.0,
                                                width: 120.0,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                            imageLink),
                                                        fit: BoxFit.cover)),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        options: CarouselOptions(
                                            padEnds: false,
                                            viewportFraction: 0.45,
                                            enableInfiniteScroll: false,
                                            disableCenter: true)),
                                  if (post.link.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 18),
                                      child: AnyLinkPreview(
                                        displayDirection:
                                            UIDirection.uiDirectionHorizontal,
                                        link: post.link,
                                      ),
                                    ),

                                  const SizedBox(
                                    height: 5,
                                  ),
                                  // post actions
                                  SizedBox(
                                    height: 20,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            IconButton(
                                              padding: EdgeInsets.zero,
                                              onPressed: () =>
                                                  navigateToComments(context),
                                              icon: SvgPicture.asset(
                                                Constants.comment,
                                                colorFilter:
                                                    const ColorFilter.mode(
                                                        Palette.postIconColor,
                                                        BlendMode.srcIn),
                                                fit: BoxFit.cover,
                                                width: 20,
                                                height: 20,
                                              ),
                                            ),
                                            Text(
                                              '${post.commentCount == 0 ? '0' : post.commentCount}',
                                              style:
                                                  const TextStyle(fontSize: 15),
                                            ),
                                          ],
                                        ),
                                        LikeButton(
                                          countBuilder:
                                              (likeCount, isLiked, text) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5.0),
                                              child: Text(
                                                '${likeCount == 0 ? '0' : likeCount}',
                                                style: const TextStyle(
                                                    fontSize: 15),
                                              ),
                                            );
                                          },
                                          onTap: (isLiked) async {
                                            likePost(ref);
                                            return !isLiked;
                                          },
                                          likeBuilder: (isLiked) {
                                            return SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: SvgPicture.asset(
                                                isLiked
                                                    ? Constants.heartFilled
                                                    : Constants.heartOutlined,
                                                fit: BoxFit.contain,
                                                colorFilter: ColorFilter.mode(
                                                    isLiked
                                                        ? Palette.redColor
                                                        : Palette.postIconColor,
                                                    BlendMode.srcIn),
                                              ),
                                            );
                                          },
                                          isLiked:
                                              post.likes.contains(user.uid),
                                          likeCount: post.likes.length,
                                        ),
                                        IconButton(
                                          padding: EdgeInsets.zero,
                                          onPressed: () {},
                                          icon: SvgPicture.asset(
                                            Constants.upload,
                                            width: 20,
                                            height: 20,
                                            fit: BoxFit.cover,
                                            colorFilter: const ColorFilter.mode(
                                                Palette.postIconColor,
                                                BlendMode.srcIn),
                                          ),
                                        ),
                                        ref
                                            .watch(getSchoolByIdProvider(
                                                post.schoolName))
                                            .when(
                                              data: (data) {
                                                if (data.mods
                                                    .contains(user.uid)) {
                                                  return IconButton(
                                                    padding: EdgeInsets.zero,
                                                    onPressed: () {
                                                      showCupertinoDialog(
                                                        barrierDismissible:
                                                            true,
                                                        context: context,
                                                        builder: (context) =>
                                                            CupertinoAlertDialog(
                                                          title: const Text(
                                                              "emin misin?"),
                                                          content: const Text(
                                                              'bu postu siliyorsun'),
                                                          actions: <CupertinoDialogAction>[
                                                            CupertinoDialogAction(
                                                              isDefaultAction:
                                                                  true,
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: const Text(
                                                                'hayır',
                                                                style: TextStyle(
                                                                    color: Palette
                                                                        .themeColor),
                                                              ),
                                                            ),
                                                            CupertinoDialogAction(
                                                              isDestructiveAction:
                                                                  true,
                                                              onPressed: () {
                                                                deletePost(ref,
                                                                    context);
                                                              },
                                                              child: const Text(
                                                                  'evet'),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                    icon: const Icon(
                                                      CupertinoIcons.command,
                                                      color: Colors.cyan,
                                                    ),
                                                  );
                                                }
                                                return const SizedBox();
                                              },
                                              error: (error, stackTrace) =>
                                                  ErrorText(
                                                error: error.toString(),
                                              ),
                                              loading: () => const Loader(),
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
    );
  }
}
