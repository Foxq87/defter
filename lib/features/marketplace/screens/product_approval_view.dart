import 'package:acc/core/commons/loader.dart';
import 'package:acc/features/auth/controller/auth_controller.dart';
import 'package:acc/features/marketplace/controller/marketplace_controller.dart';
import 'package:acc/features/marketplace/screens/create_product_screen.dart';
import 'package:acc/models/product_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/commons/large_text.dart';
import '../../../theme/palette.dart';

class ProductApprovalView extends ConsumerStatefulWidget {
  const ProductApprovalView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProductApprovalViewState();
}

class _ProductApprovalViewState extends ConsumerState<ProductApprovalView> {
  PageController pageController = PageController();
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.read(userProvider)!;
    return ref.watch(getProductApplications(currentUser.schoolId)).when(
        data: (products) => Scaffold(
              appBar: products.isNotEmpty
                  ? null
                  : CupertinoNavigationBar(
                      leading: CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: Icon(
                          CupertinoIcons.back,
                          color: Colors.white,
                          size: 27,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      backgroundColor: Colors.transparent,
                      middle: largeText(
                        'ürün onay',
                        false,
                      ),
                    ),
              body: SafeArea(
                child: products.isEmpty
                    ? Center(
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.check_mark_circled,
                            color: Palette.themeColor,
                            size: 50,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'tüm ürünler kontrol edildi!',
                            style: TextStyle(fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ))
                    : Column(
                        children: [
                          Wrap(
                              spacing: 10,
                              direction: Axis.horizontal,
                              children: List.generate(
                                products.length,
                                (i) => SizedBox(
                                    height: 30,
                                    child: CupertinoButton(
                                      padding: EdgeInsets.zero,
                                      borderRadius: BorderRadius.circular(100),
                                      color: currentPageIndex != i
                                          ? Palette.iconBackgroundColor
                                          : Palette.themeColor,
                                      onPressed: () {
                                        pageController.animateToPage(i,
                                            duration:
                                                Duration(milliseconds: 200),
                                            curve: Curves.bounceInOut);
                                      },
                                      child: Text(
                                        (i + 1).toString(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'SFProDisplayRegular'),
                                      ),
                                    )),
                              )),
                          Expanded(
                            child: PageView.builder(
                                controller: pageController,
                                itemCount: products.length,
                                onPageChanged: (i) {
                                  setState(() {
                                    currentPageIndex = i;
                                  });
                                },
                                itemBuilder: (context, index) {
                                  ProductModel product = products[index];
                                  return CreateProductScreen(product: product);
                                }),
                          ),
                        ],
                      ),
              ),
            ),
        error: (error, stackTrace) {
          print(error.toString());
          return Text(error.toString());
        },
        loading: () => Loader());
  }
}
