import 'package:musicplayer/common/net/MyOptions.dart';
import 'package:musicplayer/common/net/RequestManager.dart';
import 'package:dio/dio.dart';

class OthersApi {
  OthersApi._privateConstructor();
  static final OthersApi _instance = OthersApi._privateConstructor();
  factory OthersApi() {
    return _instance;
  }

  // 网络管家
  final requestManager = RequestManager();

  // 获取私人FM
  Future<Response> getPersonalFM({MyOptions? myOptions}) async {
    myOptions ??= MyOptions();
    myOptions.crypto = "weapi";
    Map<String, dynamic> queryParameters = {};
    return await requestManager.post(
      "https://music.163.com/weapi/v1/radio/get",
      queryParameters: queryParameters,
      myOptions: myOptions,
    );
  }
}
