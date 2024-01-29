import 'dart:async';

import 'package:get/get.dart';

class LoginState {
  late RxString qrCodeUrl; // 登录二维码图片链接
  late String qrCodeKey; // 登录二维码的key
  late Timer timer; // 二维码检测是否登录成功定时器

  LoginState() {
    qrCodeUrl = "等待链接数据获取".obs;
    qrCodeKey = "";
  }
}
