import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musicplayer/common/utils/ScreenAdaptor.dart';
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
        child: CustomScrollView(
          anchor: ScreenAdaptor().getLengthByOrientation(
            vertical: 0.04.h,
            horizon: 0.1.h,
          ),
          slivers: [
            // 搜索框
            _getSearchBar(),
          ],
        ),
      ),
    );
  }

  // 搜索框
  Widget _getSearchBar() {
    return SliverToBoxAdapter(
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
    );
  }
}
