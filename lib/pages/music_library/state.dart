import 'package:get/get.dart';
import 'package:flutter/material.dart';
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
  // 听歌排行
  late Rx<Future<List>> futureHistorySongsRank;

  // 随机歌词
  late RxString randomLyric;

  // TabBar控制器
  late TabController tabController;
  // Tabs
  late List<Widget> tabs;

  MusicLibraryState() {
    randomLyric = "".obs;
    tabs = [
      Text(S.current.libraryAllPlayList),
      Text(S.current.libraryAlbum),
      Text(S.current.libraryArtist),
      Text(S.current.libraryMV),
      Text(S.current.libraryCloudDisk),
      Text(S.current.librarySongsRank),
    ];
  }
}
