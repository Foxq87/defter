import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:like_button/like_button.dart';

import '../../../core/constants/constants.dart';
import '../../../theme/palette.dart';

class NotesLoadingView extends StatelessWidget {
  const NotesLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 10,
      separatorBuilder: (context, index) => SizedBox(
        height: 5,
      ),
      itemBuilder: (context, index) => noteCard(),
    );
  }
}

Container noteCard() {
  return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(width: 0.25, color: Palette.noteIconColor))),
      // child: Row(
      //   children: [
      //     Container(
      //         height: 40,
      //         width: 40,
      //         decoration: BoxDecoration(
      //           color: Palette.iconBackgroundColor,
      //           borderRadius: BorderRadius.circular(10),
      //         ),
      //         child: SizedBox()),
      //     SizedBox(
      //       width: 10,
      //     ),
      //     Expanded(
      //       child: Column(
      //         children: [
      //           Row(
      //             children: [
      //               Container(
      //                 height: 15,
      //                 width: 100,
      //                 decoration: BoxDecoration(
      //                   color: Palette.darkGreyColor2,
      //                   borderRadius: BorderRadius.circular(5),
      //                 ),
      //               ),
      //             ],
      //           ),
      //           SizedBox(
      //             height: 5,
      //           ),
      //           Row(
      //             children: [
      //               Container(
      //                 height: 60,
      //                 ,
      //                 decoration: BoxDecoration(
      //                   color: Palette.darkGreyColor2,
      //                   borderRadius: BorderRadius.circular(5),
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ],
      //       ),
      //     )
      //   ],
      // ),
      child: Padding(
          padding: EdgeInsets.only(left: 10.0, top: 10.0, right: 10),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Palette.iconBackgroundColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SizedBox()),
            Expanded(
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        // color: currentTheme.drawerTheme.backgroundColor,
                        ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.only(
                                  left: 10,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 100,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                  color: Palette.darkGreyColor2,
                                                  borderRadius:
                                                      BorderRadius.circular(7)),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),

                                    Container(
                                      height: 70,
                                      margin: EdgeInsets.only(right: 15),
                                      decoration: BoxDecoration(
                                          color: Palette.darkGreyColor2,
                                          borderRadius:
                                              BorderRadius.circular(7)),
                                      child: Row(),
                                    ),

                                    const SizedBox(
                                      height: 5,
                                    ),
                                    // widget.note actions
                                    SizedBox(
                                        height: 20,
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  IconButton(
                                                    onPressed: () {},
                                                    padding: EdgeInsets.zero,
                                                    icon: SvgPicture.asset(
                                                      Constants.comment,
                                                      colorFilter:
                                                          const ColorFilter
                                                              .mode(
                                                              Palette
                                                                  .noteIconColor,
                                                              BlendMode.srcIn),
                                                      fit: BoxFit.cover,
                                                      width: 20,
                                                      height: 20,
                                                    ),
                                                  ),
                                                  // Text(
                                                  //   '',
                                                  //   style: const TextStyle(color: Palette.noteIconColor,
                                                  //       fontSize: 15),
                                                  // ),
                                                ],
                                              ),
                                              LikeButton(
                                                  countBuilder: (likeCount,
                                                      isLiked, text) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 5.0),
                                                      child: Text(
                                                        '',
                                                        style: const TextStyle(
                                                            fontSize: 15),
                                                      ),
                                                    );
                                                  },
                                                  likeBuilder: (isLiked) {
                                                    return SizedBox(
                                                      width: 20,
                                                      height: 20,
                                                      child: SvgPicture.asset(
                                                        isLiked
                                                            ? Constants
                                                                .heartFilled
                                                            : Constants
                                                                .heartOutlined,
                                                        fit: BoxFit.contain,
                                                        colorFilter:
                                                            ColorFilter.mode(
                                                                isLiked
                                                                    ? Palette
                                                                        .redColor
                                                                    : Palette
                                                                        .noteIconColor,
                                                                BlendMode
                                                                    .srcIn),
                                                      ),
                                                    );
                                                  },
                                                  isLiked: false,
                                                  likeCount: 0),
                                              IconButton(
                                                padding: EdgeInsets.zero,
                                                onPressed: () {},
                                                icon: SvgPicture.asset(
                                                  Constants.upload,
                                                  width: 20,
                                                  height: 20,
                                                  fit: BoxFit.cover,
                                                  colorFilter:
                                                      const ColorFilter.mode(
                                                          Palette.noteIconColor,
                                                          BlendMode.srcIn),
                                                ),
                                              ),
                                              IconButton(
                                                padding: EdgeInsets.zero,
                                                onPressed: () {},
                                                icon: SvgPicture.asset(
                                                  Constants.bookmarkOutlined,
                                                  width: 20,
                                                  height: 20,
                                                  fit: BoxFit.cover,
                                                  colorFilter: ColorFilter.mode(
                                                      Palette.noteIconColor,
                                                      BlendMode.srcIn),
                                                ),
                                              ),
                                            ])),
                                    SizedBox(
                                      height: 10,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ])));
}
