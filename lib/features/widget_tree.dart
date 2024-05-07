// import 'package:acc/core/constants/constants.dart';
// import 'package:acc/core/utils.dart';
// import 'package:acc/features/auth/controller/auth_controller.dart';
// import 'package:acc/features/auth/screens/setup_profile.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:upgrader/upgrader.dart';
// import '../theme/palette.dart';

// class WidgetTree extends ConsumerStatefulWidget {
//   const WidgetTree({super.key});
//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _WidgetTreeState();
// }

// class _WidgetTreeState extends ConsumerState<WidgetTree> {
// final _firebaseMessaging = FirebaseMessaging.instance;

// @override
// void initState() {
//   super.initState();
//   final user = ref.read(userProvider)!;
//   configureNotifications(user.uid);
// }

// configureNotifications(String userId) {
//   FirebaseMessaging.onMessage.listen((remoteMessage) {
//     String recipientId = remoteMessage.senderId!;
//     if (recipientId == userId) {
//       print('Notification shown');

//       showSnackBar(context, remoteMessage.notification!.body.toString());
//     } else {
//       print("Notification not shown");
//     }
//   });
//   // FirebaseMessaging.onBackgroundMessage((remoteMessage) async {
//   //   await Firebase.initializeApp();
//   // });
// }

//   int currentIndex = 0;
//   @override
//   Widget build(BuildContext context) {
// final user = ref.read(userProvider)!;
// return ref.watch(authControllerProvider.notifier).isUserNoSetup(ref)
//     ? SetupProfile(user: user)
//     : UpgradeAlert(
//         canDismissDialog: false,
//         showIgnore: false,
//         showLater: false,
//         child: Scaffold(
//               body: screens[currentIndex],
// bottomNavigationBar: CupertinoTabBar(
//   border: const Border(
//     top: BorderSide(
//       width: 0.10,
//       color: Colors.grey,
//     ),
//   ),
//   backgroundColor: Colors.black.withOpacity(0.4),
//   currentIndex: currentIndex,
//   onTap: (value) => setState(() => currentIndex = value),
//   items: [
//     BottomNavigationBarItem(
//       activeIcon: SvgPicture.asset(
//         Constants.homeFilled,
//         colorFilter:
//             const ColorFilter.mode(Colors.white, BlendMode.srcIn),
//       ),
//       icon: SvgPicture.asset(
//         Constants.homeOutlined,
//         colorFilter:
//             const ColorFilter.mode(Colors.white, BlendMode.srcIn),
//       ),
//     ),
//     BottomNavigationBarItem(
//       activeIcon: SvgPicture.asset(
//         Constants.searchFilled,
//         colorFilter:
//             const ColorFilter.mode(Colors.white, BlendMode.srcIn),
//       ),
//       icon: SvgPicture.asset(
//         Constants.searchOutlined,
//         colorFilter:
//             const ColorFilter.mode(Colors.white, BlendMode.srcIn),
//       ),
//     ),
//     BottomNavigationBarItem(
//       activeIcon: SvgPicture.asset(
//         Constants.squareFilled,
//         colorFilter: const ColorFilter.mode(
//             Palette.themeColor, BlendMode.srcIn),
//       ),
//       icon: SvgPicture.asset(
//         Constants.squareOutlined,
//         colorFilter: const ColorFilter.mode(
//             Palette.themeColor, BlendMode.srcIn),
//       ),
//     ),
//     BottomNavigationBarItem(
//       activeIcon: SvgPicture.asset(
//         Constants.bellFilled,
//         colorFilter:
//             const ColorFilter.mode(Colors.white, BlendMode.srcIn),
//       ),
//       icon: SvgPicture.asset(
//         Constants.bellOutlined,
//         colorFilter:
//             const ColorFilter.mode(Colors.white, BlendMode.srcIn),
//       ),
//     ),
//     BottomNavigationBarItem(
//       activeIcon: SvgPicture.asset(
//         Constants.mailFileed,
//         colorFilter:
//             const ColorFilter.mode(Colors.white, BlendMode.srcIn),
//       ),
//       icon: SvgPicture.asset(
//         Constants.mailOutlined,
//         colorFilter:
//             const ColorFilter.mode(Colors.white, BlendMode.srcIn),
//       ),
//     ),
//   ],
// ),
//   ),
// );
//   }
// }

