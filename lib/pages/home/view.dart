import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musicplayer/common/utils/ScreenAdaptor.dart';
import 'package:musicplayer/components/Cover.dart';
import 'package:musicplayer/generated/l10n.dart';

import 'logic.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final logic = Get.put(HomeLogic());
  final state = Get.find<HomeLogic>().state;

  @override
  void dispose() {
    state.scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          left: ScreenAdaptor().getLengthByOrientation(
            vertical: 30.w,
            horizon: 10.w,
          ),
          right: ScreenAdaptor().getLengthByOrientation(
            vertical: 30.w,
            horizon: 20.w,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // 滚动视图
              NestedScrollView(
                physics: const BouncingScrollPhysics(),
                controller: state.scrollController,
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return [
                    // 欢迎语
                    _getGreetBar(),
                    // 搜索框
                    _getSearchBar(),
                  ];
                },
                body: CustomScrollView(
                  slivers: [
                    // by Apple Music
                    _getTitleText(title: S.of(context).homeByAppleMusic),
                    SliverToBoxAdapter(
                      child: Cover(
                        imageUrl:
                            "https://p1.music.126.net/ZtQOTgvhqrcWYapiPj9NWQ==/19018252626210242.jpg",
                      ),
                    ),
                    // 推荐歌单
                    _getTitleText(title: S.of(context).homeRecommendPlaylist),
                    // For You
                    _getTitleText(title: S.of(context).homeForYou),
                    // 推荐艺人
                    _getTitleText(title: S.of(context).homeRecommendArtist),
                    // 新专速递
                    _getTitleText(title: S.of(context).homeNewAlbum),
                    // 排行榜
                    _getTitleText(title: S.of(context).homeCharts),
                  ],
                ),
              ),
              // 侧边栏抽屉按钮
              _getDrawerButton(),
            ],
          ),
        ),
      ),
    );
  }

  // 获取标题文本
  Widget _getTitleText({required String title}) {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.only(
          top: ScreenAdaptor().getLengthByOrientation(
            vertical: 15.w,
            horizon: 25.w,
          ),
          bottom: ScreenAdaptor().getLengthByOrientation(
            vertical: 15.w,
            horizon: 25.w,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: ScreenAdaptor().getLengthByOrientation(
              vertical: 33.sp,
              horizon: 15.sp,
            ),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // 侧边栏抽屉按钮
  Widget _getDrawerButton() {
    if (ScreenAdaptor().getOrientation()) {
      return Positioned(
        left: 0.w,
        top: 25.w,
        child: TextButton(
          child: Icon(
            Icons.menu,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      );
    }
    return const SizedBox();
  }

  // 欢迎语
  Widget _getGreetBar() {
    return SliverAppBar(
      expandedHeight: ScreenAdaptor().getLengthByOrientation(
        vertical: 230.w,
        horizon: 70.w,
      ),
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: EdgeInsets.only(
            left: ScreenAdaptor().getLengthByOrientation(
              vertical: 35.w,
              horizon: 18.w,
            ),
            top: ScreenAdaptor().getLengthByOrientation(
              vertical: 115.w,
              horizon: 20.w,
            ),
          ),
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              Text(
                S.of(context).homeGreetText,
                style: TextStyle(
                  fontSize: ScreenAdaptor().getLengthByOrientation(
                    vertical: 40.sp,
                    horizon: 20.sp,
                  ),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "易秋",
                style: TextStyle(
                  fontSize: ScreenAdaptor().getLengthByOrientation(
                    vertical: 30.sp,
                    horizon: 20.sp,
                  ),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 搜索框
  Widget _getSearchBar() {
    return SliverAppBar(
      pinned: true,
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: ScreenAdaptor().getLengthByOrientation(
        vertical: 155.w,
        horizon: 70.w,
      ),
      title: Align(
        alignment: Alignment.centerRight,
        child: AnimatedBuilder(
          animation: state.scrollController,
          builder: (context, child) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: max(
                MediaQuery.sizeOf(context).width -
                    state.scrollController.offset.roundToDouble(),
                MediaQuery.sizeOf(context).width -
                    (ScreenAdaptor().getOrientation() ? 230.w : 0),
              ),
              padding: EdgeInsets.only(
                top: ScreenAdaptor().getLengthByOrientation(
                  vertical: 13.w,
                  horizon: 8.w,
                ),
                bottom: ScreenAdaptor().getLengthByOrientation(
                  vertical: 15.w,
                  horizon: 8.w,
                ),
              ),
              child: SizedBox(
                height: ScreenAdaptor().getLengthByOrientation(
                  vertical: 90.w,
                  horizon: 50.w,
                ),
                child: SearchBar(
                  leading: Padding(
                    padding: EdgeInsets.only(
                      left: ScreenAdaptor().getLengthByOrientation(
                        vertical: 13.w,
                        horizon: 8.w,
                      ),
                      right: ScreenAdaptor().getLengthByOrientation(
                        vertical: 5.w,
                        horizon: 2.w,
                      ),
                    ),
                    child: const Icon(Icons.search),
                  ),
                  hintText: S.of(context).homeSearchBar,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
