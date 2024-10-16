import 'dart:async';
import 'dart:io';

import 'package:acc/core/constants/constants.dart';
import 'package:acc/core/commons/commons.dart';
import 'package:acc/features/article.dart';
import 'package:acc/features/auth/controller/auth_controller.dart';
import 'package:acc/features/home/screens/close_friends_feed.dart';
import 'package:acc/features/notes/widgets/notes_loading_view.dart';
import 'package:acc/features/school/controller/school_controller.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:routemaster/routemaster.dart';
import '../../../models/models.dart';
import '../../../theme/palette.dart';
import '../../notes/widgets/note_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
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

  int segmentedValue = 2;
  int noteLimit = 10;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final user = ref.read(userProvider)!;
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
            icon: userSquare(context, user.profilePic),
          ),
        ),
        middle: largeText("defter", true),
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
                    Text(
                      'agalar',
                      style: TextStyle(
                          color: Colors.white, fontFamily: 'JetBrainsMonoBold'),
                    ),
                  ],
                ),
                onPressed: () async {
                  // final PackageInfo info = await PackageInfo.fromPlatform();
                  // final int currentVersion = int.parse(info.buildNumber);

                  // print(currentVersion.toString() +
                  //     ', this is my lovely version');

                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: Duration(milliseconds: 500),
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          CloseFriendsFeed(),
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
          child: ref
              .watch(notesProvider(segmentedValue == 1 ? "" : user.schoolId))
              .when(
                data: (notes) {
                  // if (notes.length <= noteLimit) {
                  //   setState(() {
                  //     isLoading = false;
                  //   });
                  // } else {
                  //   setState(() {
                  //     isLoading = true;
                  //   });
                  // }

                  if (skeletonLoading) {
                    return NotesLoadingView();
                  } else {
                    return ListView.builder(
                      controller: scrollController,
                      shrinkWrap: true,
                      itemCount: notes.length +
                          (notes.length / 3)
                              .floor(), // Adjust itemCount for every 3 notes
                      itemBuilder: (context, index) {
                        // Calculate the actual index of the note considering ads
                        int noteIndex = index -
                            (index / 4).floor(); // Adjust for every 3 notes

                        // Check if the position should display an ad
                        if (index % 4 == 3) {
                          // Create a new BannerAd instance for this ad placement
                          BannerAd bannerAd = createBannerAd();
                          bannerAd.load(); // Start loading the ad

                          return Container(
                            alignment: Alignment.center,
                            child: AdWidget(ad: bannerAd),
                            height: bannerAd.size.height.toDouble(),
                          );
                        } else {
                          // Display note
                          final note = notes[noteIndex];
                          return NoteCard(note: note);
                        }
                      },
                    );
                  }
                },
                error: (error, stackTrace) {
                  print(error.toString());
                  return Text(error.toString());
                },
                loading: () => const NotesLoadingView(),
              ),

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
