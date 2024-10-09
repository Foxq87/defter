import 'dart:async';

import 'package:acc/core/constants/constants.dart';
import 'package:acc/features/auth/controller/auth_controller.dart';
import 'package:acc/features/marketplace/controller/marketplace_controller.dart';
import 'package:acc/features/marketplace/screens/create_product_screen.dart';
import 'package:acc/features/marketplace/screens/view_products.dart';
import 'package:acc/features/marketplace/widgets/product_card.dart';
import 'package:acc/features/suggest_feature/screens/suggest_feature_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/commons/large_text.dart';
import '../../../theme/palette.dart';

class MarketplaceScreen extends ConsumerStatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MarketplaceScreenState();
}

class _MarketplaceScreenState extends ConsumerState<MarketplaceScreen> {
  ScrollController scrollController = ScrollController();
  navigatToSuggest() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SuggestFeature()));
  }

  navigateToCreateUpdate() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CreateProductScreen(
                  product: null,
                )));
  }

  DateTime now = DateTime.now();
  DateTime startTime = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 9);
  DateTime endTime = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 16);
  @override
  Widget build(BuildContext context) {
    // DateTime now = DateTime.now();
    // DateTime startTime = DateTime(now.year, now.month, now.day, 9);
    // DateTime endTime = DateTime(now.year, now.month, now.day, 18, 30);
    final user = ref.read(userProvider)!;
    // ProductModel prototype = ProductModel(
    //     id: 'id',
    //     uid: 'uid',
    //     title: 'title',
    //     schoolId: user.schoolId,
    //     price: 1,
    //     stock: 0,
    //     categorie: 'atıştırmalık',
    //     subcategorie: '',
    //     approve: 2,
    //     description: 'description',
    //     images: [],
    //     createdAt: DateTime.now());

    return Scaffold(
        appBar: CupertinoNavigationBar(
          automaticallyImplyLeading: false,
          transitionBetweenRoutes: false,
          backgroundColor: Colors.transparent,
          border: const Border(
              bottom: BorderSide(width: 0.5, color: Palette.darkGreyColor2)),
          middle: largeText('götür', false),
        ),
        floatingActionButton: CupertinoButton(
          padding: EdgeInsets.zero,
          borderRadius: BorderRadius.circular(100),
          color: Palette.themeColor,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            navigateToCreateUpdate();
          },
        ),
        body: user.schoolId.contains('onay bekliyor:')
            ? Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'okulundaki ürünleri görebilmen için okulunun doğrulanması gerek. doğrulama işlemi bitince seni haberdar edeceğiz.',
                  style: TextStyle(fontSize: 20, color: Palette.orangeColor),
                  textAlign: TextAlign.center,
                ),
              )
            : 
            // now.weekday != DateTime.saturday &&
            //         now.weekday != DateTime.sunday &&
            //         now.isAfter(startTime) &&
            //         now.isBefore(endTime)
            //     ? NotInSchoolTime()
            //     :
                 Scrollbar(
                    scrollbarOrientation: ScrollbarOrientation.right,
                    thumbVisibility: true,
                    trackVisibility: true,
                    controller: scrollController,
                    child: ListView(controller: scrollController, children: [
                      for (int index = 0;
                          index < Constants.categories.length;
                          index++)
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0, top: 10, bottom: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  largeText(
                                      Constants.categories[index][0].toString(),
                                      false),
                                  smallTextButton(
                                    title: "tamamını gör",
                                    color: Palette.placeholderColor,
                                    fontSize: 15.0,
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ViewProducts(),
                                          ));
                                    },
                                  ),
                                ],
                              ),
                            ),
                            ref
                                .watch(getSchoolProductsProvider(user.schoolId))
                                .when(
                                    data: (products) {
                                      if (products.isEmpty) {}
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10.0),
                                        child: SingleChildScrollView(
                                          padding: EdgeInsets.only(
                                              left: 15, right: 20),
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: List.generate(
                                                products.length, (i) {
                                              print(products[i].categorie
                                                  // +
                                                  // " esit mi " +
                                                  // Constants.categories[index][0]
                                                  );
                                              return products[i].categorie ==
                                                      Constants
                                                          .categories[index][0]
                                                          .toString()
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 10.0),
                                                      child: ProductCard(
                                                          product: products[i]),
                                                    )
                                                  : SizedBox();
                                            }),
                                          ),
                                        ),
                                      );
                                    },
                                    error: (error, stackTrace) {
                                      print(error);
                                      return Text(error.toString());
                                    },
                                    loading: () => Text('loading')),
                          ],
                        ),
                    ]),
                  ));
  }
}

// List<ProductModel> products = [
//   Prod
//   ProductModel(
//       id: 'id',
//       uid: 'ku0DDDpShoR8dqhhhx3IIbtpE5u1',
//       title: 'zart kebab',
//       price: 12.50,
//       stock: 2,
//       categorie: 'snack',
//       approve: 'approve',
//       description: 'description',
//       images: [
//         'https://images.migrosone.com/sanalmarket/product/08050858/didi-limon-aromali-soguk-cay-250-ml-cbd347-1650x1650.jpg'
//       ]),
//   ProductModel(
//       id: 'id',
//       uid: 'ku0DDDpShoR8dqhhhx3IIbtpE5u1',
//       title: 'dido',
//       price: 12.50,
//       stock: 2,
//       type: 'snack',
//       approve: 'approve',
//       description: 'description',
//       images: [
//         'https://images.migrosone.com/sanalmarket/product/08050858/didi-limon-aromali-soguk-cay-250-ml-cbd347-1650x1650.jpg'
//       ]),
//   ProductModel(
//       id: 'id',
//       uid: 'ku0DDDpShoR8dqhhhx3IIbtpE5u1',
//       title: 'cipis',
//       price: 12.50,
//       stock: 2,
//       type: 'snack',
//       approve: 'approve',
//       description: 'description',
//       images: [
//         'https://images.migrosone.com/sanalmarket/product/08050858/didi-limon-aromali-soguk-cay-250-ml-cbd347-1650x1650.jpg'
//       ]),
//   ProductModel(
//       id: 'id',
//       uid: 'ku0DDDpShoR8dqhhhx3IIbtpE5u1',
//       title: 'title',
//       price: 12.50,
//       stock: 2,
//       type: 'snack',
//       approve: 'approve',
//       description: 'description',
//       images: [
//         'https://images.migrosone.com/sanalmarket/product/08050858/didi-limon-aromali-soguk-cay-250-ml-cbd347-1650x1650.jpg'
//       ]),
// ];

class NotInSchoolTime extends ConsumerStatefulWidget {
  const NotInSchoolTime({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NotInSchoolTimeState();
}

class _NotInSchoolTimeState extends ConsumerState<NotInSchoolTime> {
  Timer? _timer;
  int _remainingTime = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }

  void _startTimer() {
    DateTime now = DateTime.now();
    DateTime endTime = DateTime(now.year, now.month, now.day, 16);
    Duration remainingDuration = endTime.difference(now);
    _remainingTime = remainingDuration.inSeconds;

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _remainingTime--;
      });

      if (_remainingTime <= 0) {
        _stopTimer();
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  Widget build(BuildContext context) {
    int hours = _remainingTime ~/ 3600;
    int minutes = (_remainingTime % 3600) ~/ 60;
    int seconds = _remainingTime % 60;

    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "kalan",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            Text(
              '$hours:$minutes:$seconds',
              style: TextStyle(fontSize: 50, color: Palette.orangeColor),
            ),
            SizedBox(
              width: 300,
              child: Text(
                "okul saati dışında kullanıma açıktır",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Palette.justGreyColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
