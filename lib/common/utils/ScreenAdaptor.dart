import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScreenAdaptor {
  ScreenAdaptor._();

  static ScreenAdaptor get instance => _getInstance();
  static ScreenAdaptor? _instance;

  static ScreenAdaptor _getInstance() {
    _instance ??= ScreenAdaptor._();
    return _instance!;
  }

  // 屏幕适配工具
  final ScreenUtil _screenUtil = ScreenUtil();

  /// 适配屏幕所需的长度
  double getLengthByOrientation({
    required double vertical,
    required double horizon,
  }) {
    return _screenUtil.orientation.index == 0 ? vertical : horizon;
  }

  /// 传入当前参数获取相对应的宽度
  double getOrientationWidth(double width) {
    return width / _screenUtil.screenWidth;
  }

  /// 获取横屏还是竖屏
  /// true: 竖屏  false: 横屏
  bool getOrientation() {
    return _screenUtil.orientation.index == 0 ? true : false;
  }
}
