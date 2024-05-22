import 'package:acc/features/home/drawers/drawer.dart';
import 'package:acc/features/notes/controller/note_controller.dart';
import 'package:acc/features/school/controller/school_controller.dart';
import 'package:acc/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart_ext/rxdart_ext.dart';

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

  bool isLoading = true;
  @override
  void initState() {
    super.initState();

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
Future<Stream<List<Note>>> getCloseFriendsFeed(UserModel currentUser) async {
  List<Stream<List<Note>>> streams = [];

  for (String friendId in currentUser.closeFriends) {
    var stream = FirebaseFirestore.instance.collection('posts')
        .where('uid', isEqualTo: friendId)
        .where('schoolName', isEqualTo: 'closeFriend-$friendId')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((querySnapshot) {
          return querySnapshot.docs.map((doc) {
            return ref.read(noteControllerProvider.notifier).getNoteById(doc.id); // Assuming you have a method to convert a DocumentSnapshot to a Note
          }).toList();
        });

    streams.add(stream);
  }

  return Rx.combineLatest(streams, (values) {
    return values.expand((element) => element).toList();
  });
}

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.read(userProvider)!;
    List<String> selectedProfileUids = [currentUser.uid];
    List<UserModel> selectedProfiles = [currentUser];
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
            padding: EdgeInsets.only(right: 20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  CupertinoIcons.chevron_down,
                  color: Palette.orangeColor,
                  size: 20,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  'agalar',
                  style: TextStyle(
                      color: Palette.orangeColor,
                      fontFamily: 'JetBrainsMonoBold'),
                ),
              ],
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
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
                            selectedProfiles.length + 1,
                            (index) => index == selectedProfiles.length
                                ? CupertinoButton(
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
                                : Padding(
                                    padding: const EdgeInsets.all(8.0)
                                        .copyWith(left: 0, right: 10),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                                child: Image.network(
                                                  selectedProfiles[index]
                                                      .profilePic,
                                                  height: 50,
                                                  width: 50,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              if (selectedProfileUids[index] !=
                                                  currentUser.uid)
                                                Positioned(
                                                  top: -8,
                                                  right: -8,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        selectedProfileUids
                                                            .remove(
                                                                selectedProfiles[
                                                                        index]
                                                                    .uid);
                                                        selectedProfiles.remove(
                                                            selectedProfiles[
                                                                index]);
                                                      });
                                                    },
                                                    child: CircleAvatar(
                                                        radius: 12,
                                                        backgroundColor: Palette
                                                            .placeholderColor,
                                                        child: Icon(
                                                          CupertinoIcons.clear,
                                                          size: 15,
                                                        )),
                                                  ),
                                                ),
                                            ],
                                          ),
                                          if (selectedProfileUids[index] !=
                                              currentUser.uid)
                                            Column(
                                              children: [
                                                SizedBox(
                                                  height: 3,
                                                ),
                                                SizedBox(
                                                  width: 55,
                                                  child: Text(
                                                    selectedProfiles[index]
                                                        .username,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style:
                                                        TextStyle(fontSize: 11),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ],
                                            )
                                        ]),
                                  )),
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 0.45,
                    color: Palette.darkGreyColor2,
                  ),
                  // FutureBuilder<Stream<List<Note>>>(
                  //   future: ref
                  //       .read(schoolControllerProvider.notifier)
                  //       .getCloseFriendsFeedProvider(),
                  //   builder: (context, snapshot) {
                  //     if (snapshot.connectionState == ConnectionState.waiting) {
                  //       return CircularProgressIndicator();
                  //     } else if (snapshot.hasError) {
                  //       return Text('Error: ${snapshot.error}');
                  //     } else {
                  //       return StreamBuilder<List<Note>>(
                  //         stream: snapshot.data,
                  //         builder: (context, snapshot) {
                  //           if (snapshot.connectionState ==
                  //               ConnectionState.waiting) {
                  //             return CircularProgressIndicator();
                  //           } else if (snapshot.hasError) {
                  //             return Text('Error: ${snapshot.error}');
                  //           } else {
                  //             return ListView.builder(
                  //               itemCount: snapshot.data?.length ?? 0,
                  //               itemBuilder: (context, index) {
                  //                 final note = snapshot.data![index];
                  //                 return NoteCard(note: note);
                  //               },
                  //             );
                  //           }
                  //         },
                  //       );
                  //     }
                  //   },
                  // ),
                  ref.watch(getCloseFriendsFeedStreamProvider).when(
                        data: (notes) {
                          return ListView.builder(
                            controller: scrollController,
                            shrinkWrap: true,
                            itemCount: notes.length,
                            itemBuilder: (context, index) {
                              final note = notes[index];
                              return NoteCard(note: note);
                            },
                          );
                        },
                        loading: () => CircularProgressIndicator(),
                        error: (error, stackTrace) => Text('Error: $error'),
                      ),

                  // ref.watch(getCloseFriendsFeedProvider).when(
                  //       data: (notes) {
                  //         if (notes.length <= noteLimit) {
                  //           setState(() {
                  //             isLoading = false;
                  //           });
                  //         } else {
                  //           setState(() {
                  //             isLoading = true;
                  //           });
                  //         }
                  //         return ListView.builder(
                  //           physics: NeverScrollableScrollPhysics(),
                  //           shrinkWrap: true,
                  //           itemCount: noteLimit > notes.length
                  //               ? notes.length
                  //               : noteLimit,
                  //           itemBuilder: (BuildContext context, int index) {
                  //             final note = notes[index];
                  //             return NoteCard(note: note);
                  //           },
                  //         );
                  //       },
                  //       error: (error, stackTrace) => Text(error.toString()),
                  //       loading: () => const Loader(),
                  //     ),
                  SizedBox(
                    height: 10,
                  ),
                  if (isLoading) CupertinoActivityIndicator(),
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
                        fontFamily: 'JetBrainsMonoRegular',
                      ),
                    ),
                  ],
                ),
                onPressed: () {},
              ),
            )
          ],
        ),
      ),
    );
  }
}
