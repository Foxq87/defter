// import 'package:cal/models/question_model.dart';
// import 'package:cal/pages/new_scale.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:cal/constants.dart';
// import 'package:cal/models/Note_model.dart';
// import 'package:cal/models/user_model.dart';
// import 'package:cal/pages/account.dart';
// import 'package:cal/pages/home.dart';
// import 'package:cal/widgets/loading.dart';
// import 'package:cal/widgets/nav_bar.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:like_button/like_button.dart';
// import 'package:timeago/timeago.dart' as timeago;
// import 'package:unicons/unicons.dart';
// import 'package:uuid/uuid.dart';
// import '../widgets/navigate_to.dart';
// import '../widgets/photo.dart';

// class Scale extends StatefulWidget {
//   final String scaleId;
//   final String writerId;
//   final String content;
//   final String renoteedScaleId;
//   final dynamic likes;
//   final String mediaUrl;
//   final String noteId;
//   final List attachedScaleId;
//   final Timestamp timestamp;
//   final bool? dont;
//   final bool? evenMe;
//   final bool isReply;
//   final currentScreen;

//   const Scale({
//     super.key,
//     required this.scaleId,
//     required this.writerId,
//     required this.content,
//     required this.likes,
//     required this.timestamp,
//     required this.mediaUrl,
//     required this.noteId,
//     required this.attachedScaleId,
//     required this.renoteedScaleId,
//     this.dont,
//     this.evenMe,
//     required this.isReply,
//     required this.currentScreen,
//   });

//   @override
//   State<Scale> createState() => _ScaleState();
// }

// class _ScaleState extends State<Scale> {
//   var currentPage;
//   @override
//   void initState() {
//     //increase view count
//     getIfBookmarked();
//     getCommentCount();
//     getReScaleCount();
//     getLikeCount(widget.likes);
//     isLiked = widget.likes[uid] == true;
//     doesReplyExists();
//     super.initState();
//   }

//   String formattedDate(Timestamp timestamp) {
//     final DateFormat formatter = DateFormat('HH:mm · dd.MM.yyyy');
//     final String formatted = formatter.format(timestamp.toDate());
//     return formatted; // something like 2013-04-20
//   }

//   bool bookmarked = false;

//   int likeCount = 0;
//   int commentCount = 0;
//   int reScaleCount = 0;
//   bool isLiked = false;

//   getReScaleCount() {
//     scalesRef
//         .where('renoteedScaleId', isEqualTo: widget.scaleId)
//         .get()
//         .then((doc) {
//       setState(() {
//         reScaleCount = doc.docs.length;
//       });
//     });
//   }

//   getCommentCount() {
//     scalesRef
//         .where("attachedScaleId", arrayContains: widget.scaleId)
//         .get()
//         .then((doc) {
//       if (doc.docs.isNotEmpty) {
//         setState(() {
//           commentCount = doc.docs.length;
//         });
//       }
//     });
//   }

//   getIfBookmarked() {
//     bookmarkRef
//         .doc(uid)
//         .collection('bookmarks')
//         .where('scaleId', isEqualTo: widget.scaleId)
//         .get()
//         .then((doc) {
//       if (doc.docs.isNotEmpty) {
//         setState(() {
//           bookmarked = true;
//         });
//       } else {
//         setState(() {
//           bookmarked = false;
//         });
//       }
//     });
//   }

//   int getLikeCount(Map likes) {
//     // if no likes, return 0
//     // ignore: unnecessary_null_comparison
//     if (likes == null) {
//       return 0;
//     }
//     int count = 0;
//     // if the key is explicitly set to true, add a like
//     for (var val in likes.values) {
//       if (val == true) {
//         count += 1;
//       }
//     }
//     setState(() {
//       likeCount = count;
//     });
//     return count;
//   }

//   bool result = false;
//   List<Widget> subComments = [];
//   doesReplyExists() {
//     if (widget.dont == true && widget.evenMe == true) {
//       setState(() {
//         result = false;
//       });
//     } else if (widget.dont != null) {
//       scalesRef
//           .where('writerId', isEqualTo: uid)
//           .where(
//             'attachedScaleId',
//             arrayContains: widget.scaleId,
//           )
//           .limit(1)
//           .get()
//           .then((doc) {
//         if (doc.docs.isNotEmpty) {
//           setState(() {
//             setState(() {
//               subComments = doc.docs
//                   .map((doc) => Scale(
//                         writerId: doc['writerId'],
//                         content: doc['content'],
//                         likes: doc['likes'],
//                         timestamp: doc['timestamp'],
//                         scaleId: doc['scaleId'],
//                         mediaUrl: doc['mediaUrl'],
//                         noteId: doc['noteId'],
//                         attachedScaleId: doc['attachedScaleId'],
//                         isReply: doc['isReply'],
//                         renoteedScaleId: doc['renoteedScaleId'],
//                         currentScreen: widget.currentScreen,
//                       ))
//                   .toList();
//               result = true;
//             });
//           });
//         } else {
//           setState(() {
//             result = false;
//           });
//         }
//       });
//     } else {
//       scalesRef
//           .where(
//             'attachedScaleId',
//             arrayContains: widget.scaleId,
//           )
//           .limit(1)
//           .get()
//           .then((doc) {
//         if (doc.docs.isNotEmpty) {
//           setState(() {
//             result = true;

//             subComments = doc.docs
//                 .map((doc) => Scale(
//                       writerId: doc['writerId'],
//                       content: doc['content'],
//                       likes: doc['likes'],
//                       timestamp: doc['timestamp'],
//                       scaleId: doc['scaleId'],
//                       mediaUrl: doc['mediaUrl'],
//                       noteId: doc['noteId'],
//                       attachedScaleId: doc['attachedScaleId'],
//                       isReply: doc['isReply'],
//                       renoteedScaleId: doc['renoteedScaleId'],
//                       currentScreen: widget.currentScreen,
//                     ))
//                 .toList();
//           });
//         } else {
//           setState(() {
//             result = false;
//           });
//         }
//       });
//     }
//   }

//   addToBookmarks(String scaleId) {
//     bookmarkRef
//         .doc(uid)
//         .collection('bookmarks')
//         .where('scaleId', isEqualTo: scaleId)
//         .get()
//         .then((doc) {
//       if (doc.docs.isNotEmpty) {
//         bookmarkRef.doc(uid).collection('bookmarks').doc(scaleId).delete();
//         setState(() {
//           bookmarked = false;
//         });
//       } else {
//         bookmarkRef.doc(uid).collection('bookmarks').doc(scaleId).set({
//           "id": scaleId,
//           "noteId": '',
//           "scaleId": scaleId,
//         });
//         setState(() {
//           bookmarked = true;
//         });
//       }
//     });
//   }

//   addToActivityFeed() {
//     String notificationId = Uuid().v4();
//     notificationsRef.doc(uid).collection('activities').doc(notificationId).set({
//       "type": "scaleLike",
//       "uid": uid,
//       "timestamp": DateTime.now(),
//       "notificationId": notificationId,
//       "scaleId": widget.scaleId,
//       "noteId": '',
//     });
//   }

