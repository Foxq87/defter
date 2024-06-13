import 'package:acc/features/home/drawers/drawer.dart';
import 'package:acc/features/notes/controller/note_controller.dart';
import 'package:acc/features/school/controller/school_controller.dart';
import 'package:acc/features/user_profile/screens/user_profile_screen.dart';
import 'package:acc/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/commons/large_text.dart';
import '../../../core/commons/loader.dart';
import '../../../core/commons/user_square.dart';
import '../../../models/note_model.dart';
import '../../../theme/palette.dart';
import '../../auth/controller/auth_controller.dart';
import '../../notes/widgets/note_card.dart';
import '../../search/screens/search_screen.dart';

class CloseFriendsFeed extends ConsumerStatefulWidget {
  const CloseFriendsFeed({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CloseFriendsFeedState();
}

class _CloseFriendsFeedState extends ConsumerState<CloseFriendsFeed> {
  ScrollController scrollController = ScrollController();
  List<String> selectedProfileUids = [];
  // List<UserModel> selectedProfiles = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    final currentUser = ref.read(userProvider)!;
    // selectedProfileUids.add(currentUser.uid);
    currentUser.closeFriends.forEach((element) {
      selectedProfileUids.add(element);
    });
    // Setup the listener.
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        bool isTop = scrollController.position.pixels == 0;
        if (!isTop) {
          setState(() {
            isLoading = true;
            noteLimit += 10;
          });
        }
        // if (scrollController.position.pixels ==
        //     scrollController.position.maxScrollExtent) {
        //   setState(() {
        //     isLoading = false;
        //   });
        //   // Page is all the way down
        //   // Add your code here
        // }
      }
    });
  }

  int segmentedValue = 2;
  int noteLimit = 10;
// Future<Stream<List<Note>>> getCloseFriendsFeed(UserModel currentUser) async {
//   List<Stream<List<Note>>> streams = [];

//   // for (String friendId in currentUser.closeFriends) {
//   //   var stream = FirebaseFirestore.instance.collection('posts')
//   //       .where('uid', isEqualTo: friendId)
//   //       .where('schoolName', isEqualTo: 'closeFriend-$friendId')
//   //       .orderBy('createdAt', descending: true)
//   //       .snapshots()
//   //       .map((querySnapshot) {
//   //         return querySnapshot.docs.map((doc) {
//   //           return ref.read(noteControllerProvider.notifier).getNoteById(doc.id); // Assuming you have a method to convert a DocumentSnapshot to a Note
//   //         }).toList();
//   //       });

//   //   streams.add(stream);
//   // }

