import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musicplayer/common/net/RequestManager.dart';
import 'package:musicplayer/common/utils/AppTheme.dart';
import 'package:musicplayer/common/utils/DataStorageManager.dart';
import 'package:musicplayer/common/utils/PlatFormUtils.dart';
import 'package:musicplayer/generated/l10n.dart';
import 'package:musicplayer/router/RouteConfig.dart';

Future<void> main() async {
  // 首先注册组件
  WidgetsFlutterBinding.ensureInitialized();
  // 初始化数据存储读取器
  await DataStorageManager().init();
  // 初始化网络请求管理
  await RequestManager().persistCookieJarInit();
  // 启动APP
  runApp(const MyApp());
  // 状态栏和底部小白条沉浸
  AppTheme.statusBarAndBottomBarImmersed();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(720, 1080),
      splitScreenMode: true,
      ensureScreenSize: true,
      builder: (context, child) {
        return GetMaterialApp(
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          localeResolutionCallback:
              (Locale? deviceLocale, Iterable<Locale> supportedLocales) {
            // 如果语言是英语
            if (deviceLocale?.languageCode == 'en') {
              DataStorageManager().setString("LanguageCode", "en");
              //注意大小写，返回美国英语
              return const Locale('en', 'US');
            } else if (deviceLocale?.languageCode == 'zh') {
              DataStorageManager().setString("LanguageCode", "zh");
              //注意大小写，返回中文
              return const Locale('zh', 'CN');
            } else {
              return deviceLocale;
            }
          },
          title: 'MusicPlayer',
          theme: ThemeData(
            colorScheme:
                ColorScheme.fromSeed(seedColor: const Color(0x00a0ca86)),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0x00fff0f2),
              brightness: Brightness.dark,
            ),
          ),
          getPages: RouteConfig.getPages,
          initialRoute: RouteConfig.main,
        );
      },
    );
  }
}