//   handleLikeNote() {
//     bool isliked = widget.likes[uid] == true;
//     if (isliked) {
//       scalesRef.doc(widget.scaleId).update({"likes.$uid": false});
//       // removeLikeFromActivityFeed();
//       setState(() {
//         likeCount -= 1;
//         isLiked = false;
//         widget.likes[uid] = false;
//       });
//     } else if (!isliked) {
//       scalesRef.doc(widget.scaleId).update({"likes.$uid": true});
//       addToActivityFeed();
//       bool isNotNoteOwner = widget.writerId != uid;
//       if (isNotNoteOwner) {}
//       setState(() {
//         likeCount += 1;
//         isLiked = true;
//         widget.likes[uid] = true;
//       });
//     }
//     getLikeCount(widget.likes);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: usersRef.doc(widget.writerId).get(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return loading();
//         }
//         UserModel user = UserModel.fromDocument(snapshot.data!);
//         return Column(
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                   border: Border(
//                       bottom: result
//                           ? const BorderSide()
//                           : BorderSide(width: 1.5, color: Colors.grey[900]!))),
//               child: CupertinoButton(
//                 padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
//                 onPressed: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ScaleDetails(
//                           scaleId: widget.scaleId,
//                           writerId: widget.writerId,
//                           content: widget.content,
//                           likes: widget.likes,
//                           timestamp: widget.timestamp,
//                           noteId: widget.noteId,
//                           mediaUrl: widget.mediaUrl,
//                           attachedScaleId: widget.attachedScaleId,
//                           isReply: widget.isReply,
//                           currentScreen: widget.currentScreen,
//                           renoteedScaleId: widget.renoteedScaleId,
//                         ),
//                       ));
//                 },
//                 child: IntrinsicHeight(
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           CupertinoButton(
//                             onPressed: widget.currentScreen != Account
//                                 ? () {
//                                     Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) => Account(
//                                             profileId: user.id,
//                                           ),
//                                         ));
//                                   }
//                                 : null,
//                             padding: EdgeInsets.zero,
//                             child: CircleAvatar(
//                               radius: 17,
//                               backgroundImage: NetworkImage(user.imageUrl),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 5,
//                           ),
//                           result
//                               ? Flexible(
//                                   child: VerticalDivider(
//                                   color: Colors.grey[850],
//                                   thickness: 2,
//                                 ))
//                               : const SizedBox(),
//                         ],
//                       ),
//                       const SizedBox(
//                         width: 5,
//                       ),
//                       Flexible(
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 GestureDetector(
//                                   onTap: widget.currentScreen != Account
//                                       ? () {
//                                           Navigator.push(
//                                               context,
//                                               MaterialPageRoute(
//                                                 builder: (context) => Account(
//                                                   profileId: user.id,
//                                                 ),
//                                               ));
//                                         }
//                                       : null,
//                                   child: Row(
//                                     children: [
//                                       Text(
//                                         user.username,
//                                         style: TextStyle(
//                                             color: Colors.grey[300],
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                       user.isVerified || user.isDeveloper
//                                           ? Row(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 const SizedBox(
//                                                   width: 5,
//                                                 ),
//                                                 Text(
//                                                   String.fromCharCode(
//                                                       CupertinoIcons
//                                                           .checkmark_seal_fill
//                                                           .codePoint),
//                                                   style: TextStyle(
//                                                     inherit: false,
//                                                     color: user.isDeveloper &&
//                                                             user.isVerified
//                                                         ? kThemeColor
//                                                         : Colors.blue,
//                                                     fontSize: 15.0,
//                                                     fontWeight: FontWeight.w900,
//                                                     fontFamily: CupertinoIcons
//                                                         .heart.fontFamily,
//                                                     package: CupertinoIcons
//                                                         .heart.fontPackage,
//                                                   ),
//                                                 ),
//                                               ],
//                                             )
//                                           : const SizedBox(),
//                                       const SizedBox(
//                                         width: 10,
//                                       ),
//                                       Text(
                                        // timeago.format(
                                        //   widget.timestamp.toDate(),
                                        // ),
//                                         style: TextStyle(
//                                             color: Colors.grey[600],
//                                             fontWeight: FontWeight.w500,
//                                             fontSize: 12),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.only(right: 15.0),
//                                   child: GestureDetector(
//                                       child: const Icon(
//                                         CupertinoIcons.ellipsis,
//                                         color: Colors.grey,
//                                       ),
//                                       onTap: () {
//                                         showCupertinoModalPopup(
//                                           context: context,
//                                           builder: (context) => CupertinoTheme(
//                                             data: const CupertinoThemeData(
//                                                 brightness: Brightness.dark),
//                                             child: CupertinoActionSheet(
//                                               cancelButton:
//                                                   CupertinoActionSheetAction(
//                                                       onPressed: () {
//                                                         Get.back();
//                                                       },
//                                                       child: const Text(
//                                                         "Back",
//                                                         style: TextStyle(
//                                                             color: Colors.blue),
//                                                       )),
//                                               actions: [
//                                                 CupertinoActionSheetAction(
//                                                     onPressed: () {
//                                                       scalesRef
//                                                           .doc(widget.scaleId)
//                                                           .delete();
//                                                       //delete bookmarks
//                                                       usersRef
//                                                           .get()
//                                                           .then((list) {
//                                                         for (var element
//                                                             in list.docs) {
//                                                           bookmarkRef
//                                                               .doc(element
//                                                                   .data()['id'])
//                                                               .collection(
//                                                                   'bookmarks')
//                                                               .where('scaleId',
//                                                                   isEqualTo: widget
//                                                                       .scaleId)
//                                                               .get()
//                                                               .then((doc) {
//                                                             doc.docs.forEach(
//                                                                 (element) {
//                                                               element.reference
//                                                                   .delete();
//                                                             });
//                                                           });
//                                                         }
//                                                       });
//                                                       Get.back();
//                                                     },
//                                                     child: const Text(
//                                                       "Delete",
//                                                       style: TextStyle(
//                                                           color: kThemeColor),
//                                                     ))
//                                               ],
//                                             ),
//                                           ),
//                                         );
//                                       }),
//                                 ),
//                               ],
//                             ),
//                             Text(
//                               widget.content,
//                               style: TextStyle(
//                                   color: Colors.grey[350],
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w500),
//                             ),
//                             const SizedBox(
//                               height: 10,
//                             ),
//                             widget.renoteedScaleId.isEmpty
//                                 ? const SizedBox()
//                                 : FutureBuilder(
//                                     future: scalesRef
//                                         .doc(widget.renoteedScaleId)
//                                         .get(),
//                                     builder: (context, snapshot) {
//                                       if (!snapshot.hasData) {
//                                         return loading();
//                                       }

//                                       return FutureBuilder(
//                                           future: usersRef
//                                               .doc(snapshot.data!
//                                                   .data()!['writerId'])
//                                               .get(),
//                                           builder: (context, writerSnapshot) {
//                                             if (!writerSnapshot.hasData) {
//                                               return loading();
//                                             }
//                                             UserModel writer =
//                                                 UserModel.fromDocument(
//                                                     writerSnapshot.data!);
//                                             final documentSnapshot =
//                                                 snapshot.data!.data()!;
//                                             return CupertinoButton(
//                                               padding: EdgeInsets.zero,
//                                               onPressed: () {
//                                                 Get.to(
//                                                   () => ScaleDetails(
//                                                     currentScreen: NewScale,
//                                                     renoteedScaleId:
//                                                         documentSnapshot[
//                                                             'renoteedScaleId'],
//                                                     isReply: documentSnapshot[
//                                                         'isReply'],
//                                                     attachedScaleId:
//                                                         documentSnapshot[
//                                                             'attachedScaleId'],
//                                                     mediaUrl: documentSnapshot[
//                                                         'mediaUrl'],
//                                                     scaleId: documentSnapshot[
//                                                         'scaleId'],
//                                                     focus: false,
//                                                     noteId: documentSnapshot[
//                                                         'noteId'],
//                                                     content: documentSnapshot[
//                                                         'content'],
//                                                     writerId: documentSnapshot[
//                                                         'writerId'],
//                                                     timestamp: documentSnapshot[
//                                                         'timestamp'],
//                                                     likes: documentSnapshot[
//                                                         'likes'],
//                                                   ),
//                                                 );
//                                               },
//                                               child: Container(
//                                                 margin: const EdgeInsets.only(
//                                                     right: 20),
//                                                 decoration: BoxDecoration(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             15),
//                                                     border: Border.all(
//                                                         width: 1.5,
//                                                         color:
//                                                             Colors.grey[900]!)),
//                                                 child: CupertinoButton(
//                                                   padding: EdgeInsets.zero,
//                                                   onPressed: () {
//                                                     Navigator.push(
//                                                         context,
//                                                         MaterialPageRoute(
//                                                           builder: (context) =>
//                                                               ScaleDetails(
//                                                             renoteedScaleId:
//                                                                 documentSnapshot[
//                                                                     'renoteedScaleId'],
//                                                             currentScreen:
//                                                                 NewScale,
//                                                             isReply:
//                                                                 documentSnapshot[
//                                                                     'isReply'],
//                                                             attachedScaleId:
//                                                                 documentSnapshot[
//                                                                     'attachedScaleId'],
//                                                             mediaUrl:
//                                                                 documentSnapshot[
//                                                                     'mediaUrl'],
//                                                             scaleId:
//                                                                 documentSnapshot[
//                                                                     'scaleId'],
//                                                             focus: false,
//                                                             noteId:
//                                                                 documentSnapshot[
//                                                                     'noteId'],
//                                                             content:
//                                                                 documentSnapshot[
//                                                                     'content'],
//                                                             writerId:
//                                                                 documentSnapshot[
//                                                                     'writerId'],
//                                                             timestamp:
//                                                                 documentSnapshot[
//                                                                     'timestamp'],
//                                                             likes:
//                                                                 documentSnapshot[
//                                                                     'likes'],
//                                                           ),
//                                                         ));
//                                                   },
//                                                   child: Column(
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .start,
//                                                     children: [
//                                                       Row(
//                                                         children: [
//                                                           CupertinoButton(
//                                                             onPressed: () {
//                                                               Navigator.push(
//                                                                   context,
//                                                                   MaterialPageRoute(
//                                                                     builder:
//                                                                         (context) =>
//                                                                             Account(
//                                                                       profileId:
//                                                                           writer
//                                                                               .id,
//                                                                     ),
//                                                                   ));
//                                                             },
//                                                             padding:
//                                                                 EdgeInsets.zero,
//                                                             child: CircleAvatar(
//                                                               radius: 12,
//                                                               backgroundImage:
//                                                                   NetworkImage(
//                                                                       writer
//                                                                           .imageUrl),
//                                                             ),
//                                                           ),
//                                                           GestureDetector(
//                                                             onTap: () {
//                                                               Navigator.push(
//                                                                   context,
//                                                                   MaterialPageRoute(
//                                                                     builder:
//                                                                         (context) =>
//                                                                             Account(
//                                                                       profileId:
//                                                                           writer
//                                                                               .id,
//                                                                     ),
//                                                                   ));
//                                                             },
//                                                             child: Row(
//                                                               children: [
//                                                                 Text(
//                                                                   writer
//                                                                       .username,
//                                                                   style: TextStyle(
//                                                                       color: Colors
//                                                                               .grey[
//                                                                           300],
//                                                                       fontSize:
//                                                                           16,
//                                                                       fontWeight:
//                                                                           FontWeight
//                                                                               .bold),
//                                                                 ),
//                                                                 writer.isVerified ||
//                                                                         writer
//                                                                             .isDeveloper
//                                                                     ? Row(
//                                                                         crossAxisAlignment:
//                                                                             CrossAxisAlignment.start,
//                                                                         children: [
//                                                                           const SizedBox(
//                                                                             width:
//                                                                                 5,
//                                                                           ),
//                                                                           Text(
//                                                                             String.fromCharCode(CupertinoIcons.checkmark_seal_fill.codePoint),
//                                                                             style:
//                                                                                 TextStyle(
//                                                                               inherit: false,
//                                                                               color: writer.isDeveloper && writer.isVerified ? kThemeColor : Colors.blue,
//                                                                               fontSize: 15.0,
//                                                                               fontWeight: FontWeight.w900,
//                                                                               fontFamily: CupertinoIcons.heart.fontFamily,
//                                                                               package: CupertinoIcons.heart.fontPackage,
//                                                                             ),
//                                                                           ),
//                                                                           const SizedBox(
//                                                                             width:
//                                                                                 10,
//                                                                           ),
//                                                                           Text(
//                                                                             timeago.format(
//                                                                               documentSnapshot['timestamp'].toDate(),
//                                                                             ),
//                                                                             style: TextStyle(
//                                                                                 color: Colors.grey[600],
//                                                                                 fontWeight: FontWeight.w500,
//                                                                                 fontSize: 12),
//                                                                           ),
//                                                                         ],
//                                                                       )
//                                                                     : const SizedBox(),
//                                                               ],
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                       Padding(
//                                                         padding:
//                                                             const EdgeInsets
//                                                                     .only(
//                                                                 left: 8.0,
//                                                                 right: 15),
//                                                         child: Text(
//                                                           documentSnapshot[
//                                                               'content'],
//                                                           style: TextStyle(
//                                                               color: Colors
//                                                                   .grey[350],
//                                                               fontSize: 16,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .w500),
//                                                         ),
//                                                       ),
//                                                       const SizedBox(
//                                                         height: 7,
//                                                       ),
//                                                       documentSnapshot['noteId']
//                                                               .isEmpty
//                                                           ? const SizedBox()
//                                                           : FutureBuilder(
//                                                               future: exploreRef
//                                                                   .doc(documentSnapshot[
//                                                                       'noteId'])
//                                                                   .get(),
//                                                               builder: (context,
//                                                                   snapshot) {
//                                                                 if (!snapshot
//                                                                     .hasData) {
//                                                                   return loading();
//                                                                 }

//                                                                 return FutureBuilder(
//                                                                     future: usersRef
//                                                                         .doc(snapshot.data!.data()![
//                                                                             'writerId'])
//                                                                         .get(),
//                                                                     builder:
//                                                                         (context,
//                                                                             writerSnapshot) {
//                                                                       if (!writerSnapshot
//                                                                           .hasData) {
//                                                                         return loading();
//                                                                       }
//                                                                       UserModel
//                                                                           writer =
//                                                                           UserModel.fromDocument(
//                                                                               writerSnapshot.data!);
//                                                                       return Column(
//                                                                         crossAxisAlignment:
//                                                                             CrossAxisAlignment.start,
//                                                                         children: [
//                                                                           CupertinoButton(
//                                                                             padding:
//                                                                                 EdgeInsets.zero,
//                                                                             onPressed:
//                                                                                 () {
//                                                                               final documentSnapshot = snapshot.data!.data()!;
//                                                                               Get.to(
//                                                                                 () => NoteDetailsMobile(
//                                                                                   previousPageTitle: '',
//                                                                                   noteId: documentSnapshot['noteId'],
//                                                                                   title: documentSnapshot['title'],
//                                                                                   thumbnailUrl: documentSnapshot['thumbnailUrl'],
//                                                                                   content: documentSnapshot['content'],
//                                                                                   writerId: documentSnapshot['writerId'],
//                                                                                   timestamp: documentSnapshot['timestamp'],
//                                                                                   views: documentSnapshot['views'],
//                                                                                   likes: documentSnapshot['likes'],
//                                                                                 ),
//                                                                               );
//                                                                             },
//                                                                             child:
//                                                                                 Container(
//                                                                               height: 100,
//                                                                               margin: const EdgeInsets.only(
//                                                                                 top: 4,
//                                                                               ),
//                                                                               decoration: BoxDecoration(
//                                                                                 borderRadius: documentSnapshot['mediaUrl'].isEmpty ? const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)) : null,
//                                                                                 color: kDarkGreyColor,
//                                                                                 border: documentSnapshot['mediaUrl'].isEmpty ? null : Border(top: BorderSide(width: 1, color: Colors.grey[900]!), right: BorderSide(width: 1, color: Colors.grey[900]!), left: BorderSide(width: 1, color: Colors.grey[900]!)),
//                                                                               ),
//                                                                               child: Row(
//                                                                                 mainAxisAlignment: MainAxisAlignment.start,
//                                                                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                                                                 children: [
//                                                                                   Expanded(
//                                                                                     child: Padding(
//                                                                                       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                                                                                       child: Column(
//                                                                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                                                                         children: [
//                                                                                           Row(
//                                                                                             children: [
//                                                                                               ClipRRect(
//                                                                                                 borderRadius: BorderRadius.circular(5),
//                                                                                                 child: Image.network(
//                                                                                                   writer.imageUrl,
//                                                                                                   height: 25,
//                                                                                                   width: 25,
//                                                                                                   fit: BoxFit.cover,
//                                                                                                 ),
//                                                                                               ),
//                                                                                               const SizedBox(
//                                                                                                 width: 5,
//                                                                                               ),
//                                                                                               Text(
//                                                                                                 writer.username,
//                                                                                                 style: TextStyle(
//                                                                                                   color: Colors.grey[350],
//                                                                                                   fontWeight: FontWeight.w500,
//                                                                                                 ),
//                                                                                               ),
//                                                                                               writer.isVerified || writer.isDeveloper
//                                                                                                   ? Row(
//                                                                                                       children: [
//                                                                                                         const SizedBox(
//                                                                                                           width: 5,
//                                                                                                         ),
//                                                                                                         Text(
//                                                                                                           String.fromCharCode(CupertinoIcons.checkmark_seal_fill.codePoint),
//                                                                                                           style: TextStyle(
//                                                                                                             inherit: false,
//                                                                                                             color: writer.isDeveloper && writer.isVerified ? kThemeColor : Colors.blue,
//                                                                                                             fontSize: 15.0,
//                                                                                                             fontWeight: FontWeight.w900,
//                                                                                                             fontFamily: CupertinoIcons.heart.fontFamily,
//                                                                                                             package: CupertinoIcons.heart.fontPackage,
//                                                                                                           ),
//                                                                                                         ),
//                                                                                                       ],
//                                                                                                     )
//                                                                                                   : const SizedBox(),
//                                                                                             ],
//                                                                                           ),
//                                                                                           const SizedBox(
//                                                                                             height: 5,
//                                                                                           ),
//                                                                                           Row(
//                                                                                             mainAxisSize: MainAxisSize.min,
//                                                                                             children: [
//                                                                                               Expanded(
//                                                                                                 child: Text(
//                                                                                                   snapshot.data!.data()!['title'],
//                                                                                                   overflow: TextOverflow.ellipsis,
//                                                                                                   style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
//                                                                                                   maxLines: 1,
//                                                                                                 ),
//                                                                                               ),
//                                                                                             ],
//                                                                                           ),
//                                                                                           const SizedBox(
//                                                                                             height: 5,
//                                                                                           ),
//                                                                                           Row(
//                                                                                             mainAxisSize: MainAxisSize.min,
//                                                                                             children: [
//                                                                                               Expanded(
//                                                                                                 child: Text(
//                                                                                                   snapshot.data!.data()!['content'],
//                                                                                                   style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 14),
//                                                                                                   maxLines: 1,
//                                                                                                   overflow: TextOverflow.ellipsis,
//                                                                                                 ),
//                                                                                               ),
//                                                                                             ],
//                                                                                           ),
//                                                                                           const SizedBox(
//                                                                                             height: 5,
//                                                                                           ),
//                                                                                         ],
//                                                                                       ),
//                                                                                     ),
//                                                                                   ),
//                                                                                   const SizedBox(
//                                                                                     width: 20,
//                                                                                   ),
//                                                                                   ClipRRect(
//                                                                                     borderRadius: documentSnapshot['mediaUrl'].isEmpty ? const BorderRadius.only(bottomRight: Radius.circular(15)) : BorderRadius.circular(0),
//                                                                                     child: Image.network(
//                                                                                       snapshot.data!.data()!['thumbnailUrl'],
//                                                                                       height: 100,
//                                                                                       width: 100,
//                                                                                       fit: BoxFit.cover,
//                                                                                     ),
//                                                                                   ),
//                                                                                 ],
//                                                                               ),
//                                                                             ),
//                                                                           ),
//                                                                         ],
//                                                                       );
//                                                                     });
//                                                               }),
//                                                       snapshot.data!
//                                                               .data()![
//                                                                   'mediaUrl']
//                                                               .isEmpty
//                                                           ? const SizedBox()
//                                                           : Row(
//                                                               mainAxisSize:
//                                                                   MainAxisSize
//                                                                       .min,
//                                                               children: [
//                                                                 Expanded(
//                                                                   child:
//                                                                       Container(
//                                                                     decoration: BoxDecoration(
//                                                                         borderRadius: const BorderRadius.only(
//                                                                             bottomLeft: Radius.circular(
//                                                                                 15),
//                                                                             bottomRight: Radius.circular(
//                                                                                 15)),
//                                                                         border: Border.all(
//                                                                             width:
//                                                                                 1,
//                                                                             color:
//                                                                                 Colors.grey[900]!)),
//                                                                     child:
//                                                                         GestureDetector(
//                                                                       onTap:
//                                                                           () {
//                                                                         Get.to(() =>
//                                                                             Photo(
//                                                                               mediaUrl: snapshot.data!.data()!['mediaUrl'],
//                                                                             ));
//                                                                       },
//                                                                       child: ClipRRect(
//                                                                           borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
//                                                                           child: Image.network(
//                                                                             snapshot.data!.data()!['mediaUrl'],
//                                                                             fit:
//                                                                                 BoxFit.cover,
//                                                                           )),
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                               ],
//                                                             ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                             );
//                                           });
//                                     }),
//                             widget.noteId.isEmpty
//                                 ? const SizedBox()
//                                 : FutureBuilder(
//                                     future: exploreRef.doc(widget.noteId).get(),
//                                     builder: (context, snapshot) {
//                                       if (!snapshot.hasData) {
//                                         return loading();
//                                       }

//                                       return FutureBuilder(
//                                           future: usersRef
//                                               .doc(snapshot.data!
//                                                   .data()!['writerId'])
//                                               .get(),
//                                           builder: (context, writerSnapshot) {
//                                             if (!writerSnapshot.hasData) {
//                                               return loading();
//                                             }
//                                             UserModel writer =
//                                                 UserModel.fromDocument(
//                                                     writerSnapshot.data!);
//                                             return Column(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 CupertinoButton(
//                                                   padding: EdgeInsets.zero,
//                                                   onPressed: () {
//                                                     final documentSnapshot =
//                                                         snapshot.data!.data()!;
//                                                     Get.to(
//                                                       () => NoteDetailsMobile(
//                                                         previousPageTitle: '',
//                                                         noteId:
//                                                             documentSnapshot[
//                                                                 'noteId'],
//                                                         title: documentSnapshot[
//                                                             'title'],
//                                                         thumbnailUrl:
//                                                             documentSnapshot[
//                                                                 'thumbnailUrl'],
//                                                         content:
//                                                             documentSnapshot[
//                                                                 'content'],
//                                                         writerId:
//                                                             documentSnapshot[
//                                                                 'writerId'],
//                                                         timestamp:
//                                                             documentSnapshot[
//                                                                 'timestamp'],
//                                                         views: documentSnapshot[
//                                                             'views'],
//                                                         likes: documentSnapshot[
//                                                             'likes'],
//                                                       ),
//                                                     );
//                                                   },
//                                                   child: Container(
//                                                     height: 100,
//                                                     margin:
//                                                         const EdgeInsets.only(
//                                                             right: 20,
//                                                             top: 4,
//                                                             left: 0),
//                                                     decoration: BoxDecoration(
//                                                         color: kDarkGreyColor,
//                                                         border: Border.all(
//                                                             width: 2,
//                                                             color: Colors
//                                                                 .grey[900]!),
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(20)),
//                                                     child: Row(
//                                                       mainAxisAlignment:
//                                                           MainAxisAlignment
//                                                               .start,
//                                                       crossAxisAlignment:
//                                                           CrossAxisAlignment
//                                                               .start,
//                                                       children: [
//                                                         Expanded(
//                                                           child: Padding(
//                                                             padding:
//                                                                 const EdgeInsets
//                                                                         .symmetric(
//                                                                     horizontal:
//                                                                         10,
//                                                                     vertical:
//                                                                         10),
//                                                             child: Column(
//                                                               crossAxisAlignment:
//                                                                   CrossAxisAlignment
//                                                                       .start,
//                                                               children: [
//                                                                 Row(
//                                                                   children: [
//                                                                     ClipRRect(
//                                                                       borderRadius:
//                                                                           BorderRadius.circular(
//                                                                               5),
//                                                                       child: Image
//                                                                           .network(
//                                                                         writer
//                                                                             .imageUrl,
//                                                                         height:
//                                                                             25,
//                                                                         width:
//                                                                             25,
//                                                                         fit: BoxFit
//                                                                             .cover,
//                                                                       ),
//                                                                     ),
//                                                                     const SizedBox(
//                                                                       width: 5,
//                                                                     ),
//                                                                     Text(
//                                                                       writer
//                                                                           .username,
//                                                                       style:
//                                                                           TextStyle(
//                                                                         color: Colors
//                                                                             .grey[350],
//                                                                         fontWeight:
//                                                                             FontWeight.w500,
//                                                                       ),
//                                                                     ),
//                                                                     writer.isVerified ||
//                                                                             writer.isDeveloper
//                                                                         ? Row(
//                                                                             children: [
//                                                                               const SizedBox(
//                                                                                 width: 5,
//                                                                               ),
//                                                                               Text(
//                                                                                 String.fromCharCode(CupertinoIcons.checkmark_seal_fill.codePoint),
//                                                                                 style: TextStyle(
//                                                                                   inherit: false,
//                                                                                   color: writer.isDeveloper && writer.isVerified ? kThemeColor : Colors.blue,
//                                                                                   fontSize: 15.0,
//                                                                                   fontWeight: FontWeight.w900,
//                                                                                   fontFamily: CupertinoIcons.heart.fontFamily,
//                                                                                   package: CupertinoIcons.heart.fontPackage,
//                                                                                 ),
//                                                                               ),
//                                                                             ],
//                                                                           )
//                                                                         : const SizedBox(),
//                                                                   ],
//                                                                 ),
//                                                                 const SizedBox(
//                                                                   height: 5,
//                                                                 ),
//                                                                 Row(
//                                                                   mainAxisSize:
//                                                                       MainAxisSize
//                                                                           .min,
//                                                                   children: [
//                                                                     Expanded(
//                                                                       child:
//                                                                           Text(
//                                                                         snapshot
//                                                                             .data!
//                                                                             .data()!['title'],
//                                                                         overflow:
//                                                                             TextOverflow.ellipsis,
//                                                                         style: const TextStyle(
//                                                                             color:
//                                                                                 Colors.white,
//                                                                             fontWeight: FontWeight.bold,
//                                                                             fontSize: 16),
//                                                                         maxLines:
//                                                                             1,
//                                                                       ),
//                                                                     ),
//                                                                   ],
//                                                                 ),
//                                                                 const SizedBox(
//                                                                   height: 5,
//                                                                 ),
//                                                                 Row(
//                                                                   mainAxisSize:
//                                                                       MainAxisSize
//                                                                           .min,
//                                                                   children: [
//                                                                     Expanded(
//                                                                       child:
//                                                                           Text(
//                                                                         snapshot
//                                                                             .data!
//                                                                             .data()!['content'],
//                                                                         style: const TextStyle(
//                                                                             color:
//                                                                                 Colors.grey,
//                                                                             fontWeight: FontWeight.bold,
//                                                                             fontSize: 14),
//                                                                         maxLines:
//                                                                             1,
//                                                                         overflow:
//                                                                             TextOverflow.ellipsis,
//                                                                       ),
//                                                                     ),
//                                                                   ],
//                                                                 ),
//                                                                 const SizedBox(
//                                                                   height: 5,
//                                                                 ),
//                                                               ],
//                                                             ),
//                                                           ),
//                                                         ),
//                                                         const SizedBox(
//                                                           width: 20,
//                                                         ),
//                                                         ClipRRect(
//                                                           borderRadius:
//                                                               const BorderRadius
//                                                                       .only(
//                                                                   topRight: Radius
//                                                                       .circular(
//                                                                           18),
//                                                                   bottomRight:
//                                                                       Radius.circular(
//                                                                           18)),
//                                                           child: Image.network(
//                                                             snapshot.data!
//                                                                     .data()![
//                                                                 'thumbnailUrl'],
//                                                             height: 100,
//                                                             width: 100,
//                                                             fit: BoxFit.cover,
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ],
//                                             );
//                                           });
//                                     }),
//                             widget.mediaUrl.isEmpty
//                                 ? const SizedBox()
//                                 : Column(
//                                     children: [
//                                       const SizedBox(
//                                         height: 8,
//                                       ),
//                                       Row(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           Expanded(
//                                             child: Container(
//                                               decoration: BoxDecoration(
//                                                   borderRadius:
//                                                       BorderRadius.circular(15),
//                                                   border: Border.all(
//                                                       width: 1,
//                                                       color:
//                                                           Colors.grey[900]!)),
//                                               child: GestureDetector(
//                                                 onTap: () {
//                                                   Get.to(() => Photo(
//                                                       mediaUrl:
//                                                           widget.mediaUrl));
//                                                 },
//                                                 child: ClipRRect(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             15),
//                                                     child: Image.network(
//                                                       widget.mediaUrl,
//                                                       fit: BoxFit.cover,
//                                                     )),
//                                               ),
//                                             ),
//                                           ),
//                                           const SizedBox(
//                                             width: 20,
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
                                // LikeButton(
                                //   countBuilder: (likeCount, isLiked, text) {
                                //     return Text(
                                //       likeCount != 0 ? text : '',
                                //       style: TextStyle(color: Colors.grey[500]),
                                //     );
                                //   },
                                //   onTap: (isLiked) async {
                                //     handleLikeNote();
                                //     return !isLiked;
                                //   },
                                //   likeBuilder: (isLiked) {
                                //     return Icon(
                                //       isLiked
                                //           ? CupertinoIcons.heart_fill
                                //           : CupertinoIcons.heart,
                                //       color: isLiked
                                //           ? kThemeColor
                                //           : Colors.grey[600],
                                //       size: 19,
                                //     );
                                //   },
                                //   size: 19,
                                //   isLiked: isLiked,
                                //   likeCount: likeCount,
                                // ),
