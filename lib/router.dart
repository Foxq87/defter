//logged out
//logged in
import 'package:acc/core/commons/no_internet_view.dart';
import 'package:acc/features/auth/screens/login_screen.dart';
import 'package:acc/features/auth/screens/suspended_account.dart';
import 'package:acc/features/notes/screens/create_note.dart';
import 'package:acc/features/notes/screens/note_details.dart';
import 'package:acc/features/widget_tree.dart';

import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

import 'core/commons/waiting_to_log_in.dart';
import 'features/school/screens/school_screen.dart';
import 'features/suggest_feature/screens/suggest_feature_screen.dart';
import 'features/updates/screens/create_update_screen.dart';
import 'features/user_profile/screens/edit_user_profile.dart';
import 'features/user_profile/screens/user_profile_screen.dart';

final suspendedAccountRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: SuspendedAccountScreen()),
});

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: LoginScreen()),
});

final noInternetRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: NoInternetView()),
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
  '/user-profile/:uid/edit-profile/:uid': (routeData) => MaterialPage(
        child: EditProfileScreen(
          uid: routeData.pathParameters['uid']!,
        ),
      ),
  '/school-profile/:id': (routeData) => MaterialPage(
        child: SchoolScreen(
          id: routeData.pathParameters['id']!,
        ),
      ),
  '/create-note': (routeData) => const MaterialPage(
        child: CreatePost(),
      ),
  '/note/:postId/details': (routeData) => MaterialPage(
        child: PostDetails(postId: routeData.pathParameters['postId']!),
      ),
  '/suggest-feature-screen': (routeData) => const MaterialPage(
        child: SuggestFeature(),
      ),
  '/create-update-screen': (routeData) => const MaterialPage(
        child: CreateUpdateScreen(),
      ),
});
