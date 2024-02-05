import 'package:acc/core/constants/constants.dart';
import 'package:acc/core/commons/commons.dart';
import 'package:acc/features/article.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:routemaster/routemaster.dart';
import '../../../models/models.dart';
import '../../../theme/palette.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        backgroundColor: Colors.transparent,
        leading: Builder(
          builder: (context) => IconButton(
            padding: EdgeInsets.zero,
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: userSquare(context),
          ),
        ),
        middle: largeText("defter", true),
      ),
      drawer: const DrawerView(),
      body: ListView(
        children: [
          //Articles
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                largeText("gazeteler", false),
                const Text(
                  "view all",
                  style: TextStyle(color: Colors.grey),
                )
              ],
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                articles.length,
                (index) => articleCard(
                  articles[index],
                  context,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.grey,
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomSlidingSegmentedControl<int>(
              initialValue: 2,
              children: const {
                1: Text(
                  'World',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontFamily: "JetBrainsMonoBold",
                  ),
                ),
                2: Text(
                  'School',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontFamily: "JetBrainsMonoBold",
                  ),
                ),
              },
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white12),
                color: CupertinoColors.black.withOpacity(0.5),
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
              onValueChanged: (v) {},
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
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white12)),
                  child: const Icon(
                    CupertinoIcons.add,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  Routemaster.of(context).push('/create-post/');
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
          CupertinoPageRoute(
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
      Constants.bookmarkFilled,
      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
      height: 20,
    ),
  );
}
