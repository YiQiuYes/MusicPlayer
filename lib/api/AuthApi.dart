import 'package:musicplayer/common/net/MyOptions.dart';
import 'package:musicplayer/common/net/RequestManager.dart';
import 'package:dio/dio.dart';

class AuthApi {
  AuthApi._privateConstructor();
  static final AuthApi _instance = AuthApi._privateConstructor();
  factory AuthApi() {
    return _instance;
  }

  // 网络管家
  final requestManager = RequestManager();

  /// 获取二维码所需要的key
  Future<Response> loginQrKey({MyOptions? myOptions}) async {
    myOptions ??= MyOptions(crypto: "weapi");
    Map<String, dynamic> queryParameters = {"type": 1};
    return await requestManager.post(
      "https://music.163.com/weapi/login/qrcode/unikey",
      queryParameters: queryParameters,
      myOptions: myOptions,
    );
  }

  /// 生成二维码链接
  Future<Response> loginQrCreate({required String key}) async {
    String url = "https://music.163.com/login?codekey=$key";
    Map<String, dynamic> data = {};
    data["code"] = 200;
    data["data"] = {"qrurl": url};

    return Response<dynamic>(
        requestOptions: RequestOptions(), statusCode: 200, data: data);
  }

  /// 检查二维码登录是否成功
  Future<Response> loginQrCheck(
      {required String key, MyOptions? myOptions}) async {
    myOptions ??= MyOptions(crypto: "weapi");
    Map<String, dynamic> queryParameters = {};
    queryParameters["key"] = key;
    queryParameters["type"] = "1";
    return await requestManager.post(
      "https://music.163.com/weapi/login/qrcode/client/login",
      queryParameters: queryParameters,
      myOptions: myOptions,
    );
  }

  /// 使用cookie登录并检查登录状态信息
  Future<Response> loginStatus() async {
    return await requestManager.post(
        "https://music.163.com/weapi/w/nuser/account/get",
        myOptions: MyOptions(crypto: "weapi"));
  }
}
