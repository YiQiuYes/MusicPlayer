import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musicplayer/common/utils/ScreenAdaptor.dart';
import 'package:musicplayer/common/utils/StaticData.dart';
import 'package:musicplayer/components/DailyTrackscard.dart';
import 'package:musicplayer/components/FMCard.dart';
import 'package:musicplayer/components/RowCover.dart';
import 'package:musicplayer/generated/l10n.dart';

import 'logic.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  final logic = Get.put(HomeLogic());
  final state = Get.find<HomeLogic>().state;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // 页面初始化
    logic.pageInit();
    super.initState();
  }

  @override
  void dispose() {
    state.scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(
            left: ScreenAdaptor().getLengthByOrientation(
              vertical: 30.w,
              horizon: 0,
            ),
            right: ScreenAdaptor().getLengthByOrientation(
              vertical: 30.w,
              horizon: 20.w,
            ),
          ),
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
                    _getGreetBarWidget(),
                    // 搜索框
                    _getSearchBarWidget(),
                  ];
                },
                body: CustomScrollView(
                  slivers: [
                    // by Apple Music
                    _getTitleTextWidget(title: S.of(context).homeByAppleMusic),
                    // by Apple Music专辑组件
                    _getByAppleMusicAlbumWidget(),
                    // 推荐歌单
                    _getTitleTextWidget(
                        title: S.of(context).homeRecommendPlaylist),
                    // 推荐歌单组件
                    _getRecommendPlaylistWidget(),
                    // For You
                    _getTitleTextWidget(title: S.of(context).homeForYou),
                    // For You组件
                    _getForYouWidget(),
                    // 间距
                    _getHeightPaddingWidget(vertical: 40.w, horizon: 20.w),
                    // 推荐艺人
                    _getTitleTextWidget(
                        title: S.of(context).homeRecommendArtist),
                    // 推荐艺人组件
                    _getRecommendArtistsWidget(),
                    // 新专速递
                    _getTitleTextWidget(title: S.of(context).homeNewAlbum),
                    // 新专速递组件
                    _getNewAlbumsWidget(),
                    // 排行榜
                    _getTitleTextWidget(title: S.of(context).homeCharts),
                    // 排行榜组件
                    _getTopListWidget(),
                  ],
                ),
              ),
              // 侧边栏抽屉按钮
              _getDrawerButtonWidget(),
            ],
          ),
        ),
      ),
    );
  }

  /// 间距
  Widget _getHeightPaddingWidget({double vertical = 0, double horizon = 0}) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: ScreenAdaptor().getLengthByOrientation(
          vertical: vertical,
          horizon: horizon,
        ),
      ),
    );
  }

  /// 获取byAppleMusic专辑
  Widget _getByAppleMusicAlbumWidget() {
    return RowCover(
      items: byAppleMusicStaticData,
      subText: "appleMusic",
      type: "playlist",
      imageWidth: ScreenAdaptor().getLengthByOrientation(
        vertical: 250.w,
        horizon: 120.w,
      ),
      imageHeight: ScreenAdaptor().getLengthByOrientation(
        vertical: 250.w,
        horizon: 120.w,
      ),
      horizontalSpacing: ScreenAdaptor().getLengthByOrientation(
        vertical: 30.w,
        horizon: 16.w,
      ),
      fontMainSize: ScreenAdaptor().getLengthByOrientation(
        vertical: 24.sp,
        horizon: 13.sp,
      ),
      fontSubSize: ScreenAdaptor().getLengthByOrientation(
        vertical: 18.sp,
        horizon: 10.sp,
      ),
    );
  }

  /// 获取推荐歌单专辑
  Widget _getRecommendPlaylistWidget() {
    return FutureBuilder(
      future: state.futureRecommendList.value,
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data!.isNotEmpty) {
          return RowCover(
            items: snapshot.data!,
            subText: "copywriter",
            type: "playlist",
            imageWidth: ScreenAdaptor().getLengthByOrientation(
              vertical: 250.w,
              horizon: 120.w,
            ),
            imageHeight: ScreenAdaptor().getLengthByOrientation(
              vertical: 250.w,
              horizon: 120.w,
            ),
            horizontalSpacing: ScreenAdaptor().getLengthByOrientation(
              vertical: 30.w,
              horizon: 16.w,
            ),
            fontMainSize: ScreenAdaptor().getLengthByOrientation(
              vertical: 24.sp,
              horizon: 13.sp,
            ),
            fontSubSize: ScreenAdaptor().getLengthByOrientation(
              vertical: 18.sp,
              horizon: 10.sp,
            ),
          );
        }
        return const SliverToBoxAdapter(child: SizedBox());
      },
    );
  }

  /// 获取For You组件
  Widget _getForYouWidget() {
    return SliverToBoxAdapter(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: ScreenAdaptor().byOrientationReturn(
          horizon: const NeverScrollableScrollPhysics(),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(() {
              return FutureBuilder(
                future: state.futureDailyTracksList.value,
                builder: (
                  BuildContext context,
                  AsyncSnapshot<List<dynamic>> snapshot,
                ) {
                  // 如果数据加载完成且数据不为空
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.data!.isNotEmpty) {
                    return DailyTracksCard(
                      dailyTracksList: snapshot.data,
                      width: ScreenAdaptor().getLengthByOrientation(
                        vertical: 560.w,
                        horizon: 290.w,
                      ),
                      height: ScreenAdaptor().getLengthByOrientation(
                        vertical: 250.w,
                        horizon: 120.w,
                      ),
                    );
                  } else if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.data!.isEmpty) {
                    // 如果数据加载完成且数据为空
                    return DailyTracksCard(
                      width: ScreenAdaptor().getLengthByOrientation(
                        vertical: 560.w,
                        horizon: 290.w,
                      ),
                      height: ScreenAdaptor().getLengthByOrientation(
                        vertical: 250.w,
                        horizon: 120.w,
                      ),
                    );
                  }
                  return SizedBox(
                    width: ScreenAdaptor().getLengthByOrientation(
                      vertical: 560.w,
                      horizon: 290.w,
                    ),
                    height: ScreenAdaptor().getLengthByOrientation(
                      vertical: 250.w,
                      horizon: 120.w,
                    ),
                  );
                },
              );
            }),
            // 间距
            SizedBox(
              width: ScreenAdaptor().getLengthByOrientation(
                vertical: 30.w,
                horizon: 20.w,
              ),
            ),
            // FM
            Obx(
              () {
                return FutureBuilder(
                  future: state.futurePersonalFMList.value,
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<List<dynamic>> snapshot,
                  ) {
                    // 如果数据加载完成且数据不为空
                    if (snapshot.connectionState == ConnectionState.done) {
                      return FMCard(
                        items: snapshot.data,
                        width: ScreenAdaptor().getLengthByOrientation(
                          vertical: 560.w,
                          horizon: 290.w,
                        ),
                        height: ScreenAdaptor().getLengthByOrientation(
                          vertical: 250.w,
                          horizon: 120.w,
                        ),
                      );
                    }
                    return SizedBox(
                      width: ScreenAdaptor().getLengthByOrientation(
                        vertical: 560.w,
                        horizon: 290.w,
                      ),
                      height: ScreenAdaptor().getLengthByOrientation(
                        vertical: 250.w,
                        horizon: 120.w,
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 获取推荐艺人组件
  Widget _getRecommendArtistsWidget() {
    return Obx(() {
      return FutureBuilder(
        future: state.futureRecommendArtistsList.value,
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data!.isNotEmpty) {
            return RowCover(
              items: snapshot.data!,
              type: "artist",
              imageWidth: ScreenAdaptor().getLengthByOrientation(
                vertical: 250.w,
                horizon: 120.w,
              ),
              imageHeight: ScreenAdaptor().getLengthByOrientation(
                vertical: 250.w,
                horizon: 120.w,
              ),
              horizontalSpacing: ScreenAdaptor().getLengthByOrientation(
                vertical: 30.w,
                horizon: 16.w,
              ),
              fontMainSize: ScreenAdaptor().getLengthByOrientation(
                vertical: 24.sp,
                horizon: 13.sp,
              ),
              fontSubSize: ScreenAdaptor().getLengthByOrientation(
                vertical: 18.sp,
                horizon: 10.sp,
              ),
            );
          }
          return const SliverToBoxAdapter(child: SizedBox());
        },
      );
    });
  }

  /// 获取新专速递组件
  Widget _getNewAlbumsWidget() {
    return Obx(() {
      return FutureBuilder(
        future: state.futureNewAlbumsList.value,
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data!.isNotEmpty) {
            return RowCover(
              items: snapshot.data!,
              type: "album",
              subText: "artist",
              imageWidth: ScreenAdaptor().getLengthByOrientation(
                vertical: 250.w,
                horizon: 120.w,
              ),
              imageHeight: ScreenAdaptor().getLengthByOrientation(
                vertical: 250.w,
                horizon: 120.w,
              ),
              horizontalSpacing: ScreenAdaptor().getLengthByOrientation(
                vertical: 30.w,
                horizon: 16.w,
              ),
              fontMainSize: ScreenAdaptor().getLengthByOrientation(
                vertical: 24.sp,
                horizon: 13.sp,
              ),
              fontSubSize: ScreenAdaptor().getLengthByOrientation(
                vertical: 18.sp,
                horizon: 10.sp,
              ),
            );
          }
          return const SliverToBoxAdapter(child: SizedBox());
        },
      );
    });
  }

  /// 获取排行榜组件
  Widget _getTopListWidget() {
    return Obx(() {
      return FutureBuilder(
        future: state.futureTopList.value,
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data!.isNotEmpty) {
            return RowCover(
              items: snapshot.data!,
              type: "playlist",
              subText: "updateFrequency",
              imageWidth: ScreenAdaptor().getLengthByOrientation(
                vertical: 250.w,
                horizon: 120.w,
              ),
              imageHeight: ScreenAdaptor().getLengthByOrientation(
                vertical: 250.w,
                horizon: 120.w,
              ),
              horizontalSpacing: ScreenAdaptor().getLengthByOrientation(
                vertical: 30.w,
                horizon: 16.w,
              ),
              fontMainSize: ScreenAdaptor().getLengthByOrientation(
                vertical: 24.sp,
                horizon: 13.sp,
              ),
              fontSubSize: ScreenAdaptor().getLengthByOrientation(
                vertical: 18.sp,
                horizon: 10.sp,
              ),
            );
          }
          return const SliverToBoxAdapter(child: SizedBox());
        },
      );
    });
  }

  /// 获取标题文本
  Widget _getTitleTextWidget({required String title}) {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.only(
          top: ScreenAdaptor().getLengthByOrientation(
            vertical: 15.w,
            horizon: 10.w,
          ),
          bottom: ScreenAdaptor().getLengthByOrientation(
            vertical: 15.w,
            horizon: 15.w,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: ScreenAdaptor().getLengthByOrientation(
              vertical: 33.sp,
              horizon: 18.sp,
            ),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  /// 侧边栏抽屉按钮
  Widget _getDrawerButtonWidget() {
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

  /// 欢迎语
  Widget _getGreetBarWidget() {
    return SliverAppBar(
      expandedHeight: ScreenAdaptor().getLengthByOrientation(
        vertical: 230.w,
        horizon: 80.w,
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
              horizon: 15.w,
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

  /// 搜索框
  Widget _getSearchBarWidget() {
    return SliverAppBar(
      pinned: true,
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: ScreenAdaptor().getLengthByOrientation(
        vertical: 155.w,
        horizon: 72.w,
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
