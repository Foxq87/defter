
import 'package:acc/core/commons/error_text.dart';
import 'package:acc/core/commons/loader.dart';
import 'package:acc/core/constants/firebase_constants.dart';
import 'package:acc/features/auth/controller/auth_controller.dart';
import 'package:acc/features/school/controller/school_controller.dart';
import 'package:acc/theme/palette.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../../../models/user_model.dart';

class SetupProfile extends ConsumerStatefulWidget {
  final UserModel user;
  const SetupProfile({
    super.key,
    required this.user,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SetupProfileState();
}

class _SetupProfileState extends ConsumerState<SetupProfile> {
  bool isLoading = false;
  String errorText = '';
  List<String> schoolIds = [];
  List<String> usernames = [];
  TextEditingController schoolController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController fullnameController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    fullnameController.dispose();
    super.dispose();
  }

  CollectionReference get _users =>
      FirebaseFirestore.instance.collection(FirebaseConstants.usersCollection);

  CollectionReference get _schools => FirebaseFirestore.instance
      .collection(FirebaseConstants.schoolsCollection);

  @override
  void initState() {
    fullnameController = TextEditingController(text: widget.user.name);
    usernameController = TextEditingController(text: widget.user.username);
    schoolController = TextEditingController(text: widget.user.schoolId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(

        border: const Border(
            bottom: BorderSide(width: 1.0, color: Palette.textFieldColor)),
        backgroundColor: Palette.backgroundColor,
        trailing: SizedBox(
          height: 30,
          child: CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              borderRadius: BorderRadius.circular(100),
              color: Palette.themeColor,
              child: Text(
                isLoading ? '...' : 'kaydet',
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'JetBrainsMonoBold',
                ),
              ),
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });

                await _users.get().then((value) {
                  for (var element in value.docs) {
                    if (element.get('username').toString().isNotEmpty) {
                      usernames.add(
                          element.get('username').toString().toLowerCase());
                    }
                  }
                });

                usernames.remove(widget.user.username);

                await _schools.get().then((value) {
                  for (var element in value.docs) {
                    if (element.get('id').toString().isNotEmpty) {
                      schoolIds.add(element.get('id').toString().toUpperCase());
                    }
                  }
                });

                print(schoolIds);

                //are all the fields filled? if not show an error text
                if (fullnameController.text.trim().isEmpty ||
                    usernameController.text.trim().isEmpty ||
                    schoolController.text.trim().isEmpty) {
                  setState(() {
                    errorText = "lütfen tüm alanları doldurun";
                  });
                }
                //is the fields filled with at least four characters
                else if ((fullnameController.text.trim().length < 4 ||
                    usernameController.text.trim().length < 4 ||
                    fullnameController.text.trim().length > 32 ||
                    usernameController.text.trim().length > 32)) {
                  setState(() {
                    errorText =
                        "isim ve kullanıcı adı 4-32 karakter arasında olmalıdır";
                  });
                }

                //is the username available? if not show an error text
                else if (usernames
                    .contains(usernameController.text.trim().toLowerCase())) {
                  setState(() {
                    errorText =
                        "bu kullanıcı adı başka bir kullanıcı tarafından kullanılıyor";
                  });
                }
                //is the school valid?
                else if (schoolIds.contains(schoolController.text.trim()) ==
                    false) {
                  setState(() {
                    errorText = "lütfen bir okul seçin";
                  });
                } else if (!usernames
                        .contains(usernameController.text.trim()) &&
                    schoolIds.contains(schoolController.text.trim()) &&
                    (fullnameController.text.trim().isNotEmpty ||
                        usernameController.text.trim().isNotEmpty ||
                        schoolController.text.trim().isNotEmpty) &&
                    (fullnameController.text.trim().length >= 4 ||
                        usernameController.text.trim().length >= 4 ||
                        fullnameController.text.trim().length <= 32 ||
                        usernameController.text.trim().length <= 32)) {
                  errorText = '';
                  setState(() {
                    isLoading = true;
                  });

                  ref.read(authControllerProvider.notifier).setupUser(
                        context,
                        widget.user.uid,
                        fullnameController.text.trim(),
                        usernameController.text.trim(),
                        schoolController.text.trim(),
                      );
                  ref.read(userProvider.notifier).update(
                        (state) => widget.user.copyWith(
                          username: usernameController.text.trim(),
                          name: fullnameController.text.trim(),
                          schoolId: schoolController.text.trim(),
                        ),
                      );

                  setState(() {
                    isLoading = false;
                  });
                  Routemaster.of(context).push('/');
                } else {
                  errorText =
                      "bir hata oluştu lütfen daha sonra tekrar deneyin";
                }
                setState(() {
                  isLoading = false;
                });
              }),
        ),
        middle: const Text(
          "hesabını tamamla",
          style: TextStyle(
              fontFamily: 'JetBrainsMonoExtraBold', color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView(
          children: [
            const SizedBox(
              height: 30,
            ),
            if (errorText.isNotEmpty)
              Text(
                errorText,
                style: const TextStyle(
                    color: Palette.redColor,
                    fontSize: 16,
                    fontFamily: 'JetBrainsMonoExtraBold'),
              ),
            const Text(
              'kişisel bilgiler',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontFamily: 'JetBrainsMonoBold'),
            ),
            const SizedBox(
              height: 10,
            ),
            CupertinoTextField(
              controller: fullnameController,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'JetBrainsMonoRegular',
              ),
              decoration: BoxDecoration(
                color: Palette.textFieldColor,
                borderRadius: BorderRadius.circular(10),
              ),
              placeholder: 'tam isim',
              placeholderStyle: const TextStyle(
                  color: Palette.placeholderColor,
                  fontFamily: 'JetBrainsMonoRegular'),
            ),
            const SizedBox(
              height: 10,
            ),
            CupertinoTextField(
              controller: usernameController,
              style: const TextStyle(
                  color: Colors.white, fontFamily: 'JetBrainsMonoRegular'),
              decoration: BoxDecoration(
                color: Palette.textFieldColor,
                borderRadius: BorderRadius.circular(10),
              ),
              placeholder: 'kullanıcı adı',
              placeholderStyle: const TextStyle(
                  color: Palette.placeholderColor,
                  fontFamily: 'JetBrainsMonoRegular'),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              'okul',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontFamily: 'JetBrainsMonoBold'),
            ),
            const SizedBox(
              height: 10,
            ),
            Autocomplete<String>(
              fieldViewBuilder: (context, textEditingController, focusNode,
                  onFieldSubmitted) {
                return SizedBox(
                  height: 40,
                  child: CupertinoTextField(
                    onChanged: (val) => setState(() {
                      textEditingController.text = val;
                    }),
                    style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'JetBrainsMonoRegular'),
                    placeholder: "Okul ör: BAIHL",
                    placeholderStyle: const TextStyle(
                      color: Palette.placeholderColor,
                      fontFamily: 'JetBrainsMonoRegular',
                    ),
                    focusNode: focusNode,
                    controller: schoolController,
                    decoration: BoxDecoration(
                      color: Palette.textFieldColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
              optionsViewBuilder: (context, onSelected, options) {
                return Material(
                  color: Colors.transparent,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListView.builder(
                        cacheExtent: 5,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: options.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) => Container(
                          margin: const EdgeInsets.only(top: 10, right: 20),
                          decoration: BoxDecoration(
                            color: Palette.textFieldColor,
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: ListTile(
                            onTap: () {
                              setState(() {
                                schoolController.text =
                                    options.elementAt(index);
                              });
                            },
                            title: Text(
                              options.elementAt(index),
                              style: const TextStyle(
                                  fontSize: 19,
                                  fontFamily: 'JetBrainsMonoExtraBold'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              optionsBuilder: (_) {
                List<String> schoolIds = [];
                if (schoolController.text.trim().isEmpty) {
                  return const Iterable<String>.empty();
                } else {
                  ref.watch(getAllSchoolsProvider).when(
                        data: (schools) {
                          for (var element in schools) {
                            schoolIds.add(element.id);
                          }
                        },
                        error: (error, stackTrace) =>
                            ErrorText(error: error.toString()),
                        loading: () => const Loader(),
                      );
                  return schoolIds.where(
                    (item) {
                      return item
                          .toUpperCase()
                          .contains(schoolController.text.trim().toUpperCase());
                    },
                  );
                }
              },
              onSelected: (selection) {
                setState(() {
                  schoolController.text = selection;
                });
                debugPrint(selection);
              },
              displayStringForOption: ((option) =>
                  option.characters.toString()),
            ),
          ],
        ),
      ),
    );
  }
}
