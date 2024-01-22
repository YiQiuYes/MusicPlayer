import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class HomeState {
  // 滚动控制器
  late ScrollController scrollController;
  // 推荐歌单缓存数据
  late Rx<Future<List<dynamic>>> futureRecommendList;
  // 每日推荐歌曲缓存数据
  late Rx<Future<List<dynamic>>> futureDailyTracksList;
  // 私人FM缓存数据
  late Rx<Future<List<dynamic>>> futurePersonalFMList;

  HomeState() {
    scrollController = ScrollController();
  }
}
