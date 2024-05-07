import 'package:acc/core/commons/error_text.dart';
import 'package:acc/features/auth/controller/auth_controller.dart';
import 'package:acc/features/marketplace/screens/product_details.dart';
import 'package:acc/models/product_model.dart';
import 'package:acc/theme/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductCard extends ConsumerStatefulWidget {
  final ProductModel product;
  const ProductCard({super.key, required this.product});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductCardState();
}

class _ProductCardState extends ConsumerState<ProductCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) =>
                  ProductDetails(productId: widget.product.id))),
      child: Container(
        width: 155,
        decoration: BoxDecoration(
          border: Border.all(color: Palette.placeholderColor, width: 0.45),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Palette.placeholderColor,
                    width: 0.45,
                  ),
                ),
              ),
              child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  child: Image.network(
                    widget.product.images.first,
                    height: 120,
                    width: 155,
                    fit: BoxFit.cover,
                  )),
            ),

            ref.watch(getUserDataProvider(widget.product.uid)).when(
                data: (vendor) => Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            vendor.profilePic,
                            height: 40,
                            width: 40,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.product.title,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontFamily: 'JetBrainsMonoBold'),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                    '${widget.product.price.toStringAsFixed(2)} ₺',
                                    style: const TextStyle(
                                        color: Palette.justGrayColor,
                                        fontSize: 12,
                                        fontFamily: 'JetBrainsMonoRegular')),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
                error: (error, stackTrace) => Text(error.toString()),
                loading: () => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CupertinoActivityIndicator(),
                    )),

            Padding(
              padding: const EdgeInsets.all(
                7.0,
              ).copyWith(top: 0),
              child: SizedBox(
                height: 30,
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  color: widget.product.stock > 0
                      ? Palette.themeColor
                      : Palette.darkGreyColor2,
                  borderRadius: BorderRadius.circular(10),
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        widget.product.stock > 0 ? 'detay' : 'stokta yok',
                        style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'JetBrainsMonoRegular'),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) =>
                                ProductDetails(productId: widget.product.id)));
                    // if (type == "editProduct") {
                    //   try {
                    //     Get.to(() => CreatePage(
                    //           productId: widget.productId,
                    //           imageUrl: widget.imageUrl,
                    //           type: type,
                    //           title: widget.title,
                    //           price: widget.price.toString(),
                    //           desc: widget.description,
                    //           quantity: widget.quantity,
                    //           editing: true,
                    //         ));
                    //   } catch (e) {
                    //     //print(e);
                    //   }
                    // } else if (type != "tripMode" &&
                    //     type != "outOfOrder" &&
                    //     widget.vendor != currentUser.id) {
                    //   try {
                    //     createProductInCart();
                    //   } catch (e) {
                    //     //print(e);
                    //   }
                    // } else {}
                  },
                ),
              ),
            ),

            // StreamBuilder(
            //     stream: usersRef.doc(widget.vendor).snapshots(),
            //     builder: (context, onlineSnapshot) {
            //       if (!onlineSnapshot.hasData) {
            //         return loading();
            //       }
            //       return childMan(widget.vendor == currentUser.id
            //           ? "editProduct"
            //           : onlineSnapshot.data!.get('tripMode') == true
            //               ? "tripMode"
            //               : widget.quantity <= 0
            //                   ? "outOfOrder"
            //                   : "addToCart");
            //     })
          ],
        ),
      ),
    );
  }
}
