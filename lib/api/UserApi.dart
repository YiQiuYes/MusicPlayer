import 'package:musicplayer/common/net/MyOptions.dart';
import 'package:musicplayer/common/net/RequestManager.dart';
import 'package:dio/dio.dart';

class UserApi {
  UserApi._privateConstructor();
  static final UserApi _instance = UserApi._privateConstructor();
  factory UserApi() {
    return _instance;
  }

  // 网络管家
  final requestManager = RequestManager();

  /// 获取用户详情
  /// 说明: 登录后调用此接口 , 传入用户 id, 可以获取用户详情
  /// - [uid] : 用户 id
  /// - [myOptions] : 可选参数
  Future<Response> userDetail({required int uid}) async {
    MyOptions myOptions = MyOptions(crypto: "weapi");
    return await requestManager.post(
      "https://music.163.com/weapi/v1/user/detail/$uid",
      myOptions: myOptions,
    );
  }

  /// 喜欢的歌曲列表无序
  Future<Response> userLikedSongsIDs({required int uid}) async {
    MyOptions myOptions = MyOptions(crypto: "weapi");
    Map<String, dynamic> queryParameters = {
      "uid": uid,
    };
    return await requestManager.post(
      "https://music.163.com/weapi/song/like/get",
      myOptions: myOptions,
      queryParameters: queryParameters,
    );
  }

  // 获取用户歌单
  Future<Response> userPlayList(
      {required int uid, int? limit, int? offset}) async {
    MyOptions myOptions = MyOptions(crypto: "weapi");
    Map<String, dynamic> queryParameters = {
      "uid": uid,
      "limit": limit ?? 30,
      "offset": offset ?? 0,
      "includeVideo": true,
    };
    return await requestManager.post(
      "https://music.163.com/weapi/user/playlist",
      myOptions: myOptions,
      queryParameters: queryParameters,
    );
  }

  // 获取收藏的专辑
  Future<Response> userLikedAlbums({int? limit, int? offset}) async {
    MyOptions myOptions = MyOptions(crypto: "weapi");
    Map<String, dynamic> queryParameters = {
      "limit": limit ?? 25,
      "offset": offset ?? 0,
      "total": true,
    };
    return await requestManager.post(
      "https://music.163.com/weapi/album/sublist",
      myOptions: myOptions,
      queryParameters: queryParameters,
    );
  }

  // 获取收藏的歌手
  Future<Response> userLikedArtists({int? limit, int? offset}) async {
    MyOptions myOptions = MyOptions(crypto: "weapi");
    Map<String, dynamic> queryParameters = {
      "limit": limit ?? 25,
      "offset": offset ?? 0,
      "total": true,
    };
    return await requestManager.post(
      "https://music.163.com/weapi/artist/sublist",
      myOptions: myOptions,
      queryParameters: queryParameters,
    );
  }

  // 获取收藏的MV
  Future<Response> userLikedMVs({int? limit, int? offset}) async {
    MyOptions myOptions = MyOptions(crypto: "weapi");
    Map<String, dynamic> queryParameters = {
      "limit": limit ?? 25,
      "offset": offset ?? 0,
      "total": true,
    };
    return await requestManager.post(
      "https://music.163.com/weapi/cloudvideo/allvideo/sublist",
      myOptions: myOptions,
      queryParameters: queryParameters,
    );
  }

  // 获取云盘歌曲
  Future<Response> userCloudDisk({int? limit, int? offset}) async {
    MyOptions myOptions = MyOptions(crypto: "weapi");
    Map<String, dynamic> queryParameters = {
      "limit": limit ?? 30,
      "offset": offset ?? 0,
    };
    return await requestManager.post(
      "https://music.163.com/weapi/v1/cloud/get",
      myOptions: myOptions,
      queryParameters: queryParameters,
    );
  }

  // 获取云盘歌曲详细
  Future<Response> userCloudDiskTrackDetail({required List ids}) async {
    MyOptions myOptions = MyOptions(crypto: "weapi");
    Map<String, dynamic> queryParameters = {
      "songIds": ids.join(","),
    };
    return await requestManager.post(
      "https://music.163.com/weapi/v1/cloud/get/byids",
      myOptions: myOptions,
      queryParameters: queryParameters,
    );
  }

  /// 获取听歌排行
  /// - [uid] 用户id
  /// - [type] 0 为所有时间， 1 为最近一周
  Future<Response> userPlayHistory({required String uid, int? type}) async {
    MyOptions myOptions = MyOptions(crypto: "weapi");
    Map<String, dynamic> queryParameters = {
      "uid": uid,
      "type": type ?? 0,
    };
    return await requestManager.post(
      "https://music.163.com/weapi/v1/play/record",
      myOptions: myOptions,
      queryParameters: queryParameters,
    );
  }
}