import 'package:acc/core/constants/constants.dart';
import 'package:acc/core/utils.dart';
import 'package:acc/features/auth/controller/auth_controller.dart';
import 'package:acc/features/auth/screens/setup_profile.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import '../theme/palette.dart';

class WidgetTree extends ConsumerStatefulWidget {
  const WidgetTree({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends ConsumerState<WidgetTree>
    with AutomaticKeepAliveClientMixin<WidgetTree> {
  @override
  bool get wantKeepAlive => true;
  int _selectedPageIndex = 0;
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider)!;
    configureNotifications(user.uid);
    _selectedPageIndex = 0;

    _pageController = PageController(initialPage: _selectedPageIndex);
  }

  configureNotifications(String userId) {
    FirebaseMessaging.onMessage.listen((remoteMessage) {
      String recipientId = remoteMessage.senderId!;
      if (recipientId == userId) {
        print('Notification shown');

        showSnackBar(context, remoteMessage.notification!.body.toString());
      } else {
        print("Notification not shown");
      }
    });
    // FirebaseMessaging.onBackgroundMessage((remoteMessage) async {
    //   await Firebase.initializeApp();
    // });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final user = ref.read(userProvider)!;
    return ref.watch(authControllerProvider.notifier).isUserNotSetup(ref)
        ? SetupProfile(user: user)
        : Scaffold(
            body: PageView(
              controller: _pageController,
              //The following parameter is just to prevent
              //the user from swiping to the next page.
              physics: NeverScrollableScrollPhysics(),
              children: screens,
            ),
            bottomNavigationBar: CupertinoTabBar(
              border: const Border(
                top: BorderSide(
                  width: 0.10,
                  color: Colors.grey,
                ),
              ),
              backgroundColor: Colors.black.withOpacity(0.4),
              currentIndex: _selectedPageIndex,
              onTap: (value) => setState(() {
                _selectedPageIndex = value;
                _pageController.jumpToPage(value);
              }),
              items: [
                BottomNavigationBarItem(
                  activeIcon: SvgPicture.asset(
                    Constants.homeFilled,
                    colorFilter:
                        const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                  icon: SvgPicture.asset(
                    Constants.homeOutlined,
                    colorFilter:
                        const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                ),
                BottomNavigationBarItem(
                  activeIcon: SvgPicture.asset(
                    Constants.searchFilled,
                    colorFilter:
                        const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                  icon: SvgPicture.asset(
                    Constants.searchOutlined,
                    colorFilter:
                        const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                ),
                BottomNavigationBarItem(
                  activeIcon: SvgPicture.asset(
                    Constants.squareFilled,
                    colorFilter: const ColorFilter.mode(
                        Palette.themeColor, BlendMode.srcIn),
                  ),
                  icon: SvgPicture.asset(
                    Constants.squareOutlined,
                    colorFilter: const ColorFilter.mode(
                        Palette.themeColor, BlendMode.srcIn),
                  ),
                ),
                BottomNavigationBarItem(
                  activeIcon: SvgPicture.asset(
                    Constants.bellFilled,
                    colorFilter:
                        const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                  icon: SvgPicture.asset(
                    Constants.bellOutlined,
                    colorFilter:
                        const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                ),
                BottomNavigationBarItem(
                  activeIcon: SvgPicture.asset(
                    Constants.mailFileed,
                    colorFilter:
                        const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                  icon: SvgPicture.asset(
                    Constants.mailOutlined,
                    colorFilter:
                        const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                ),
              ],
            ),
          );
  }
}
