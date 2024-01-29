import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer/api/PlayListApi.dart';
import 'package:musicplayer/common/net/RequestManager.dart';
import 'package:musicplayer/common/utils/DataStorageManager.dart';
import 'package:musicplayer/common/utils/RequestUtils.dart';
import 'package:musicplayer/common/utils/StaticData.dart';
import 'state.dart';

class ExploreLogic extends GetxController {
  final ExploreState state = ExploreState();

  /// 获取TabBar标签组
  List<Widget> getTabBarTabs() {
    var result = state.playListCategories.map((e) => Text(e["name"]));
    return result.toList();
  }

  /// TabBar切换逻辑
  void onTabChange(int index) {
    state.currentTab = state.playListCategories[index]["name"];
    loadPlayListCacheData(type: state.currentTab).then((value) async {
      Map<String, dynamic> cacheData =
          await state.futurePlayListCacheData.value;
      // 判断是否需要添加数据
      if (cacheData[state.currentTab] == null) {
        // 添加数据
        cacheData.addAll(value);
      }
      state.futurePlayListCacheData.refresh();
    });
  }

  /// 获取子标题
  String getSubText(String subType) {
    switch (subType) {
      case "排行榜":
        return "updateFrequency";
      case "推荐歌单":
        return "copywriter";
      default:
        return "";
    }
  }

  /// 加载数据逻辑
  Future<Map<String, List<dynamic>>> loadPlayListCacheData(
      {required String type}) async {
    switch (type) {
      case "排行榜":
        return {
          type: await PlayListApi().getTopLists().then((value) {
            var result = RequestUtils.transformResponse(value);
            return result["list"];
          })
        };
      case "推荐歌单":
        // 判断登录状态
        bool isLogin = await RequestManager().isLogin();
        // 登录成功
        if (isLogin) {
          // 每日推荐歌单
          List<dynamic> dailyRecommendPlayList = await PlayListApi()
              .getDailyRecommendPlayList(limit: 8)
              .then((value) {
            var result = RequestUtils.transformResponse(value);
            return result["recommend"];
          });

          // 推荐歌单
          List<dynamic> recommendPlayList = await PlayListApi()
              .getRecommendPlayList(limit: 99 - dailyRecommendPlayList.length)
              .then((value) {
            var result = RequestUtils.transformResponse(value);
            return result["result"];
          });

          // 合并list
          List<dynamic> list = [];
          list.addAll(dailyRecommendPlayList);
          list.addAll(recommendPlayList);

          return {type: list};
        } else {
          // 尚未登陆
          return {
            type: await PlayListApi()
                .getRecommendPlayList(limit: 99)
                .then((value) {
              var result = RequestUtils.transformResponse(value);
              return result["result"];
            })
          };
        }
      case "精品歌单":
        int lastTime = 0;
        if ((await state.futurePlayListCacheData.value)[type] != null) {
          if ((await state.futurePlayListCacheData.value)[type]!.isNotEmpty) {
            lastTime = (await state.futurePlayListCacheData.value)[type]!
                .last["updateTime"];
          } else {
            lastTime = 0;
          }
        }
        return {
          type: await PlayListApi()
              .getHighQualityPlayList(limit: 48, lasttime: lastTime)
              .then((value) {
            var result = RequestUtils.transformResponse(value);
            return result["playlists"];
          })
        };
      // 默认情况下，获取歌单数据
      default:
        int? offset = await state.futurePlayListCacheData.value.then((value) {
          return value[type] != null ? value[type]?.length : 0;
        });
        return {
          type: await PlayListApi()
              .getTopPlayList(cat: type, offset: offset, limit: 48)
              .then((value) {
            var result = RequestUtils.transformResponse(value);
            return result["playlists"];
          })
        };
    }
  }

  /// 返回分类标题内容
  Map<String, dynamic> getPlaylistCategoriesTileContext() {
    // 获取相对应的标签
    var categoriesList = state.playlistCategoriesTile.map((e) {
      var singleCategories = playlistCategoriesStaticData.where((element) {
        return element["bigCat"] == e;
      });

      return singleCategories.toList();
    });

    Map<String, dynamic> result = {};
    for (List<dynamic> value in categoriesList) {
      result[value[0]["bigCat"]] = value;
    }
    return result;
  }

  /// 返回是否为选中状态
  bool isSelect(String name) {
    return state.playListCategories.any(
      (element) => element["name"] == name && element["enable"],
    );
  }

  /// 改变选中状态
  void changeSelect(String name, var that) {
    bool isExist =
        state.playListCategories.any((element) => element["name"] == name);

    if (isExist) {
      for (var element in state.playListCategories) {
        if (element["name"] == name) {
          state.playListCategories.remove(element);
          break;
        }
      }
    } else {
      for (var element in state.originPlayListCategoriesData) {
        if (element["name"] == name) {
          element["enable"] = true;
          state.playListCategories.add(element);
          break;
        }
      }
    }

    // 刷新TabBar控制器并防止内存泄露
    state.tabController.value.dispose();
    state.tabController.value =
        TabController(length: state.playListCategories.length, vsync: that);
    // 持久化存储数据
    DataStorageManager().setString(
      "playListCategories",
      jsonEncode(state.playListCategories),
    );
  }
}
