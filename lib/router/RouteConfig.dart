import '../pages/appmain/view.dart';
import 'package:get/get.dart';

class RouteConfig {
  //主页面
  static const String main = "/";

  static final List<GetPage> getPages = [
    GetPage(name: main, page: () => const AppMainPage()),
  ];
}