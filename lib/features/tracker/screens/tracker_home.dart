// import 'package:acc/features/auth/controller/auth_controller.dart';
// import 'package:acc/features/tracker/controller/tracker_controller.dart';
// import 'package:acc/features/tracker/repository/tracker_repository.dart';
// import 'package:acc/theme/palette.dart';
// import 'package:calendar_timeline/calendar_timeline.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class TrackerHome extends ConsumerStatefulWidget {
//   final String uid;
//   const TrackerHome({super.key, required this.uid});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _TrackerHomeState();
// }

// class _TrackerHomeState extends ConsumerState<TrackerHome> {
//   DateTime mydate = DateTime.now();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 8.0),
//               child: CalendarTimeline(
//                 initialDate: DateTime.now(),
//                 firstDate: DateTime(2019, 1, 15),
//                 lastDate: DateTime.now().add(Duration(days: 7)),
//                 onDateSelected: (date) => setState(() {
//                   print(date);
//                   mydate = date;
//                 }),
//                 leftMargin: 20,
//                 monthColor: Colors.blueGrey,
//                 dayColor: Colors.teal[200],
//                 activeDayColor: Colors.white,
//                 activeBackgroundDayColor: Palette.themeColor,
//                 // dotsColor: Color(0xFF333A47),
//                 selectableDayPredicate: (date) => date.day != 23,
//                 locale: 'en_ISO',
//               ),
//             ),
// Expanded(child: )
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Palette.themeColor,
//         child: Icon(Icons.add),
//         onPressed: () {
//           showModalBottomSheet(
//             isScrollControlled: true,
//             context: context,
//             builder: (BuildContext context) {
//               return AddTest();
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// class LessonChip extends StatelessWidget {
//   final String lesson;
//   final bool isSelected;
//   final VoidCallback onTap;

//   const LessonChip({
//     required this.lesson,
//     required this.isSelected,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         margin: EdgeInsets.only(right: 8),
//         decoration: BoxDecoration(
//           color: isSelected ? Palette.orangeColor : Palette.justGreyColor,
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Text(
//           lesson,
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }
// }

// class AddTest extends ConsumerStatefulWidget {
//   const AddTest({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _AddTestState();
// }

// class _AddTestState extends ConsumerState<AddTest> {
//   TextEditingController correctCount = TextEditingController();
//   TextEditingController wrongCount = TextEditingController();
//   TextEditingController emptyCount = TextEditingController();
//   String selectedLesson = 'matematik';
//   @override
//   Widget build(BuildContext context) {
//     final currentUser = ref.read(userProvider)!;
//     return Scaffold(
//       body: ListView(
//         children: [
//           SizedBox(
//             height: 20,
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 BackButton(),
//                 Text(
//                   'soru ekle',
//                 ),
//                 SizedBox(
//                   height: 35,
//                   child: CupertinoButton(
//                       borderRadius: BorderRadius.circular(20),
//                       padding: EdgeInsets.symmetric(horizontal: 25),
//                       color: Palette.themeColor,
//                       child: Text(
//                         'ekle',
//                         style: TextStyle(color: Colors.white),
//                       ),
//                       onPressed: () {
//                         ref.read(trackerControllerProvider.notifier).addTest(
//                             currentUser.uid,
//                             selectedLesson,
//                             int.parse(correctCount.text.trim()),
//                             int.parse(wrongCount.text.trim()),
//                             int.parse(emptyCount.text.trim()),
//                             context);
//                       }),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 35,
//             child: ListView(
//               shrinkWrap: true,
//               scrollDirection: Axis.horizontal,
//               children: [
//                 LessonChip(
//                   lesson: 'matematik',
//                   isSelected: selectedLesson == 'matematik',
//                   onTap: () {
//                     setState(() {
//                       selectedLesson = 'matematik';
//                     });

//                     // Handle lesson selection
//                   },
//                 ),
//                 LessonChip(
//                   lesson: 'fizik',
//                   isSelected: selectedLesson == 'fizik',
//                   onTap: () {
//                     setState(() {
//                       selectedLesson = 'fizik';
//                     });
//                     // Handle lesson selection
//                   },
//                 ),
//                 LessonChip(
//                   lesson: 'kimya',
//                   isSelected: selectedLesson == 'kimya',
//                   onTap: () {
//                     setState(() {
//                       selectedLesson = 'kimya';
//                     });
//                     // Handle lesson selection
//                   },
//                 ),
//                 LessonChip(
//                   lesson: 'biyoloji',
//                   isSelected: selectedLesson == 'biyoloji',
//                   onTap: () {
//                     setState(() {
//                       selectedLesson = 'biyoloji';
//                     });
//                     // Handle lesson selection
//                   },
//                 ),
//                 LessonChip(
//                   lesson: 'edebiyat',
//                   isSelected: selectedLesson == 'edebiyat',
//                   onTap: () {
//                     setState(() {
//                       selectedLesson = 'edebiyat';
//                     });
//                     // Handle lesson selection
//                   },
//                 ),
//               ],
//             ),
//           ),
//           Row(
//             children: [
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: CupertinoTextField(
//                     controller: correctCount,
//                     placeholder: 'doğru',
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: CupertinoTextField(
//                     controller: wrongCount,
//                     placeholder: 'yanlış',
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: CupertinoTextField(
//                     controller: emptyCount,
//                     placeholder: 'boş',
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
