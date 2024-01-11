import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musicplayer/pages/explore/view.dart';
import 'package:musicplayer/pages/home/view.dart';
import 'package:musicplayer/pages/music_library/view.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../../common/utils/ScreenAdaptor.dart';
import '../../components/SalomonNavigationRail.dart';
import 'logic.dart';

class AppMainPage extends StatefulWidget {
  const AppMainPage({super.key});

  @override
  State<AppMainPage> createState() => _AppMainPageState();
}

class _AppMainPageState extends State<AppMainPage> {
  final logic = Get.put(AppMainLogic());
  final state = Get.find<AppMainLogic>().state;

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // 侧边导航栏
          _getNavigationRail(),
          // 主页面
          Expanded(
            child: IndexedStack(
              index: _currentIndex == 0 ? 0 : _currentIndex - 1,
              children: const [
                HomePage(),
                ExplorePage(),
                MusicLibraryPage(),
              ],
            ),
          ),
        ],
      ),
      // 底部导航栏
      bottomNavigationBar: _getBottomNavigationBar(),
    );
  }

  // 获取侧边导航栏
  Widget _getNavigationRail() {
    // 如果是横屏，不显示侧边导航栏
    if (ScreenAdaptor.instance.getOrientation()) {
      return const SizedBox();
    }

    return SizedBox(
      width: 100,
      child: SalomonNavigationRail(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        itemPadding: const EdgeInsets.symmetric(
          vertical: 0,
          horizontal: 16,
        ),
        margin: const EdgeInsets.only(
          bottom: 30,
          top: 30,
        ),
        items: [
          /// Home
          SalomonNavigationRailItem(
            icon: const Icon(Icons.home),
            title: const Text("Home"),
          ),

          /// Likes
          SalomonNavigationRailItem(
            icon: const Icon(Icons.favorite_border),
            title: const Text("Likes"),
          ),

          /// Search
          SalomonNavigationRailItem(
            icon: const Icon(Icons.search),
            title: const Text("Search"),
          ),

          /// Profile
          SalomonNavigationRailItem(
            icon: const Icon(Icons.person),
            title: const Text("Profile"),
          ),
        ],
      ),
    );
  }

  // 获取底部导航栏
  SalomonBottomBar? _getBottomNavigationBar() {
    // 如果是竖屏，不显示底部导航栏
    if (!ScreenAdaptor.instance.getOrientation()) {
      return null;
    }
    return SalomonBottomBar(
      currentIndex: _currentIndex,
      onTap: (i) => setState(() => _currentIndex = i),
      margin: const EdgeInsets.only(
        left: 30,
        right: 30,
        bottom: 30,
      ),
      itemPadding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 50,
      ),
      items: [
        /// Home
        SalomonBottomBarItem(
          icon: const Icon(Icons.home),
          title: const Text("Home"),
        ),

        /// Likes
        SalomonBottomBarItem(
          icon: const Icon(Icons.favorite_border),
          title: const Text("Likes"),
        ),

        /// Search
        SalomonBottomBarItem(
          icon: const Icon(Icons.search),
          title: const Text("Search"),
        ),

        /// Profile
        SalomonBottomBarItem(
          icon: const Icon(Icons.person),
          title: const Text("Profile"),
        ),
      ],
    );
  }
}
