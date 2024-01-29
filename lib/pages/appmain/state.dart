import 'dart:async';

import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer/common/utils/DataStorageManager.dart';

class AppMainState {
  // key
  late GlobalKey<ScaffoldState> scaffoldKey;
  // 头像
  late RxString avatarUrl;
  // 当前导航栏索引
  late RxInt currentIndex;
  // TabBarView控制器
  late TabController tabController;

  // 监听数据总线返回的数据
  late StreamSubscription streamSubscription;

  AppMainState() {
    currentIndex = 0.obs;
    scaffoldKey = GlobalKey<ScaffoldState>();
    String? url = DataStorageManager().getString("avatarUrl");
    // 如果有头像就用，没有就用默认头像
    if (url != null) {
      avatarUrl = url.obs;
    } else {
      avatarUrl =
          "http://s4.music.126.net/style/web2/img/default/default_avatar.jpg"
              .obs;
    }
  }
}
