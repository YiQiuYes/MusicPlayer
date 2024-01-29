import 'dart:math';

import 'package:get/get.dart';
import 'package:musicplayer/api/AlbumApi.dart';
import 'package:musicplayer/api/ArtistApi.dart';
import 'package:musicplayer/api/OthersApi.dart';
import 'package:musicplayer/api/PlayListApi.dart';
import 'package:musicplayer/common/net/RequestManager.dart';
import 'package:musicplayer/common/utils/EventBusManager.dart';
import 'package:musicplayer/common/utils/RequestUtils.dart';
import 'package:musicplayer/common/utils/ShareData.dart';

import 'state.dart';

class HomeLogic extends GetxController {
  final HomeState state = HomeState();

  /// 页面初始化
  void pageInit() async {
    // 获取推荐歌单数据
    state.futureRecommendList = loadFutureRecommendList().obs;
    // 获取每日推荐歌曲数据
    state.futureDailyTracksList = loadFutureDailyTracksList().obs;
    // 获取私人FM数据
    state.futurePersonalFMList = loadFuturePersonalFMList().obs;
    // 获取推荐艺人数据
    state.futureRecommendArtistsList = loadFutureRecommendArtistsList().obs;
    // 获取新专速递
    state.futureNewAlbumsList = loadFutureNewAlbumsList().obs;
    // 获取排行榜
    state.futureTopList = loadFutureTopList().obs;
  }

  /// 页面数据刷新
  void refreshData() {
    // 获取推荐歌单数据
    state.futureRecommendList.value = loadFutureRecommendList();
    // 获取每日推荐歌曲数据
    state.futureDailyTracksList.value = loadFutureDailyTracksList();
    // 获取私人FM数据
    state.futurePersonalFMList.value = loadFuturePersonalFMList();
    // 获取推荐艺人数据
    state.futureRecommendArtistsList.value = loadFutureRecommendArtistsList();
    // 获取新专速递
    state.futureNewAlbumsList.value = loadFutureNewAlbumsList();
    // 获取排行榜
    state.futureTopList.value = loadFutureTopList();
  }

  /// 数据总线页面监听逻辑
  void pageStateListenForEvents(Map pageState) {
    // 是否刷新数据
    if (pageState["isReFreshPage"]) {
      refreshData();
    }
  }

  /// 监听逻辑
  void listenForEvents() {
    // 初始化监听器
    state.streamSubscription =
        EventBusManager().eventBus.on<ShareData>().listen((ShareData event) {
      if (event.mapData[ShareDataType.pageState] != null) {
        Map pageState = event.mapData[ShareDataType.pageState]!;
        // 数据总线页面监听逻辑
        pageStateListenForEvents(pageState);
      }
    });
  }

  /// 获取推荐歌单数据
  Future<List<dynamic>> loadFutureRecommendList() async {
    // 判断登录状态
    bool isLogin = await RequestManager().isLogin();

    // 登录成功
    if (isLogin) {
      // 每日推荐歌单
      List<dynamic> dailyRecommendPlayList =
          await PlayListApi().getDailyRecommendPlayList(limit: 8).then((value) {
        var result = RequestUtils.transformResponse(value);
        return result["recommend"];
      });

      // 推荐歌单
      List<dynamic> recommendPlayList = await PlayListApi()
          .getRecommendPlayList(limit: 10 - dailyRecommendPlayList.length)
          .then((value) {
        var result = RequestUtils.transformResponse(value);
        return result["result"];
      });

      // 合并list
      List<dynamic> list = [];
      list.addAll(dailyRecommendPlayList);
      list.addAll(recommendPlayList);
      return list;
    } else {
      // 尚未登陆
      return await PlayListApi().getRecommendPlayList(limit: 10).then((value) {
        var result = RequestUtils.transformResponse(value);
        return result["result"];
      });
    }
  }

  /// 获取每日推荐歌曲
  Future<List<dynamic>> loadFutureDailyTracksList() async {
    // 判断登录状态
    bool isLogin = await RequestManager().isLogin();

    if (isLogin) {
      return await PlayListApi().getDailyRecommendTracks().then((value) {
        var result = RequestUtils.transformResponse(value);
        return result["data"]["dailySongs"];
      });
    } else {
      return [];
    }
  }

  /// 获取私人FM数据
  Future<List<dynamic>> loadFuturePersonalFMList() async {
    return await OthersApi().getPersonalFM().then((value) {
      var result = RequestUtils.transformResponse(value);
      return result["data"];
    });
  }

  /// 获取推荐艺人数据
  Future<List<dynamic>> loadFutureRecommendArtistsList() async {
    // 随机数0到50的整数
    var offset = Random().nextInt(50);
    return await ArtistApi()
        .getTopListOfArtists(limit: 5, offset: offset)
        .then((value) {
      var result = RequestUtils.transformResponse(value);
      return result["artists"];
    });
  }

  /// 获取新专速递数据
  Future<List<dynamic>> loadFutureNewAlbumsList() async {
    return await AlbumApi().getNewAlbums(limit: 10).then((value) {
      var result = RequestUtils.transformResponse(value);
      return result["albums"];
    });
  }

  /// 获取排行榜数据
  Future<List<dynamic>> loadFutureTopList() async {
    return await PlayListApi().getTopLists().then((value) {
      var result = RequestUtils.transformResponse(value);
      List<dynamic> test = result["list"];

      return test.where((dynamic element) {
        return state.topListIds.contains(element["id"]);
      }).toList();
    });
  }
}
