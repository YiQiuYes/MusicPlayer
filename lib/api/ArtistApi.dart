import 'package:musicplayer/common/net/MyOptions.dart';
import 'package:musicplayer/common/net/RequestManager.dart';
import 'package:dio/dio.dart';

class ArtistApi {
  ArtistApi._privateConstructor();
  static final ArtistApi _instance = ArtistApi._privateConstructor();
  factory ArtistApi() {
    return _instance;
  }

  // 网络管家
  final requestManager = RequestManager();

  /// 歌手榜
  Future<Response> getTopListOfArtists(
      {MyOptions? myOptions, int? limit, int? offset}) async {
    myOptions ??= MyOptions();
    myOptions.crypto = "weapi";
    Map<String, dynamic> queryParameters = {
      "limit": limit ?? 50,
      "offset": offset ?? 0,
      "total": true,
    };
    return await requestManager.post(
      "https://music.163.com/weapi/artist/top",
      queryParameters: queryParameters,
      myOptions: myOptions,
    );
  }
}
