import 'package:acc/features/school/controller/school_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

// class CommunityScreen extends ConsumerWidget {
//   final String name;
//   const CommunityScreen({super.key, required this.name});

//   // http://localhost:4000/r/flutter

//   void navigateToModTools(BuildContext context) {
//     Routemaster.of(context).push('/mod-tools/$name');
//   }

//   void joinCommunity(WidgetRef ref, Community community, BuildContext context) {
//     ref.read(communityControllerProvider.notifier).joinCommunity(community, context);
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final user = ref.watch(userProvider)!;
//     final isGuest = !user.isAuthenticated;

//     return Scaffold(
//       body: ref.watch(getCommunityByNameProvider(name)).when(
//             data: (community) => NestedScrollView(
//               headerSliverBuilder: (context, innerBoxIsScrolled) {
//                 return [
//                   SliverAppBar(
//                     expandedHeight: 150,
//                     floating: true,
//                     snap: true,
//                     flexibleSpace: Stack(
//                       children: [
//                         Positioned.fill(
//                           child: Image.network(
//                             community.banner,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SliverPadding(
//                     padding: const EdgeInsets.all(16),
//                     sliver: SliverList(
//                       delegate: SliverChildListDelegate(
//                         [
//                           Align(
//                             alignment: Alignment.topLeft,
//                             child: CircleAvatar(
//                               backgroundImage: NetworkImage(community.avatar),
//                               radius: 35,
//                             ),
//                           ),
//                           const SizedBox(height: 5),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 'r/${community.name}',
//                                 style: const TextStyle(
//                                   fontSize: 19,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               if (!isGuest)
//                                 community.mods.contains(user.uid)
//                                     ? OutlinedButton(
//                                         onPressed: () {
//                                           navigateToModTools(context);
//                                         },
//                                         style: ElevatedButton.styleFrom(
//                                           shape: RoundedRectangleBorder(
//                                             borderRadius: BorderRadius.circular(20),
//                                           ),
//                                           padding: const EdgeInsets.symmetric(horizontal: 25),
//                                         ),
//                                         child: const Text('Mod Tools'),
//                                       )
//                                     : OutlinedButton(
//                                         onPressed: () => joinCommunity(ref, community, context),
//                                         style: ElevatedButton.styleFrom(
//                                           shape: RoundedRectangleBorder(
//                                             borderRadius: BorderRadius.circular(20),
//                                           ),
//                                           padding: const EdgeInsets.symmetric(horizontal: 25),
//                                         ),
//                                         child: Text(community.members.contains(user.uid) ? 'Joined' : 'Join'),
//                                       ),
//                             ],
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(top: 10),
//                             child: Text(
//                               '${community.members.length} members',
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ];
//               },
//               body: ref.watch(getCommunityPostsProvider(name)).when(
//                     data: (data) {
//                       return ListView.builder(
//                         itemCount: data.length,
//                         itemBuilder: (BuildContext context, int index) {
//                           final post = data[index];
//                           return PostCard(post: post);
//                         },
//                       );
//                     },
//                     error: (error, stackTrace) {
//                       return ErrorText(error: error.toString());
//                     },
//                     loading: () => const Loader(),
//                   ),
//             ),
//             error: (error, stackTrace) => ErrorText(error: error.toString()),
//             loading: () => const Loader(),
//           ),
//     );
//   }
// }
import 'package:acc/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/commons/error_text.dart';
import '../../../core/commons/loader.dart';
// import 'package:acc/core/common/post_card.dart';
import '../../../core/commons/nav_bar_button.dart';
import '../../../features/auth/controller/auth_controller.dart';
import '../../../theme/palette.dart';

