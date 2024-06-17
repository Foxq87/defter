import 'dart:math';

import 'package:acc/core/commons/loader.dart';
import 'package:acc/core/constants/constants.dart';
import 'package:acc/core/constants/firebase_constants.dart';
import 'package:acc/features/auth/controller/auth_controller.dart';
import 'package:acc/features/school/controller/school_controller.dart';
import 'package:acc/theme/palette.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:url_launcher/url_launcher.dart';
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
  bool isEulaAccepted = false;
  bool isLoading = false;
  String errorText = '';
  List<String> schoolIds = [];
  List<String> usernames = [];
  TextEditingController schoolController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController fullnameController = TextEditingController();
  void launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

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
  String schoolId = '';
  @override
  void initState() {
    isEulaAccepted = widget.user.didAcceptEula;
    fullnameController = TextEditingController(text: widget.user.name);
    usernameController = TextEditingController(text: widget.user.username);

    if (widget.user.schoolId.contains('onay bekliyor:')) {
      schoolId = widget.user.schoolId.trim().replaceAll('onay bekliyor: ', '');
      print("testing school id : " + schoolId);
    } else {
      schoolId = widget.user.schoolId;
    }
    schoolController = TextEditingController(text: schoolId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isAppBeyogluUser = widget.user.roles.contains('appbeyoglu-user');
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
              child: isLoading
                  ? CupertinoActivityIndicator()
                  : Text(
                      'kaydet',
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'SFProDisplayMedium',
                      ),
                    ),
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });

                //minimize same username selection at the same time
                final random = Random();
                final randomNumber = random.nextInt(3) + 1;
                await Future.delayed(Duration(seconds: randomNumber));

                //write usernames to a list
                await _users.get().then((value) {
                  for (var element in value.docs) {
                    if (element.get('username').toString().isNotEmpty) {
                      usernames.add(
                          element.get('username').toString().toLowerCase());
                    }
                  }
                });
//remove this users username from the list
                usernames.remove(widget.user.username);

                //write schoolids to a list
                await _schools.get().then((value) {
                  for (var element in value.docs) {
                    if (element.get('id').toString().isNotEmpty) {
                      schoolIds.add(element.get('id').toString().toUpperCase());
                    }
                  }
                });

                print(schoolIds);

                //are all the fields filled? if not show an error text
                if (!isEulaAccepted) {
                  setState(() {
                    errorText = "kullanıcı sözleşmesini onaylamak mecburidir";
                  });
                } else if (fullnameController.text.trim().isEmpty ||
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
                } else if (isEulaAccepted &&
                    !usernames.contains(usernameController.text.trim()) &&
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
                  if (widget.user.uid.isEmpty) {
                    print('we got problem to solve');
                  } else {
                    print('we dont have problem');
                  }

                  ref.read(authControllerProvider.notifier).setupUser(
                        context,
                        widget.user.uid,
                        fullnameController.text.trim(),
                        fullnameController.text.trim().toLowerCase(),
                        usernameController.text.trim(),
                        usernameController.text.trim().toLowerCase(),
                        schoolController.text.trim(), //onay bekliyor
                      );
                  if (widget.user.schoolId.contains("onay bekliyor: ") ||
                      widget.user.schoolId.isEmpty) {
                    schoolId = "onay bekliyor: " + schoolId.trim();
                  }
                  print(schoolId + 'zaart');
                  ref.read(userProvider.notifier).update(
                        (state) => widget.user.copyWith(
                          username: usernameController.text.trim(),
                          username_insensitive:
                              usernameController.text.trim().toLowerCase(),
                          name: fullnameController.text.trim(),
                          name_insensitive:
                              fullnameController.text.trim().toLowerCase(),
                          didAcceptEula: true,
                          schoolId: schoolId, //onay bekliyor
                        ),
                      );

                  setState(() {
                    isLoading = false;
                  });
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
          style: TextStyle(fontFamily: 'SFProDisplayBold', color: Colors.white),
        ),
      ),
      body: Form(
        child: Padding(
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
                      fontFamily: 'SFProDisplayBold'),
                ),
              const Text(
                'kişisel bilgiler',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontFamily: 'SFProDisplayMedium'),
              ),
              const SizedBox(
                height: 10,
              ),
              CupertinoTextField(
                cursorColor: Palette.themeColor,
                controller: fullnameController,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'SFProDisplayRegular',
                ),
                decoration: BoxDecoration(
                  color: Palette.textFieldColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                placeholder: 'tam isim',
                placeholderStyle: const TextStyle(
                    color: Palette.placeholderColor,
                    fontFamily: 'SFProDisplayRegular'),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^[a-zA-ZğüşıöçĞÜŞİÖÇ\s]*$')),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              CupertinoTextField(
                maxLength: 32,
                cursorColor: Palette.themeColor,
                controller: usernameController,
                style: const TextStyle(
                    color: Colors.white, fontFamily: 'SFProDisplayRegular'),
                decoration: BoxDecoration(
                  color: Palette.textFieldColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                placeholder: 'kullanıcı adı',
                placeholderStyle: const TextStyle(
                    color: Palette.placeholderColor,
                    fontFamily: 'SFProDisplayRegular'),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(
                      r'^[a-zA-ZğüşıöçĞÜŞİÖÇ][a-zA-Z0-9ğüşıöçĞÜŞİÖÇ_]*$')),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                'okul',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontFamily: 'SFProDisplayMedium'),
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
                      cursorColor: Palette.themeColor,
                      onChanged: (val) {
                        setState(() {
                          textEditingController.text = val;
                        });
                      },
                      style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'SFProDisplayRegular'),
                      placeholder: "Okul ör: BAIHL",
                      placeholderStyle: const TextStyle(
                        color: Palette.placeholderColor,
                        fontFamily: 'SFProDisplayRegular',
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
                                    fontFamily: 'SFProDisplayBold'),
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
                          error: (error, stackTrace) => Text(error.toString()),
                          loading: () => const Loader(),
                        );
                    return schoolIds.where(
                      (item) {
                        return item.toUpperCase().contains(
                            schoolController.text.trim().toUpperCase());
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
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Checkbox(
                    activeColor: Palette.themeColor,
                    checkColor: Colors.white,
                    value: isEulaAccepted,
                    onChanged: (value) {
                      setState(() {
                        isEulaAccepted = value!;
                      });
                    },
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => launchURL(Constants.eulaLink),
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: 'Kullanıcı Sözleşmesi',
                            style: TextStyle(
                              color: Palette.themeColor,
                              fontFamily: 'SFProDisplayRegular',
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          TextSpan(
                            text: '\'ni Kabul Ediyorum',
                            style: TextStyle(
                              fontFamily: 'SFProDisplayRegular',
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
