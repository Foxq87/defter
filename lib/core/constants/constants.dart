import 'package:acc/features/chats/screens/chats_screen.dart';
import 'package:flutter/material.dart';
import '../../features/features.dart';

class Constants {
  static const List categories = [
    [
      'atıştırmalık',
      ['çikolata', 'cips', 'bisküvi', 'kraker', 'kuruyemiş', 'diğer']
    ],
    [
      'içecek',
      [
        'gazlı içecek',
        'maden suyu',
        'ayran & süt',
        'buzlu çay',
        'meyve suyu',
        'diğer'
      ]
    ],
    [
      'kıyafet',
      [
        'pantolon & eşofman',
        'tişört',
        'gömlek',
        'kazak',
        'sweatshirt & hırka',
        'diğer'
      ]
    ],
    [
      'kırtasiye',
      [
        'okuma kitabı',
        'test kitabı',
        'defter',
        'kalem',
        'silgi',
        'ek malzemeler',
        'diğer'
      ]
    ],
    [
      'ayak giyim',
      ['ayakkabı', 'futbol ayakkabısı', 'terlik', 'diğer']
    ],
    ['diğer'],
  ];

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
  static const String bookmarkFilled = "assets/svgs/bookmark-outlined.svg";
  static const String bookmarkOutlined = "assets/svgs/bookmark-filled.svg";
  static const String comment =
      "assets/svgs/bottom-nav-bar-icons/comment-outlined.svg";
  static const String send = "assets/svgs/send-outlined.svg";
  static const String heartOutlined =
      "assets/svgs/bottom-nav-bar-icons/heart-outlined.svg";
  static const String heartFilled =
      "assets/svgs/bottom-nav-bar-icons/heart-filled.svg";
  static const String renote = "assets/svgs/bottom-nav-bar-icons/renote.svg";
  static const String upload = "assets/svgs/bottom-nav-bar-icons/upload.svg";

  static const String crown = "assets/svgs/crown.svg";

  //defaults
  static const String bannerDefault =
      'https://upload.wikimedia.org/wikipedia/commons/thumb/0/04/Flag_of_Libya_%281977%E2%80%932011%29.svg/300px-Flag_of_Libya_%281977%E2%80%932011%29.svg.png';
  static const String avatarDefault =
      'https://static.vecteezy.com/system/resources/previews/009/292/244/non_2x/default-avatar-icon-of-social-media-user-vector.jpg';
  static const String moderator = "assets/svgs/moderator.svg";
  static const String developer = "assets/svgs/html-code.svg";
  static const String systemUid = 'ku0DDDpShoR8dqhhhx3IIbtpE5u1';
}

List<Widget> screens = [
  //Home
  const HomeScreen(),
  //Search
  const SearchScreen(
    isForChat: false,
  ),
  //Events
  const MarketplaceScreen(),
  //Notifications
  const NotificationsScreen(),
  //Messages
  const ChatsScreen()
];
