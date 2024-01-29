import 'package:get/get.dart';
import 'package:musicplayer/common/net/RequestManager.dart';
import 'package:musicplayer/common/utils/EventBusManager.dart';
import 'package:musicplayer/common/utils/ShareData.dart';
import 'package:musicplayer/router/RouteConfig.dart';

import 'state.dart';

class AppMainLogic extends GetxController {
  final AppMainState state = AppMainState();

  /// 导航栏路由切换管理
  void navigationManage(int index) {
    // 点击音乐库时判断是否已经登录
    if (index == 2) {
      RequestManager().isLogin().then((bool isLogin) {
        if (isLogin) {
          state.currentIndex.value = index;
          state.tabController.animateTo(index);
        } else {
          Get.toNamed(RouteConfig.login);
        }
      });
    } else {
      state.currentIndex.value = index;
      state.tabController.animateTo(index);
    }
  }

  /// 数据总线页面监听逻辑
  void pageStateListenForEvents(Map pageState) {
    if(pageState["pageOthers"] != null) {
      Map pageOthers = pageState["pageOthers"];
      if(pageOthers["appMain"] != null) {
        Map appMain = pageOthers["appMain"];
        state.currentIndex.value = appMain["currentIndex"];
        state.tabController.animateTo(state.currentIndex.value);
      }
    }
  }

  /// 监听逻辑
  void listenForEvents() {
    // 初始化监听器
    state.streamSubscription =
        EventBusManager().eventBus.on<ShareData>().listen((ShareData event) {
      // 页面状态逻辑
      if (event.mapData[ShareDataType.pageState] != null) {
        Map pageState = event.mapData[ShareDataType.pageState]!;
        // 数据总线页面监听逻辑
        pageStateListenForEvents(pageState);
      }
    });
  }
}
