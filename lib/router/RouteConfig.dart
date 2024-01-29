import 'package:musicplayer/pages/login/view.dart';

import '../pages/appmain/view.dart';
import 'package:get/get.dart';

class RouteConfig {
  // 主页面
  static const String main = "/";
  // 登录页面
  static const String login = "/login";

  static final List<GetPage> getPages = [
    GetPage(name: main, page: () => const AppMainPage()),
    GetPage(name: login, page: () => const LoginPage()),
  ];
}