//   return Rx.combineLatest(streams, (values) {
//     return values.expand((element) => element).toList();
//   });
// }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(userProvider)!;

    return Scaffold(
      appBar: CupertinoNavigationBar(
        border: Border(
            bottom: BorderSide(width: 0.5, color: Palette.darkGreyColor2)),
        backgroundColor: Colors.black.withOpacity(0.4),
        padding: EdgeInsetsDirectional.zero,
        leading: Builder(
          builder: (context) => IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: userSquare(context, currentUser.profilePic),
          ),
        ),
        middle: largeText("defter", true),
        trailing: CupertinoButton(
          onPressed: () {
            Navigator.pop(context);
          },
          padding: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.only(right: 15.0, bottom: 5),
            child: SizedBox(
              height: 30,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    backgroundColor: Palette.darkGreyColor2,
                    radius: 15,
                    child: Center(
                      child: Icon(
                        CupertinoIcons.clear,
                        size: 17,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  CupertinoButton(
                      borderRadius: BorderRadius.circular(100),
                      disabledColor: Palette.themeColor,
                      color: Palette.themeColor,
                      padding: EdgeInsets.symmetric(horizontal: 5)
                          .copyWith(right: 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'agalar',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'SFProDisplayMedium'),
                          ),
                        ],
                      ),
                      onPressed: null),
                ],
              ),
            ),
          ),
        ),
      ),
      drawer: const DrawerView(),
      body: currentUser.closeFriends.isEmpty
          ? buildNoCloseFriend()
          : Scrollbar(
              scrollbarOrientation: ScrollbarOrientation.right,
              thumbVisibility: true,
              trackVisibility: true,
              controller: scrollController,
              child: ListView(
                controller: scrollController,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0).copyWith(bottom: 0),
                    child: largeText('yakın arkadaşlar', false),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 7,
                    ).copyWith(bottom: 0),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: List.generate(
                              selectedProfileUids.length + 1,
                              (index) => index == selectedProfileUids.length
                                  ? CupertinoButton(
                                      onPressed: () {
                                        showModalBottomSheet(
                                          useSafeArea: true,
                                          isScrollControlled: true,
                                          backgroundColor:
                                              Palette.darkGreyColor2,
                                          context: context,
                                          builder: (BuildContext context) {
                                            return FractionallySizedBox(
                                                heightFactor: 0.98,
                                                child: SearchScreen(
                                                  isForCloseFriends: true,
                                                ));
                                          },
                                        );
                                      },
                                      padding: EdgeInsets.zero,
                                      child: CircleAvatar(
                                        backgroundColor: Palette.orangeColor,
                                        radius: 13,
                                        child: Icon(
                                          CupertinoIcons.add,
                                          size: 17,
                                        ),
                                      ),
                                    )
                                  : ref
                                      .watch(getUserDataProvider(
                                          selectedProfileUids[index]))
                                      .when(
                                          data: (data) => CupertinoButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            UserProfileScreen(
                                                                uid: data.uid),
                                                      ));
                                                },
                                                padding: EdgeInsets.zero,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0)
                                                          .copyWith(
                                                              left: 0,
                                                              right: 10),
                                                  child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Stack(
                                                          clipBehavior:
                                                              Clip.none,
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15.0),
                                                              child:
                                                                  Image.network(
                                                                data.profilePic,
                                                                height: 50,
                                                                width: 50,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                            // if (selectedProfileUids[
                                                            //             index] !=
                                                            //         currentUser
                                                            //             .uid)
                                                            //   Positioned(
                                                            //     top: -8,
                                                            //     right: -8,
                                                            //     child:
                                                            //         GestureDetector(
                                                            //       onTap: () {
                                                            //         setState(() {
                                                            //           selectedProfileUids
                                                            //               .remove(
                                                            //                   data.uid);
                                                            //         });
                                                            //       },
                                                            //       child:
                                                            //           CircleAvatar(
                                                            //               radius:
                                                            //                   12,
                                                            //               backgroundColor:
                                                            //                   Palette
                                                            //                       .placeholderColor,
                                                            //               child:
                                                            //                   Icon(
                                                            //                 CupertinoIcons
                                                            //                     .clear,
                                                            //                 size:
                                                            //                     15,
                                                            //               )),
                                                            //     ),
                                                            //   ),
                                                          ],
                                                        ),
                                                        if (selectedProfileUids[
                                                                index] !=
                                                            currentUser.uid)
                                                          Column(
                                                            children: [
                                                              SizedBox(
                                                                height: 3,
                                                              ),
                                                              SizedBox(
                                                                width: 55,
                                                                child: Text(
                                                                  data.username,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontFamily:
                                                                          'SFProDisplayRegular',
                                                                      fontSize:
                                                                          11),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                      ]),
                                                ),
                                              ),
                                          error: (error, stackTrace) =>
                                              Text(error.toString()),
                                          loading: () =>
                                              CupertinoActivityIndicator()))),
                    ),
                  ),
                  Divider(
                    thickness: 0.45,
                    color: Palette.darkGreyColor2,
                  ),

                  ref.watch(getCloseFriendsFeedProvider).when(
                      data: (data) {
                        data.sort((a, b) => a.createdAt.compareTo(b.createdAt));
                        return ListView.builder(
                          reverse: true,
                          // controller: scrollController,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            final note = data[index];
                            return NoteCard(
                              note: note,
                              isComment: false,
                            );
                          },
                        );
                        // return ListView.builder(
                        //   // controller: scrollController,
                        //   physics: NeverScrollableScrollPhysics(),
                        //   shrinkWrap: true,
                        //   itemCount: data.length,
                        //   itemBuilder: (context, index) {
                        //     final note = data[index];
                        //     return NoteCard(note: note);
                        //   },
                        // );
                      },
                      error: (error, stackTrace) => Text(error.toString()),
                      loading: () => CupertinoActivityIndicator()),
                  SizedBox(
                    height: 10,
                  ),
                  // if (isLoading) CupertinoActivityIndicator(),
                  SizedBox(
                    height: 70,
                  )
                ],
              ),
            ),
    );
  }

  Center buildNoCloseFriend() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 40,
            ),
            Icon(
              CupertinoIcons.profile_circled,
              color: Palette.orangeColor,
              size: 50,
            ),
            Text(
              'henüz yakın arkadaşın bulunmamakta :(',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 40,
              child: CupertinoButton(
                // padding: EdgeInsets.symmetric(horizontal: 60),
                padding: EdgeInsets.symmetric(horizontal: 10),
                borderRadius: BorderRadius.circular(100),
                color: Palette.themeColor,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      backgroundColor: Palette.darkGreyColor,
                      radius: 13,
                      child: Center(
                        child: Icon(
                          CupertinoIcons.add,
                          size: 17,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'yakın arkadaş ekle',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'SFProDisplayRegular',
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  showModalBottomSheet(
                    useSafeArea: true,
                    isScrollControlled: true,
                    backgroundColor: Palette.darkGreyColor2,
                    context: context,
                    builder: (BuildContext context) {
                      return FractionallySizedBox(
                          heightFactor: 0.98,
                          child: SearchScreen(
                            isForCloseFriends: true,
                          ));
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
