import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicplayer/common/utils/ScreenAdaptor.dart';
import 'package:musicplayer/common/utils/backdropcssfilter/filter.dart';

class DailyTracksCard extends StatefulWidget {
  const DailyTracksCard(
      {super.key,
      required this.width,
      required this.height,
      this.dailyTracksList,
      this.defaultTracksList = const [
        'https://p2.music.126.net/0-Ybpa8FrDfRgKYCTJD8Xg==/109951164796696795.jpg',
        'https://p2.music.126.net/QxJA2mr4hhb9DZyucIOIQw==/109951165422200291.jpg',
        'https://p1.music.126.net/AhYP9TET8l-VSGOpWAKZXw==/109951165134386387.jpg',
      ]});

  final double width;
  final double height;
  final List<dynamic>? dailyTracksList;
  final List<String>? defaultTracksList;

  @override
  State<DailyTracksCard> createState() => _DailyTracksCardState();
}

class _DailyTracksCardState extends State<DailyTracksCard>
    with SingleTickerProviderStateMixin {
  // 平移动画控制器
  late AnimationController animationController;
  late Animation<double> animation;
  late Future<ui.Image> image;

  // 获取For You 每日推荐图片
  Future<ui.Image> loadDailyTracksImage(String path) async {
    final data = await NetworkAssetBundle(Uri.parse(path)).load(path);
    final bytes = data.buffer.asUint8List();
    final image = await decodeImageFromList(bytes);
    return image;
  }

  // 获取图片构建器
  Future<ui.Image> loadUiImage() async {
    if (widget.dailyTracksList != null && widget.dailyTracksList!.isNotEmpty) {
      return await loadDailyTracksImage(
              widget.dailyTracksList![0]["al"]["picUrl"])
          .then((value) {
        animationController = AnimationController(
          duration: const Duration(seconds: 28),
          vsync: this,
        )..repeat(reverse: true);

        animation = animationController.drive(Tween(
          begin: 0,
          end: (value.height * widget.width / value.width - widget.height),
        ));
        return value;
      });
    } else {
      // 随机从0到3的数，不包括3
      int index = Random().nextInt(3).toInt();
      return await loadDailyTracksImage(widget.defaultTracksList![index])
          .then((value) {
        animationController = AnimationController(
          duration: const Duration(seconds: 28),
          vsync: this,
        )..repeat(reverse: true);

        animation = animationController.drive(Tween(
          begin: 0,
          end: (value.height * widget.width / value.width - widget.height),
        ));
        return value;
      });
    }
  }

  @override
  void initState() {
    // 异步获取图片
    image = loadUiImage();
    super.initState();
  }

  @override
  void dispose() {
    // 释放动画资源
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(
        ScreenAdaptor().getLengthByOrientation(vertical: 20.w, horizon: 12.w),
      ),
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: FutureBuilder(
          future: image,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: DailyTracksCardPainter(
                        image: snapshot.data,
                        currentY: animation,
                        repaint: animationController,
                      ),
                    ),
                  ),
                  Positioned(
                    top: ScreenAdaptor().getLengthByOrientation(
                      vertical: 40.w,
                      horizon: 17.w,
                    ),
                    left: ScreenAdaptor().getLengthByOrientation(
                      vertical: 40.w,
                      horizon: 18.w,
                    ),
                    child: Text(
                      "每日\n推荐",
                      style: TextStyle(
                        fontSize: ScreenAdaptor().getLengthByOrientation(
                          vertical: 60.sp,
                          horizon: 30.sp,
                        ),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: ScreenAdaptor().getLengthByOrientation(
                          vertical: 25.w,
                          horizon: 12.w,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: ScreenAdaptor().getLengthByOrientation(
                      vertical: 25.w,
                      horizon: 10.w,
                    ),
                    bottom: ScreenAdaptor().getLengthByOrientation(
                      vertical: 25.w,
                      horizon: 10.w,
                    ),
                    child: ClipOval(
                      child: BackdropCSSFilter.blur(
                        value: ScreenAdaptor().getLengthByOrientation(
                          vertical: 10.w,
                          horizon: 5.w,
                        ),
                        child: IconButton(
                          iconSize: ScreenAdaptor().getLengthByOrientation(
                            vertical: 60.w,
                            horizon: 35.w,
                          ),
                          // 播放按钮
                          icon: const Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.white,
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  )
                ],
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

// 画布类
class DailyTracksCardPainter extends CustomPainter {
  ui.Image? image;
  double x;
  // 当前y轴位置
  final Animation<double> currentY;
  final Animation<double> repaint;

  DailyTracksCardPainter(
      {this.image, this.x = 0, required this.currentY, required this.repaint})
      : super(repaint: repaint);

  final painter = Paint();
  @override
  void paint(Canvas canvas, Size size) {
    double imageX = image!.width.toDouble();
    double imageY = image!.height.toDouble();
    // 要绘制的Rect，即原图片的大小
    Rect src = Rect.fromLTWH(0, 0, imageX, imageY);
    // 要绘制成的Rect，即绘制后的图片大小
    canvas.drawImageRect(
        image!,
        src,
        Rect.fromLTWH(
            x,
            -currentY.value,
            image!.width.toDouble() * size.width / imageX,
            image!.height.toDouble() * size.width / imageY),
        painter);
  }

  @override
  bool shouldRepaint(covariant DailyTracksCardPainter oldDelegate) {
    return oldDelegate.repaint != repaint;
  }
}
