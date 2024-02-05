//logged out
//logged in

import 'package:acc/features/auth/screens/login_screen.dart';
import 'package:acc/features/posts/screens/create_post.dart';
import 'package:acc/features/widget_tree.dart';

import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

import 'features/school/screens/school_screen.dart';
import 'features/user_profile/screens/edit_user_profile.dart';
import 'features/user_profile/screens/user_profile_screen.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: LoginScreen()),
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
  '/create-post': (routeData) => const MaterialPage(
        child: CreatePost(),
      ),
});
