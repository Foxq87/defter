import 'dart:io';

import 'package:acc/core/constants/constants.dart';
import 'package:acc/theme/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'nav_bar_button.dart';

class ImageView extends StatefulWidget {
  final List<String> imageUrls;
  final List<File> imageFiles;
  const ImageView(
      {super.key, required this.imageUrls, required this.imageFiles});

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  bool isTapped = true;
  CupertinoTheme _navBar(double screenWidth) {
    return CupertinoTheme(
      data: const CupertinoThemeData(
        brightness: Brightness.dark,
        primaryColor: Palette.themeColor,
      ),
      child: CupertinoNavigationBar(
        middle: const Text('Resim'),
        backgroundColor: Colors.black.withOpacity(0.7),
        automaticallyImplyLeading: true,
        trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            child: SvgPicture.asset(
              Constants.upload,
              colorFilter:
                  const ColorFilter.mode(Palette.themeColor, BlendMode.srcIn),
              height: 25,
              width: 25,
            ),
            onPressed: () {}),
      ),
    );
  }

  Widget _bottomNavBar() {
    return const SizedBox();
  }

  void tap() {
    setState(() {
      isTapped = !isTapped;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      bottomNavigationBar: isTapped ? _bottomNavBar() : null,
      body: Stack(
        children: [
          PageView.builder(
              itemCount: widget.imageUrls.isNotEmpty
                  ? widget.imageUrls.length
                  : widget.imageFiles.length,
              itemBuilder: (context, index) => GestureDetector(
                    onTap: () => tap(),
                    child: SizedBox(
                      height: screenHeight,
                      width: screenWidth,
                      child: widget.imageUrls.isNotEmpty
                          ? Image.network(widget.imageUrls[index])
                          : Image.file(widget.imageFiles[index]),
                    ),
                  )),
          isTapped ? _navBar(screenWidth) : const SizedBox(),
        ],
      ),
    );
  }
}
