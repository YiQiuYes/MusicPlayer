import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musicplayer/common/net/RequestManager.dart';
import 'package:musicplayer/common/utils/DataStorageManager.dart';
import 'package:musicplayer/generated/l10n.dart';
import 'package:musicplayer/router/RouteConfig.dart';

Future<void> main() async {
  // 首先注册组件
  WidgetsFlutterBinding.ensureInitialized();
  // 初始化数据存储读取器
  await DataStorageManager().init();
  // 初始化网络请求管理
  await RequestManager().persistCookieJarInit();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(720, 1080),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
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
