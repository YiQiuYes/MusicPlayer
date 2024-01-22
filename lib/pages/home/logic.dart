import 'package:get/get.dart';
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
    return await OthersListApi().getPersonalFM().then((value) {
      var result = RequestUtils.transformResponse(value);
      return result["data"];
    });
  }
}
