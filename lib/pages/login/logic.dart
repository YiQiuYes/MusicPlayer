import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:get/get.dart';
import 'package:musicplayer/api/AuthApi.dart';
import 'package:musicplayer/common/utils/EventBusManager.dart';
import 'package:musicplayer/common/utils/ShareData.dart';
import 'package:musicplayer/pages/home/view.dart';
import 'package:musicplayer/router/RouteConfig.dart';

import 'state.dart';

class LoginLogic extends GetxController {
  final LoginState state = LoginState();

  /// 加载二维码链接
  void loadQRImageUrl() {
    AuthApi().loginQrKey().then((value) async {
      String key = value.data["unikey"];
      state.qrCodeKey = key;
      String url = await AuthApi()
          .loginQrCreate(key: key)
          .then((value) => value.data["data"]["qrurl"]);
      state.qrCodeUrl.value = url;
      // 检查登录状态
      checkQrLoginState();
    });
  }

  /// 定时器刷新数据
  void checkQrLoginState() {
    state.timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      AuthApi().loginQrCheck(key: state.qrCodeKey).then((value) {
        if (value.data["code"] == 803) {
          List<ShareDataType> typeList = [ShareDataType.pageState];
          Map pageOthers = {
            "appMain": {
              "currentIndex": 2,
            }
          };
          EventBusManager().eventBus.fire(ShareData(
                typeList: typeList,
                isReFreshPage: true,
                pageOthers: pageOthers,
              ));
          // 取消定时器
          timer.cancel();
          // 跳转到主页
          Get.back();
        }
      });
    });
  }
}
