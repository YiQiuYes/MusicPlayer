import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musicplayer/generated/l10n.dart';
import 'package:musicplayer/pages/explore/view.dart';
import 'package:musicplayer/pages/home/view.dart';
import 'package:musicplayer/pages/music_library/view.dart';

import '../../common/utils/ScreenAdaptor.dart';
import 'logic.dart';
import '../../common/utils/AppTheme.dart';

class AppMainPage extends StatefulWidget {
  const AppMainPage({super.key});

  @override
  State<AppMainPage> createState() => _AppMainPageState();
}

class _AppMainPageState extends State<AppMainPage>
    with TickerProviderStateMixin {
  final logic = Get.put(AppMainLogic());
  final state = Get.find<AppMainLogic>().state;

  @override
  void initState() {
    // 初始化TabController
    state.tabController = TabController(
      initialIndex: 2,
      length: 3,
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    state.tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: state.scaffoldKey,
      drawer: _getDrawer(),
      body: Row(
        children: [
          // 侧边导航栏
          _getNavigationRail(),
          // 主页面
          Expanded(
            child: _getMainPage(),
          ),
        ],
      ),
      // 底部导航栏
      bottomNavigationBar: _getBottomNavigationBar(),
    );
  }

  // 获取侧边栏
  Widget _getDrawer() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          top: ScreenAdaptor().getLengthByOrientation(
            vertical: 200.w,
            horizon: 12.w,
          ),
          bottom: ScreenAdaptor().getLengthByOrientation(
            vertical: 200.w,
            horizon: 12.w,
          ),
          left: ScreenAdaptor().getLengthByOrientation(
            vertical: 30.w,
            horizon: 15.w,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            ScreenAdaptor().getLengthByOrientation(
              vertical: 30.w,
              horizon: 15.w,
            ),
          ),
          child: Drawer(
            width: ScreenAdaptor().getLengthByOrientation(
              vertical: 500.w,
              horizon: 250.w,
            ),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Obx(() {
                  return SizedBox(
                    height: ScreenAdaptor().getLengthByOrientation(
                      vertical: 270.w,
                      horizon: 140.w,
                    ),
                    child: DrawerHeader(
                      margin: EdgeInsets.zero,
                      padding: EdgeInsets.zero,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            state.avatarUrl.value,
                          ),
                          fit: BoxFit.cover,
                          colorFilter: AppTheme().isDarkMode(
                            dart: ColorFilter.mode(
                              Colors.black.withOpacity(0.5),
                              BlendMode.srcOver,
                            ),
                          ),
                        ),
                      ),
                      child: Align(
                        alignment: Alignment(0, -0.52.w),
                        child: Text(
                          S.of(context).drawerHeaderName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: ScreenAdaptor().getLengthByOrientation(
                              vertical: 45.sp,
                              horizon: 28.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                Padding(
                  padding: EdgeInsets.only(
                    top: ScreenAdaptor().getLengthByOrientation(
                      vertical: 10.w,
                      horizon: 5.w,
                    ),
                    left: ScreenAdaptor().getLengthByOrientation(
                      vertical: 30.w,
                      horizon: 15.w,
                    ),
                    right: ScreenAdaptor().getLengthByOrientation(
                      vertical: 30.w,
                      horizon: 15.w,
                    ),
                  ),
                  child: Column(
                    children: [
                      // 间距
                      SizedBox(
                        height: ScreenAdaptor().getLengthByOrientation(
                          vertical: 10.w,
                          horizon: 5.w,
                        ),
                      ),
                      Card(
                        clipBehavior: Clip.antiAlias,
                        elevation: ScreenAdaptor().getLengthByOrientation(
                          vertical: 11.w,
                          horizon: 7.w,
                        ),
                        child: InkWell(
                          onTap: () {
                            state.scaffoldKey.currentState?.closeDrawer();
                            state.tabController.animateTo(0);
                            state.currentIndex.value = 0;
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: ScreenAdaptor().getLengthByOrientation(
                                vertical: 30.w,
                                horizon: 20.w,
                              ),
                              top: ScreenAdaptor().getLengthByOrientation(
                                vertical: 20.w,
                                horizon: 10.w,
                              ),
                              bottom: ScreenAdaptor().getLengthByOrientation(
                                vertical: 20.w,
                                horizon: 10.w,
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.home),
                                SizedBox(
                                  width: ScreenAdaptor().getLengthByOrientation(
                                    vertical: 30.w,
                                    horizon: 10.w,
                                  ),
                                ),
                                Text(S.of(context).drawerTileHome),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // 间距
                      SizedBox(
                        height: ScreenAdaptor().getLengthByOrientation(
                          vertical: 20.w,
                          horizon: 10.w,
                        ),
                      ),
                      Card(
                        clipBehavior: Clip.antiAlias,
                        elevation: ScreenAdaptor().getLengthByOrientation(
                          vertical: 11.w,
                          horizon: 7.w,
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: ScreenAdaptor().getLengthByOrientation(
                              vertical: 30.w,
                              horizon: 20.w,
                            ),
                            top: ScreenAdaptor().getLengthByOrientation(
                              vertical: 20.w,
                              horizon: 10.w,
                            ),
                            bottom: ScreenAdaptor().getLengthByOrientation(
                              vertical: 20.w,
                              horizon: 10.w,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.settings),
                              SizedBox(
                                width: ScreenAdaptor().getLengthByOrientation(
                                  vertical: 30.w,
                                  horizon: 10.w,
                                ),
                              ),
                              Text(S.of(context).drawerTileSettings),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 获取主页面
  Widget _getMainPage() {
    return TabBarView(
      controller: state.tabController,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        HomePage(),
        ExplorePage(),
        MusicLibraryPage(),
      ],
    );
  }

  // 获取侧边导航栏
  Widget _getNavigationRail() {
    // 如果是横屏，不显示侧边导航栏
    if (ScreenAdaptor().getOrientation()) {
      return const SizedBox();
    }

    return Obx(() {
      return SizedBox(
        width: 90.w,
        child: NavigationRail(
          leading: TextButton(
            onPressed: () {
              state.scaffoldKey.currentState?.openDrawer();
            },
            child: Icon(
              Icons.menu,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          destinations: [
            NavigationRailDestination(
              icon: const Icon(Icons.home_outlined),
              label: Text(S.of(context).navigationBarHome),
              padding: EdgeInsets.only(top: 5.w, bottom: 5.w),
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
            state.tabController.animateTo(index);
            state.currentIndex.value = index;
          },
          labelType: NavigationRailLabelType.selected,
        ),
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
        height: 140.w,
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
          state.tabController.animateTo(index);
        },
      );
    });
  }
}
