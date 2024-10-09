import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../../../models/product_model.dart';
import '../../../theme/palette.dart';
import '../../auth/controller/auth_controller.dart';
import '../screens/product_details.dart';

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
      onTap: () => Routemaster.of(context).push('product/${widget.product.id}'),
      child: Container(
        width: 140,
        decoration: BoxDecoration(
            // border: Border.all(color: Pale  borderRadius: BorderRadius.circular(15),tte.darkGreyColor2, width: 0.45),
            // borderRadius: BorderRadius.circular(15),
            ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ref.watch(getUserDataProvider(widget.product.uid)).when(
                data: (vendor) => Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(7),
                          child: Image.network(
                            vendor.profilePic,
                            height: 25,
                            width: 25,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        Expanded(
                          child: Text(
                            "@" + vendor.username,
                            style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontFamily: 'SFProDisplayMedium'),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    )),
                error: (error, stackTrace) => Text(error.toString()),
                loading: () => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CupertinoActivityIndicator(),
                    )),
            SizedBox(
              height: 5.0,
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  // bottom: BorderSide(
                  width: 0.45,
                  color: Palette.darkGreyColor2,
                  // ),
                ),
                color: Palette.textFieldColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    widget.product.images.first,
                    fit: BoxFit.cover,
                    width: 140,
                    height: 130,
                    // loadingBuilder: (BuildContext context, Widget child,
                    //     ImageChunkEvent? loadingProgress) {
                    //   if (loadingProgress == null) {
                    //     return child;
                    //   }
                    //   return Center(
                    //     child: SizedBox(
                    //       height: 130,
                    //       width: 140,
                    //       child: LinearProgressIndicator(
                    //         color: Palette.themeColor,
                    //         value: loadingProgress.expectedTotalBytes != null
                    //             ? loadingProgress.cumulativeBytesLoaded /
                    //                 loadingProgress.expectedTotalBytes!
                    //             : null,
                    //       ),
                    //     ),
                    //   );
                    // },
                  )),
            ),
            if (widget.product.stock <= 0)
              Padding(
                padding: const EdgeInsets.only(top: 7.0),
                child: Text(
                  'stokta yok',
                  style: const TextStyle(
                      color: Palette.orangeColor,
                      fontFamily: 'SFProDisplayRegular'),
                ),
              ),

            SizedBox(
              height: 5,
            ),
            Text(
              widget.product.title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'SFProDisplayMedium'),
              overflow: TextOverflow.ellipsis,
            ),
            Text('${widget.product.price.toStringAsFixed(2)} ₺',
                style: const TextStyle(
                    color: Palette.lightGreyColor,
                    fontSize: 12,
                    fontFamily: 'SFProDisplayRegular')),

            // Padding(
            //   padding: const EdgeInsets.all(
            //     7.0,
            //   ).copyWith(top: 0),
            //   child: SizedBox(
            //     height: 30,
            //     child: CupertinoButton(
            //       padding: EdgeInsets.zero,
            //       color: widget.product.stock > 0
            //           ? Palette.themeColor
            //           : Palette.darkGreyColor2,
            //       borderRadius: BorderRadius.circular(10),
            //       child: Center(
            //         child: FittedBox(
            //           fit: BoxFit.scaleDown,
            //           child: Text(
            //             widget.product.stock > 0 ? 'detay' : 'stokta yok',
            //             style: const TextStyle(
            //                 color: Colors.white,
            //                 fontFamily: 'SFProDisplayRegular'),
            //           ),
            //         ),
            //       ),
            //       onPressed: () {
            //         Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //                 builder: (context) =>
            //                     ProductDetails(productId: widget.product.id)));
            //       },
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
