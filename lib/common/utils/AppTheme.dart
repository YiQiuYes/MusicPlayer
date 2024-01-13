import 'package:get/get.dart';

class AppTheme {
  AppTheme._privateConstructor();
  static final AppTheme _instance = AppTheme._privateConstructor();
  factory AppTheme() {
    return _instance;
  }

  /// 判断是否为暗色模式并返回对应的值
  T? isDarkMode<T>({T? dart, T? light}) {
    return Get.isDarkMode ? dart : light;
  }
}
