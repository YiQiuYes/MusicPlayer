import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musicplayer/common/utils/ScreenAdaptor.dart';
import 'package:musicplayer/components/RowCover.dart';

import 'logic.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  // 主页面构建器
  late BuildContext appMainContext;

  final logic = Get.put(ExploreLogic());
  final state = Get.find<ExploreLogic>().state;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    state.tabController = TabController(
      length: logic.getTabBarTabs().length,
      vsync: this,
    ).obs;
    logic.loadPlayListCacheData(type: state.currentTab).then((value) async {
      (await state.futurePlayListCacheData.value).addAll(value);
      state.futurePlayListCacheData.refresh();
    });
  }

  @override
  void dispose() {
    state.tabController.value.dispose();
    state.scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    appMainContext = context;
    return SafeArea(
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
            controller: state.scrollController,
            slivers: [
              // 获取AppBar
              _getSliverBarWidget(),
              // 获取歌单组件
              _getPlayListWidget(),
            ],
          ),
        ),
      ),
    );
  }

  /// 获取AppBar
  Widget _getSliverBarWidget() {
    return SliverAppBar(
      pinned: true,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      toolbarHeight: ScreenAdaptor().getLengthByOrientation(
        vertical: 125.w,
        horizon: 57.w,
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            // 侧边栏按钮
            ScreenAdaptor().byOrientationReturn(
              vertical: Positioned(
                top: 25.w,
                child: TextButton(
                  child: Icon(
                    Icons.menu,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  onPressed: () {
                    Scaffold.of(appMainContext).openDrawer();
                  },
                ),
              ),
              horizon: const SizedBox(),
            )!,
            // TabBar
            Positioned(
              top: ScreenAdaptor().getLengthByOrientation(
                vertical: 53.w,
                horizon: 18.w,
              ),
              left: ScreenAdaptor().getLengthByOrientation(
                vertical: 130.w,
                horizon: 0.w,
              ),
              right: ScreenAdaptor().getLengthByOrientation(
                vertical: 130.w,
                horizon: 75.w,
              ),
              child: Center(
                child: Obx(() {
                  return TabBar(
                    tabs: logic.getTabBarTabs(),
                    controller: state.tabController.value,
                    isScrollable: true,
                    splashBorderRadius: BorderRadius.circular(
                      ScreenAdaptor().getLengthByOrientation(
                        vertical: 23.w,
                        horizon: 15.w,
                      ),
                    ),
                    onTap: logic.onTabChange,
                  );
                }),
              ),
            ),
            // 更多按钮
            Positioned(
              top: ScreenAdaptor().getLengthByOrientation(
                vertical: 25.w,
                horizon: 5.w,
              ),
              right: 0,
              child: TextButton(
                onPressed: _showDialogChoiceWidget,
                child: Icon(
                  Icons.more_horiz_rounded,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 标题组件
  Widget _getTitleWidget(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: ScreenAdaptor().getLengthByOrientation(
          vertical: 30.sp,
          horizon: 17.sp,
        ),
        fontWeight: FontWeight.bold,
      ),
    );
  }

  /// 获取标签流组件
  Widget _getTagsTextWidget(List<dynamic> showTags, List<dynamic> tags) {
    List<Widget> list = tags.map((e) {
      return SizedBox(
        width: ScreenAdaptor().getLengthByOrientation(
          vertical: 145.w,
          horizon: 80.w,
        ),
        child: InkWell(
          onTap: () {
            logic.changeSelect(e["name"], this);
          },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Obx(() {
            return Text(
              e["name"],
              style: logic.isSelect(e["name"])
                  ? TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: ScreenAdaptor().getLengthByOrientation(
                        vertical: 23.sp,
                        horizon: 14.sp,
                      ),
                    )
                  : TextStyle(
                      fontSize: ScreenAdaptor().getLengthByOrientation(
                        vertical: 23.sp,
                        horizon: 14.sp,
                      ),
                    ),
            );
          }),
        ),
      );
    }).toList();

    return Wrap(
      spacing: ScreenAdaptor().getLengthByOrientation(
        vertical: 14.w,
        horizon: 15.w,
      ),
      runSpacing: ScreenAdaptor().getLengthByOrientation(
        vertical: 10.w,
        horizon: 10.w,
      ),
      children: list,
    );
  }

  /// 显示专辑标签选择表对话框
  void _showDialogChoiceWidget() {
    // 获取分类标签数据
    Map<String, dynamic> categoriesMap =
        logic.getPlaylistCategoriesTileContext();

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "",
      pageBuilder: (BuildContext context, Animation<double> animation1,
          Animation<double> animation2) {
        List<Widget> list = [];
        for (int i = 0; i < state.playlistCategoriesTile.length; i++) {
          list.addAll([
            // 间距
            SizedBox(
              height: ScreenAdaptor().getLengthByOrientation(
                vertical: 30.w,
                horizon: 10.w,
              ),
            ),
            // 分类标题
            _getTitleWidget(state.playlistCategoriesTile[i]),
            // 间距
            SizedBox(
              height: ScreenAdaptor().getLengthByOrientation(
                vertical: 10.w,
                horizon: 10.w,
              ),
            ),
            // 分类标签
            _getTagsTextWidget(
              state.playListCategories,
              categoriesMap[state.playlistCategoriesTile[i]],
            ),
          ]);
        }

        return SafeArea(
          child: AlertDialog(
            alignment: Alignment.topCenter,
            scrollable: true,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: list,
            ),
          ),
        );
      },
      transitionBuilder: (BuildContext context, Animation<double> animation1,
          Animation<double> animation2, Widget child) {
        return FractionalTranslation(
          translation: Offset(0, 1 - animation1.value),
          child: child,
        );
      },
    );
  }

  /// 获取歌单组件
  Widget _getPlayListWidget() {
    return Obx(() {
      return FutureBuilder(
        future: state.futurePlayListCacheData.value,
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data!.isNotEmpty &&
              snapshot.data![state.currentTab] != null) {
            return RowCover(
              items: snapshot.data![state.currentTab]!,
              subText: logic.getSubText(state.currentTab),
              type: "playlist",
              columnNumber: ScreenAdaptor().byOrientationReturn(
                vertical: 3,
                horizon: 5,
              )!,
              imageWidth: ScreenAdaptor().getLengthByOrientation(
                vertical: 200.w,
                horizon: 100.w,
              ),
              imageHeight: ScreenAdaptor().getLengthByOrientation(
                vertical: 200.w,
                horizon: 100.w,
              ),
              horizontalSpacing: ScreenAdaptor().getLengthByOrientation(
                vertical: 30.w,
                horizon: 10.w,
              ),
              fontMainSize: ScreenAdaptor().getLengthByOrientation(
                vertical: 20.sp,
                horizon: 11.sp,
              ),
              fontSubSize: ScreenAdaptor().getLengthByOrientation(
                vertical: 15.sp,
                horizon: 9.sp,
              ),
            );
          }
          return const SliverToBoxAdapter(child: SizedBox());
        },
      );
    });
  }
}
