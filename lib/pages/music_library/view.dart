import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musicplayer/common/utils/AppTheme.dart';
import 'package:musicplayer/common/utils/ScreenAdaptor.dart';
import 'package:musicplayer/components/TrackList.dart';
import 'package:musicplayer/generated/l10n.dart';

import 'logic.dart';

class MusicLibraryPage extends StatefulWidget {
  const MusicLibraryPage({super.key});

  @override
  State<MusicLibraryPage> createState() => _MusicLibraryPageState();
}

class _MusicLibraryPageState extends State<MusicLibraryPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
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
          child: CustomScrollView(
            slivers: [
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
            ],
          ),
        ),
      ),
    );
  }

  /// 获取TabBar条
  Widget _getTabBarWidget() {
    return SliverToBoxAdapter(
      child: Center(
        child: TabBar(
          controller: state.tabController,
          isScrollable: true,
          padding: EdgeInsets.zero,
            tabAlignment: TabAlignment.start,
          splashBorderRadius: BorderRadius.circular(
            ScreenAdaptor().getLengthByOrientation(
              vertical: 23.w,
              horizon: 15.w,
            ),
          ),
          tabs: state.tabs,
        ),
      ),
    );
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
                        vertical: 23.w,
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
            FutureBuilder(
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
            ),
          ],
        ),
      ),
    );
  }

  /// 获取AppBar
  Widget _getAppBarWidget() {
    if (ScreenAdaptor().getOrientation()) {
      return SliverAppBar(
        pinned: true,
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
