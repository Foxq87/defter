import 'package:acc/core/commons/large_text.dart';
import 'package:acc/features/bookmarks/controller/bookmark_controller.dart';
import 'package:acc/features/marketplace/widgets/product_card.dart';
import 'package:acc/theme/palette.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../../notes/widgets/note_card.dart';

class SavedContent extends ConsumerStatefulWidget {
  final String uid;
  const SavedContent({super.key, required this.uid});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SavedState();
}

class _SavedState extends ConsumerState<SavedContent> {
  ScrollController scrollController = ScrollController();
  int noteLimit = 10;
  int segmentedValue = 1;
  bool isLoading = true;
  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        bool isTop = scrollController.position.pixels == 0;
        if (!isTop) {
          setState(() {
            noteLimit += 10;
          });
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        backgroundColor: Colors.black,
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
        middle: largeText("kütüphane", false),
        border: Border(
            bottom: BorderSide(width: 0.5, color: Palette.darkGreyColor2)),
      ),
      body: ListView(
        controller: scrollController,
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
        children: [
          segmentedValue == 1
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    largeText('notlar', false),
                    ref.watch(getBookmarkedNotesProvider(widget.uid)).when(
                        data: (notes) {
                          if (notes.length <= noteLimit) {
                            setState(() {
                              isLoading = false;
                            });
                          } else {
                            setState(() {
                              isLoading = true;
                            });
                          }
                          return ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: noteLimit > notes.length
                                ? notes.length
                                : noteLimit,
                            itemBuilder: (BuildContext context, int index) {
                              final note = notes[index];
                              return NoteCard(note: note);
                            },
                          );
                        },
                        error: (error, stackTrace) {
                          print(error);
                          return Text(error.toString());
                        },
                        loading: () => CupertinoActivityIndicator()),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    largeText('ürünler', false),
                    ref.watch(getBookmarkedProductsProvider(widget.uid)).when(
                        data: (products) {
                          if (products.length <= noteLimit) {
                            setState(() {
                              isLoading = false;
                            });
                          } else {
                            setState(() {
                              isLoading = true;
                            });
                          }
                          return ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: noteLimit > products.length
                                ? products.length
                                : noteLimit,
                            itemBuilder: (BuildContext context, int index) {
                              final product = products[index];
                              return ProductCard(product: product);
                            },
                          );
                        },
                        error: (error, stackTrace) {
                          print(error);
                          return Text(error.toString());
                        },
                        loading: () => CupertinoActivityIndicator()),
                  ],
                ),
          if (isLoading) CupertinoActivityIndicator(),
          SizedBox(
            height: 70,
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomSlidingSegmentedControl<int>(
              initialValue: 1,
              children: {
                1: const Text(
                  'notlar',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontFamily: "JetBrainsMonoBold",
                  ),
                ),
                2: Text(
                  'ürünler',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontFamily: "JetBrainsMonoBold",
                  ),
                ),
              },
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white12),
                color: CupertinoColors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(100),
              ),
              thumbDecoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.3),
                    blurRadius: 4.0,
                    spreadRadius: 1.0,
                    offset: const Offset(
                      0.0,
                      2.0,
                    ),
                  ),
                ],
              ),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              onValueChanged: (v) {
                setState(() {
                  segmentedValue = v;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
