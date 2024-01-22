import 'package:musicplayer/common/net/MyOptions.dart';
import 'package:musicplayer/common/net/RequestManager.dart';
import 'package:dio/dio.dart';

class PlayListApi {
  PlayListApi._privateConstructor();
  static final PlayListApi _instance = PlayListApi._privateConstructor();
  factory PlayListApi() {
    return _instance;
  }

  // 网络管家
  final requestManager = RequestManager();

  /// 获取推荐歌单数据
  Future<Response> getRecommendPlayList({MyOptions? myOptions, int? limit}) async {
    myOptions ??= MyOptions();
    myOptions.crypto = "weapi";
    Map<String, dynamic> queryParameters = {
      "limit": limit ?? 30,
      "total": true,
      "n": 1000,
    };
    return await requestManager.post(
      "https://music.163.com/weapi/personalized/playlist",
      queryParameters: queryParameters,
      myOptions: myOptions,
    );
  }

  // 获取每日推荐歌曲 需要登录的情况下调用
  Future<Response> getDailyRecommendTracks() async {
    MyOptions myOptions = MyOptions(crypto: "weapi");
    return await requestManager.post(
      "https://music.163.com/api/v3/discovery/recommend/songs",
      myOptions: myOptions,
    );
  }
}
