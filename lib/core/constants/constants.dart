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
        'ceket',
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
    ['diğer', []],
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
  static const String edit = 'assets/svgs/edit.svg';

  static const String crown = "assets/svgs/crown.svg";
  static const String eulaLink =
      "https://docs.google.com/document/d/1o61TIQ6T5z-SWfjd8FiTn6Pn4gZVwhbULhoBGCnaNsw/edit?usp=sharing";

  static const String privacyPolicyLink =
      "https://doc-hosting.flycricket.io/defter-terms-of-use/0e499657-c82d-4f12-bbdf-fbb5d665bfaa/terms";
  //defaults
  static const String bannerDefault =
      'https://upload.wikimedia.org/wikipedia/commons/thumb/0/04/Flag_of_Libya_%281977%E2%80%932011%29.svg/300px-Flag_of_Libya_%281977%E2%80%932011%29.svg.png';
  static const String avatarDefault =
      'https://static.vecteezy.com/system/resources/previews/009/292/244/non_2x/default-avatar-icon-of-social-media-user-vector.jpg';
  static const String chatAvatarDefault =
      'https://firebasestorage.googleapis.com/v0/b/appbeyoglu.appspot.com/o/chats%2FScreenshot%202024-05-06%20at%2020.45.00.png?alt=media&token=422cdb82-feb6-4eb7-80d6-fe6c6f9059ce';

  static const String moderator = "assets/svgs/moderator.svg";
  static const String developer = "assets/svgs/html-code.svg";
  static const String systemUid = 'ku0DDDpShoR8dqhhhx3IIbtpE5u1';
  static const String shoppingBag =
      'assets/svgs/bottom-nav-bar-icons/shopping_bag.svg';
  static const String shoppingBagFilled =
      'assets/svgs/bottom-nav-bar-icons/shopping_bag_filled.svg';
  static const String downArrow = 'assets/svgs/down-arrow.svg';
  static const String upArrow = 'assets/svgs/up-arrow.svg';
  static const String bagOutlined = 'assets/svgs/bag-outlined.svg';
  static const String bagFilled = 'assets/svgs/bag-filled.svg';
}

List<Widget> screens = [
  //Home
  const HomeScreen(),
  //Search
  // const SearchScreen(),
  //Events
  const MarketplaceScreen(),
  //Notifications
  const NotificationsScreen(),
  //Messages
  const ChatsScreen()
];
