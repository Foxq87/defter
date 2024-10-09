import 'package:acc/core/commons/image_view.dart';
import 'package:acc/core/commons/large_text.dart';
import 'package:acc/core/commons/loader.dart';
import 'package:acc/core/commons/share_bottom_sheet.dart';
import 'package:acc/features/bookmarks/controller/bookmark_controller.dart';
import 'package:acc/features/chats/controller/chat_controller.dart';

import 'package:acc/features/marketplace/controller/marketplace_controller.dart';
import 'package:acc/features/marketplace/screens/create_product_screen.dart';
import 'package:acc/features/user_profile/screens/user_profile_screen.dart';

import 'package:acc/models/product_model.dart';
import 'package:acc/theme/palette.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/constants/constants.dart';
import '../../auth/controller/auth_controller.dart';

class ProductDetails extends ConsumerStatefulWidget {
  final String productId;
  const ProductDetails({super.key, required this.productId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends ConsumerState<ProductDetails> {
  CarouselSliderController carouselController = CarouselSliderController();
  int currentCarouselIndex = 0;
  void deleteProduct(ProductModel product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('silme işlemini onayla'),
          content: Text('ürünü silmek istediğinize emin misiniz?'),
          actions: [
            TextButton(
              child: Text(
                'geri',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'ürünü sil',
                style: TextStyle(color: Palette.redColor, fontSize: 18),
              ),
              onPressed: () {
                ref
                    .read(marketplaceControllerProvider.notifier)
                    .deleteProduct(product, context);
                Routemaster.of(context).pop();
                Routemaster.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.read(userProvider)!;

    return ref.watch(getProductByIdProvider(widget.productId)).when(
        data: (product) {
          bool isBookmarked = product.bookmarks.contains(currentUser.uid);
          return Scaffold(
            appBar: CupertinoNavigationBar(
              // heroTag: 'product-details-${product.id}',
              leading: CupertinoButton(
                padding: EdgeInsets.zero,
                child: Icon(
                  CupertinoIcons.back,
                  color: Colors.white,
                  size: 27,
                ),
                onPressed: () {
                  Routemaster.of(context).pop();
                },
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: SvgPicture.asset(
                      isBookmarked
                          ? Constants.bookmarkFilled
                          : Constants.bookmarkOutlined,
                      colorFilter: ColorFilter.mode(
                        isBookmarked ? Palette.themeColor : Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    onPressed: () {
                      ref
                          .read(bookmarkControllerProvider.notifier)
                          .bookmarkProduct(product, context);
                    },
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: SvgPicture.asset(
                      Constants.upload,
                      colorFilter: ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    onPressed: () {
                      showShareModalBottomSheet(context,
                          'https://defter.web.app/product/${widget.productId}');
                    },
                  ),
                ],
              ),
              backgroundColor: Colors.transparent,
              middle: largeText(
                'ürün',
                false,
              ),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          children: [
                            Text(
                              product.categorie +
                                  (product.categorie.toLowerCase() == 'diğer'
                                      ? ''
                                      : '\t|\t' + product.subcategorie),
                              style: TextStyle(fontSize: 16),
                            ),
                            Spacer(),
                            Text(
                              "stok: " + product.stock.toString(),
                              style: TextStyle(fontSize: 17),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CarouselSlider(
                          carouselController: carouselController,
                          items: List.generate(
                              product.images.length,
                              (index) => GestureDetector(
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ImageView(
                                                imageUrls: product.images,
                                                imageFiles: [],
                                                index: index))),
                                    child: Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      width: MediaQuery.of(context).size.width,
                                      height: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                product.images[index]),
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                  )),
                          options: CarouselOptions(
                              onPageChanged: (index, reason) => setState(() {
                                    currentCarouselIndex = index;
                                  }),
                              enableInfiniteScroll: false,
                              viewportFraction: 1)),
                      SizedBox(
                        height: 10,
                      ),
                      if (product.images.length > 1)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                              product.images.length,
                              (index) => Container(
                                    margin: EdgeInsets.only(right: 5),
                                    height: 7,
                                    width: 30,
                                    decoration: BoxDecoration(
                                        color: currentCarouselIndex == index
                                            ? Palette.themeColor
                                            : Palette.noteIconColor,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                  )),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(25.0).copyWith(top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              product.title,
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              product.description,
                              style: TextStyle(fontSize: 17),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (product.uid == currentUser.uid)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 10),
                    child: CupertinoButton(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        color: Palette.justGreyColor,
                        borderRadius: BorderRadius.circular(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'ürünü sil',
                              style: TextStyle(color: Palette.redColor),
                            ),
                            Icon(
                              CupertinoIcons.delete,
                              color: Palette.redColor,
                            ),
                          ],
                        ),
                        onPressed: () => deleteProduct(product)),
                  ),
                Divider(
                  thickness: 0.5,
                  color: Palette.darkGreyColor2,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 5.0),
                  child: largeText("satıcı", false),
                ),
                ref.watch(getUserDataProvider(product.uid)).when(
                    data: (vendor) => ListTile(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      UserProfileScreen(uid: vendor.uid))),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              vendor.profilePic,
                              height: 45,
                              width: 45,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            vendor.name,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontFamily: 'SFProDisplayMedium'),
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            "@" + vendor.username,
                            style: const TextStyle(
                                color: Palette.placeholderColor,
                                fontSize: 15,
                                fontFamily: 'SFProDisplayMedium'),
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "fiyat: ",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: 'SFProDisplayRegular',
                                  ),
                                ),
                                TextSpan(
                                  text: product.price.toStringAsFixed(2) + "₺",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'SFProDisplayRegular',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    error: (error, stackTrace) => Text(error.toString()),
                    loading: () => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CupertinoActivityIndicator(),
                        )),
              ],
            ),
            bottomNavigationBar: SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  color: Palette.backgroundColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CupertinoButton(
                        onPressed: () {
                          if ((product.uid != currentUser.uid)) {
                            Routemaster.of(context)
                                .push('/chat/${product.uid}/true');
                          } else {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CreateProductScreen(
                                      product: product, editing: true),
                                ));
                          }

                          // ref.read(chatControllerProvider.notifier).startChat(
                          //     uids: [product.uid],
                          //     title: '',
                          //     description: '',
                          //     profilePic: null,
                          //     context: context);
                        },
                        color: (product.uid != currentUser.uid)
                            ? Palette.themeColor
                            : Palette.darkGreyColor2,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        borderRadius: BorderRadius.circular(40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              (product.uid != currentUser.uid)
                                  ? Constants.mailOutlined
                                  : Constants.edit,
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              (product.uid != currentUser.uid)
                                  ? 'iletişime geç'
                                  : 'ürünü düzenle',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontFamily: 'SFProDisplayBold',
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (product.stock == 0)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: const Text(
                            'stokta yok',
                            style: TextStyle(
                              color: Palette.redColor,
                              fontSize: 17,
                              fontFamily: 'SFProDisplayRegular',
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        error: (error, stackTrace) => Text(error.toString()),
        loading: () => Loader());
  }
}
