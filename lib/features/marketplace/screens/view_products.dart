import 'package:acc/features/auth/controller/auth_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../core/commons/large_text.dart';
import '../../../core/commons/nav_bar_button.dart';
import '../../../core/constants/constants.dart';
import '../../../theme/palette.dart';
import '../controller/marketplace_controller.dart';
import '../widgets/product_card.dart';

class ViewProducts extends ConsumerStatefulWidget {
  const ViewProducts({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ViewProductsState();
}

class _ViewProductsState extends ConsumerState<ViewProducts> {
  List<GlobalKey> categorieKeys = [];
  List<GlobalKey> subcategorieKeys = [];
  int categorieIndex = 0;
  ScrollController scrollController = ScrollController();
  String categorie = Constants.categories.first[0].toString();
  String subcategorie = Constants.categories.first[1].first.toString();

  @override
  void initState() {
    for (var i = 0; i < Constants.categories.length; i++) {
      print(Constants.categories[i][1].length);
      for (var j = 0; j < Constants.categories[i][1].length; j++) {
        subcategorieKeys.add(GlobalKey());
      }
      categorieKeys.add(GlobalKey());
    }
    print(categorieKeys.length);
    print(subcategorieKeys.length);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.read(userProvider)!;
    return Scaffold(
        appBar: CupertinoNavigationBar(
          transitionBetweenRoutes: false,
          backgroundColor: Colors.black,
          middle: const Text(
            'ürünler',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'SFProDisplayRegular',
              fontSize: 18,
            ),
          ),
          leading: JustIconButton(
            icon: CupertinoIcons.back,
            onPressed: () => Navigator.of(context).pop(),
          ),
          // border: Border(
          //     bottom: BorderSide(width: 0.5, color: Palette.darkGreyColor2)),
          // // trailing: JustIconButton(icon: Icons.more_horiz, onPressed: () {}),
        ),
        body: SafeArea(
            child: Column(children: [
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
                color: Colors.black,
                border: Border(
                    bottom: BorderSide(
                  width: 0.45,
                  color: Palette.darkGreyColor2,
                ))),
            child: Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      Constants.categories.length,
                      (index) => Column(
                        children: [
                          GestureDetector(
                              onTap: () {
                                if (categorie !=
                                    Constants.categories[index][0]) {
                                  setState(() {
                                    subcategorie = Constants
                                            .categories[index][1].isEmpty
                                        ? ''
                                        : Constants.categories[index][1].first;
                                  });
                                }
                                setState(() {
                                  categorie = Constants.categories[index][0];
                                  categorieIndex = index;
                                });
                                scrollController.jumpTo(0);
                                Scrollable.ensureVisible(
                                    categorieKeys[index].currentContext!);
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: 5, bottom: 5),
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: categorie ==
                                          Constants.categories[index][0]
                                      ? Palette.themeColor
                                      : null,
                                  border: Border.all(
                                      width: 1,
                                      color: Palette.iconBackgroundColor),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  Constants.categories[index][0],
                                  style:
                                      TextStyle(fontFamily: 'SFProDisplayBold'),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
                Divider(
                  color: Palette.darkGreyColor2,
                  thickness: 0.45,
                  height: 0,
                ),
                SingleChildScrollView(
                  controller: scrollController,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      Constants.categories[categorieIndex][1].length,
                      (index) => GestureDetector(
                          onTap: () {
                            setState(() {
                              subcategorie = Constants
                                  .categories[categorieIndex][1][index];
                            });
                            // Scrollable.ensureVisible(
                            //     subcategorieKeys[index].currentContext!);
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 5, top: 5),
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1,
                                    color: Palette.iconBackgroundColor),
                                borderRadius: BorderRadius.circular(8),
                                color: subcategorie ==
                                        Constants.categories[categorieIndex][1]
                                            [index]
                                    ? Palette.orangeColor
                                    : null),
                            child: Text(
                              Constants.categories[categorieIndex][1][index],
                              style: TextStyle(fontFamily: 'SFProDisplayBold'),
                            ),
                          )),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(children: [
              for (int index = 0; index < Constants.categories.length; index++)
                Column(
                  key: categorieKeys[index],
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0, top: 10),
                        child: largeText(
                            Constants.categories[index][0].toString(), false),
                      ),
                    ),
                    for (int i = 0;
                        i < Constants.categories[index][1].length;
                        i++)
                      Column(
                        // key: subcategorieKeys[i],
                        children: [
                          ref
                              .watch(getSchoolProductsProvider(
                                  currentUser.schoolId))
                              .when(
                                  data: (products) {
                                    products = products.where(
                                      (element) {
                                        return element.categorie ==
                                                Constants.categories[index]
                                                    [0] &&
                                            (element.subcategorie.isEmpty
                                                ? true
                                                : element.subcategorie ==
                                                    Constants.categories[index]
                                                        [1][i]);
                                      },
                                    ).toList();
                                    return Column(
                                      children: [
                                        if (products.isNotEmpty)
                                          Align(
                                            // key: subcategorieKeys[i],
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15.0,
                                                  bottom: 10,
                                                  top: 15),
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 5, vertical: 2),
                                                decoration: BoxDecoration(
                                                    color:
                                                        Palette.darkGreyColor2,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0)),
                                                child: Text(Constants
                                                    .categories[index][1][i]),
                                              ),
                                            ),
                                          ),
                                        GridView(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                  mainAxisSpacing: 15,
                                                  crossAxisCount: 3,
                                                  mainAxisExtent: 210),
                                          padding: EdgeInsets.only(left: 15),
                                          children: List.generate(
                                              products.length, (i) {
                                            // print(products[i].categorie
                                            //     // +
                                            //     // " esit mi " +
                                            //     // Constants.categories[index][0]
                                            //     );
                                            return
                                                // products[i].categorie ==
                                                //         Constants.categories[categorieIndex][0]
                                                //             .toString()
                                                //     ?
                                                Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 10.0),
                                              child: ProductCard(
                                                  product: products[i]),
                                            );
                                          }),
                                        ),
                                      ],
                                    );
                                  },
                                  error: (error, stackTrace) {
                                    print(error);
                                    return Text(error.toString());
                                  },
                                  loading: () => Text('loading')),
                        ],
                      )
                  ],
                ),
            ]),
          ),
        ])));
  }
}
