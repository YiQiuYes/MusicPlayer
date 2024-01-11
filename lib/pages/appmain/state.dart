import 'package:get/get_rx/src/rx_types/rx_types.dart';

class AppMainState {
  // 导航栏索引
  late RxInt currentIndex;

  AppMainState() {
    currentIndex = 0.obs;
  }
}
