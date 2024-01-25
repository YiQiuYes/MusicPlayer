import 'package:musicplayer/common/net/MyOptions.dart';
import 'package:musicplayer/common/net/RequestManager.dart';
import 'package:dio/dio.dart';

class AlbumApi {
  AlbumApi._privateConstructor();
  static final AlbumApi _instance = AlbumApi._privateConstructor();
  factory AlbumApi() {
    return _instance;
  }

  // 网络管家
  final requestManager = RequestManager();

  /// 获取全部新碟
  /// ALL:全部,ZH:华语,EA:欧美,KR:韩国,JP:日本
  Future<Response> getNewAlbums({MyOptions? myOptions, int? limit, int? offset, String? area}) async {
    myOptions ??= MyOptions();
    myOptions.crypto = "weapi";
    Map<String, dynamic> queryParameters = {
      "limit" : limit ?? 30,
      "offset" : offset ?? 0,
      "total" : true,
      "area" : area ?? "ALL",
    };
    return await requestManager.post(
      "https://music.163.com/weapi/album/new",
      queryParameters: queryParameters,
      myOptions: myOptions,
    );
  }
}
