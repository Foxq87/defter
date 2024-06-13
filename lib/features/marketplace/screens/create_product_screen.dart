import 'dart:io';

import 'package:acc/core/commons/error_text.dart';
import 'package:acc/core/commons/loader.dart';
import 'package:acc/core/utils.dart';
import 'package:acc/features/auth/controller/auth_controller.dart';
import 'package:acc/features/marketplace/controller/marketplace_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

import '../../../core/commons/image_view.dart';
import '../../../core/commons/large_text.dart';
import '../../../core/constants/constants.dart';
import '../../../models/product_model.dart';
import '../../../models/user_model.dart';
import '../../../theme/palette.dart';

class CreateProductScreen extends ConsumerStatefulWidget {
  final ProductModel? product;
  final bool? editing;
  const CreateProductScreen(
      {super.key, this.editing = false, required this.product});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateProductScreenState();
}

class _CreateProductScreenState extends ConsumerState<CreateProductScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController stockController = TextEditingController();
  List<File> imageFiles = [];
  List<String> imageLinks = [];
  int categorieIndex = 0;
  String categorie = 'atıştırmalık';
  String subcategorie = 'çikolata';

  String errorText = '';

  void onPickImages() async {
    final action = await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              child: Text(
                "kamera",
                style: TextStyle(
                    fontFamily: 'SFProDisplayRegular', color: Colors.white),
              ),
              onPressed: () {
                Navigator.pop(context, "photo");
              },
            ),
            CupertinoActionSheetAction(
              child: Text(
                "fotoğraf seç",
                style: TextStyle(
                    fontFamily: 'SFProDisplayRegular', color: Colors.white),
              ),
              onPressed: () {
                Navigator.pop(context, "library");
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDestructiveAction: true,
            child: Text(
              "geri",
              style: TextStyle(
                  fontFamily: 'SFProDisplayRegular',
                  color: Palette.orangeColor),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        );
      },
    );

    if (action == "photo") {
      imageFiles = await camera(allowMultiple: false);
      setState(() {});
    } else if (action == "library") {
      imageFiles = await pickImages(allowMultiple: true);
      if (imageFiles.length > 3) {
        showSnackBar(context, "maksimum 3 resim seçin");
        while (imageFiles.length > 3) {
          imageFiles.removeLast();
        }
      }
      setState(() {});
    }
  }

  void onShareUpdate(UserModel currentUser) async {
    // showSnackBar(context, 'calisacak np ama biraz daha bekle');
    if (titleController.text.trim().isNotEmpty &&
        priceController.text.trim().isNotEmpty &&
        stockController.text.trim().isNotEmpty &&
        descriptionController.text.trim().isNotEmpty &&
        (imageLinks.isNotEmpty || imageFiles.isNotEmpty)) {
      errorText = "";
      String productId = Uuid().v4();

      double price =
          double.tryParse(priceController.text.trim().replaceAll(',', '.'))!;
      ref.read(marketplaceControllerProvider.notifier).sendProductToApproval(
            vendor: currentUser,
            title: titleController.text.trim(),
            price: price,
            stock: int.tryParse(stockController.text.trim())!,
            description: descriptionController.text.trim(),
            categorie: categorie,
            subcategorie: subcategorie,
            imageFiles: imageFiles,
            imageLinks: imageLinks,
            context: context,
            productId: widget.product == null ? productId : widget.product!.id,
          );
    } else {
      setState(() {
        errorText = "lütfen tüm alanları doldurun";
      });
    }
  }

  @override
  void initState() {
    if (widget.product != null) {
      setState(() {
        imageLinks = widget.product!.images;
        categorie = widget.product!.categorie;
        subcategorie = widget.product!.subcategorie;
        titleController = TextEditingController(text: widget.product!.title);
        priceController = TextEditingController(
            text: widget.product!.price.toStringAsFixed(2));
        stockController =
            TextEditingController(text: widget.product!.stock.toString());
        descriptionController =
            TextEditingController(text: widget.product!.description);
      });
    }

    super.initState();
  }

  buildSelectedImages() {
    return imageFiles.map((file) {
      return GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImageView(
              imageUrls: const [],
              imageFiles: imageFiles,
              index: imageFiles.indexOf(file),
            ),
          ),
        ),
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.width / 3 - 10,
              width: MediaQuery.of(context).size.width / 3 - 10,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      image: FileImage(file), fit: BoxFit.cover)),
            ),
            Positioned(
              top: 7,
              right: 7,
              child: Container(
                height: 25,
                width: 25,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.black),
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: const Center(
                    child: Icon(
                      CupertinoIcons.clear,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      imageFiles.remove(file);
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  buildProductImages() {
    return imageLinks.map((imageLink) {
      return GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImageView(
              imageUrls: imageLinks,
              imageFiles: const [],
              index: imageLinks.indexOf(imageLink),
            ),
          ),
        ),
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.width / 3 - 10,
              width: MediaQuery.of(context).size.width / 3 - 10,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      image: NetworkImage(imageLink), fit: BoxFit.cover)),
            ),
            Positioned(
              top: 7,
              right: 7,
              child: Container(
                height: 25,
                width: 25,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.black),
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: const Center(
                    child: Icon(
                      CupertinoIcons.clear,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      imageLinks.remove(imageLink);
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.read(userProvider)!;
    bool isLoading = ref.watch(marketplaceControllerProvider);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        heroTag: 'three',
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
        backgroundColor: Palette.backgroundColor,
        // border: const Border(
        //   bottom: BorderSide(width: 1, color: Palette.textFieldColor),
        // ),
        middle: largeText(
          widget.editing == true || widget.product == null
              ? 'ürünü düzenle'
              : 'ürün onay',
          false,
        ),
        trailing: widget.product != null && widget.editing == false
            ? SizedBox()
            : SizedBox(
                height: 35,
                child: CupertinoButton(
                  onPressed: () {
                    if (!isLoading) {
                      onShareUpdate(currentUser);
                    }
                  },
                  color: Palette.themeColor,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  borderRadius: BorderRadius.circular(40),
                  child: const Text(
                    'kaydet',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontFamily: 'SFProDisplayBold',
                    ),
                  ),
                ),
              ),
      ),
      bottomNavigationBar: widget.product == null || widget.editing!
          ? null
          : Container(
              decoration: BoxDecoration(
                  color: Palette.backgroundColor,
                  border: Border(
                      top: BorderSide(
                          width: 0.5, color: Palette.darkGreyColor2))),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
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
                            fontFamily: 'SFProDisplayBold',
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
                          if (titleController.text.trim().isNotEmpty &&
                              priceController.text.trim().isNotEmpty &&
                              stockController.text.trim().isNotEmpty &&
                              categorie.isNotEmpty &&
                              subcategorie.isNotEmpty &&
                              (imageFiles.isNotEmpty ||
                                  imageLinks.isNotEmpty)) {
                            errorText = "";
                            double price = double.tryParse(priceController.text
                                .trim()
                                .replaceAll(',', '.'))!;
                            ref
                                .read(getUserDataProvider(widget.product!.uid))
                                .when(
                                    data: (vendor) {
                                      ref
                                          .read(marketplaceControllerProvider
                                              .notifier)
                                          .approveProduct(
                                            vendor: vendor,
                                            productId: widget.product!.id,
                                            title: titleController.text.trim(),
                                            price: price,
                                            stock: int.tryParse(
                                                stockController.text.trim())!,
                                            description: descriptionController
                                                .text
                                                .trim(),
                                            categorie: categorie,
                                            subcategorie: subcategorie,
                                            imageLinks: imageLinks,
                                            createdAt:
                                                widget.product!.createdAt,
                                            context: context,
                                          );
                                    },
                                    error: (error, stackTrace) =>
                                        Text(error.toString()),
                                    loading: () => Loader());
                          } else {
                            setState(() {
                              errorText = "lütfen tüm alanları doldurun";
                            });
                          }
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
                            fontFamily: 'SFProDisplayBold',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      body: isLoading
          ? Loader()
          : ListView(
              padding: EdgeInsets.only(bottom: 50),
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: Palette.backgroundColor,
                  padding: imageFiles.isEmpty
                      ? null
                      : EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Wrap(
                        spacing: 7.0,
                        runSpacing: 7.0,
                        direction: Axis.horizontal,
                        children:
                            (widget.editing == true && imageFiles.isNotEmpty) ||
                                    imageFiles.isNotEmpty
                                ? buildSelectedImages()
                                : buildProductImages()),
                  ),
                ),
                if (imageFiles.isEmpty && imageLinks.isEmpty)
                  Container(
                    color: Palette.backgroundColor,
                    padding: EdgeInsets.all(10.0),
                    child: GestureDetector(
                      onTap: onPickImages,
                      child: Container(
                        child: Row(
                          children: [
                            Expanded(
                                child: AspectRatio(
                              aspectRatio: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        width: 1.5,
                                        color: Palette.darkGreyColor2)),
                                child: Center(
                                  child: Icon(
                                    CupertinoIcons.camera,
                                    size: 30,
                                  ),
                                ),
                              ),
                            )),
                            SizedBox(
                              width: 7,
                            ),
                            Expanded(
                                child: AspectRatio(
                                    aspectRatio: 1,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                              width: 1.5,
                                              color: Palette.darkGreyColor2)),
                                    ))),
                            SizedBox(
                              width: 7,
                            ),
                            Expanded(
                                child: AspectRatio(
                                    aspectRatio: 1,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                              width: 1.5,
                                              color: Palette.darkGreyColor2)),
                                    ))),
                          ],
                        ),
                      ),
                    ),
                  ),
                SizedBox(
                  height: 7.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: largeText('kategori', false),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                      color: Palette.backgroundColor,
                      border: Border.symmetric(
                          horizontal: BorderSide(
                        width: 0.2,
                        color: Palette.justGreyColor,
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
                                          subcategorie = '';
                                        });
                                      }
                                      setState(() {
                                        categorie =
                                            Constants.categories[index][0];
                                        categorieIndex = index;
                                      });
                                    },
                                    child: Container(
                                      margin:
                                          EdgeInsets.only(right: 5, bottom: 5),
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
                                        style: TextStyle(
                                            fontFamily: 'SFProDisplayBold'),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        color: Palette.justGreyColor,
                        thickness: 0.2,
                        height: 0,
                      ),
                      SingleChildScrollView(
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
                                              Constants.categories[
                                                  categorieIndex][1][index]
                                          ? Palette.orangeColor
                                          : null),
                                  child: Text(
                                    Constants.categories[categorieIndex][1]
                                        [index],
                                    style: TextStyle(
                                        fontFamily: 'SFProDisplayBold'),
                                  ),
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: largeText('ürün detayları', false),
                ),
                CupertinoTextField(
                  cursorColor: Palette.themeColor,
                  textInputAction: TextInputAction.next,
                  controller: titleController,
                  style: TextStyle(
                      color: Colors.white, fontFamily: 'SFProDisplayRegular'),
                  placeholder: 'başlık',
                  placeholderStyle: TextStyle(
                      color: Palette.placeholderColor,
                      fontFamily: 'SFProDisplayRegular'),
                  padding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                  decoration: BoxDecoration(
                    color: Palette.backgroundColor,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    Expanded(
                      child: CupertinoTextField(
                        cursorColor: Palette.themeColor,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\,?\d{0,2}')),
                        ],
                        maxLength: 7,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.numberWithOptions(
                            signed: false, decimal: true),
                        controller: priceController,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'SFProDisplayRegular'),
                        placeholder: 'fiyat',
                        placeholderStyle: TextStyle(
                            color: Palette.placeholderColor,
                            fontFamily: 'SFProDisplayRegular'),
                        padding: EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 10.0),
                        decoration: BoxDecoration(
                            border: Border(
                                right: BorderSide(
                                    width: 2.5,
                                    color: Palette.iconBackgroundColor)),
                            color: Palette.backgroundColor),
                      ),
                    ),
                    Expanded(
                      child: CupertinoTextField(
                        cursorColor: Palette.themeColor,
                        maxLength: 3,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.numberWithOptions(
                            signed: false, decimal: false),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        controller: stockController,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'SFProDisplayRegular'),
                        placeholder: 'stok',
                        placeholderStyle: TextStyle(
                            color: Palette.placeholderColor,
                            fontFamily: 'SFProDisplayRegular'),
                        padding: EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 10.0),
                        decoration:
                            BoxDecoration(color: Palette.backgroundColor),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                CupertinoTextField(
                  cursorColor: Palette.themeColor,
                  maxLength: 2000,
                  textInputAction: TextInputAction.done,
                  textAlignVertical: TextAlignVertical.top,
                  controller: descriptionController,
                  minLines: 4,
                  maxLines: null,
                  style: TextStyle(
                      color: Colors.white, fontFamily: 'SFProDisplayRegular'),
                  placeholder: 'açıklama',
                  placeholderStyle: TextStyle(
                      color: Palette.placeholderColor,
                      fontFamily: 'SFProDisplayRegular'),
                  decoration: BoxDecoration(color: Palette.backgroundColor),
                ),
                if (errorText.isNotEmpty)
                  Text(
                    errorText,
                    style: TextStyle(
                        color: Palette.redColor,
                        fontFamily: "SFProDisplayMedium"),
                  )
              ],
            ),
    );
  }
}
