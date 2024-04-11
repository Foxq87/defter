import 'package:flutter/material.dart';
import '../../features/features.dart';

class Constants {
  static const String bellOutlined =
      "assets/svgs/bottom-nav-bar-icons/bell-outlined.svg";
  static const String bellFilled =
      "assets/svgs/bottom-nav-bar-icons/bell-filled.svg";
  static const String homeOutlined =
      "assets/svgs/bottom-nav-bar-icons/home-outlined.svg";
  static const String homeFilled =
      "assets/svgs/bottom-nav-bar-icons/home-filled.svg";
  static const String mailOutlined =
      "assets/svgs/bottom-nav-bar-icons/mail-outlined.svg";
  static const String mailFileed =
      "assets/svgs/bottom-nav-bar-icons/mail-filled.svg";
  static const String searchOutlined =
      "assets/svgs/bottom-nav-bar-icons/search-outlined.svg";
  static const String searchFilled =
      "assets/svgs/bottom-nav-bar-icons/search-filled.svg";
  static const String squareOutlined =
      "assets/svgs/bottom-nav-bar-icons/square-outlined.svg";
  static const String squareFilled =
      "assets/svgs/bottom-nav-bar-icons/square-filled.svg";
  static const String bookmarkOutlined = "assets/svgs/bookmark-outlined.svg";
  static const String bookmarkFilled = "assets/svgs/bookmark-filled.svg";
  static const String comment =
      "assets/svgs/bottom-nav-bar-icons/comment-outlined.svg";
  static const String heartOutlined =
      "assets/svgs/bottom-nav-bar-icons/heart-outlined.svg";
  static const String heartFilled =
      "assets/svgs/bottom-nav-bar-icons/heart-filled.svg";
  static const String repost = "assets/svgs/bottom-nav-bar-icons/repost.svg";
  static const String upload = "assets/svgs/bottom-nav-bar-icons/upload.svg";

  //defaults
  static const String bannerDefault =
      'https://upload.wikimedia.org/wikipedia/commons/thumb/0/04/Flag_of_Libya_%281977%E2%80%932011%29.svg/300px-Flag_of_Libya_%281977%E2%80%932011%29.svg.png';
  static const String avatarDefault =
      'https://static.vecteezy.com/system/resources/previews/009/292/244/non_2x/default-avatar-icon-of-social-media-user-vector.jpg';
}

List<Widget> screens = [
  //Home
  const HomeScreen(),
  //Search
  const SearchScreen(),
  //Events
  const UpdatesScreen(),
  //Notifications
  const NotificationsScreen(),
  //Messages
  const Messages()
];
