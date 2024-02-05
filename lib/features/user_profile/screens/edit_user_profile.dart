import 'dart:io';

import 'package:acc/theme/palette.dart';
import 'package:acc/core/constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: ref.read(userProvider)!.name);
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
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

  void save() {
    ref.read(userProfileControllerProvider.notifier).editUserProfile(
          profileFile: profileFile,
          bannerFile: bannerFile,
          context: context,
          name: nameController.text.trim(),
          bannerWebFile: bannerWebFile,
          profileWebFile: profileWebFile,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(userProfileControllerProvider);
    // final currentTheme = ref.watch(themeNotifierProvider);

    return ref.watch(getUserDataProvider(widget.uid)).when(
          data: (user) => Scaffold(
            // backgroundColor: currentTheme.backgroundColor,
            appBar: CupertinoNavigationBar(
              backgroundColor: Colors.black,
              leading: CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: const Icon(CupertinoIcons.back),
                  onPressed: () {
                    Routemaster.of(context).pop();
                  }),
              middle: const Text(
                'Edit Profile',
                style: TextStyle(
                    color: Colors.white, fontFamily: 'JetBrainsMonoExtraBold'),
              ),
              trailing: TextButton(
                onPressed: save,
                child: const Text(
                  'Done',
                  style: TextStyle(
                      color: Palette.themeColor,
                      fontFamily: 'JetBrainsMonoBold'),
                ),
              ),
            ),
            body: isLoading
                ? const Loader()
                : Responsive(
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
                                          color: Palette.textfieldColor),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
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
                                        borderRadius: BorderRadius.circular(15),
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
                          CupertinoTextField(
                            controller: nameController,
                            placeholder: 'Name',
                            style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'JetBrainsMonoRegular'),
                            placeholderStyle: const TextStyle(
                                color: Colors.grey,
                                fontFamily: 'JetBrainsMonoRegular'),
                            decoration: BoxDecoration(
                                color: Palette.textfieldColor,
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CupertinoTextField(
                            maxLines: 4,
                            // controller: nameController,
                            placeholder: 'Bio',
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
                                color: Palette.textfieldColor,
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
