import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer/common/utils/ScreenAdaptor.dart';
import 'package:musicplayer/generated/l10n.dart';

class MusicLibraryState {
  // 用户信息
  late Rx<Future<Map>> futureUserInfoMap;
  // 我喜欢的歌曲
  late Rx<Future<List>> futureLikeSongs;
  // 用户歌单
  late Rx<Future<List>> futureUserPlayList;
  // 收藏的专辑
  late Rx<Future<List>> futureUserLikedAlbums;
  // 收藏的艺人
  late Rx<Future<List>> futureUserLikedArtists;
  // 收藏的MV
  late Rx<Future<List>> futureUserLikedMVs;
  // 云盘歌曲信息
  late Rx<Future<List>> futureCloudDiskSongs;
  // 听歌排行最近一周
  late Rx<Future<List>> futureHistorySongsRankLastWeek;
  // 听歌排行所有时间
  late Rx<Future<List>> futureHistorySongsRankAllTime;

  // 随机歌词
  late RxString randomLyric;

  // TabBar控制器
  late TabController tabController;
  // 听歌排行TabBar控制器
  late TabController tabControllerHistorySongsRank;
  // 听歌排行是否被选中
  late RxBool historySongsRankIsTrue;

  MusicLibraryState() {
    randomLyric = "".obs;
    historySongsRankIsTrue = false.obs;
  }
}