class SchoolScreen extends ConsumerStatefulWidget {
  final String id;
  const SchoolScreen({super.key, required this.id});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<SchoolScreen> {
  void navigateToEditUser(BuildContext context) {
    Routemaster.of(context).push('/edit-profile/${widget.id}');
  }

  List contentItems = [
    ['posts', true],
    ['articles', false],
  ];
  void selectAndUnselectOthers(int index) {
    for (var element in contentItems) {
      setState(() {
        element[1] = false;
        contentItems[index][1] = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserModel currentUser = ref.watch(userProvider)!;
    return Scaffold(
      //build edit profile

      body: ref.watch(getSchoolByIdProvider(widget.id)).when(
            data: (school) => ListView(children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: AspectRatio(
                          aspectRatio: 10 / 3.5,
                          child: Image.network(
                            school.banner,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: JustIconButton(
                      icon: CupertinoIcons.back,
                      onPressed: () {
                        Routemaster.of(context).pop();
                      },
                    ),
                  ),
                  Positioned(
                      top: 10,
                      right: 10,
                      child: JustIconButton(
                          icon: CupertinoIcons.ellipsis,
                          onPressed: () {
                            Routemaster.of(context).pop();
                          })),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0).copyWith(top: 0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        school.avatar,
                        fit: BoxFit.cover,
                        height: 80,
                        width: 80,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              school.title,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'JetBrainsMonoExtraBold'),
                            ),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          buildStudentCount()
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: school.id == currentUser.uid
                      ? [
                          buildActionButton(
                            onPressed: () => navigateToEditUser(context),
                            text: 'Edit Profile',
                            color: Palette.textfieldColor,
                          )
                        ]
                      : [
                          buildActionButton(
                              onPressed: () {},
                              text: 'i am this schools student',
                              color: Palette.themeColor),
                        ],
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 10),
              //   child: Text(
              //     '${user.karma} karma',
              //   ),
              // ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(contentItems.length, (index) {
                    return CupertinoButton(
                      onPressed: () => selectAndUnselectOthers(index),
                      padding: EdgeInsets.zero,
                      child: buildContentItem(
                          text: contentItems[index][0].toString(),
                          isSelected: contentItems[index][1]),
                    );
                  })),

              const Divider(
                thickness: 0.6,
                height: 0,
              ),
            ]
                //   body: ref.watch(getUserPostsProvider(uid)).when(
                //         data: (data) {
                //           return ListView.builder(
                //             itemCount: data.length,
                //             itemBuilder: (BuildContext context, int index) {
                //               final post = data[index];
                //               return PostCard(post: post);
                //             },
                //           );
                //         },
                //         error: (error, stackTrace) {
                //           return ErrorText(error: error.toString());
                //         },
                //         loading: () => const Loader(),
                //       ),
                ),
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }

  Container buildEditProfile(BuildContext context) {
    return Container(
      alignment: Alignment.bottomLeft,
      padding: const EdgeInsets.all(20),
      child: OutlinedButton(
        onPressed: () => navigateToEditUser(context),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 25),
        ),
        child: const Text('Edit Profile'),
      ),
    );
  }

  Padding buildStudentCount() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
        child: GestureDetector(
          onTap: () {
            // Routemaster.of(context).push();
          },
          child: RichText(
              text: const TextSpan(children: [
            TextSpan(
                text: '534',
                style: TextStyle(fontFamily: 'JetBrainsMonoRegular')),
            TextSpan(
                text: ' students',
                style: TextStyle(
                    color: Palette.placeholderColor,
                    fontFamily: 'JetBrainsMonoRegular')),
          ])),
        ));
  }

  Expanded buildActionButton({
    required VoidCallback onPressed,
    required String text,
    required Color color,
  }) {
    return Expanded(
      child: SizedBox(
        height: 40,
        child: CupertinoButton(
            borderRadius: BorderRadius.circular(10),
            color: color,
            padding: EdgeInsets.zero,
            onPressed: onPressed,
            child: Text(
              text,
              style: const TextStyle(
                  color: Colors.white, fontFamily: 'JetBrainsMonoBold'),
            )),
      ),
    );
  }

  Padding buildContentItem({required String text, required bool isSelected}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 15.0, 8.0, 0.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  width: 4,
                  color: isSelected ? Palette.themeColor : Colors.transparent)),
        ),
        child: Text(
          text,
          style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontFamily: 'JetBrainsMonoBold'),
        ),
      ),
    );
  }
}
