import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musicplayer/generated/l10n.dart';
import 'package:musicplayer/pages/explore/view.dart';
import 'package:musicplayer/pages/home/view.dart';
import 'package:musicplayer/pages/music_library/view.dart';

import '../../common/utils/ScreenAdaptor.dart';
import 'logic.dart';

class AppMainPage extends StatefulWidget {
  const AppMainPage({super.key});

  @override
  State<AppMainPage> createState() => _AppMainPageState();
}

class _AppMainPageState extends State<AppMainPage> {
  final logic = Get.put(AppMainLogic());
  final state = Get.find<AppMainLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // 侧边导航栏
          _getNavigationRail(),
          // 主页面
          Expanded(
            // 获取主页面
            child: _getMainPage(),
          ),
        ],
      ),
      // 底部导航栏
      bottomNavigationBar: _getBottomNavigationBar(),
    );
  }

  // 获取主页面
  Widget _getMainPage() {
    return Obx(() {
      return IndexedStack(
        index: state.currentIndex.value,
        children: const [
          HomePage(),
          ExplorePage(),
          MusicLibraryPage(),
        ],
      );
    });
  }

  // 获取侧边导航栏
  Widget _getNavigationRail() {
    // 如果是横屏，不显示侧边导航栏
    if (ScreenAdaptor().getOrientation()) {
      return const SizedBox();
    }

    return Obx(() {
      return NavigationRail(
        destinations: [
          NavigationRailDestination(
            icon: const Icon(Icons.home_outlined),
            label: Text(S.of(context).navigationBarHome),
            padding: EdgeInsets.only(top: 15.w, bottom: 5.w),
            selectedIcon: const Icon(Icons.home),
          ),
          NavigationRailDestination(
            icon: const Icon(Icons.explore_outlined),
            label: Text(S.of(context).navigationBarExplore),
            padding: EdgeInsets.only(top: 5.w, bottom: 5.w),
            selectedIcon: const Icon(Icons.explore),
          ),
          NavigationRailDestination(
            icon: const Icon(Icons.library_music_outlined),
            label: Text(S.of(context).navigationBarMusicLibrary),
            padding: EdgeInsets.only(top: 5.w, bottom: 5.w),
            selectedIcon: const Icon(Icons.library_music),
          ),
        ],
        selectedIndex: state.currentIndex.value,
        onDestinationSelected: (int index) {
          state.currentIndex.value = index;
        },
        labelType: NavigationRailLabelType.selected,
      );
    });
  }

  // 获取底部导航栏
  Widget? _getBottomNavigationBar() {
    // 如果是竖屏，不显示底部导航栏
    if (!ScreenAdaptor().getOrientation()) {
      return null;
    }
    return Obx(() {
      return NavigationBar(
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            label: S.of(context).navigationBarHome,
            selectedIcon: const Icon(Icons.home),
          ),
          NavigationDestination(
            icon: const Icon(Icons.explore_outlined),
            label: S.of(context).navigationBarExplore,
            selectedIcon: const Icon(Icons.explore),
          ),
          NavigationDestination(
            icon: const Icon(Icons.library_music_outlined),
            label: S.of(context).navigationBarMusicLibrary,
            selectedIcon: const Icon(Icons.library_music),
          ),
        ],
        selectedIndex: state.currentIndex.value,
        onDestinationSelected: (int index) {
          state.currentIndex.value = index;
        },
      );
    });
  }
}
