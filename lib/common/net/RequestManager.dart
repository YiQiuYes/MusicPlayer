import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:encrypt/encrypt.dart';
import 'package:musicplayer/common/net/MyOptions.dart';
import 'package:musicplayer/common/utils/Crypto.dart';
import 'package:path_provider/path_provider.dart';

class RequestManager {
  RequestManager._privateConstructor();
  static final RequestManager _instance = RequestManager._privateConstructor();
  factory RequestManager() {
    return _instance;
  }

  final String _anonymousTokenStr = "abcdefghijklmnopqrstuvwxyz0123456789";
  final String userAgent =
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/118.0.0.0 Safari/537.36 Edg/118.0.2088.76";
  static final Dio _dio = Dio();
  late PersistCookieJar _persistCookieJar;

  // 获取dio
  Dio getDio() {
    return _dio;
  }

  // 初始化cookie管理器,main函数中调用
  Future<void> persistCookieJarInit() async {
    Directory tempDir = await getTemporaryDirectory();
    final tempPath = tempDir.path;
    _persistCookieJar = PersistCookieJar(
      ignoreExpires: true,
      storage: FileStorage(tempPath),
    );
    // 添加拦截器
    _dio.interceptors.add(CookieManager(_persistCookieJar));
    _persistCookieJar
        .loadForRequest(Uri.parse("https://music.163.com"))
        .then((value) {
      // TODO: 未完成
      if (value.isEmpty) {
        _persistCookieJar.saveFromResponse(Uri.parse("https://music.163.com"), [
          Cookie("__remember_me", "true"),
          Cookie("_ntes_nuid", Encrypted.fromSecureRandom(16).base16),
          Cookie("MUSIC_A", _anonymousToken()),
        ]);
      }

      MyOptions myOptions = MyOptions();
      myOptions.crypto = "weapi";
      Map<String, dynamic> queryParameters = {
        "limit": 30,
        "total": true,
        "n": 1000,
      };
      post(
        "https://music.163.com/weapi/personalized/playlist",
        queryParameters: queryParameters,
        myOptions: myOptions,
      ).then((value) => print(value));
    });
  }

  // {
  //   Map<String, dynamic> cookieMap = {};
  //   cookieMap["__remember_me"] = "true";
  //   cookieMap["_ntes_nuid"] = Encrypted.fromSecureRandom(16).base16;
  //
  //   if (!url.contains("login")) {
  //     cookieMap['NMTID'] = Encrypted.fromSecureRandom(16).base16;
  //   }
  //
  //   if (cookieMap["MUSIC_U"] == null) {
  //     // 游客
  //     if (cookieMap["MUSIC_A"] == null) {
  //       cookieMap["MUSIC_A"] = _anonymousToken();
  //     }
  //   }
  //
  //   String cookieParam = "";
  //   cookieMap.forEach((key, value) {
  //     cookieParam =
  //         "$cookieParam${Uri.encodeComponent(key)}=${Uri.encodeComponent(value)}; ";
  //   });
  //
  //   _dio.options.headers["Cookie"] = cookieParam;
  // }

  // get请求
  Future<Response> get(String url,
      {Map<String, dynamic>? queryParameters, MyOptions? myOptions}) async {
    myOptions ??= MyOptions(); // 为空则创建
    myOptions.method = "GET";
    myOptions.responseType = ResponseType.json;
    myOptions.headers = {"User-Agent": userAgent};

    // 处理参数
    Map<String, dynamic> resultParam = await _samePrecess(url,
        queryParameters: queryParameters, myOptions: myOptions);
    queryParameters = resultParam["queryParameters"];
    myOptions = resultParam["myOptions"];

    return await _dio.get(url,
        queryParameters: queryParameters, options: myOptions);
  }

  // post请求
  Future<Response> post(String url,
      {Map<String, dynamic>? queryParameters, MyOptions? myOptions}) async {
    myOptions ??= MyOptions(); // 为空则创建
    myOptions.method = "POST";
    myOptions.responseType = ResponseType.json;
    myOptions.headers = {"User-Agent": userAgent};

    // 处理参数
    Map<String, dynamic> resultParam = await _samePrecess(url,
        queryParameters: queryParameters, myOptions: myOptions);

    queryParameters = resultParam["queryParameters"];
    myOptions = resultParam["myOptions"];

    Response response = await _dio.post(url,
        queryParameters: queryParameters, options: myOptions);
    return response;
  }

  Future<Map<String, dynamic>> _samePrecess(String url,
      {Map<String, dynamic>? queryParameters,
      required MyOptions myOptions}) async {
    // 添加请求头
    if (myOptions.method?.toUpperCase() == "POST") {
      _dio.options.headers["Content-Type"] =
          "application/x-www-form-urlencoded";
    }

    if (url.contains("music.163.com")) {
      _dio.options.headers["Referer"] = "https://music.163.com";
    }

    if (myOptions.reaIP != null) {
      _dio.options.headers['X-Real-IP'] = myOptions.reaIP;
      _dio.options.headers['X-Forwarded-For'] = myOptions.reaIP;
    }

    // {
    //   Map<String, dynamic> cookieMap = {};
    //   cookieMap["__remember_me"] = "true";
    //   cookieMap["_ntes_nuid"] = Encrypted.fromSecureRandom(16).base16;
    //
    //   if (!url.contains("login")) {
    //     cookieMap['NMTID'] = Encrypted.fromSecureRandom(16).base16;
    //   }
    //
    //   if (cookieMap["MUSIC_U"] == null) {
    //     // 游客
    //     if (cookieMap["MUSIC_A"] == null) {
    //       cookieMap["MUSIC_A"] = _anonymousToken();
    //     }
    //   }
    //
    //   String cookieParam = "";
    //   cookieMap.forEach((key, value) {
    //     cookieParam =
    //         "$cookieParam${Uri.encodeComponent(key)}=${Uri.encodeComponent(value)}; ";
    //   });
    //
    //   _dio.options.headers["Cookie"] = cookieParam;
    // }

    if (myOptions.crypto?.toLowerCase() == "weapi") {
      _dio.options.headers["User-Agent"] =
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36 Edg/116.0.1938.69";
      queryParameters =
          jsonDecode(nestedCrypto.weapi(jsonEncode(queryParameters)));
      RegExp exp = RegExp(r"\w*api");
      url = url.replaceAll(exp, "weapi");
    }

    return {
      "url": url,
      "queryParameters": queryParameters,
      "myOptions": myOptions,
    };
  }

  // 获取匿名token
  String _anonymousToken() {
    Uint8List bytes = Encrypted.fromSecureRandom(16).bytes;
    return bytes.map((n) => _anonymousTokenStr[(n % 36)]).toList().join();
  }
}
