import 'package:acc/core/commons/error_text.dart';
import 'package:acc/core/commons/loader.dart';
import 'package:acc/core/constants/constants.dart';
import 'package:acc/core/commons/commons.dart';
import 'package:acc/features/article.dart';
import 'package:acc/features/auth/controller/auth_controller.dart';
import 'package:acc/features/school/controller/school_controller.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
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
      ),
      drawer: const DrawerView(),
      body: Scrollbar(
        scrollbarOrientation: ScrollbarOrientation.right,
        thumbVisibility: true,
        trackVisibility: true,
        controller: scrollController,
        child: ListView(
          controller: scrollController,
          children: [
            segmentedValue == 1
                ? ref.watch(getWorldNotesProvider(user.schoolId)).when(
                      data: (notes) {
                        // if (scrollController.position.atEdge) {
                        //   noteLimit += 10;
                        // }
                        if (notes.length <= noteLimit) {
                          setState(() {
                            isLoading = false;
                          });
                        } else {
                          setState(() {
                            isLoading = true;
                          });
                        }
                        return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: noteLimit > notes.length
                              ? notes.length
                              : noteLimit,
                          itemBuilder: (BuildContext context, int index) {
                            final note = notes[index];
                            return NoteCard(note: note);
                          },
                        );
                      },
                      error: (error, stackTrace) => Text(error.toString()),
                      loading: () => const Loader(),
                    )
                : ref.watch(getSchoolNotesProvider(user.schoolId)).when(
                      data: (notes) {
                        if (notes.length <= noteLimit) {
                          setState(() {
                            isLoading = false;
                          });
                        } else {
                          setState(() {
                            isLoading = true;
                          });
                        }

                        return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: noteLimit > notes.length
                              ? notes.length
                              : noteLimit,
                          itemBuilder: (BuildContext context, int index) {
                            final note = notes[index];
                            return NoteCard(note: note);
                          },
                        );
                      },
                      error: (error, stackTrace) => Text(error.toString()),
                      loading: () => const Loader(),
                    ),
            SizedBox(
              height: 10,
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
            //           fontFamily: 'JetBrainsMonoRegular',
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
            if (isLoading) CupertinoActivityIndicator(),
            SizedBox(
              height: 70,
            )
          ],
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
                    fontFamily: "JetBrainsMonoBold",
                  ),
                ),
                2: Text(
                  user.schoolId,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontFamily: "JetBrainsMonoBold",
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
