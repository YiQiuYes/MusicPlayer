import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:musicplayer/common/utils/EventBusManager.dart';
import 'package:musicplayer/common/utils/ShareData.dart';

class HomeState {
  // 滚动控制器
  late ScrollController scrollController;
  // 推荐歌单缓存数据
  late Rx<Future<List<dynamic>>> futureRecommendList;
  // 每日推荐歌曲缓存数据
  late Rx<Future<List<dynamic>>> futureDailyTracksList;
  // 私人FM缓存数据
  late Rx<Future<List<dynamic>>> futurePersonalFMList;
  // 推荐艺人数据
  late Rx<Future<List<dynamic>>> futureRecommendArtistsList;
  // 新专速递
  late Rx<Future<List<dynamic>>> futureNewAlbumsList;
  // 排行榜
  late Rx<Future<List<dynamic>>> futureTopList;
  // 排行榜过滤器id数组
  late List<int> topListIds;

  // 监听数据总线返回的数据
  late StreamSubscription streamSubscription;

  HomeState() {
    scrollController = ScrollController();
    topListIds = [19723756, 180106, 60198, 3812895, 60131];
  }
}
