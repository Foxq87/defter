import 'dart:async';
import 'dart:io';

import 'package:acc/core/commons/error_text.dart';
import 'package:acc/core/commons/loader.dart';
import 'package:acc/features/auth/controller/auth_controller.dart';
import 'package:acc/models/user_model.dart';
import 'package:acc/router.dart';
import 'package:acc/theme/palette.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:routemaster/routemaster.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  late StreamSubscription internetSubscription;
  final _firebaseMessaging = FirebaseMessaging.instance;
  UserModel? userModel;
  bool hasInternet = false;

  @override
  void initState() {
    super.initState();
    internetSubscription =
        InternetConnectionChecker().onStatusChange.listen((status) {
      final hasInternet = status == InternetConnectionStatus.connected;
      setState(() => this.hasInternet = hasInternet);
    });
  }

  Future<void> getData(WidgetRef ref, User data) async {
    userModel = await ref
        .watch(authControllerProvider.notifier)
        .getUserData(data.uid)
        .first;
    ref.read(userProvider.notifier).update((state) => userModel);
    configurePushNotifications(data);
    // print(userModel?.email);
  }

  configurePushNotifications(User data) async {
    final userId = data.uid;
    if (Platform.isIOS) {
      getiOSPermission();
      await _firebaseMessaging.getAPNSToken().then((token) async {
        //  print("Firebase Messaging Token: $token\n");
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({"notificationToken": token});
      });
    } else if (Platform.isAndroid) {
      await _firebaseMessaging.getToken().then((token) async {
        // print("Firebase Messaging Token: $token\n");
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({"notificationToken": token});
      });
    } else {
      throw Exception("Unsupported platform");
    }
  }

  getiOSPermission() {
    _firebaseMessaging.requestPermission(alert: true, badge: true, sound: true);
  }

// MaterialApp.router(
//               title: 'defter',
//               debugShowCheckedModeBanner: false,
//               theme: ThemeData(
//                 brightness: Brightness.dark,
//                 scaffoldBackgroundColor: Palette.backgroundColor,
//                 fontFamily: "JetBrainsMonoRegular",
//               ),
//               routerDelegate: RoutemasterDelegate(
//                   navigatorKey: Get.key,
//                   routesBuilder: (context) {
//                     if (data != null) {
//                       getData(ref, data);
//                       if (userModel != null) {
//                         return loggedInRoute;
//                       }
//                     } else {
//                       return loggedOutRoute;
//                     }
//                     return waitingToLoginRoute;
//                   }),
//               routeInformationParser: const RoutemasterParser(),
//             ),
  @override
  Widget build(BuildContext context) {
    return ref.watch(authStateChangeProvider).when(
        data: (data) => data == null
            ? MaterialApp.router(
                title: 'defter',
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  brightness: Brightness.dark,
                  scaffoldBackgroundColor: Palette.backgroundColor,
                  fontFamily: "JetBrainsMonoRegular",
                ),
                // ... other properties ...
                routerDelegate: RoutemasterDelegate(
                  navigatorKey: Get.key,
                  routesBuilder: (context) => loggedOutRoute,
                ),
                routeInformationParser: const RoutemasterParser(),
              )
            : FutureBuilder(
                future: getData(ref, data),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return MaterialApp.router(
                      title: 'defter',
                      debugShowCheckedModeBanner: false,
                      theme: ThemeData(
                        brightness: Brightness.dark,
                        scaffoldBackgroundColor: Palette.backgroundColor,
                        fontFamily: "JetBrainsMonoRegular",
                      ),
                      // ... other properties ...
                      routerDelegate: RoutemasterDelegate(
                        navigatorKey: Get.key,
                        routesBuilder: (context) => waitingToLoginRoute,
                      ),
                      routeInformationParser: const RoutemasterParser(),
                    );
                  } else {
                    return MaterialApp.router(
                      // ... other properties ...
                      title: 'defter',
                      debugShowCheckedModeBanner: false,
                      theme: ThemeData(
                        brightness: Brightness.dark,
                        scaffoldBackgroundColor: Palette.backgroundColor,
                        fontFamily: "JetBrainsMonoRegular",
                      ),
                      routerDelegate: RoutemasterDelegate(
                        navigatorKey: Get.key,
                        routesBuilder: (context) => userModel != null
                            ? userModel!.isSuspended
                                ? suspendedAccountRoute
                                : loggedInRoute
                            : waitingToLoginRoute,
                      ),
                      routeInformationParser: const RoutemasterParser(),
                    );
                  }
                },
              ),
        error: (error, stacktrace) => ErrorText(error: error.toString()),
        loading: () => const Loader());
  }
}
