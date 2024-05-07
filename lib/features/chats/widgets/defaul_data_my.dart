import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_reactions/model/menu_item.dart';
import 'package:unicons/unicons.dart';

class DefaultData {
// default list of five reactions to be displayed from emojis and a plus icon at the end
// the plus icon will be used to add more reactions
  static const List<String> reactions = [
    '👍',
    '❤️',
    '😂',
    '😮',
    '😢',
    '😠',
    '➕',
  ];
  // The default list of menuItems
  static const List<MenuItem> menuItems = [
    copy,
    delete,
  ];

  // defaul reply menu item
  // static const MenuItem reply = MenuItem(
  //   label: 'Reply',
  //   icon: Icons.reply,
  // );

  // default copy menu item
  static const MenuItem copy = MenuItem(
    label: 'kopyala',
    icon: UniconsLine.copy,
  );

  // default edit menu item
  static const MenuItem delete = MenuItem(
    label: 'sil',
    icon: CupertinoIcons.delete,
    isDestuctive: true,
  );
}
