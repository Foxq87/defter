//logged out
//logged in
import 'package:acc/core/commons/no_internet_view.dart';
import 'package:acc/features/auth/screens/login_screen.dart';
import 'package:acc/features/auth/screens/suspended_account.dart';
import 'package:acc/features/chats/screens/chat_screen.dart';
import 'package:acc/features/marketplace/screens/product_details.dart';
import 'package:acc/features/notes/screens/create_note.dart';
import 'package:acc/features/notes/screens/note_details.dart';
import 'package:acc/features/settings/screens/settings_view.dart';
import 'package:acc/features/widget_tree.dart';

import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

import 'core/commons/new_version_available_screen.dart';
import 'core/commons/waiting_to_log_in.dart';
import 'features/auth/screens/sign_up_view.dart';
import 'features/school/screens/school_screen.dart';
import 'features/suggest_feature/screens/suggest_feature_screen.dart';
import 'features/marketplace/screens/create_product_screen.dart';
import 'features/user_profile/screens/edit_user_profile.dart';
import 'features/user_profile/screens/user_profile_screen.dart';

final suspendedAccountRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: SuspendedAccountScreen()),
});

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: LoginScreen()),
  '/create-account': (routeData) => MaterialPage(
        child: SignUpView(),
      ),
});

final noInternetRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: NoInternetView()),
});
final newVersionRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: NewVersionAvailable()),
});
final waitingToLoginRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: WaitingToLogin()),
});

final loggedInRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: WidgetTree()),
  '/user-profile/:uid': (routeData) => MaterialPage(
        child: UserProfileScreen(
          uid: routeData.pathParameters['uid']!,
        ),
      ),
  '/user-profile/:uid/edit-profile/': (routeData) => MaterialPage(
        child: EditProfileScreen(
          uid: routeData.pathParameters['uid']!,
        ),
      ),
  '/school-profile/:id': (routeData) => MaterialPage(
        child: SchoolScreen(
          id: routeData.pathParameters['id']!,
        ),
      ),
  '/product/:id': (routeData) => MaterialPage(
        child: ProductDetails(
          productId: routeData.pathParameters['id']!,
        ),
      ),
  '/create-note': (routeData) => const MaterialPage(
        child: CreateNote(),
      ),
  '/note/:noteId': (routeData) => MaterialPage(
        child: NoteDetails(noteId: routeData.pathParameters['noteId']!),
      ),
  '/suggest-feature-screen': (routeData) => const MaterialPage(
        child: SuggestFeature(),
      ),
  '/create-update-screen': (routeData) => const MaterialPage(
        child: CreateProductScreen(
          product: null,
        ),
      ),
  '/settings': (routeData) => const MaterialPage(
        child: SettingsView(),
      ),
  '/chat/:chatId/:isDM': (routeData) => MaterialPage(
        child: ChatScreen(
            chatId: routeData.pathParameters['chatId']!,
            isDM: bool.parse(routeData.pathParameters['isDM']!)),
      ),
});
