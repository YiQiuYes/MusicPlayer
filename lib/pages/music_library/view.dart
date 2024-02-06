import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musicplayer/common/utils/AppTheme.dart';
import 'package:musicplayer/common/utils/ScreenAdaptor.dart';
import 'package:musicplayer/components/MvRow.dart';
import 'package:musicplayer/components/RowCover.dart';
import 'package:musicplayer/components/TrackList.dart';
import 'package:musicplayer/generated/l10n.dart';

import 'logic.dart';

class MusicLibraryPage extends StatefulWidget {
  const MusicLibraryPage({super.key});

  @override
  State<MusicLibraryPage> createState() => _MusicLibraryPageState();
}

class _MusicLibraryPageState extends State<MusicLibraryPage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  final logic = Get.put(MusicLibraryLogic());
  final state = Get.find<MusicLibraryLogic>().state;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // 页面初始化
    logic.pageInit();
    state.tabController = TabController(
      length: 6,
      vsync: this,
    );
    state.tabControllerHistorySongsRank = TabController(
      length: 2,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    // 状态栏颜色
    AppTheme.statusBarAndBottomBarImmersed();
    super.build(context);
    return SafeArea(
      left: false,
      right: false,
      bottom: false,
      child: Scaffold(
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
          child: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool isTrue) {
              return [
                // AppBar
                _getAppBarWidget(),
                // 间距
                _getHeightPaddingWidget(vertical: 28.w, horizon: 15.w),
                // 用户名
                _getUserNameWidget(),
                // 间距
                _getHeightPaddingWidget(vertical: 50.w, horizon: 30.w),
                // 获取我喜欢的音乐和我喜欢的歌曲
                _getILoveAndLikeSongsWidget(),
                // 间距
                _getHeightPaddingWidget(vertical: 50.w, horizon: 30.w),
                // TabBar条
                _getTabBarWidget(),
                // 听歌排行TabBar
                _getHistorySongsRankTabBarWidget(),
              ];
            },
            // TabBarView
            body: _getTabBarViewWidget(),
          ),
        ),
      ),
    );
  }

  /// 获取TabBarView
  Widget _getTabBarViewWidget() {
    return TabBarView(
      controller: state.tabController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        // 全部歌单
        _getAllPlayListTabBarViewWidget(),
        // 专辑
        _getLikedAlbumsTabBarViewWidget(),
        // 艺人
        _getLikedArtistsTabBarViewWidget(),
        // MV
        _getLikedMVsTabBarViewWidget(),
        // 云盘歌曲
        _getCloudDiskSongsTabBarViewWidget(),
        // 听歌排行
        _getHistorySongsRankWidget(),
      ],
    );
  }

  /// 获取全部歌单
  Widget _getAllPlayListTabBarViewWidget() {
    return CustomScrollView(
      anchor: ScreenAdaptor().getLengthByOrientation(
        vertical: 0.13.w,
        horizon: 0.12.w,
      ),
      slivers: [
        Obx(() {
          return FutureBuilder(
            future: state.futureUserPlayList.value,
            builder:
                (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return SliverLayoutBuilder(
                  builder:
                      (BuildContext context, SliverConstraints constraints) {
                    int columnNumber = ScreenAdaptor().byOrientationReturn(
                      vertical: 3,
                      horizon: 5,
                    )!;
                    double horizontalSpacing =
                        ScreenAdaptor().getLengthByOrientation(
                      vertical: 30.w,
                      horizon: 10.w,
                    );
                    double size = (constraints.crossAxisExtent -
                            (columnNumber - 1) * horizontalSpacing) /
                        columnNumber;
                    return RowCover(
                      items: snapshot.data!,
                      subText: "creator",
                      type: "playlist",
                      columnNumber: columnNumber,
                      imageWidth: ScreenAdaptor().getLengthByOrientation(
                        vertical: 200.w,
                        horizon: size,
                      ),
                      imageHeight: ScreenAdaptor().getLengthByOrientation(
                        vertical: 200.w,
                        horizon: size,
                      ),
                      horizontalSpacing: horizontalSpacing,
                      fontMainSize: ScreenAdaptor().getLengthByOrientation(
                        vertical: 20.sp,
                        horizon: 11.sp,
                      ),
                      fontSubSize: ScreenAdaptor().getLengthByOrientation(
                        vertical: 15.sp,
                        horizon: 9.sp,
                      ),
                    );
                  },
                );
              }
              return const SliverToBoxAdapter(child: SizedBox());
            },
          );
        }),
        // 间距
        _getHeightPaddingWidget(vertical: 50.w, horizon: 30.w),
      ],
    );
  }

  /// 获取专辑
  Widget _getLikedAlbumsTabBarViewWidget() {
    return CustomScrollView(
      anchor: ScreenAdaptor().getLengthByOrientation(
        vertical: 0.13.w,
        horizon: 0.12.w,
      ),
      slivers: [
        Obx(() {
          return FutureBuilder(
            future: state.futureUserLikedAlbums.value,
            builder:
                (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return SliverLayoutBuilder(
                  builder:
                      (BuildContext context, SliverConstraints constraints) {
                    int columnNumber = ScreenAdaptor().byOrientationReturn(
                      vertical: 3,
                      horizon: 5,
                    )!;
                    double horizontalSpacing =
                        ScreenAdaptor().getLengthByOrientation(
                      vertical: 30.w,
                      horizon: 10.w,
                    );
                    double size = (constraints.crossAxisExtent -
                            (columnNumber - 1) * horizontalSpacing) /
                        columnNumber;
                    return RowCover(
                      items: snapshot.data!,
                      subText: "artist",
                      type: "album",
                      columnNumber: columnNumber,
                      imageWidth: ScreenAdaptor().getLengthByOrientation(
                        vertical: 200.w,
                        horizon: size,
                      ),
                      imageHeight: ScreenAdaptor().getLengthByOrientation(
                        vertical: 200.w,
                        horizon: size,
                      ),
                      horizontalSpacing: horizontalSpacing,
                      fontMainSize: ScreenAdaptor().getLengthByOrientation(
                        vertical: 20.sp,
                        horizon: 11.sp,
                      ),
                      fontSubSize: ScreenAdaptor().getLengthByOrientation(
                        vertical: 15.sp,
                        horizon: 9.sp,
                      ),
                    );
                  },
                );
              }
              return const SliverToBoxAdapter(child: SizedBox());
            },
          );
        }),
        // 间距
        _getHeightPaddingWidget(vertical: 50.w, horizon: 30.w),
      ],
    );
  }

  /// 获取艺人
  Widget _getLikedArtistsTabBarViewWidget() {
    return CustomScrollView(
      anchor: ScreenAdaptor().getLengthByOrientation(
        vertical: 0.13.w,
        horizon: 0.12.w,
      ),
      slivers: [
        Obx(() {
          return FutureBuilder(
            future: state.futureUserLikedArtists.value,
            builder:
                (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return SliverLayoutBuilder(
                  builder:
                      (BuildContext context, SliverConstraints constraints) {
                    int columnNumber = ScreenAdaptor().byOrientationReturn(
                      vertical: 3,
                      horizon: 5,
                    )!;
                    double horizontalSpacing =
                        ScreenAdaptor().getLengthByOrientation(
                      vertical: 30.w,
                      horizon: 10.w,
                    );
                    double size = (constraints.crossAxisExtent -
                            (columnNumber - 1) * horizontalSpacing) /
                        columnNumber;
                    return RowCover(
                      items: snapshot.data!,
                      type: "artist",
                      columnNumber: columnNumber,
                      imageWidth: ScreenAdaptor().getLengthByOrientation(
                        vertical: 200.w,
                        horizon: size,
                      ),
                      imageHeight: ScreenAdaptor().getLengthByOrientation(
                        vertical: 200.w,
                        horizon: size,
                      ),
                      horizontalSpacing: horizontalSpacing,
                      fontMainSize: ScreenAdaptor().getLengthByOrientation(
                        vertical: 20.sp,
                        horizon: 11.sp,
                      ),
                      fontSubSize: ScreenAdaptor().getLengthByOrientation(
                        vertical: 15.sp,
                        horizon: 9.sp,
                      ),
                    );
                  },
                );
              }
              return const SliverToBoxAdapter(child: SizedBox());
            },
          );
        }),
        // 间距
        _getHeightPaddingWidget(vertical: 50.w, horizon: 30.w),
      ],
    );
  }

  /// 获取MV
  Widget _getLikedMVsTabBarViewWidget() {
    return CustomScrollView(
      anchor: ScreenAdaptor().getLengthByOrientation(
        vertical: 0.13.w,
        horizon: 0.12.w,
      ),
      slivers: [
        Obx(() {
          return FutureBuilder(
            future: state.futureUserLikedMVs.value,
            builder:
                (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return SliverLayoutBuilder(
                  builder:
                      (BuildContext context, SliverConstraints constraints) {
                    int columnNumber = ScreenAdaptor().byOrientationReturn(
                      vertical: 3,
                      horizon: 5,
                    )!;
                    double horizontalSpacing =
                        ScreenAdaptor().getLengthByOrientation(
                      vertical: 30.w,
                      horizon: 10.w,
                    );
                    double size = (constraints.crossAxisExtent -
                            (columnNumber - 1) * horizontalSpacing) /
                        columnNumber;
                    return MvRow(
                      items: snapshot.data!,
                      columnNumber: columnNumber,
                      imageWidth: ScreenAdaptor().getLengthByOrientation(
                        vertical: 200.w,
                        horizon: size,
                      ),
                      imageHeight: ScreenAdaptor().getLengthByOrientation(
                        vertical: 120.w,
                        horizon: size * 3 / 5,
                      ),
                      horizontalSpacing: horizontalSpacing,
                      fontMainSize: ScreenAdaptor().getLengthByOrientation(
                        vertical: 20.sp,
                        horizon: 11.sp,
                      ),
                      fontSubSize: ScreenAdaptor().getLengthByOrientation(
                        vertical: 15.sp,
                        horizon: 9.sp,
                      ),
                    );
                  },
                );
              }
              return const SliverToBoxAdapter(child: SizedBox());
            },
          );
        }),
        // 间距
        _getHeightPaddingWidget(vertical: 50.w, horizon: 30.w),
      ],
    );
  }

  /// 获取云盘歌曲
  Widget _getCloudDiskSongsTabBarViewWidget() {
    return CustomScrollView(
      anchor: ScreenAdaptor().getLengthByOrientation(
        vertical: 0.13.w,
        horizon: 0.12.w,
      ),
      slivers: [
        Obx(() {
          return FutureBuilder(
            future: state.futureCloudDiskSongs.value,
            builder:
                (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return TrackList(
                  type: "sliverCloudDisk",
                  tracks: snapshot.data!,
                  columnCount: 1,
                  isShowSongAlbumNameAndTimes: true,
                );
              }
              return const SliverToBoxAdapter(child: SizedBox());
            },
          );
        }),
        // 间距
        _getHeightPaddingWidget(vertical: 50.w, horizon: 30.w),
      ],
    );
  }

  /// 获取听歌排行Tabs
  List<Widget> _getTabsHistorySongsRankListWidget() {
    return [
      Tab(
        height: ScreenAdaptor().getLengthByOrientation(
          vertical: 50.w,
          horizon: 27.w,
        ),
        child: Text(
          S.current.librarySongsRankLastWeek,
          style: TextStyle(
            fontSize: ScreenAdaptor().getLengthByOrientation(
              vertical: 22.sp,
              horizon: 13.sp,
            ),
          ),
        ),
      ),
      Tab(
        height: ScreenAdaptor().getLengthByOrientation(
          vertical: 50.w,
          horizon: 27.w,
        ),
        child: Text(
          S.current.librarySongsRankAllTime,
          style: TextStyle(
            fontSize: ScreenAdaptor().getLengthByOrientation(
              vertical: 22.sp,
              horizon: 13.sp,
            ),
          ),
        ),
      ),
    ];
  }

  /// 获取听歌排行
  Widget _getHistorySongsRankWidget() {
    return TabBarView(
      controller: state.tabControllerHistorySongsRank,
      children: [
        // 听歌排行最近一周歌曲
        _getHistorySongsRankLastWeekWidget(),
        // 听歌排行所有时间歌曲
        _getHistorySongsRankAllTimeWidget(),
      ],
    );
  }

  /// 获取听歌排行所有时间歌曲
  Widget _getHistorySongsRankAllTimeWidget() {
    return CustomScrollView(
      anchor: ScreenAdaptor().getLengthByOrientation(
        vertical: 0.13.w,
        horizon: 0.12.w,
      ),
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        Obx(() {
          return FutureBuilder(
            future: state.futureHistorySongsRankAllTime.value,
            builder:
                (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return TrackList(
                  type: "sliverTrackList",
                  columnCount: 1,
                  tracks: snapshot.data!,
                );
              }
              return const SliverToBoxAdapter(child: SizedBox());
            },
          );
        }),
      ],
    );
  }

  /// 获取听歌排行最近一周歌曲
  Widget _getHistorySongsRankLastWeekWidget() {
    return CustomScrollView(
      anchor: ScreenAdaptor().getLengthByOrientation(
        vertical: 0.13.w,
        horizon: 0.12.w,
      ),
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        Obx(() {
          return FutureBuilder(
            future: state.futureHistorySongsRankLastWeek.value,
            builder:
                (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return TrackList(
                  type: "sliverTrackList",
                  columnCount: 1,
                  tracks: snapshot.data!,
                );
              }
              return const SliverToBoxAdapter(child: SizedBox());
            },
          );
        }),
      ],
    );
  }

  /// 获取Tabs
  List<Widget> _getTabsListWidget() {
    return [
      Tab(
        height: ScreenAdaptor().getLengthByOrientation(
          vertical: 60.w,
          horizon: 35.w,
        ),
        child: Text(
          S.current.libraryAllPlayList,
          style: TextStyle(
            fontSize: ScreenAdaptor().getLengthByOrientation(
              vertical: 28.sp,
              horizon: 16.sp,
            ),
          ),
        ),
      ),
      Tab(
        height: ScreenAdaptor().getLengthByOrientation(
          vertical: 60.w,
          horizon: 35.w,
        ),
        child: Text(
          S.current.libraryAlbum,
          style: TextStyle(
            fontSize: ScreenAdaptor().getLengthByOrientation(
              vertical: 28.sp,
              horizon: 16.sp,
            ),
          ),
        ),
      ),
      Tab(
        height: ScreenAdaptor().getLengthByOrientation(
          vertical: 60.w,
          horizon: 35.w,
        ),
        child: Text(
          S.current.libraryArtist,
          style: TextStyle(
            fontSize: ScreenAdaptor().getLengthByOrientation(
              vertical: 28.sp,
              horizon: 16.sp,
            ),
          ),
        ),
      ),
      Tab(
        height: ScreenAdaptor().getLengthByOrientation(
          vertical: 60.w,
          horizon: 35.w,
        ),
        child: Text(
          S.current.libraryMV,
          style: TextStyle(
            fontSize: ScreenAdaptor().getLengthByOrientation(
              vertical: 28.sp,
              horizon: 16.sp,
            ),
          ),
        ),
      ),
      Tab(
        height: ScreenAdaptor().getLengthByOrientation(
          vertical: 60.w,
          horizon: 35.w,
        ),
        child: Text(
          S.current.libraryCloudDisk,
          style: TextStyle(
            fontSize: ScreenAdaptor().getLengthByOrientation(
              vertical: 28.sp,
              horizon: 16.sp,
            ),
          ),
        ),
      ),
      Tab(
        height: ScreenAdaptor().getLengthByOrientation(
          vertical: 60.w,
          horizon: 35.w,
        ),
        child: Text(
          S.current.librarySongsRank,
          style: TextStyle(
            fontSize: ScreenAdaptor().getLengthByOrientation(
              vertical: 28.sp,
              horizon: 16.sp,
            ),
          ),
        ),
      ),
    ];
  }

  /// 获取TabBar条
  Widget _getTabBarWidget() {
    return SliverAppBar(
      toolbarHeight: ScreenAdaptor().getLengthByOrientation(
        vertical: 80.w,
        horizon: 40.w,
      ),
      flexibleSpace: TabBar(
        controller: state.tabController,
        isScrollable: true,
        padding: EdgeInsets.zero,
        onTap: logic.historySongsRankChange,
        splashBorderRadius: BorderRadius.circular(
          ScreenAdaptor().getLengthByOrientation(
            vertical: 23.w,
            horizon: 15.w,
          ),
        ),
        tabs: _getTabsListWidget(),
      ),
    );
  }

  /// 获取听歌排行TabBar
  Widget _getHistorySongsRankTabBarWidget() {
    return Obx(() {
      return SliverVisibility(
        visible: state.historySongsRankIsTrue.value,
        sliver: SliverAppBar(
          toolbarHeight: ScreenAdaptor().getLengthByOrientation(
            vertical: 103.w,
            horizon: 62.w,
          ),
          flexibleSpace: Padding(
            padding: EdgeInsets.only(
              top: ScreenAdaptor().getLengthByOrientation(
                vertical: 23.w,
                horizon: 15.w,
              ),
            ),
            child: TabBar(
              isScrollable: true,
              controller: state.tabControllerHistorySongsRank,
              splashBorderRadius: BorderRadius.circular(
                ScreenAdaptor().getLengthByOrientation(
                  vertical: 20.w,
                  horizon: 10.w,
                ),
              ),
              tabs: _getTabsHistorySongsRankListWidget(),
            ),
          ),
        ),
      );
    });
  }

  /// 获取我喜欢的音乐和我喜欢的歌曲
  Widget _getILoveAndLikeSongsWidget() {
    return SliverToBoxAdapter(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // 我喜欢的音乐
            ClipRRect(
              borderRadius: BorderRadius.circular(
                ScreenAdaptor().getLengthByOrientation(
                  vertical: 25.w,
                  horizon: 12.w,
                ),
              ),
              child: Container(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.18),
                width: ScreenAdaptor().getLengthByOrientation(
                  vertical: 560.w,
                  horizon: 290.w,
                ),
                height: ScreenAdaptor().getLengthByOrientation(
                  vertical: 370.w,
                  horizon: 220.w,
                ),
                child: Stack(
                  children: [
                    // 我喜欢的音乐文本
                    Positioned(
                      bottom: ScreenAdaptor().getLengthByOrientation(
                        vertical: 70.w,
                        horizon: 38.w,
                      ),
                      left: ScreenAdaptor().getLengthByOrientation(
                        vertical: 40.w,
                        horizon: 20.w,
                      ),
                      child: Text(
                        S.of(context).libraryLikedSongs,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: ScreenAdaptor().getLengthByOrientation(
                            vertical: 35.sp,
                            horizon: 17.sp,
                          ),
                        ),
                      ),
                    ),
                    // 播放按钮
                    Positioned(
                      bottom: ScreenAdaptor().getLengthByOrientation(
                        vertical: 27.w,
                        horizon: 12.w,
                      ),
                      right: ScreenAdaptor().getLengthByOrientation(
                        vertical: 27.w,
                        horizon: 12.w,
                      ),
                      child: IconButton(
                        onPressed: () {},
                        color: Theme.of(context).colorScheme.primary,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.8),
                          ),
                        ),
                        icon: const Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    // 歌曲数量
                    Positioned(
                      bottom: ScreenAdaptor().getLengthByOrientation(
                        vertical: 28.w,
                        horizon: 15.w,
                      ),
                      left: ScreenAdaptor().getLengthByOrientation(
                        vertical: 40.w,
                        horizon: 20.w,
                      ),
                      child: Obx(() {
                        return FutureBuilder(
                          future: state.futureLikeSongs.value,
                          builder: (BuildContext context,
                              AsyncSnapshot<List> snapShot) {
                            if (snapShot.connectionState ==
                                ConnectionState.done) {
                              return Text(
                                "${snapShot.data!.length} ${S.of(context).libraryLikedSongsNumber}",
                                style: TextStyle(
                                  fontSize:
                                      ScreenAdaptor().getLengthByOrientation(
                                    vertical: 27.sp,
                                    horizon: 14.sp,
                                  ),
                                ),
                              );
                            }
                            return const SizedBox();
                          },
                        );
                      }),
                    ),
                    // 三行歌词
                    Positioned(
                      top: ScreenAdaptor().getLengthByOrientation(
                        vertical: 30.w,
                        horizon: 15.w,
                      ),
                      left: ScreenAdaptor().getLengthByOrientation(
                        vertical: 40.w,
                        horizon: 20.w,
                      ),
                      child: Obx(() {
                        return Text(
                          state.randomLyric.value,
                          style: TextStyle(
                            fontSize: ScreenAdaptor().getLengthByOrientation(
                              vertical: 26.sp,
                              horizon: 13.sp,
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
            // 间距
            SizedBox(
              width: ScreenAdaptor().getLengthByOrientation(
                vertical: 30.w,
                horizon: 20.w,
              ),
            ),
            // 我喜欢的歌曲
            Obx(() {
              return FutureBuilder(
                future: state.futureLikeSongs.value,
                builder: (BuildContext context, AsyncSnapshot<List> snapShot) {
                  if (snapShot.connectionState == ConnectionState.done) {
                    return SizedBox(
                      width: ScreenAdaptor().getLengthByOrientation(
                        vertical: 860.w,
                        horizon: 488.w,
                      ),
                      height: ScreenAdaptor().getLengthByOrientation(
                        vertical: 370.w,
                        horizon: 220.w,
                      ),
                      child: TrackList(
                        type: "tracklist",
                        tracks: snapShot.data!,
                        columnCount: 3,
                      ),
                    );
                  }
                  return const SizedBox();
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  /// 获取AppBar
  Widget _getAppBarWidget() {
    if (ScreenAdaptor().getOrientation()) {
      return SliverAppBar(
        //pinned: true,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        flexibleSpace: FlexibleSpaceBar(
          background: Align(
            alignment: Alignment(-1, 4.2.w),
            child: TextButton(
              child: Icon(
                Icons.menu_rounded,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
        ),
      );
    }
    return const SliverToBoxAdapter(child: SizedBox());
  }

  /// 获取{{用户名}}的音乐库
  Widget _getUserNameWidget() {
    return SliverToBoxAdapter(
      child: FutureBuilder(
        future: state.futureUserInfoMap.value,
        builder: (BuildContext context,
            AsyncSnapshot<Map<dynamic, dynamic>> snapShot) {
          if (snapShot.connectionState == ConnectionState.done) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 用户头像
                ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: snapShot.data!["avatarUrl"] + "?param=100y100",
                    width: ScreenAdaptor().getLengthByOrientation(
                      vertical: 65.w,
                      horizon: 45.w,
                    ),
                    height: ScreenAdaptor().getLengthByOrientation(
                      vertical: 65.w,
                      horizon: 45.w,
                    ),
                  ),
                ),
                // 间距
                SizedBox(
                  width: ScreenAdaptor().getLengthByOrientation(
                    vertical: 20.w,
                    horizon: 10.w,
                  ),
                ),
                // 用户名
                SizedBox(
                  width: ScreenAdaptor().getLengthByOrientation(
                    vertical: 574.w,
                    horizon: 540.w,
                  ),
                  child: Text(
                    snapShot.data!["nickname"] + S.of(context).librarySLibrary,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: ScreenAdaptor().getLengthByOrientation(
                        vertical: 36.sp,
                        horizon: 22.sp,
                      ),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          }
          return SizedBox(
            height: ScreenAdaptor().getLengthByOrientation(
              vertical: 60.w,
              horizon: 45.w,
            ),
          );
        },
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
}
