import 'package:acc/core/commons/error_text.dart';
import 'package:acc/core/commons/loader.dart';
import 'package:acc/features/auth/controller/auth_controller.dart';
import 'package:acc/features/marketplace/controller/marketplace_controller.dart';
import 'package:acc/features/marketplace/screens/create_product_screen.dart';
import 'package:acc/features/marketplace/widgets/product_card.dart';

import 'package:acc/features/suggest_feature/screens/suggest_feature_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import '../../../core/commons/large_text.dart';
import '../../../models/product_model.dart';
import '../../../models/update_model.dart';
import '../../../theme/palette.dart';

class UpdatesScreen extends ConsumerStatefulWidget {
  const UpdatesScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UpdatesScreenState();
}

class _UpdatesScreenState extends ConsumerState<UpdatesScreen> {
  navigatToSuggest() {
    Navigator.push(
        context, CupertinoPageRoute(builder: (context) => SuggestFeature()));
  }

  navigateToCreateUpdate() {
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => CreateUpdateScreen(
                  product: null,
                )));
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.read(userProvider)!;
    return Scaffold(
      appBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        backgroundColor: Colors.transparent,
        border: const Border(
            bottom: BorderSide(width: 1, color: Palette.textFieldColor)),
        middle: largeText('götür', false),
      ),
      floatingActionButton: user.roles.contains('developer')
          ? CupertinoButton(
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
            )
          : CupertinoButton(
              padding: EdgeInsets.zero,
              borderRadius: BorderRadius.circular(100),
              color: Palette.themeColor,
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () {
                navigatToSuggest();
              },
            ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                largeText("atıştırmalıklar", false),
                smallTextButton(
                  title: "tamamını gör",
                  color: Palette.placeholderColor,
                  fontSize: 15.0,
                  onPressed: () {},
                )
              ],
            ),
          ),
          // SingleChildScrollView(
          //   scrollDirection: Axis.horizontal,
          //   child: Row(
          //       children: List.generate(
          //           products.length,
          //           (index) => Padding(
          //                 padding: index == 0
          //                     ? const EdgeInsets.only(
          //                         left: 15.0,
          //                       )
          //                     : const EdgeInsets.only(
          //                         left: 7.0,
          //                       ),
          //                 child: ProductCard(
          //                   product: products[index],
          //                 ),
          //               ))),
          // )
        ],
      ),
    );
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
