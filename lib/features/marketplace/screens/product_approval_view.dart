import 'package:acc/core/commons/error_text.dart';
import 'package:acc/core/commons/image_view.dart';
import 'package:acc/core/commons/loader.dart';
import 'package:acc/features/auth/controller/auth_controller.dart';
import 'package:acc/features/marketplace/controller/marketplace_controller.dart';
import 'package:acc/features/marketplace/screens/edit_product_view.dart';
import 'package:acc/models/product_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../theme/palette.dart';

class ProductApprovalView extends ConsumerStatefulWidget {
  const ProductApprovalView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProductApprovalViewState();
}

class _ProductApprovalViewState extends ConsumerState<ProductApprovalView> {
  @override
  Widget build(BuildContext context) {
    final currentUser = ref.read(userProvider)!;
    return ref.watch(getProductApplications(currentUser.schoolId)).when(
        data: (products) => SafeArea(
              child: Scaffold(
                body: PageView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      ProductModel product = products[index];
                      return EditProductView(product: product);
                    }),
                bottomNavigationBar: Container(
                  decoration: BoxDecoration(
                      color: Palette.backgroundColor,
                      border: Border(
                          top: BorderSide(
                              width: 0.5, color: Palette.darkGreyColor2))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: CupertinoButton(
                            onPressed: () {
                              // if (!isLoading) {
                              //   onShareUpdate(currentUser);
                              // }
                            },
                            color: Palette.redColor,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            borderRadius: BorderRadius.circular(40),
                            child: const Text(
                              'reddet',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontFamily: 'JetBrainsMonoExtraBold',
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: CupertinoButton(
                            onPressed: () {
                              // if (!isLoading) {
                              //   onShareUpdate(currentUser);
                              // }
                            },
                            color: Palette.themeColor,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            borderRadius: BorderRadius.circular(40),
                            child: const Text(
                              'onayla',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontFamily: 'JetBrainsMonoExtraBold',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        error: (error, stackTrace) {
          print(error.toString());
          return ErrorText(error: error.toString());
        },
        loading: () => Loader());
  }
}
