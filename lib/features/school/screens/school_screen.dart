import 'package:acc/core/commons/not_available_card.dart';
import 'package:acc/core/commons/view_users_by_uids.dart';

import 'package:acc/features/school/controller/school_controller.dart';
import 'package:acc/models/note_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:acc/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/commons/image_view.dart';
import '../../../core/commons/loader.dart';
import '../../../core/commons/nav_bar_button.dart';
import '../../../models/school_model.dart';
import '../../notes/widgets/note_card.dart';
import '../../../features/auth/controller/auth_controller.dart';
import '../../../theme/palette.dart';

class SchoolScreen extends ConsumerStatefulWidget {
  final String id;
  const SchoolScreen({super.key, required this.id});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<SchoolScreen> {
  void navigateToEditUser(BuildContext context) {
    Routemaster.of(context).push('/edit-profile/${widget.id}');
  }

  List contentItems = [
    ['notlar', true],
    ['gazeteler', false],
  ];
  void selectAndUnselectOthers(int index) {
    for (var element in contentItems) {
      setState(() {
        element[1] = false;
        contentItems[index][1] = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserModel currentUser = ref.watch(userProvider)!;
    return Scaffold(
      //build edit profile

      body: ref.watch(getSchoolByIdProvider(widget.id)).when(
            data: (school) => ListView(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ImageView(
                                    imageUrls: [school.banner],
                                    imageFiles: [],
                                    index: 0))),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: AspectRatio(
                              aspectRatio: 10 / 3.5,
                              child: Image.network(
                                school.banner,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      left: 10,
                      child: JustIconButton(
                        icon: CupertinoIcons.back,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    Positioned(
                        top: 10,
                        right: 10,
                        child: JustIconButton(
                            icon: CupertinoIcons.ellipsis,
                            onPressed: () {
                              Navigator.of(context).pop();
                            })),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0).copyWith(top: 0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ImageView(
                                    imageUrls: [school.avatar],
                                    imageFiles: [],
                                    index: 0))),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            school.avatar,
                            fit: BoxFit.cover,
                            height: 80,
                            width: 80,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                school.title,
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'SFProDisplayBold'),
                              ),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            buildStudentCount(school)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: school.mods.contains(currentUser.uid)
                      ? Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 40,
                                child: CupertinoButton(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Palette.textFieldColor,
                                    padding: EdgeInsets.zero,
                                    onPressed: () =>
                                        navigateToEditUser(context),
                                    child: const Text(
                                      'profili düzenle',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'SFProDisplayMedium'),
                                    )),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox(),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 10),
                //   child: Text(
                //     '${user.karma} karma',
                //   ),
                // ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(contentItems.length, (index) {
                      return CupertinoButton(
                        onPressed: () => selectAndUnselectOthers(index),
                        padding: EdgeInsets.zero,
                        child: buildContentItem(
                            text: contentItems[index][0].toString(),
                            isSelected: contentItems[index][1]),
                      );
                    })),

                const Divider(
                  thickness: 0.6,
                  height: 0,
                ),

                if (contentItems[0][1])
                  ref.watch(getSchoolNotesProvider(school.id)).when(
                        data: (data) {
                          return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: data.length,
                            itemBuilder: (BuildContext context, int index) {
                              final Note note = data[index];
                              return NoteCard(
                                note: note,
                                isComment: false,
                              );
                            },
                          );
                        },
                        error: (error, stackTrace) {
                          return Text(error.toString());
                        },
                        loading: () => const Loader(),
                      )
                else
                  const NotAvailable(), //   body: ref.watch(getUserNotesProvider(uid)).when(
                //         data: (data) {
                //           return ListView.builder(
                //             itemCount: data.length,
                //             itemBuilder: (BuildContext context, int index) {
                //               final note = data[index];
                //               return NoteCard(note: note);
                //             },
                //           );
                //         },
                //         error: (error, stackTrace) {
                //           return Text(error.toString());
                //         },
                //         loading: () => const Loader(),
                //       ),
              ],
            ),
            error: (error, stackTrace) => Text(error.toString()),
            loading: () => const Loader(),
          ),
    );
  }

  Container buildEditProfile(BuildContext context) {
    return Container(
      alignment: Alignment.bottomLeft,
      padding: const EdgeInsets.all(20),
      child: OutlinedButton(
        onPressed: () => navigateToEditUser(context),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 25),
        ),
        child: const Text('Edit Profile'),
      ),
    );
  }

  SizedBox buildStudentCount(School school) {
    return SizedBox(
      height: 30,
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ViewUsersByUids(
                        uids: school.students,
                        isLiker: true,
                      )));
        },
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: school.students.length.toString(),
                  style: const TextStyle(fontFamily: 'SFProDisplayRegular')),
              const TextSpan(
                  text: ' öğrenci',
                  style: TextStyle(
                      color: Palette.placeholderColor,
                      fontFamily: 'SFProDisplayRegular')),
            ]))),
      ),
    );
  }

  Padding buildContentItem({required String text, required bool isSelected}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 15.0, 8.0, 0.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  width: 4,
                  color: isSelected ? Palette.themeColor : Colors.transparent)),
        ),
        child: Text(
          text,
          style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontFamily: 'SFProDisplayMedium'),
        ),
      ),
    );
  }
}