//                                 LikeButton(
//                                   size: 19,
//                                   animationDuration: const Duration(),
//                                   padding: EdgeInsets.zero,
//                                   onTap: (isLiked) async {
//                                     myNavigator(
//                                         ScaleDetails(
//                                           scaleId: widget.scaleId,
//                                           writerId: widget.writerId,
//                                           content: widget.content,
//                                           likes: widget.likes,
//                                           timestamp: widget.timestamp,
//                                           noteId: widget.noteId,
//                                           mediaUrl: widget.mediaUrl,
//                                           attachedScaleId:
//                                               widget.attachedScaleId,
//                                           isReply: widget.isReply,
//                                           focus: true,
//                                           currentScreen: widget.currentScreen,
//                                           renoteedScaleId:
//                                               widget.renoteedScaleId,
//                                         ),
//                                         context);
//                                     return isLiked;
//                                   },
//                                   likeBuilder: (isLiked) {
//                                     return SvgPicture.asset(
//                                       'assets/comment.svg',
//                                       color: Colors.grey[600],
//                                     );
//                                   },
//                                   countBuilder: (likeCount, isLiked, text) {
//                                     return Padding(
//                                       padding: const EdgeInsets.only(left: 6.0),
//                                       child: Text(
//                                         likeCount != 0 ? text : '',
//                                         style:
//                                             TextStyle(color: Colors.grey[500]),
//                                       ),
//                                     );
//                                   },
//                                   likeCount: commentCount,
//                                 ),
//                                 LikeButton(
//                                   countBuilder: (likeCount, isLiked, text) {
//                                     return Padding(
//                                       padding: const EdgeInsets.only(left: 6.0),
//                                       child: Text(
//                                         likeCount != 0 ? text : '',
//                                         style:
//                                             TextStyle(color: Colors.grey[500]),
//                                       ),
//                                     );
//                                   },
//                                   size: 18,
//                                   padding: EdgeInsets.zero,
//                                   likeBuilder: (isLiked) {
//                                     return SvgPicture.asset(
//                                       "assets/retweet.svg",
//                                       color: Colors.grey[600],
//                                     );
//                                   },
//                                   onTap: (isLiked) async {
//                                     Get.to(
//                                         () => NewScale(
//                                             noteId: '',
//                                             scaleId: widget.scaleId),
//                                         transition: Transition.downToUp);
//                                   },
//                                   likeCount: reScaleCount,
//                                 ),
//                                 LikeButton(
//                                   countBuilder: (likeCount, isLiked, text) =>
//                                       const SizedBox(),
//                                   onTap: (isLiked) async {
//                                     addToBookmarks(widget.scaleId);
//                                     return bookmarked;
//                                   },
//                                   likeBuilder: (isLiked) {
//                                     return Center(
//                                       child: Text(
//                                         String.fromCharCode(isLiked
//                                             ? CupertinoIcons
//                                                 .bookmark_fill.codePoint
//                                             : CupertinoIcons
//                                                 .bookmark.codePoint),
//                                         style: TextStyle(
//                                           inherit: false,
//                                           color: isLiked
//                                               ? kThemeColor
//                                               : Colors.grey[600],
//                                           fontSize: 17.0,
//                                           fontWeight: FontWeight.w600,
//                                           fontFamily:
//                                               CupertinoIcons.share.fontFamily,
//                                           package:
//                                               CupertinoIcons.share.fontPackage,
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                   isLiked: bookmarked,
//                                   likeCount: 0,
//                                 ),
//                                 CupertinoButton(
//                                     padding: EdgeInsets.zero,
//                                     child: Text(
//                                       String.fromCharCode(
//                                           UniconsLine.upload.codePoint),
//                                       style: TextStyle(
//                                         inherit: false,
//                                         color: Colors.grey[600],
//                                         fontSize: 17.0,
//                                         fontWeight: FontWeight.w900,
//                                         fontFamily:
//                                             UniconsLine.share.fontFamily,
//                                         package: UniconsLine.share.fontPackage,
//                                       ),
//                                     ),
//                                     onPressed: () {}),
//                               ],
//                             )
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Column(
//                   children: subComments,
//                 ),
//               ],
//             )
//           ],
//         );
//       },
//     );
//   }
// }

// class ScaleDetails extends StatefulWidget {
//   final String scaleId;
//   final String writerId;
//   final String content;
//   final dynamic likes;
//   final Timestamp timestamp;
//   final String mediaUrl;
//   final String noteId;
//   final List attachedScaleId;
//   final bool isReply;
//   final bool? focus;
//   final String renoteedScaleId;
//   final currentScreen;
//   const ScaleDetails({
//     super.key,
//     required this.scaleId,
//     required this.writerId,
//     required this.content,
//     required this.likes,
//     required this.timestamp,
//     required this.mediaUrl,
//     required this.noteId,
//     required this.attachedScaleId,
//     required this.isReply,
//     this.focus,
//     required this.currentScreen,
//     required this.renoteedScaleId,
//   });

//   @override
//   State<ScaleDetails> createState() => _ScaleDetailsState();
// }

// class _ScaleDetailsState extends State<ScaleDetails> {
//   FocusNode focusNode = FocusNode();
//   TextEditingController commentTextController = TextEditingController();
//   @override
//   void initState() {
//     getCommentCount();
//     getIfBookmarked();
//     getReScaleCount();
//     if (widget.focus != null && widget.focus == true) {
//       setState(() {
//         focusNode.requestFocus();
//       });
//     }
//     //increase view count
//     fetchData();
//     getLikeCount(widget.likes);
//     isLiked = widget.likes[uid] == true;
//     super.initState();
//   }

//   getReScaleCount() {
//     scalesRef
//         .where('renoteedScaleId', isEqualTo: widget.scaleId)
//         .get()
//         .then((doc) {
//       setState(() {
//         reScaleCount = doc.docs.length;
//       });
//     });
//   }

//   getCommentCount() {
//     scalesRef
//         .where("attachedScaleId", arrayContains: widget.scaleId)
//         .get()
//         .then((doc) {
//       if (doc.docs.isNotEmpty) {
//         setState(() {
//           commentCount = doc.docs.length;
//         });
//       }
//     });
//   }

//   getIfBookmarked() {
//     bookmarkRef
//         .doc(uid)
//         .collection('bookmarks')
//         .where('scaleId', isEqualTo: widget.scaleId)
//         .get()
//         .then((doc) {
//       if (doc.docs.isNotEmpty) {
//         setState(() {
//           bookmarked = true;
//         });
//       } else {
//         setState(() {
//           bookmarked = false;
//         });
//       }
//     });
//   }

//   bool bookmarked = false;

//   int likeCount = 0;
//   int commentCount = 0;
//   int reScaleCount = 0;
//   bool isLoading = false;
//   List<Widget> comments = [];
//   void fetchData() async {
//     setState(() {
//       isLoading = true;
//     });

//     QuerySnapshot scaleSnapshot = await scalesRef
//         .orderBy('timestamp', descending: false)
//         .where('attachedScaleId', arrayContains: widget.scaleId)
//         .get();
//     setState(() {
//       comments = scaleSnapshot.docs
//           .map((doc) => Scale(
//                 writerId: doc['writerId'],
//                 content: doc['content'],
//                 likes: doc['likes'],
//                 timestamp: doc['timestamp'],
//                 scaleId: doc['scaleId'],
//                 mediaUrl: doc['mediaUrl'],
//                 noteId: doc['noteId'],
//                 attachedScaleId: doc['attachedScaleId'],
//                 isReply: doc['isReply'],
//                 renoteedScaleId: doc['renoteedScaleId'],
//                 currentScreen: widget.currentScreen,
//               ))
//           .toList();
//       isLoading = false;
//     });
//   }

  // String formattedDate(Timestamp timestamp) {
  //   final DateFormat formatter = DateFormat('HH:mm · dd.MM.yyyy');
  //   final String formatted = formatter.format(timestamp.toDate());
  //   return formatted; // something like 2013-04-20
  // }

//   bool isLiked = false;

//   int getLikeCount(Map likes) {
//     // if no likes, return 0
//     // ignore: unnecessary_null_comparison
//     if (likes == null) {
//       return 0;
//     }
//     int count = 0;
//     // if the key is explicitly set to true, add a like
//     for (var val in likes.values) {
//       if (val == true) {
//         count += 1;
//       }
//     }
//     setState(() {
//       likeCount = count;
//     });
//     return count;
//   }

//   addToBookmarks(String scaleId) {
//     bookmarkRef
//         .doc(uid)
//         .collection('bookmarks')
//         .where('scaleId', isEqualTo: scaleId)
//         .get()
//         .then((doc) {
//       if (doc.docs.isNotEmpty) {
//         bookmarkRef.doc(uid).collection('bookmarks').doc(scaleId).delete();
//         setState(() {
//           bookmarked = false;
//         });
//       } else {
//         bookmarkRef.doc(uid).collection('bookmarks').doc(scaleId).set({
//           "id": scaleId,
//           "noteId": '',
//           "scaleId": scaleId,
//         });
//         setState(() {
//           bookmarked = true;
//         });
//       }
//     });
//   }

//   handleLikeNote() {
//     bool isliked = widget.likes[uid] == true;
//     if (isliked) {
//       scalesRef.doc(widget.scaleId).update({"likes.$uid": false});
//       // removeLikeFromActivityFeed();
//       setState(() {
//         likeCount -= 1;
//         isLiked = false;
//         widget.likes[uid] = false;
//       });
//     } else if (!isliked) {
//       scalesRef.doc(widget.scaleId).update({"likes.$uid": true});
//       // addToActivityFeed();
//       bool isNotNoteOwner = widget.writerId != uid;
//       if (isNotNoteOwner) {}
//       setState(() {
//         likeCount += 1;
//         isLiked = true;
//         widget.likes[uid] = true;
//       });
//     }
//     getLikeCount(widget.likes);
//   }

//   addToActivityFeed() {
//     String notificationId = Uuid().v4();
//     notificationsRef
//         .doc(widget.writerId)
//         .collection('activities')
//         .doc(notificationId)
//         .set({
//       "type": "scaleComment",
//       "uid": uid,
//       "timestamp": DateTime.now(),
//       "notificationId": notificationId,
//       "scaleId": widget.scaleId,
//       "noteId": '',
//     });
//   }

//   addComment() {
//     String scaleId = const Uuid().v4();
//     if (commentTextController.text.isNotEmpty) {
//       // if (isNotNoteOwner) {}

//       scalesRef.doc(scaleId).set({
//         "scaleId": scaleId,
//         "writerId": uid,
//         "content": commentTextController.text,
//         "timestamp": DateTime.now(),
//         "noteId": '',
//         "likes": {},
//         "mediaUrl": '',
//         "isReply": true,
//         "renoteedScaleId": '',
//         "attachedScaleId": [widget.scaleId],
//       });

//       commentTextController.clear();
//     }
//     addToActivityFeed();
//   }

//   buildWriteComment() {
//     return Align(
//       alignment: Alignment.bottomCenter,
//       child: FutureBuilder(
//           future: usersRef.doc(uid).get(),
//           builder: (context, snapshot) {
//             if (!snapshot.hasData) {
//               return loading();
//             }
//             UserModel user = UserModel.fromDocument(snapshot.data!);
//             return Container(
//               decoration: BoxDecoration(
//                   color: Colors.black,
//                   border: Border(
//                       top: BorderSide(width: 1, color: Colors.grey[900]!))),
//               child: Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
//                 child: SizedBox(
//                   height: 55,
//                   child: Center(
//                     child: Padding(
//                       padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           CircleAvatar(
//                             backgroundImage: NetworkImage(user.imageUrl),
//                           ),
//                           const SizedBox(width: 10),
//                           commentTextField(),
//                           inactive == false
//                               ? Row(
//                                   children: [
//                                     const SizedBox(
//                                       width: 10,
//                                     ),
//                                     SizedBox(
//                                       height: 40,
//                                       width: 35,
//                                       child: Center(
//                                         child: CupertinoButton(
//                                           borderRadius: kCircleBorderRadius,
//                                           padding: EdgeInsets.zero,
//                                           color: kThemeColor,
//                                           child: const Center(
//                                               child: Icon(
//                                             Icons.send,
//                                             size: 20,
//                                           )),
//                                           onPressed: addComment,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 )
//                               : const SizedBox(),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           }),
//     );
//   }

//   bool inactive = true;

//   Expanded commentTextField() {
//     return Expanded(
//       flex: 2,
//       child: Material(
//           color: Colors.transparent,
//           child: CupertinoTextField(cursorColor:Palette.themeColor,
//             onChanged: (val) {
//               if (val.isNotEmpty) {
//                 setState(() {
//                   inactive = false;
//                 });
//               } else {
//                 setState(() {
//                   inactive = true;
//                 });
//               }
//             },
//             decoration: BoxDecoration(
//                 color: kDarkGreyColor, borderRadius: kCircleBorderRadius),
//             focusNode: focusNode,
//             controller: commentTextController,
//             style: const TextStyle(color: Colors.white),
//             placeholder: 'Write your reply',
//             placeholderStyle: const TextStyle(color: Colors.grey),
//             maxLines: 10,
//           )),
//     );
//   }

//   buildComments() {
//     return ListView(
//       physics: const NeverScrollableScrollPhysics(),
//       shrinkWrap: true,
//       children: comments,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: navBar(
//         'Note',
//         'Scale',
//         elevation: true,
//       ),
//       backgroundColor: kBackgroundColor,
//       body: SizedBox(
//         height: Get.height,
//         width: Get.width,
//         child: Stack(
//           children: [
//             ListView(
//               children: [
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 FutureBuilder(
//                   future: usersRef.doc(widget.writerId).get(),
//                   builder: (context, snapshot) {
//                     if (!snapshot.hasData) {
//                       return loading();
//                     }
//                     UserModel user = UserModel.fromDocument(snapshot.data!);
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           CupertinoButton(
//                             onPressed: widget.currentScreen != Account
//                                 ? () {
//                                     Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) => Account(
//                                             profileId: user.id,
//                                           ),
//                                         ));
//                                   }
//                                 : null,
//                             padding: EdgeInsets.zero,
//                             child: CircleAvatar(
//                               backgroundImage: NetworkImage(user.imageUrl),
//                             ),
//                           ),
//                           const SizedBox(
//                             width: 8,
//                           ),
//                           Expanded(
//                             child: Column(
//                               mainAxisSize: MainAxisSize.max,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   children: [
//                                     GestureDetector(
//                                       onTap: widget.currentScreen != Account
//                                           ? () {
//                                               Navigator.push(
//                                                   context,
//                                                   MaterialPageRoute(
//                                                     builder: (context) =>
//                                                         Account(
//                                                       profileId: user.id,
//                                                     ),
//                                                   ));
//                                             }
//                                           : null,
//                                       child: Text(
//                                         user.username,
//                                         style: TextStyle(
//                                             color: Colors.grey[300],
//                                             fontSize: 19,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                     user.isVerified || user.isDeveloper
//                                         ? Row(
//                                             children: [
//                                               const SizedBox(
//                                                 width: 5,
//                                               ),
//                                               Text(
//                                                 String.fromCharCode(
//                                                     CupertinoIcons
//                                                         .checkmark_seal_fill
//                                                         .codePoint),
//                                                 style: TextStyle(
//                                                   inherit: false,
//                                                   color: user.isDeveloper &&
//                                                           user.isVerified
//                                                       ? kThemeColor
//                                                       : Colors.blue,
//                                                   fontSize: 17.0,
//                                                   fontWeight: FontWeight.w900,
//                                                   fontFamily: CupertinoIcons
//                                                       .heart.fontFamily,
//                                                   package: CupertinoIcons
//                                                       .heart.fontPackage,
//                                                 ),
//                                               ),
//                                             ],
//                                           )
//                                         : const SizedBox(),
//                                     const SizedBox(
//                                       width: 10,
//                                     ),
//                                   ],
//                                 ),
//                                 Text(
//                                   timeago.format(
//                                     widget.timestamp.toDate(),
//                                   ),
//                                   style: TextStyle(
//                                       color: Colors.grey[600],
//                                       fontWeight: FontWeight.w500),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.only(
//                                       right: 20.0, top: 5),
//                                   child: Text(
//                                     widget.content,
//                                     style: TextStyle(
//                                         color: Colors.grey[350], fontSize: 19),
//                                   ),
//                                 ),
//                                 const SizedBox(
//                                   height: 10,
//                                 ),
//                                 widget.noteId.isEmpty
//                                     ? const SizedBox()
//                                     : FutureBuilder(
//                                         future:
//                                             exploreRef.doc(widget.noteId).get(),
//                                         builder: (context, snapshot) {
//                                           if (!snapshot.hasData) {
//                                             return loading();
//                                           }

//                                           return FutureBuilder(
//                                               future: usersRef
//                                                   .doc(snapshot.data!
//                                                       .data()!['writerId'])
//                                                   .get(),
//                                               builder:
//                                                   (context, writerSnapshot) {
//                                                 if (!writerSnapshot.hasData) {
//                                                   return loading();
//                                                 }
//                                                 UserModel writer =
//                                                     UserModel.fromDocument(
//                                                         writerSnapshot.data!);
//                                                 return Column(
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   children: [
//                                                     CupertinoButton(
//                                                       padding: EdgeInsets.zero,
//                                                       onPressed: () {
//                                                         final documentSnapshot =
//                                                             snapshot.data!
//                                                                 .data()!;
//                                                         Get.to(
//                                                           () =>
//                                                               NoteDetailsMobile(
//                                                             previousPageTitle:
//                                                                 '',
//                                                             noteId:
//                                                                 documentSnapshot[
//                                                                     'noteId'],
//                                                             title:
//                                                                 documentSnapshot[
//                                                                     'title'],
//                                                             thumbnailUrl:
//                                                                 documentSnapshot[
//                                                                     'thumbnailUrl'],
//                                                             content:
//                                                                 documentSnapshot[
//                                                                     'content'],
//                                                             writerId:
//                                                                 documentSnapshot[
//                                                                     'writerId'],
//                                                             timestamp:
//                                                                 documentSnapshot[
//                                                                     'timestamp'],
//                                                             views:
//                                                                 documentSnapshot[
//                                                                     'views'],
//                                                             likes:
//                                                                 documentSnapshot[
//                                                                     'likes'],
//                                                           ),
//                                                         );
//                                                       },
//                                                       child: Container(
//                                                         height: 100,
//                                                         margin: const EdgeInsets
//                                                                 .only(
//                                                             right: 20,
//                                                             top: 4,
//                                                             left: 0),
//                                                         decoration: BoxDecoration(
//                                                             color:
//                                                                 kDarkGreyColor,
//                                                             border: Border.all(
//                                                                 width: 2,
//                                                                 color:
//                                                                     Colors.grey[
//                                                                         900]!),
//                                                             borderRadius:
//                                                                 BorderRadius
//                                                                     .circular(
//                                                                         20)),
//                                                         child: Row(
//                                                           mainAxisAlignment:
//                                                               MainAxisAlignment
//                                                                   .start,
//                                                           crossAxisAlignment:
//                                                               CrossAxisAlignment
//                                                                   .start,
//                                                           children: [
//                                                             Expanded(
//                                                               child: Padding(
//                                                                 padding: const EdgeInsets
//                                                                         .symmetric(
//                                                                     horizontal:
//                                                                         10,
//                                                                     vertical:
//                                                                         10),
//                                                                 child: Column(
//                                                                   crossAxisAlignment:
//                                                                       CrossAxisAlignment
//                                                                           .start,
//                                                                   children: [
//                                                                     Row(
//                                                                       children: [
//                                                                         ClipRRect(
//                                                                           borderRadius:
//                                                                               BorderRadius.circular(5),
//                                                                           child:
//                                                                               Image.network(
//                                                                             writer.imageUrl,
//                                                                             height:
//                                                                                 25,
//                                                                             width:
//                                                                                 25,
//                                                                             fit:
//                                                                                 BoxFit.cover,
//                                                                           ),
//                                                                         ),
//                                                                         const SizedBox(
//                                                                           width:
//                                                                               5,
//                                                                         ),
//                                                                         Text(
//                                                                           writer
//                                                                               .username,
//                                                                           style:
//                                                                               TextStyle(
//                                                                             color:
//                                                                                 Colors.grey[350],
//                                                                             fontWeight:
//                                                                                 FontWeight.w500,
//                                                                           ),
//                                                                         ),
//                                                                         writer.isVerified ||
//                                                                                 writer.isDeveloper
//                                                                             ? Row(
//                                                                                 children: [
//                                                                                   const SizedBox(
//                                                                                     width: 5,
//                                                                                   ),
//                                                                                   Text(
//                                                                                     String.fromCharCode(CupertinoIcons.checkmark_seal_fill.codePoint),
//                                                                                     style: TextStyle(
//                                                                                       inherit: false,
//                                                                                       color: writer.isDeveloper && writer.isVerified ? kThemeColor : Colors.blue,
//                                                                                       fontSize: 15.0,
//                                                                                       fontWeight: FontWeight.w900,
//                                                                                       fontFamily: CupertinoIcons.heart.fontFamily,
//                                                                                       package: CupertinoIcons.heart.fontPackage,
//                                                                                     ),
//                                                                                   ),
//                                                                                 ],
//                                                                               )
//                                                                             : const SizedBox(),
//                                                                       ],
//                                                                     ),
//                                                                     const SizedBox(
//                                                                       height: 5,
//                                                                     ),
//                                                                     Row(
//                                                                       mainAxisSize:
//                                                                           MainAxisSize
//                                                                               .min,
//                                                                       children: [
//                                                                         Expanded(
//                                                                           child:
//                                                                               Text(
//                                                                             snapshot.data!.data()!['title'],
//                                                                             overflow:
//                                                                                 TextOverflow.ellipsis,
//                                                                             style: const TextStyle(
//                                                                                 color: Colors.white,
//                                                                                 fontWeight: FontWeight.bold,
//                                                                                 fontSize: 16),
//                                                                             maxLines:
//                                                                                 1,
//                                                                           ),
//                                                                         ),
//                                                                       ],
//                                                                     ),
//                                                                     const SizedBox(
//                                                                       height: 5,
//                                                                     ),
//                                                                     Row(
//                                                                       mainAxisSize:
//                                                                           MainAxisSize
//                                                                               .min,
//                                                                       children: [
//                                                                         Expanded(
//                                                                           child:
//                                                                               Text(
//                                                                             snapshot.data!.data()!['content'],
//                                                                             style: const TextStyle(
//                                                                                 color: Colors.grey,
//                                                                                 fontWeight: FontWeight.bold,
//                                                                                 fontSize: 14),
//                                                                             maxLines:
//                                                                                 1,
//                                                                             overflow:
//                                                                                 TextOverflow.ellipsis,
//                                                                           ),
//                                                                         ),
//                                                                       ],
//                                                                     ),
//                                                                     const SizedBox(
//                                                                       height: 5,
//                                                                     ),
//                                                                   ],
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                             const SizedBox(
//                                                               width: 20,
//                                                             ),
//                                                             ClipRRect(
//                                                               borderRadius: const BorderRadius
//                                                                       .only(
//                                                                   topRight: Radius
//                                                                       .circular(
//                                                                           18),
//                                                                   bottomRight: Radius
//                                                                       .circular(
//                                                                           18)),
//                                                               child:
//                                                                   Image.network(
//                                                                 snapshot.data!
//                                                                         .data()![
//                                                                     'thumbnailUrl'],
//                                                                 height: 100,
//                                                                 width: 100,
//                                                                 fit: BoxFit
//                                                                     .cover,
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 );
//                                               });
//                                         }),
//                                 widget.mediaUrl.isEmpty
//                                     ? const SizedBox()
//                                     : Column(
//                                         children: [
//                                           const SizedBox(
//                                             height: 10,
//                                           ),
//                                           Row(
//                                             mainAxisSize: MainAxisSize.min,
//                                             children: [
//                                               Expanded(
//                                                 child: GestureDetector(
//                                                   onTap: () {
//                                                     Get.to(() => Photo(
//                                                         mediaUrl:
//                                                             widget.mediaUrl));
//                                                   },
//                                                   child: ClipRRect(
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               15),
//                                                       child: Image.network(
//                                                         widget.mediaUrl,
//                                                         fit: BoxFit.cover,
//                                                       )),
//                                                 ),
//                                               ),
//                                               const SizedBox(
//                                                 width: 20,
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                 widget.renoteedScaleId.isEmpty
//                                     ? const SizedBox()
//                                     : FutureBuilder(
//                                         future: scalesRef
//                                             .doc(widget.renoteedScaleId)
//                                             .get(),
//                                         builder: (context, snapshot) {
//                                           if (!snapshot.hasData) {
//                                             return loading();
//                                           }

//                                           return FutureBuilder(
//                                               future: usersRef
//                                                   .doc(snapshot.data!
//                                                       .data()!['writerId'])
//                                                   .get(),
//                                               builder:
//                                                   (context, writerSnapshot) {
//                                                 if (!writerSnapshot.hasData) {
//                                                   return loading();
//                                                 }
//                                                 UserModel writer =
//                                                     UserModel.fromDocument(
//                                                         writerSnapshot.data!);
//                                                 final documentSnapshot =
//                                                     snapshot.data!.data()!;
//                                                 return CupertinoButton(
//                                                   padding: EdgeInsets.zero,
//                                                   onPressed: () {
//                                                     Get.to(
//                                                       () => ScaleDetails(
//                                                         currentScreen: NewScale,
//                                                         renoteedScaleId:
//                                                             documentSnapshot[
//                                                                 'renoteedScaleId'],
//                                                         isReply:
//                                                             documentSnapshot[
//                                                                 'isReply'],
//                                                         attachedScaleId:
//                                                             documentSnapshot[
//                                                                 'attachedScaleId'],
//                                                         mediaUrl:
//                                                             documentSnapshot[
//                                                                 'mediaUrl'],
//                                                         scaleId:
//                                                             documentSnapshot[
//                                                                 'scaleId'],
//                                                         focus: false,
//                                                         noteId:
//                                                             documentSnapshot[
//                                                                 'noteId'],
//                                                         content:
//                                                             documentSnapshot[
//                                                                 'content'],
//                                                         writerId:
//                                                             documentSnapshot[
//                                                                 'writerId'],
//                                                         timestamp:
//                                                             documentSnapshot[
//                                                                 'timestamp'],
//                                                         likes: documentSnapshot[
//                                                             'likes'],
//                                                       ),
//                                                     );
//                                                   },
//                                                   child: Container(
//                                                     margin:
//                                                         const EdgeInsets.only(
//                                                             right: 20),
//                                                     decoration: BoxDecoration(
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(15),
//                                                         border: Border.all(
//                                                             width: 1.5,
//                                                             color: Colors
//                                                                 .grey[900]!)),
//                                                     child: CupertinoButton(
//                                                       padding: const EdgeInsets
//                                                           .fromLTRB(0, 0, 0, 0),
//                                                       onPressed: () {
//                                                         Navigator.push(
//                                                             context,
//                                                             MaterialPageRoute(
//                                                               builder: (context) =>
//                                                                   ScaleDetails(
//                                                                 renoteedScaleId:
//                                                                     documentSnapshot[
//                                                                         'renoteedScaleId'],
//                                                                 currentScreen:
//                                                                     NewScale,
//                                                                 isReply:
//                                                                     documentSnapshot[
//                                                                         'isReply'],
//                                                                 attachedScaleId:
//                                                                     documentSnapshot[
//                                                                         'attachedScaleId'],
//                                                                 mediaUrl:
//                                                                     documentSnapshot[
//                                                                         'mediaUrl'],
//                                                                 scaleId:
//                                                                     documentSnapshot[
//                                                                         'scaleId'],
//                                                                 focus: false,
//                                                                 noteId:
//                                                                     documentSnapshot[
//                                                                         'noteId'],
//                                                                 content:
//                                                                     documentSnapshot[
//                                                                         'content'],
//                                                                 writerId:
//                                                                     documentSnapshot[
//                                                                         'writerId'],
//                                                                 timestamp:
//                                                                     documentSnapshot[
//                                                                         'timestamp'],
//                                                                 likes:
//                                                                     documentSnapshot[
//                                                                         'likes'],
//                                                               ),
//                                                             ));
//                                                       },
//                                                       child: Column(
//                                                         crossAxisAlignment:
//                                                             CrossAxisAlignment
//                                                                 .start,
//                                                         children: [
//                                                           Row(
//                                                             children: [
//                                                               CupertinoButton(
//                                                                 onPressed: () {
//                                                                   Navigator.push(
//                                                                       context,
//                                                                       MaterialPageRoute(
//                                                                         builder:
//                                                                             (context) =>
//                                                                                 Account(
//                                                                           profileId:
//                                                                               writer.id,
//                                                                         ),
//                                                                       ));
//                                                                 },
//                                                                 padding:
//                                                                     EdgeInsets
//                                                                         .zero,
//                                                                 child:
//                                                                     CircleAvatar(
//                                                                   radius: 12,
//                                                                   backgroundImage:
//                                                                       NetworkImage(
//                                                                           writer
//                                                                               .imageUrl),
//                                                                 ),
//                                                               ),
//                                                               GestureDetector(
//                                                                 onTap: () {
//                                                                   Navigator.push(
//                                                                       context,
//                                                                       MaterialPageRoute(
//                                                                         builder:
//                                                                             (context) =>
//                                                                                 Account(
//                                                                           profileId:
//                                                                               writer.id,
//                                                                         ),
//                                                                       ));
//                                                                 },
//                                                                 child: Row(
//                                                                   children: [
//                                                                     Text(
//                                                                       writer
//                                                                           .username,
//                                                                       style: TextStyle(
//                                                                           color: Colors.grey[
//                                                                               300],
//                                                                           fontSize:
//                                                                               16,
//                                                                           fontWeight:
//                                                                               FontWeight.bold),
//                                                                     ),
//                                                                     writer.isVerified ||
//                                                                             writer.isDeveloper
//                                                                         ? Row(
//                                                                             crossAxisAlignment:
//                                                                                 CrossAxisAlignment.start,
//                                                                             children: [
//                                                                               const SizedBox(
//                                                                                 width: 5,
//                                                                               ),
//                                                                               Text(
//                                                                                 String.fromCharCode(CupertinoIcons.checkmark_seal_fill.codePoint),
//                                                                                 style: TextStyle(
//                                                                                   inherit: false,
//                                                                                   color: writer.isDeveloper && writer.isVerified ? kThemeColor : Colors.blue,
//                                                                                   fontSize: 15.0,
//                                                                                   fontWeight: FontWeight.w900,
//                                                                                   fontFamily: CupertinoIcons.heart.fontFamily,
//                                                                                   package: CupertinoIcons.heart.fontPackage,
//                                                                                 ),
//                                                                               ),
//                                                                               const SizedBox(
//                                                                                 width: 10,
//                                                                               ),
//                                                                               Text(
//                                                                                 timeago.format(
//                                                                                   documentSnapshot['timestamp'].toDate(),
//                                                                                 ),
//                                                                                 style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w500, fontSize: 12),
//                                                                               ),
//                                                                             ],
//                                                                           )
//                                                                         : const SizedBox(),
//                                                                   ],
//                                                                 ),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                           Padding(
//                                                             padding:
//                                                                 const EdgeInsets
//                                                                         .only(
//                                                                     left: 8.0,
//                                                                     right: 15),
//                                                             child: Text(
//                                                               documentSnapshot[
//                                                                   'content'],
//                                                               style: TextStyle(
//                                                                   color: Colors
//                                                                           .grey[
//                                                                       350],
//                                                                   fontSize: 16,
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .w500),
//                                                             ),
//                                                           ),
//                                                           const SizedBox(
//                                                             height: 7,
//                                                           ),
//                                                           documentSnapshot[
//                                                                       'noteId']
//                                                                   .isEmpty
//                                                               ? const SizedBox()
//                                                               : FutureBuilder(
//                                                                   future: exploreRef
//                                                                       .doc(documentSnapshot[
//                                                                           'noteId'])
//                                                                       .get(),
//                                                                   builder: (context,
//                                                                       snapshot) {
//                                                                     if (!snapshot
//                                                                         .hasData) {
//                                                                       return loading();
//                                                                     }

//                                                                     return FutureBuilder(
//                                                                         future: usersRef
//                                                                             .doc(snapshot.data!.data()![
//                                                                                 'writerId'])
//                                                                             .get(),
//                                                                         builder:
//                                                                             (context,
//                                                                                 writerSnapshot) {
//                                                                           if (!writerSnapshot
//                                                                               .hasData) {
//                                                                             return loading();
//                                                                           }
//                                                                           UserModel
//                                                                               writer =
//                                                                               UserModel.fromDocument(writerSnapshot.data!);
//                                                                           return Column(
//                                                                             crossAxisAlignment:
//                                                                                 CrossAxisAlignment.start,
//                                                                             children: [
//                                                                               CupertinoButton(
//                                                                                 padding: EdgeInsets.zero,
//                                                                                 onPressed: () {
//                                                                                   final documentSnapshot = snapshot.data!.data()!;
//                                                                                   Get.to(
//                                                                                     () => NoteDetailsMobile(
//                                                                                       previousPageTitle: '',
//                                                                                       noteId: documentSnapshot['noteId'],
//                                                                                       title: documentSnapshot['title'],
//                                                                                       thumbnailUrl: documentSnapshot['thumbnailUrl'],
//                                                                                       content: documentSnapshot['content'],
//                                                                                       writerId: documentSnapshot['writerId'],
//                                                                                       timestamp: documentSnapshot['timestamp'],
//                                                                                       views: documentSnapshot['views'],
//                                                                                       likes: documentSnapshot['likes'],
//                                                                                     ),
//                                                                                   );
//                                                                                 },
//                                                                                 child: Container(
//                                                                                   height: 100,
//                                                                                   margin: const EdgeInsets.only(
//                                                                                     top: 4,
//                                                                                   ),
//                                                                                   decoration: BoxDecoration(
//                                                                                     color: kDarkGreyColor,
//                                                                                     border: Border.symmetric(horizontal: BorderSide(width: 1, color: Colors.grey[900]!)),
//                                                                                   ),
//                                                                                   child: Row(
//                                                                                     mainAxisAlignment: MainAxisAlignment.start,
//                                                                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                                                                     children: [
//                                                                                       Expanded(
//                                                                                         child: Padding(
//                                                                                           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                                                                                           child: Column(
//                                                                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                                                                             children: [
//                                                                                               Row(
//                                                                                                 children: [
//                                                                                                   ClipRRect(
//                                                                                                     borderRadius: BorderRadius.circular(5),
//                                                                                                     child: Image.network(
//                                                                                                       writer.imageUrl,
//                                                                                                       height: 25,
//                                                                                                       width: 25,
//                                                                                                       fit: BoxFit.cover,
//                                                                                                     ),
//                                                                                                   ),
//                                                                                                   const SizedBox(
//                                                                                                     width: 5,
//                                                                                                   ),
//                                                                                                   Text(
//                                                                                                     writer.username,
//                                                                                                     style: TextStyle(
//                                                                                                       color: Colors.grey[350],
//                                                                                                       fontWeight: FontWeight.w500,
//                                                                                                     ),
//                                                                                                   ),
//                                                                                                   writer.isVerified || writer.isDeveloper
//                                                                                                       ? Row(
//                                                                                                           children: [
//                                                                                                             const SizedBox(
//                                                                                                               width: 5,
//                                                                                                             ),
//                                                                                                             Text(
//                                                                                                               String.fromCharCode(CupertinoIcons.checkmark_seal_fill.codePoint),
//                                                                                                               style: TextStyle(
//                                                                                                                 inherit: false,
//                                                                                                                 color: writer.isDeveloper && writer.isVerified ? kThemeColor : Colors.blue,
//                                                                                                                 fontSize: 15.0,
//                                                                                                                 fontWeight: FontWeight.w900,
//                                                                                                                 fontFamily: CupertinoIcons.heart.fontFamily,
//                                                                                                                 package: CupertinoIcons.heart.fontPackage,
//                                                                                                               ),
//                                                                                                             ),
//                                                                                                           ],
//                                                                                                         )
//                                                                                                       : const SizedBox(),
//                                                                                                 ],
//                                                                                               ),
//                                                                                               const SizedBox(
//                                                                                                 height: 5,
//                                                                                               ),
//                                                                                               Row(
//                                                                                                 mainAxisSize: MainAxisSize.min,
//                                                                                                 children: [
//                                                                                                   Expanded(
//                                                                                                     child: Text(
//                                                                                                       snapshot.data!.data()!['title'],
//                                                                                                       overflow: TextOverflow.ellipsis,
//                                                                                                       style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
//                                                                                                       maxLines: 1,
//                                                                                                     ),
//                                                                                                   ),
//                                                                                                 ],
//                                                                                               ),
//                                                                                               const SizedBox(
//                                                                                                 height: 5,
//                                                                                               ),
//                                                                                               Row(
//                                                                                                 mainAxisSize: MainAxisSize.min,
//                                                                                                 children: [
//                                                                                                   Expanded(
//                                                                                                     child: Text(
//                                                                                                       snapshot.data!.data()!['content'],
//                                                                                                       style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 14),
//                                                                                                       maxLines: 1,
//                                                                                                       overflow: TextOverflow.ellipsis,
//                                                                                                     ),
//                                                                                                   ),
//                                                                                                 ],
//                                                                                               ),
//                                                                                               const SizedBox(
//                                                                                                 height: 5,
//                                                                                               ),
//                                                                                             ],
//                                                                                           ),
//                                                                                         ),
//                                                                                       ),
//                                                                                       const SizedBox(
//                                                                                         width: 20,
//                                                                                       ),
//                                                                                       ClipRRect(
//                                                                                         child: Image.network(
//                                                                                           snapshot.data!.data()!['thumbnailUrl'],
//                                                                                           height: 100,
//                                                                                           width: 100,
//                                                                                           fit: BoxFit.cover,
//                                                                                         ),
//                                                                                       ),
//                                                                                     ],
//                                                                                   ),
//                                                                                 ),
//                                                                               ),
//                                                                             ],
//                                                                           );
//                                                                         });
//                                                                   }),
//                                                           snapshot.data!
//                                                                   .data()![
//                                                                       'mediaUrl']
//                                                                   .isEmpty
//                                                               ? const SizedBox()
//                                                               : Row(
//                                                                   mainAxisSize:
//                                                                       MainAxisSize
//                                                                           .min,
//                                                                   children: [
//                                                                     Expanded(
//                                                                       child:
//                                                                           Container(
//                                                                         decoration: BoxDecoration(
//                                                                             borderRadius:
//                                                                                 const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
//                                                                             border: Border.all(width: 1, color: Colors.grey[900]!)),
//                                                                         child:
//                                                                             GestureDetector(
//                                                                           onTap:
//                                                                               () {
//                                                                             Get.to(() =>
//                                                                                 Photo(
//                                                                                   mediaUrl: snapshot.data!.data()!['mediaUrl'],
//                                                                                 ));
//                                                                           },
//                                                                           child: ClipRRect(
//                                                                               borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
//                                                                               child: Image.network(
//                                                                                 snapshot.data!.data()!['mediaUrl'],
//                                                                                 fit: BoxFit.cover,
//                                                                               )),
//                                                                         ),
//                                                                       ),
//                                                                     ),
//                                                                   ],
//                                                                 ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 );
//                                               });
//                                         }),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 15.0),
//                   child: Text(
//                     formattedDate(widget.timestamp),
//                     style: const TextStyle(color: Colors.grey),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 Divider(
//                   height: 5,
//                   color: Colors.grey[900],
//                   thickness: 1.8,
//                 ),
//                 Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         LikeButton(
//                           countBuilder: (likeCount, isLiked, text) {
//                             return Text(
//                               likeCount != 0 ? text : '',
//                               style: TextStyle(
//                                   color: Colors.grey[500], fontSize: 22),
//                             );
//                           },
//                           onTap: (isLiked) async {
//                             handleLikeNote();
//                             return !isLiked;
//                           },
//                           likeBuilder: (isLiked) {
//                             return Center(
//                               child: Text(
//                                 String.fromCharCode(isLiked
//                                     ? CupertinoIcons.heart_fill.codePoint
//                                     : CupertinoIcons.heart.codePoint),
//                                 style: TextStyle(
//                                   inherit: false,
//                                   color:
//                                       isLiked ? kThemeColor : Colors.grey[600],
//                                   fontSize: 25.0,
//                                   fontWeight: FontWeight.w600,
//                                   fontFamily: CupertinoIcons.share.fontFamily,
//                                   package: CupertinoIcons.share.fontPackage,
//                                 ),
//                               ),
//                             );
//                           },
//                           isLiked: isLiked,
//                           likeCount: likeCount,
//                         ),
//                         LikeButton(
//                           size: 26,
//                           animationDuration: const Duration(),
//                           padding: EdgeInsets.zero,
//                           onTap: (isLiked) async {
//                             myNavigator(
//                                 ScaleDetails(
//                                   scaleId: widget.scaleId,
//                                   writerId: widget.writerId,
//                                   content: widget.content,
//                                   likes: widget.likes,
//                                   timestamp: widget.timestamp,
//                                   noteId: widget.noteId,
//                                   mediaUrl: widget.mediaUrl,
//                                   attachedScaleId: widget.attachedScaleId,
//                                   isReply: widget.isReply,
//                                   focus: true,
//                                   currentScreen: widget.currentScreen,
//                                   renoteedScaleId: widget.renoteedScaleId,
//                                 ),
//                                 context);
//                             return isLiked;
//                           },
//                           likeBuilder: (isLiked) {
//                             return SvgPicture.asset(
//                               'assets/comment.svg',
//                               color: Colors.grey[600],
//                             );
//                           },
//                           countBuilder: (likeCount, isLiked, text) {
//                             return Padding(
//                               padding: const EdgeInsets.only(left: 6.0),
//                               child: Text(
//                                 likeCount != 0 ? text : '',
//                                 style: TextStyle(
//                                     color: Colors.grey[500], fontSize: 22),
//                               ),
//                             );
//                           },
//                           likeCount: commentCount,
//                         ),
//                         LikeButton(
//                           countBuilder: (likeCount, isLiked, text) {
//                             return Padding(
//                               padding: const EdgeInsets.only(left: 6.0),
//                               child: Text(
//                                 likeCount != 0 ? text : '',
//                                 style: TextStyle(
//                                     color: Colors.grey[500], fontSize: 22),
//                               ),
//                             );
//                           },
//                           size: 26,
//                           padding: EdgeInsets.zero,
//                           likeBuilder: (isLiked) {
//                             return SvgPicture.asset(
//                               "assets/retweet.svg",
//                               color: Colors.grey[600],
//                             );
//                           },
//                           onTap: (isLiked) async {
//                             Get.to(
//                                 () => NewScale(
//                                     noteId: '', scaleId: widget.scaleId),
//                                 transition: Transition.downToUp);
//                           },
//                           likeCount: reScaleCount,
//                         ),
//                         LikeButton(
//                           size: 26,
//                           countBuilder: (likeCount, isLiked, text) =>
//                               const SizedBox(),
//                           onTap: (isLiked) async {
//                             addToBookmarks(widget.scaleId);
//                             return bookmarked;
//                           },
//                           likeBuilder: (isLiked) {
//                             return Center(
//                               child: Text(
//                                 String.fromCharCode(isLiked
//                                     ? CupertinoIcons.bookmark_fill.codePoint
//                                     : CupertinoIcons.bookmark.codePoint),
//                                 style: TextStyle(
//                                   inherit: false,
//                                   color:
//                                       isLiked ? kThemeColor : Colors.grey[600],
//                                   fontSize: 22.0,
//                                   fontWeight: FontWeight.w600,
//                                   fontFamily: CupertinoIcons.share.fontFamily,
//                                   package: CupertinoIcons.share.fontPackage,
//                                 ),
//                               ),
//                             );
//                           },
//                           isLiked: bookmarked,
//                           likeCount: 0,
//                         ),
//                         CupertinoButton(
//                             padding: EdgeInsets.zero,
//                             child: Text(
//                               String.fromCharCode(UniconsLine.upload.codePoint),
//                               style: TextStyle(
//                                 inherit: false,
//                                 color: Colors.grey[600],
//                                 fontSize: 24.0,
//                                 fontWeight: FontWeight.w500,
//                                 fontFamily: UniconsLine.share.fontFamily,
//                                 package: UniconsLine.share.fontPackage,
//                               ),
//                             ),
//                             onPressed: () {}),
//                       ],
//                     )),
//                 Divider(
//                   height: 5,
//                   color: Colors.grey[900],
//                   thickness: 1.8,
//                 ),
//                 buildComments(),
//                 const SizedBox(
//                   height: 100,
//                 )
//               ],
//             ),
//             buildWriteComment()
//           ],
//         ),
//       ),
//     );
//   }
// }

// ///Scale.model backup
