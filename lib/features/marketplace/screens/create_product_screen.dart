import 'dart:io';

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

import '../../../core/commons/image_view.dart';
import '../../../core/commons/large_text.dart';
import '../../../models/product_model.dart';
import '../../../models/user_model.dart';
import '../../../theme/palette.dart';

class CreateUpdateScreen extends ConsumerStatefulWidget {
  final ProductModel? product;
  const CreateUpdateScreen({super.key, required this.product});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateUpdateScreenState();
}

class _CreateUpdateScreenState extends ConsumerState<CreateUpdateScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController stockController = TextEditingController();
  int categorieIndex = 0;
  String categorie = 'atıştırmalık';
  String subcategorie = 'çikolata';
  List categories = [
    [
      'atıştırmalık',
      ['çikolata', 'cips', 'bisküvi', 'kraker', 'kuruyemiş', 'diğer']
    ],
    [
      'içecek',
      [
        'gazlı içecek',
        'maden suyu',
        'ayran & süt',
        'buzlu çay',
        'meyve suyu',
        'diğer'
      ]
    ],
    [
      'kıyafet',
      [
        'pantolon & eşofman',
        'tişört',
        'gömlek',
        'kazak',
        'sweatshirt & hırka',
        'diğer'
      ]
    ],
    [
      'kırtasiye',
      [
        'okuma kitabı',
        'test kitabı',
        'defter',
        'kalem',
        'silgi',
        'ek malzemeler',
        'diğer'
      ]
    ],
    [
      'ayak giyim',
      ['ayakkabı', 'futbol ayakkabısı', 'terlik', 'diğer']
    ],
  ];
  List<File> images = [];
  String errorText = '';
  void onPickImages() async {
    images = await pickImages(allowMultiple: true);
    if (images.length > 3) {
      showSnackBar(context, "maksimum 3 resim seçin");
      while (images.length != 3) {
        images.removeLast();
      }
    }

    setState(() {});
  }

  void onShareUpdate(UserModel currentUser) async {
    // showSnackBar(context, 'calisacak np ama biraz daha bekle');
    if (titleController.text.trim().isNotEmpty &&
        priceController.text.trim().isNotEmpty &&
        stockController.text.trim().isNotEmpty &&
        descriptionController.text.trim().isNotEmpty &&
        images.isNotEmpty) {
      errorText = "";
      double price =
          double.tryParse(priceController.text.trim().replaceAll(',', '.'))!;
      ref.read(updateControllerProvider.notifier).sendProductToApproval(
            currentUser: currentUser,
            title: titleController.text.trim(),
            price: price,
            stock: int.tryParse(stockController.text.trim())!,
            description: descriptionController.text.trim(),
            categorie: categorie,
            subcategorie: subcategorie,
            imageFiles: images,
            context: context,
          );
    } else {
      setState(() {
        errorText = "lütfen tüm alanları doldurun";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.read(userProvider)!;
    bool isLoading = ref.watch(updateControllerProvider);
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
            Routemaster.of(context).pop();
          },
        ),
        backgroundColor: Palette.backgroundColor,
        // border: const Border(
        //   bottom: BorderSide(width: 1, color: Palette.textFieldColor),
        // ),
        middle: largeText(
          widget.product == null ? 'ürün ekle' : 'ürün onay',
          false,
        ),
        trailing: SizedBox(
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
                fontFamily: 'JetBrainsMonoExtraBold',
              ),
            ),
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
                  padding: images.isEmpty
                      ? null
                      : EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Wrap(
                      spacing: 7.0,
                      runSpacing: 7.0,
                      direction: Axis.horizontal,
                      children: images.map((file) {
                        return GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ImageView(
                                imageUrls: const [],
                                imageFiles: images,
                                index: images.indexOf(file),
                              ),
                            ),
                          ),
                          child: Stack(
                            children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.width / 3 - 10,
                                width:
                                    MediaQuery.of(context).size.width / 3 - 10,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                        image: FileImage(file),
                                        fit: BoxFit.cover)),
                              ),
                              Positioned(
                                top: 7,
                                right: 7,
                                child: Container(
                                  height: 25,
                                  width: 25,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black),
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
                                        images.remove(file);
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                if (images.isEmpty)
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
                        color: Palette.justGrayColor,
                      ))),
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                            categories.length,
                            (index) => Column(
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      if (categorie != categories[index][0]) {
                                        setState(() {
                                          subcategorie = '';
                                        });
                                      }
                                      setState(() {
                                        categorie = categories[index][0];
                                        categorieIndex = index;
                                      });
                                    },
                                    child: Container(
                                      margin:
                                          EdgeInsets.only(right: 5, bottom: 5),
                                      padding: EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: categorie == categories[index][0]
                                            ? Palette.themeColor
                                            : null,
                                        border: Border.all(
                                            width: 1,
                                            color: Palette.iconBackgroundColor),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        categories[index][0],
                                        style: TextStyle(
                                            fontFamily:
                                                'JetBrainsMonoExtraBold'),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        color: Palette.justGrayColor,
                        thickness: 0.2,
                        height: 0,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                            categories[categorieIndex][1].length,
                            (index) => GestureDetector(
                                onTap: () {
                                  setState(() {
                                    subcategorie =
                                        categories[categorieIndex][1][index];
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
                                              categories[categorieIndex][1]
                                                  [index]
                                          ? Palette.orangeColor
                                          : null),
                                  child: Text(
                                    categories[categorieIndex][1][index],
                                    style: TextStyle(
                                        fontFamily: 'JetBrainsMonoExtraBold'),
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
                  textInputAction: TextInputAction.next,
                  controller: titleController,
                  style: TextStyle(
                      color: Colors.white, fontFamily: 'JetBrainsMonoRegular'),
                  placeholder: 'başlık',
                  placeholderStyle: TextStyle(
                      color: Palette.placeholderColor,
                      fontFamily: 'JetBrainsMonoRegular'),
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
                            fontFamily: 'JetBrainsMonoRegular'),
                        placeholder: 'fiyat',
                        placeholderStyle: TextStyle(
                            color: Palette.placeholderColor,
                            fontFamily: 'JetBrainsMonoRegular'),
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
                            fontFamily: 'JetBrainsMonoRegular'),
                        placeholder: 'stok',
                        placeholderStyle: TextStyle(
                            color: Palette.placeholderColor,
                            fontFamily: 'JetBrainsMonoRegular'),
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
                  maxLength: 2000,
                  textInputAction: TextInputAction.done,
                  textAlignVertical: TextAlignVertical.top,
                  controller: descriptionController,
                  minLines: 4,
                  maxLines: null,
                  style: TextStyle(
                      color: Colors.white, fontFamily: 'JetBrainsMonoRegular'),
                  placeholder: 'açıklama',
                  placeholderStyle: TextStyle(
                      color: Palette.placeholderColor,
                      fontFamily: 'JetBrainsMonoRegular'),
                  decoration: BoxDecoration(color: Palette.backgroundColor),
                ),
                if (errorText.isNotEmpty)
                  Text(
                    errorText,
                    style: TextStyle(
                        color: Palette.redColor,
                        fontFamily: "JetBrainsMonoBold"),
                  )
              ],
            ),
    );
  }
}
