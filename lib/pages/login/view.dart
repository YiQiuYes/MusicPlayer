import 'package:css_filter/css_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musicplayer/common/utils/AppTheme.dart';
import 'package:musicplayer/common/utils/ScreenAdaptor.dart';
import 'package:musicplayer/generated/l10n.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'logic.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final logic = Get.put(LoginLogic());
  final state = Get.find<LoginLogic>().state;

  @override
  void initState() {
    logic.loadQRImageUrl();
    super.initState();
  }

  @override
  void dispose() {
    state.timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 状态栏颜色
    AppTheme.statusBarAndBottomBarImmersed();
    return Scaffold(
      body: SafeArea(
        child: ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: Column(
            children: [
              // 间距
              _getHeightPaddingWidget(vertical: 100.w, horizon: 10.w),
              // 获取网易云图标
              _getNeteasePngWidget(),
              // 间距
              _getHeightPaddingWidget(vertical: 40.w, horizon: 15.w),
              // 登录语
              _getLoginTextWidget(),
              // 间距
              _getHeightPaddingWidget(vertical: 50.w, horizon: 15.w),
              // 登录二维码
              _getLoginQRImageView(),
              // 间距
              _getHeightPaddingWidget(vertical: 40.w, horizon: 15.w),
              // 登录提示
              _getLoginTipWidget(),
            ],
          ),
        ),
      ),
    );
  }

  /// 获取登录提示
  Widget _getLoginTipWidget() {
    return Text(
      S.of(context).loginQRTip,
      style: TextStyle(
          fontSize: ScreenAdaptor().getLengthByOrientation(
        vertical: 28.sp,
        horizon: 13.sp,
      )),
    );
  }

  /// 获取登录二维码
  Widget _getLoginQRImageView() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(
        ScreenAdaptor().getLengthByOrientation(
          vertical: 40.w,
          horizon: 20.w,
        ),
      ),
      child: Container(
        width: ScreenAdaptor().getLengthByOrientation(
          vertical: 450.w,
          horizon: 180.w,
        ),
        height: ScreenAdaptor().getLengthByOrientation(
          vertical: 450.w,
          horizon: 180.w,
        ),
        color: const Color.fromRGBO(234, 239, 253, 1.0),
        padding: EdgeInsets.all(
          ScreenAdaptor().getLengthByOrientation(
            vertical: 25.w,
            horizon: 10.5.w,
          ),
        ),
        child: Obx(() {
          return QrImageView(
            data: state.qrCodeUrl.value,
            dataModuleStyle: const QrDataModuleStyle(
              dataModuleShape: QrDataModuleShape.square,
              color: Color.fromRGBO(51, 94, 234, 1.0),
            ),
            eyeStyle: const QrEyeStyle(
              eyeShape: QrEyeShape.square,
              color: Color.fromRGBO(51, 94, 234, 1.0),
            ),
          );
        }),
      ),
    );
  }

  /// 获取登陆语
  Widget _getLoginTextWidget() {
    return Text(
      S.of(context).loginText,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: ScreenAdaptor().getLengthByOrientation(
          vertical: 40.sp,
          horizon: 18.sp,
        ),
      ),
    );
  }

  /// 间距
  Widget _getHeightPaddingWidget({double vertical = 0, double horizon = 0}) {
    return SizedBox(
      height: ScreenAdaptor().getLengthByOrientation(
        vertical: vertical,
        horizon: horizon,
      ),
    );
  }

  /// 获取网易云图标
  Widget _getNeteasePngWidget() {
    return CSSFilter.blur(
      value: ScreenAdaptor().getLengthByOrientation(
        vertical: 0.6.w,
        horizon: 0.3.w,
      ),
      child: Image.asset(
        "lib/assets/logos/netease-music.png",
        width: ScreenAdaptor().getLengthByOrientation(
          vertical: 150.w,
          horizon: 60.w,
        ),
        height: ScreenAdaptor().getLengthByOrientation(
          vertical: 150.w,
          horizon: 60.w,
        ),
      ),
    );
  }
}
