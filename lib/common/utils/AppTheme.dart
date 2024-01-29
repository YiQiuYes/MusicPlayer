import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:musicplayer/common/utils/PlatFormUtils.dart';

class AppTheme {
  AppTheme._privateConstructor();
  static final AppTheme _instance = AppTheme._privateConstructor();
  factory AppTheme() {
    return _instance;
  }

  /// 判断是否为暗色模式并返回对应的值
  static T? isDarkMode<T>({T? dart, T? light}) {
    return Get.isDarkMode ? dart : light;
  }

  /// 状态栏和底部小白条沉浸
  static void statusBarAndBottomBarImmersed() {
    if (PlatformUtils.isAndroid || PlatformUtils.isIOS) {
      SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        // statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        // systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: Colors.transparent,
        // statusBarIconBrightness: Brightness.dark,
      );
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }
}
