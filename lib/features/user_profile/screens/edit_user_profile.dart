import 'dart:io';

import 'package:acc/core/constants/firebase_constants.dart';
import 'package:acc/models/user_model.dart';
import 'package:acc/theme/palette.dart';
import 'package:acc/core/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/commons/error_text.dart';
import '../../../core/commons/loader.dart';
import '../../../core/utils.dart';
import '../../../responsive/responsive.dart';
import '../../auth/controller/auth_controller.dart';
import '../controller/user_profile_controller.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final String uid;
  const EditProfileScreen({
    super.key,
    required this.uid,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  File? bannerFile;
  File? profileFile;

  Uint8List? bannerWebFile;
  Uint8List? profileWebFile;
  late TextEditingController nameController;
  late TextEditingController usernameController;
  late TextEditingController bioController;
  List<String> usernames = [];
  String errorText = '';
  bool isLoading = false;

  CollectionReference get _users =>
      FirebaseFirestore.instance.collection(FirebaseConstants.usersCollection);
  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider)!;
    bioController = TextEditingController(text: user.bio);
    usernameController = TextEditingController(text: user.username);
    nameController = TextEditingController(text: user.name);
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    usernameController.dispose();
    bioController.dispose();
  }

  void selectBannerImage() async {
    final res = await pickImage();

    if (res != null) {
      if (kIsWeb) {
        setState(() {
          bannerWebFile = res.files.first.bytes;
        });
      } else {
        setState(() {
          bannerFile = File(res.files.first.path!);
        });
      }
    }
  }

  void selectProfileImage() async {
    final res = await pickImage();

    if (res != null) {
      if (kIsWeb) {
        setState(() {
          profileWebFile = res.files.first.bytes;
        });
      } else {
        setState(() {
          profileFile = File(res.files.first.path!);
        });
      }
    }
  }

  Future<void> save(UserModel user) async {
    isLoading = true;
    await _users.get().then((value) {
      for (var element in value.docs) {
        if (element.get('username').toString().isNotEmpty) {
          usernames.add(element.get('username').toString().toLowerCase());
        }
      }
    });
    usernames.remove(user.username);
    if (nameController.text.trim().isEmpty ||
        usernameController.text.trim().isEmpty) {
      setState(() {
        errorText = "isim ve kullanıcı adı boş olamaz";
      });
    }
    //is the fields filled with at least four characters
    else if ((nameController.text.trim().length < 4 ||
        usernameController.text.trim().length < 4 ||
        nameController.text.trim().length > 32 ||
        usernameController.text.trim().length > 32)) {
      setState(() {
        errorText = "isim ve kullanıcı adı 4-32 karakter arasında olmalıdır";
      });
    } else if (usernames
        .contains(usernameController.text.trim().toLowerCase())) {
      setState(() {
        errorText =
            "bu kullanıcı adı başka bir kullanıcı tarafından kullanılıyor";
      });
    } else {
      ref.read(userProfileControllerProvider.notifier).editUserProfile(
            profileFile: profileFile,
            bannerFile: bannerFile,
            context: context,
            name: nameController.text.trim(),
            username: usernameController.text.trim(),
            bio: bioController.text.trim(),
            bannerWebFile: bannerWebFile,
            profileWebFile: profileWebFile,
          );
    }
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(userProfileControllerProvider);
    // final currentTheme = ref.watch(themeNotifierProvider);

    return ref.watch(getUserDataProvider(widget.uid)).when(
          data: (user) => isLoading
              ? const Loader()
              : isLoading
                  ? Loader()
                  : Scaffold(
                      // backgroundColor: currentTheme.backgroundColor,
                      appBar: CupertinoNavigationBar(
                        backgroundColor: Colors.black,
                        leading: CupertinoButton(
                            padding: EdgeInsets.zero,
                            child: const Icon(CupertinoIcons.back),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                        middle: const Text(
                          'profili düzenle',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'JetBrainsMonoExtraBold'),
                        ),
                        trailing: TextButton(
                          onPressed: () async {
                            await save(user);
                          },
                          child: Text(
                            isLoading ? '...' : 'kaydet',
                            style: TextStyle(
                                color: Palette.themeColor,
                                fontFamily: 'JetBrainsMonoBold'),
                          ),
                        ),
                      ),
                      body: Responsive(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView(
                            children: [
                              SizedBox(
                                height: 200,
                                child: Stack(
                                  children: [
                                    GestureDetector(
                                      onTap: selectBannerImage,
                                      child: Container(
                                        width: double.infinity,
                                        height: 150,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 0.8,
                                              color: Palette.textFieldColor),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: bannerWebFile != null
                                              ? Image.memory(
                                                  bannerWebFile!,
                                                  fit: BoxFit.cover,
                                                )
                                              : bannerFile != null
                                                  ? Image.file(
                                                      bannerFile!,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : user.banner.isEmpty ||
                                                          user.banner ==
                                                              Constants
                                                                  .bannerDefault
                                                      ? const Center(
                                                          child: Icon(
                                                            Icons
                                                                .camera_alt_outlined,
                                                            size: 40,
                                                          ),
                                                        )
                                                      : Image.network(
                                                          user.banner,
                                                          fit: BoxFit.cover,
                                                        ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 20,
                                      left: 20,
                                      child: GestureDetector(
                                        onTap: selectProfileImage,
                                        child: SizedBox(
                                          height: 70,
                                          width: 70,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: profileWebFile != null
                                                ? Image.memory(
                                                    profileWebFile!,
                                                    fit: BoxFit.cover,
                                                  )
                                                : profileFile != null
                                                    ? Image.file(
                                                        profileFile!,
                                                        fit: BoxFit.cover,
                                                      )
                                                    : user.profilePic.isEmpty ||
                                                            user.profilePic ==
                                                                Constants
                                                                    .avatarDefault
                                                        ? const Center(
                                                            child: Icon(
                                                              Icons
                                                                  .camera_alt_outlined,
                                                              size: 40,
                                                            ),
                                                          )
                                                        : Image.network(
                                                            user.profilePic,
                                                            fit: BoxFit.cover,
                                                          ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (errorText.isNotEmpty)
                                Text(
                                  errorText,
                                  style: const TextStyle(
                                      color: Palette.redColor,
                                      fontSize: 16,
                                      fontFamily: 'JetBrainsMonoExtraBold'),
                                ),
                              SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  'isim',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: 'JetBrainsMonoBold',
                                  ),
                                ),
                              ),
                              CupertinoTextField(
                                cursorColor: Palette.themeColor,
                                maxLength: 32,
                                controller: nameController,
                                placeholder: 'isim',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'JetBrainsMonoRegular',
                                ),
                                placeholderStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'JetBrainsMonoRegular',
                                ),
                                decoration: BoxDecoration(
                                  color: Palette.textFieldColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^[a-zA-ZğüşıöçĞÜŞİÖÇ\s]*$')),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  'kullanıcı adı',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: 'JetBrainsMonoBold',
                                  ),
                                ),
                              ),
                              CupertinoTextField(
                                cursorColor: Palette.themeColor,
                                maxLength: 32,
                                controller: usernameController,
                                placeholder: 'kullanıcı adı',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'JetBrainsMonoRegular',
                                ),
                                placeholderStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'JetBrainsMonoRegular',
                                ),
                                decoration: BoxDecoration(
                                  color: Palette.textFieldColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(
                                      r'^[a-zA-ZğüşıöçĞÜŞİÖÇ][a-zA-Z0-9ğüşıöçĞÜŞİÖÇ_]*$')),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  'hakkında',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: 'JetBrainsMonoBold',
                                  ),
                                ),
                              ),
                              CupertinoTextField(
                                cursorColor: Palette.themeColor,
                                maxLines: 4,
                                maxLength: 100,
                                controller: bioController,
                                placeholder: 'hakkında',
                                textAlign: TextAlign.start,
                                textAlignVertical: TextAlignVertical.top,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'JetBrainsMonoRegular'),
                                placeholderStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'JetBrainsMonoRegular',
                                ),
                                decoration: BoxDecoration(
                                    color: Palette.textFieldColor,
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
          loading: () => const Loader(),
          error: (error, stackTrace) => ErrorText(
            error: error.toString(),
          ),
        );
  }
}
