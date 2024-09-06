import 'dart:async';
import 'dart:io';

import 'package:acc/features/home/drawers/drawer.dart';
import 'package:acc/features/school/controller/school_controller.dart';
import 'package:acc/features/user_profile/screens/user_profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../../core/commons/large_text.dart';

import '../../../core/commons/user_square.dart';
import '../../../models/note_model.dart';
import '../../../theme/palette.dart';
import '../../auth/controller/auth_controller.dart';
import '../../notes/widgets/note_card.dart';
import '../../search/screens/search_screen.dart';

//ca-app-pub-9838840200304232/2799553883 ** android
//ca-app-pub-9838840200304232/6271895038 ** ios
class CloseFriendsFeed extends ConsumerStatefulWidget {
  const CloseFriendsFeed({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CloseFriendsFeedState();
}

class _CloseFriendsFeedState extends ConsumerState<CloseFriendsFeed>
    with AutomaticKeepAliveClientMixin<CloseFriendsFeed> {
  ScrollController scrollController = ScrollController();
  List<String> selectedProfileUids = [];
  List<Note> notes = []; // Assuming Post is your model class
  bool isLoading = false;
  int currentPage = 1;
  final int postsPerPage = 10;
  BannerAd? bannerAd; // Nullable to handle disposal
  Timer? adRefreshTimer;
  final ScrollController _scrollController = ScrollController();
  List<Note> _notes = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  // List<UserModel> selectedProfiles = [];

  BannerAd createBannerAd() {
    // Your ad creation logic here
    return BannerAd(
      adUnitId: Platform.isIOS
          ? 'ca-app-pub-9838840200304232/6271895038'
          : 'ca-app-pub-9838840200304232/2799553883',
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
          // Implement listener methods if needed
          ),
    );
  }

  Future<void> _fetchPosts() async {
    if (_isLoading || !_hasMore) return;

    setState(() => _isLoading = true);

    try {
      // Replace this with your method to fetch posts
      List<Note> newPosts =
          await ref.read(getCloseFriendsFeedProvider(_currentPage).future);

      if (newPosts.isEmpty || newPosts.length < 10) {
        _hasMore = false;
      } else {
        _currentPage++;
        _notes.addAll(newPosts);
      }
    } catch (e) {
      // Handle errors
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _fetchPosts();
    }
  }

  @override
  void initState() {
    super.initState();
    final currentUser = ref.read(userProvider)!;
    loadBannerAd();
    startAdRefreshTimer();
    // selectedProfileUids.add(currentUser.uid);
    currentUser.closeFriends.forEach((element) {
      selectedProfileUids.add(element);
    });
    _fetchPosts();
    _scrollController.addListener(_onScroll);
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

  void loadBannerAd() {
    bannerAd?.dispose(); // Dispose the current ad if it exists
    bannerAd = BannerAd(
      adUnitId: Platform.isIOS
          ? 'ca-app-pub-9838840200304232/6271895038'
          : 'ca-app-pub-9838840200304232/6570142465',
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
          // Implement listener methods if needed
          ),
    )..load();
  }

  void startAdRefreshTimer() {
    adRefreshTimer = Timer.periodic(Duration(minutes: 2), (timer) {
      // Reload the ad every 2 minutes
      loadBannerAd();
    });
  }

  @override
  void dispose() {
    bannerAd?.dispose(); // Dispose of the ad when the widget is disposed
    _scrollController.dispose();
    adRefreshTimer?.cancel(); // Cancel the timer
    scrollController.dispose();
    super.dispose();
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
    super.build(context);
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

                  // ref.watch(getCloseFriendsFeedProvider).when(
                  //     data: (notes) {
                  //       notes
                  //           .sort((a, b) => a.createdAt.compareTo(b.createdAt));
                  //       return
                  ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _notes.length +
                        (_notes.length / 3).floor() 
                        , // Adjust itemCount for every 3 _notes
                    itemBuilder: (context, index) {
                      // Calculate the actual index of the note considering ads
                      int noteIndex = index -
                          (index / 4).floor(); // Adjust for every 3 _notes

                      // Check if the position should display an ad
                      if (index % 4 == 3) {
                        // Create a new BannerAd instance for this ad placement
                        BannerAd bannerAd = createBannerAd();
                        bannerAd.load(); // Start loading the ad

                        return Container(
                          alignment: Alignment.center,
                          child: AdWidget(ad: bannerAd!),
                          height: bannerAd!.size.height.toDouble(),
                        );
                      } else {
                        // Display note
                        // final note = _notes[noteIndex];
                 
                        return NoteCard(
                            note: _notes[
                                index]); // Your method to build each post item
                      }
                    },
                  ),
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
                  // },
                  // error: (error, stackTrace) => Text(error.toString()),
                  // loading: () => CupertinoActivityIndicator()),
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
