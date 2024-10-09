import 'dart:async';
import 'dart:io';

import 'package:acc/core/constants/constants.dart';
import 'package:acc/core/commons/commons.dart';
import 'package:acc/core/constants/firebase_constants.dart';
import 'package:acc/features/article.dart';
import 'package:acc/features/auth/controller/auth_controller.dart';
import 'package:acc/features/notes/widgets/notes_loading_view.dart';
import 'package:acc/features/school/controller/school_controller.dart';
import 'package:acc/features/search/screens/search_screen.dart';
import 'package:acc/models/note_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:routemaster/routemaster.dart';
import '../../../models/models.dart';
import '../../../models/user_model.dart';
import '../../../theme/palette.dart';
import '../../notes/widgets/note_card.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

Stream<DocumentSnapshot> getUserStream(String userId) {
  return FirebaseFirestore.instance.collection('users').doc(userId).snapshots();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with AutomaticKeepAliveClientMixin<HomeScreen> {
  late ScrollController scrollController;
  bool isLoading = false;
  bool skeletonLoading = true;
  BannerAd? bannerAd; // Nullable to handle disposal
  Timer? adRefreshTimer;

  BannerAd createBannerAd() {
    // Your ad creation logic here
    return BannerAd(
      adUnitId: Platform.isIOS
          ? 'ca-app-pub-9838840200304232/1734223531'
          : 'ca-app-pub-9838840200304232/6570142465',
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
          // Implement listener methods if needed
          ),
    );
  }

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();

    loadBannerAd();
    startAdRefreshTimer();
    // MobileAds.instance.initialize();
    // myBanner = BannerAd(
    //   adUnitId: 'ca-app-pub-9838840200304232/6570142465',
    //   size: AdSize.banner,
    //   request: AdRequest(),
    //   listener: BannerAdListener(),
    // )..load();

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        skeletonLoading = false;
      });
    });
    // Setup the listener.
    // scrollController.addListener(() {
    //   if (scrollController.position.atEdge) {
    //     bool isTop = scrollController.position.pixels == 0;
    //     if (!isTop) {
    //       setState(() {
    //         isLoading = true;
    //         noteLimit += 10;
    //       });
    //     }
    // if (scrollController.position.pixels ==
    //     scrollController.position.maxScrollExtent) {
    //   setState(() {
    //     isLoading = false;
    //   });
    //   // Page is all the way down
    //   // Add your code here
    // }
    //     }
    // });
  }

  // @override
  // void dispose() {
  //   myBanner?.dispose();
  //   super.dispose();
  // }
  void loadBannerAd() {
    bannerAd?.dispose(); // Dispose the current ad if it exists
    bannerAd = BannerAd(
      adUnitId: Platform.isIOS
          ? 'ca-app-pub-9838840200304232/1734223531'
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
    adRefreshTimer?.cancel(); // Cancel the timer
    scrollController.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    ref.read(schoolControllerProvider.notifier).refreshData(context);
  }

  Future<UserModel> getUserData() async {
    // Replace this with your actual method to fetch user data
    return await getUserData();
  }

  bool checkLoading = false;
  int segmentedValue = 2;
  int noteLimit = 10;
  int filterIndex = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final user = ref.read(userProvider)!;

    final notesQuery = FirebaseFirestore.instance
        .collection(FirebaseConstants.notesCollection)
        .where('schoolName',
            isEqualTo: segmentedValue == 1 ? "" : user.schoolId)
        .where('repliedTo', isEqualTo: '')
        .where('uid',
            whereNotIn: user.blockedAccountIds.isNotEmpty
                ? user.blockedAccountIds
                : [''])
        .orderBy('createdAt', descending: true);
    return Scaffold(
      appBar: CupertinoNavigationBar(
        // border: Border(
        // bottom: BorderSide(width: 0.5, color: Palette.darkGreyColor2)),
        backgroundColor: Colors.black.withOpacity(0.4),
        padding: EdgeInsetsDirectional.zero,
        leading: Builder(
          builder: (context) => IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: userSquare(context, user.profilePic),
          ),
        ),
        middle: largeText("defder", true),
        trailing: Padding(
          padding: const EdgeInsets.only(right: 15.0, bottom: 5),
          child: SizedBox(
            height: 30,
            child: CupertinoButton(
                borderRadius: BorderRadius.circular(100),
                color: Palette.darkGreyColor2,
                padding:
                    EdgeInsets.symmetric(horizontal: 5).copyWith(right: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 5,
                    ),
                    SvgPicture.asset(
                      Constants.searchOutlined,
                      colorFilter:
                          const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                      height: 20,
                      width: 20,
                    ),
                  ],
                ),
                onPressed: () async {
                  // ref.read(userProvider.notifier).update((state) =>
                  //     user.copyWith(schoolId: "onay bekliyor: BAIHL"));
                  // final PackageInfo info = await PackageInfo.fromPlatform();
                  // final int currentVersion = int.parse(info.buildNumber);

                  // print(currentVersion.toString() +
                  //     ', this is my lovely version');

                  Navigator.of(context).push(
                    PageRouteBuilder(
                      transitionDuration: Duration(milliseconds: 500),
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          SearchScreen(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        var begin = Offset(0.0, 1.0);
                        var end = Offset.zero;
                        var curve = Curves.ease;

                        var tween = Tween(begin: begin, end: end)
                            .chain(CurveTween(curve: curve));

                        return SlideTransition(
                          position: animation.drive(tween),
                          child: child,
                        );
                      },
                    ),
                  );
                }),
          ),
        ),
      ),

      drawer: const DrawerView(),
      body: RefreshIndicator(
        color: Palette.themeColor,
        onRefresh: _refreshData,
        child: Scrollbar(
            scrollbarOrientation: ScrollbarOrientation.right,
            thumbVisibility: true,
            trackVisibility: true,
            controller: skeletonLoading ? null : scrollController,
            child:
                // if (notes.length <= noteLimit) {
                //   setState(() {
                //     isLoading = false;
                //   });
                // } else {
                //   setState(() {
                //     isLoading = true;
                //   });
                // }

                skeletonLoading
                    ? NotesLoadingView()
                    : Column(
                        children: [
                          Container(
                            color: Colors.black.withOpacity(0.4),
                            padding: EdgeInsets.all(8),
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 35,
                                  child: CupertinoButton(
                                    color: filterIndex == 0
                                        ? Palette.themeColor
                                        : Palette.darkGreyColor2,
                                    borderRadius: BorderRadius.circular(15),
                                    child: Text(
                                      'güncel',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'JetBrainsMonoBold'),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        filterIndex = 0;
                                      });
                                    },
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15),
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                SizedBox(
                                  height: 35,
                                  child: CupertinoButton(
                                    color: filterIndex == 1
                                        ? Palette.themeColor
                                        : Palette.darkGreyColor2,
                                    borderRadius: BorderRadius.circular(15),
                                    child: Text(
                                      'popüler',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'JetBrainsMonoBold'),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        filterIndex = 1;
                                      });
                                    },
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15),
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                SizedBox(
                                  height: 35,
                                  child: CupertinoButton(
                                    color: filterIndex == 2
                                        ? Palette.themeColor
                                        : Palette.darkGreyColor2,
                                    borderRadius: BorderRadius.circular(15),
                                    child: Text(
                                      'samimi',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'JetBrainsMonoBold'),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        filterIndex = 2;
                                      });
                                    },
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                              height: 0,
                              thickness: 0.5,
                              color: Palette.darkGreyColor2),
                          if (user.schoolId.contains('onay bekliyor:'))
                            StreamBuilder<DocumentSnapshot>(
                                stream: getUserStream(user.uid),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  }
                                  if (snapshot.hasError) {
                                    return Center(
                                        child:
                                            Text('Error: ${snapshot.error}'));
                                  }
                                  if (!snapshot.hasData ||
                                      !snapshot.data!.exists) {
                                    return Center(
                                        child: Text('User not found'));
                                  }

                                  UserModel userData = UserModel.fromMap(
                                      snapshot.data!.data()
                                          as Map<String, dynamic>);
                                  String realtimeSchoolId = userData.schoolId;
                                  if (realtimeSchoolId
                                      .contains('onay bekliyor:')) {
                                    return buildInReview();
                                  } else {
                                    return buildReviewed(userData);
                                  }
                                }),
                          if (filterIndex == 2)
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.all(10),
                                        margin: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: Palette.darkGreyColor),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 7,
                                            ),
                                            Icon(
                                              CupertinoIcons.group,
                                              size: 40,
                                              color: Palette.themeColor,
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'yakın arkadaşlarının paylaştığı notları burada görebilirsin',
                                                maxLines: 4,
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ),
                                            // CupertinoButton(
                                            //   color: Palette.themeColor,
                                            //   padding: EdgeInsets.symmetric(
                                            //       horizontal: 20),
                                            //   child: checkLoading
                                            //       ? CupertinoActivityIndicator()
                                            //       : Text(
                                            //           'kontrol et',
                                            //           style: TextStyle(
                                            //               fontFamily:
                                            //                   'JetBrainsMonoBold',
                                            //               color: Colors.white),
                                            //         ),
                                            //   onPressed: () async {
                                            //     setState(() {
                                            //       checkLoading = true;
                                            //     });
                                            //     await Future.delayed(
                                            //         Duration(seconds: 2));
                                            //     setState(() {
                                            //       checkLoading = false;
                                            //     });
                                            //   },
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Text('')
                              ],
                            ),
                          Expanded(
                            child: FirestoreQueryBuilder(
                              pageSize: 5,
                              query: filterIndex == 0
                                  ? FirebaseFirestore.instance
                                      .collection(
                                          FirebaseConstants.notesCollection)
                                      .where('schoolName',
                                          isEqualTo: segmentedValue == 1
                                              ? ""
                                              : user.schoolId)
                                      .where('repliedTo', isEqualTo: '')
                                      .where('uid',
                                          whereNotIn: user.blockedAccountIds.isNotEmpty
                                              ? user.blockedAccountIds
                                              : [''])
                                      .orderBy('createdAt', descending: true)
                                  : filterIndex == 1
                                      ? FirebaseFirestore.instance
                                          .collection(
                                              FirebaseConstants.notesCollection)
                                          .where('schoolName',
                                              isEqualTo: segmentedValue == 1
                                                  ? ""
                                                  : user.schoolId)
                                          .where('repliedTo', isEqualTo: '')
                                          .where('uid',
                                              whereNotIn:
                                                  user.blockedAccountIds.isNotEmpty
                                                      ? user.blockedAccountIds
                                                      : [''])
                                          .orderBy('likesCount',
                                              descending: true)
                                      : filterIndex == 2
                                          ? FirebaseFirestore.instance.collection(FirebaseConstants.notesCollection).where('schoolId', isEqualTo: 'closeFriends-${user.uid}').where('repliedTo', isEqualTo: '').where('uid', whereNotIn: user.blockedAccountIds.isNotEmpty ? user.blockedAccountIds : ['']).orderBy(
                                              'createdAt',
                                              descending: true)
                                          : FirebaseFirestore.instance
                                              .collection(FirebaseConstants.notesCollection)
                                              .where('schoolName', isEqualTo: segmentedValue == 1 ? "" : user.schoolId)
                                              .where('repliedTo', isEqualTo: '')
                                              .where('uid', whereNotIn: user.blockedAccountIds.isNotEmpty ? user.blockedAccountIds : [''])
                                              .orderBy('createdAt', descending: true),
                              builder: (context, snapshot, child) {
                                if (snapshot.hasError) {
                                  print(snapshot.error);
                                  return Center(
                                      child: Text('Error: ${snapshot.error}'));
                                }

                                // Calculate the total item count including ads
                                int itemCount = snapshot.docs.length +
                                    (snapshot.docs.length / 4).floor();

                                return ListView.builder(
                                  controller: scrollController,
                                  shrinkWrap: true,
                                  itemCount:
                                      itemCount, // Adjust itemCount for every 4 notes
                                  itemBuilder: (context, index) {
                                    if (snapshot.hasMore &&
                                        index + 1 == snapshot.docs.length) {
                                      // Tell FirestoreQueryBuilder to try to obtain more items.
                                      // It is safe to call this function from within the build method.
                                      snapshot.fetchMore();
                                    }
                                    // Check if the position should display an ad
                                    if (index % 4 == 3) {
                                      // Create a new BannerAd instance for this ad placement
                                      BannerAd bannerAd = BannerAd(
                                        adUnitId:
                                            'ca-app-pub-9838840200304232/7133588550', // Replace with your actual Ad Unit ID
                                        size: AdSize.banner,
                                        request: AdRequest(),
                                        listener: BannerAdListener(
                                          onAdLoaded: (Ad ad) =>
                                              print('Ad loaded.'),
                                          onAdFailedToLoad:
                                              (Ad ad, LoadAdError error) {
                                            ad.dispose();
                                            print('Ad failed to load: $error');
                                          },
                                        ),
                                      );
                                      bannerAd.load(); // Start loading the ad

                                      return Container(
                                        alignment: Alignment.center,
                                        child: AdWidget(ad: bannerAd),
                                        height: bannerAd.size.height.toDouble(),
                                      );
                                    } else {
                                      // Calculate the actual index of the note considering ads
                                      int noteIndex =
                                          index - (index / 4).floor();
                                      Note note = Note.fromMap(
                                          snapshot.docs[noteIndex].data());
                                      return NoteCard(
                                        note: note,
                                        isComment: false,
                                      );
                                    }
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      )
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     CupertinoButton(
            //       padding: EdgeInsets.symmetric(horizontal: 20),
            //       color: Palette.orangeColor,
            //       borderRadius: BorderRadius.circular(20),
            //       child: Text(
            //         'daha fazla',
            //         textAlign: TextAlign.center,
            //         style: TextStyle(
            //           fontSize: 18,
            //           color: Colors.white,
            //           fontFamily: 'SFProDisplayRegular',
            //         ),
            //       ),
            //       onPressed: () {
            //         setState(() {
            //           noteLimit += 10;
            //         });
            //       },
            //     ),
            //   ],
            // ),
            // if (isLoading) CupertinoActivityIndicator(),
            ),
      ),
      //Articles
      // Padding(
      //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: [
      //       largeText("gazeteler", false),
      //       const Text(
      //         "view all",
      //         style: TextStyle(color: Colors.grey),
      //       )
      //     ],
      //   ),
      // ),
      // SingleChildScrollView(
      //   padding: const EdgeInsets.all(10),
      //   scrollDirection: Axis.horizontal,
      //   child: Row(
      //     children: List.generate(
      //       articles.length,
      //       (index) => articleCard(
      //         articles[index],
      //         context,
      //       ),
      //     ),
      //   ),
      // ),
      // const Divider(
      //   color: Colors.grey,
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // FutureBuilder(
            //     future: getUserStream(user.uid),
            //     builder: (context, snapshot) {
            //       if (snapshot.connectionState == ConnectionState.waiting) {
            //         return Center(child: CupertinoActivityIndicator());
            //       } else if (snapshot.hasError) {
            //         return Center(child: Text('Error: ${snapshot.error}'));
            //       } else {
            //         // Your code here
            //         final realtimeUser = UserModel.fromMap(
            //             snapshot.data!.data() as Map<String, dynamic>);
            //         return
            CustomSlidingSegmentedControl<int>(
              initialValue: 2,
              children: {
                1: const Text(
                  'dünya',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontFamily: "SFProDisplayMedium",
                  ),
                ),
                2: Text(
                  user.schoolId,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontFamily: "SFProDisplayMedium",
                  ),
                ),
              },
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white12),
                color: CupertinoColors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(100),
              ),
              thumbDecoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.3),
                    blurRadius: 4.0,
                    spreadRadius: 1.0,
                    offset: const Offset(
                      0.0,
                      2.0,
                    ),
                  ),
                ],
              ),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              onValueChanged: (v) {
                setState(() {
                  segmentedValue = v;
                });
                print(v);
              },
            ),
            const SizedBox(
              width: 4,
            ),
            CupertinoButton(
                padding: EdgeInsets.zero,
                child: Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.8),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white12)),
                  child: const Icon(
                    CupertinoIcons.add,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  Routemaster.of(context).push('/create-note/');
                })
          ],
        ),
      ),
    );
  }

  Column buildReviewed(UserModel userData) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Palette.darkGreyColor),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 7,
                    ),
                    Icon(
                      CupertinoIcons.check_mark_circled,
                      size: 30,
                      color: Palette.themeColor,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Text(
                        'okulun onaylandı!',
                        maxLines: 4,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    CupertinoButton(
                      color: Palette.themeColor,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: checkLoading
                          ? CupertinoActivityIndicator()
                          : Text(
                              'yenile',
                              style: TextStyle(
                                  fontFamily: 'JetBrainsMonoBold',
                                  color: Colors.white),
                            ),
                      onPressed: () async {
                        setState(() {
                          checkLoading = true;
                        });
                        _refreshData();
                        ref
                            .read(userProvider.notifier)
                            .update((state) => userData);
                        await Future.delayed(Duration(seconds: 2));
                        setState(() {
                          checkLoading = false;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Column buildInReview() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Palette.darkGreyColor),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 7,
                    ),
                    Icon(
                      CupertinoIcons.alarm,
                      size: 30,
                      color: Palette.orangeColor,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Text(
                        'okulun onay sürecinde\nsonuçlanınca sana haber vereceğiz',
                        maxLines: 4,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    // CupertinoButton(
                    //   color: Palette.themeColor,
                    //   padding: EdgeInsets.symmetric(
                    //       horizontal: 20),
                    //   child: checkLoading
                    //       ? CupertinoActivityIndicator()
                    //       : Text(
                    //           'kontrol et',
                    //           style: TextStyle(
                    //               fontFamily:
                    //                   'JetBrainsMonoBold',
                    //               color: Colors.white),
                    //         ),
                    //   onPressed: () async {
                    //     setState(() {
                    //       checkLoading = true;
                    //     });
                    //     await Future.delayed(
                    //         Duration(seconds: 2));
                    //     setState(() {
                    //       checkLoading = false;
                    //     });
                    //   },
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Text('')
      ],
    );
  }
}

GestureDetector articleCard(Article article, BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleView(
              article: article,
            ),
          ));
    },
    child: Container(
      margin: const EdgeInsets.only(right: 20),
      padding: const EdgeInsets.all(10.0),
      height: 140,
      width: 300,
      decoration: BoxDecoration(
        color: Palette.redColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //Placeholder image & title
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/images/mic.png',
                  fit: BoxFit.cover,
                  height: 60,
                  width: 60,
                ),
                // child: Image.network(
                //   article.thumbmnailUrl,
                //   fit: BoxFit.cover,
                //   height: 60,
                // ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  article.title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          //Author
          const Text(
            'by Ryan McBeth',
            style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
                fontSize: 13),
          ),
          const Spacer(),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //Estimated reading time
              readingTime(article.readingTime),

              //Bookmark
              bookmarkButton(),
            ],
          )
        ],
      ),
    ),
  );
}

Text readingTime(int min) {
  return Text(
    '${min.toString()} min read',
    style: const TextStyle(
        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
  );
}

CircleAvatar bookmarkButton() {
  return CircleAvatar(
    radius: 17,
    backgroundColor: Colors.white.withOpacity(0.3),
    child: SvgPicture.asset(
      Constants.bookmarkOutlined,
      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
      height: 20,
    ),
  );
}
