import 'dart:math';

import 'package:get/get.dart';
import 'package:musicplayer/api/AlbumApi.dart';
import 'package:musicplayer/api/ArtistApi.dart';
import 'package:musicplayer/api/OthersApi.dart';
import 'package:musicplayer/api/PlayListApi.dart';
import 'package:musicplayer/common/net/RequestManager.dart';
import 'package:musicplayer/common/utils/RequestUtils.dart';

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

  /// 获取推荐歌单数据
  Future<List<dynamic>> loadFutureRecommendList() async {
    // 判断登录状态
    bool isLogin = await RequestManager().isLogin();

    // 登录成功
    if (isLogin) {
      return await PlayListApi().getRecommendPlayList(limit: 8).then((value) {
        var result = RequestUtils.transformResponse(value);
        return result["result"];
      });
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
        return result["dailySongs"];
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
