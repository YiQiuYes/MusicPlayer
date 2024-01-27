import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:musicplayer/common/utils/DataStorageManager.dart';
import 'package:musicplayer/common/utils/StaticData.dart';
import 'package:get/get.dart';

class ExploreState {
  // TabBar控制器
  late Rx<TabController> tabController;
  // 顶部TabBar分类标签
  late RxList playListCategories;
  // 分类标签原始数据
  late List<Map<String, dynamic>> originPlayListCategoriesData;
  // 当前选择的标签
  late String currentTab;
  // CustomScrollView控制器
  late ScrollController scrollController;
  // 分类面板总分类标题
  late List<String> playlistCategoriesTile;
  GlobalKey key = GlobalKey();

  // 歌单缓存数据
  late Rx<Future<Map<String, List<dynamic>>>> futurePlayListCacheData;

  ExploreState() {
    // 分类标签原始数据
    originPlayListCategoriesData = playlistCategoriesStaticData.map((e) {
      return {
        "name": e["name"],
        "enable": e["enable"],
        "bigCat": e["bigCat"],
      };
    }).toList();
    // 获取顶部TabBar分类标签数据

    if (DataStorageManager().getString("playListCategories") != null) {
      playListCategories = [
        ...jsonDecode(DataStorageManager().getString("playListCategories")!)
      ].obs;
    } else {
      playListCategories = originPlayListCategoriesData
          .where((element) => element["enable"] == true)
          .toList()
          .obs;
      DataStorageManager()
          .setString("playListCategories", jsonEncode(playListCategories));
    }
    // 初始化歌单缓存数据
    futurePlayListCacheData = Rx(Future.value({}));
    // 初始化当前选择的标签
    currentTab = playListCategories[0]["name"];
    // 初始化CustomScrollView控制器
    scrollController = ScrollController();

    // 初始化分类面板总分类标题
    playlistCategoriesTile = ["语种", "风格", "场景", "情感", "主题"];
  }
}
