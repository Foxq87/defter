import 'package:acc/core/constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../theme/palette.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  PersistentTabController tabController = PersistentTabController();

  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: CupertinoTabBar(
        border: const Border(
            top: BorderSide(
          width: 0.10,
          color: Colors.grey,
        )),
        backgroundColor: Colors.transparent,
        currentIndex: currentIndex,
        onTap: (value) => setState(() => currentIndex = value),
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
              colorFilter:
                  const ColorFilter.mode(Palette.themeColor, BlendMode.srcIn),
            ),
            icon: SvgPicture.asset(
              Constants.squareOutlined,
              colorFilter:
                  const ColorFilter.mode(Palette.themeColor, BlendMode.srcIn),
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
