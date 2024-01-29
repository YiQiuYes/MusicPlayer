import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicplayer/common/utils/ScreenAdaptor.dart';
import 'package:musicplayer/generated/l10n.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:tinycolor2/tinycolor2.dart';

class FMCard extends StatefulWidget {
  const FMCard(
      {super.key, required this.width, required this.height, this.items});

  // 宽高
  final double width;
  final double height;
  final List<dynamic>? items;

  @override
  State<FMCard> createState() => _FMCardState();
}

class _FMCardState extends State<FMCard> {
  // 专辑图片
  late Image image;
  late Future<List<Color>> colors;

  @override
  void initState() {
    super.initState();
    image =
        Image.network(widget.items![0]["album"]["picUrl"] + "?param=512y512");
    colors = PaletteGenerator.fromImageProvider(image.image).then((value) {
      TinyColor color = TinyColor.fromColor(value.dominantColor!.color);
      Color dominantColorBottomRight = color.darken(10).color;
      Color dominantColorTopLeft = color.lighten(28).spin(-30).color;
      return [dominantColorTopLeft, dominantColorBottomRight];
    });
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
          future: colors,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Stack(
                children: [
                  // 渐变背景
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        // 渐变颜色
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          stops: const [0.0, 1.0],
                          colors: [snapshot.data[0], snapshot.data[1]],
                        ),
                      ),
                    ),
                  ),
                  // 专辑图片
                  Positioned(
                    top: ScreenAdaptor().getLengthByOrientation(
                      vertical: 20.w,
                      horizon: 10.w,
                    ),
                    left: ScreenAdaptor().getLengthByOrientation(
                      vertical: 20.w,
                      horizon: 11.w,
                    ),
                    bottom: ScreenAdaptor().getLengthByOrientation(
                      vertical: 20.w,
                      horizon: 10.w,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        ScreenAdaptor().getLengthByOrientation(
                          vertical: 16.w,
                          horizon: 10.w,
                        ),
                      ),
                      child: image,
                    ),
                  ),
                  // 私人FM图标和文字
                  Positioned(
                    right: ScreenAdaptor().getLengthByOrientation(
                      vertical: 15.w,
                      horizon: 10.w,
                    ),
                    bottom: ScreenAdaptor().getLengthByOrientation(
                      vertical: 18.w,
                      horizon: 10.w,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.radio_rounded,
                          size: ScreenAdaptor().getLengthByOrientation(
                            vertical: 22.w,
                            horizon: 13.w,
                          ),
                          color: Colors.white.withOpacity(0.18),
                        ),
                        // 间隔
                        SizedBox(
                          width: ScreenAdaptor().getLengthByOrientation(
                            vertical: 8.w,
                            horizon: 4.w,
                          ),
                        ),
                        Text(
                          S.of(context).homeDailyTracksCardTitle,
                          style: TextStyle(
                            letterSpacing: 0,
                            color: Colors.white.withOpacity(0.18),
                            fontSize: ScreenAdaptor().getLengthByOrientation(
                              vertical: 20.sp,
                              horizon: 11.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 按钮侧
                  Positioned(
                    left: ScreenAdaptor().getLengthByOrientation(
                      vertical: 245.w,
                      horizon: 120.w,
                    ),
                    bottom: ScreenAdaptor().getLengthByOrientation(
                      vertical: 15.w,
                      horizon: 10.w,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 不喜欢按钮
                        SizedBox(
                          width: ScreenAdaptor().getLengthByOrientation(
                            vertical: 60.w,
                            horizon: 30.w,
                          ),
                          height: ScreenAdaptor().getLengthByOrientation(
                            vertical: 60.w,
                            horizon: 30.w,
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: Icon(
                              Icons.thumb_down_rounded,
                              size: ScreenAdaptor().getLengthByOrientation(
                                vertical: 40.w,
                                horizon: 20.w,
                              ),
                              color: Colors.white,
                            ),
                            onPressed: () {},
                          ),
                        ),
                        // 播放按钮
                        SizedBox(
                          width: ScreenAdaptor().getLengthByOrientation(
                            vertical: 60.w,
                            horizon: 30.w,
                          ),
                          height: ScreenAdaptor().getLengthByOrientation(
                            vertical: 60.w,
                            horizon: 30.w,
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            // 播放按钮
                            icon: Icon(
                              Icons.play_arrow_rounded,
                              size: ScreenAdaptor().getLengthByOrientation(
                                vertical: 55.w,
                                horizon: 30.w,
                              ),
                              color: Colors.white,
                            ),
                            onPressed: () {},
                          ),
                        ),
                        // 下一首按钮
                        SizedBox(
                          width: ScreenAdaptor().getLengthByOrientation(
                            vertical: 60.w,
                            horizon: 30.w,
                          ),
                          height: ScreenAdaptor().getLengthByOrientation(
                            vertical: 60.w,
                            horizon: 30.w,
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            // 下一首按钮
                            icon: Icon(
                              Icons.skip_next_rounded,
                              size: ScreenAdaptor().getLengthByOrientation(
                                vertical: 55.w,
                                horizon: 30.w,
                              ),
                              color: Colors.white,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 歌曲信息
                  Positioned(
                    top: ScreenAdaptor().getLengthByOrientation(
                      vertical: 20.w,
                      horizon: 10.w,
                    ),
                    left: ScreenAdaptor().getLengthByOrientation(
                      vertical: 250.w,
                      horizon: 125.w,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: ScreenAdaptor().getLengthByOrientation(
                            vertical: 300.w,
                            horizon: 150.w,
                          ),
                          child: Text(
                            widget.items![0]["name"],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: ScreenAdaptor().getLengthByOrientation(
                                vertical: 32.sp,
                                horizon: 16.sp,
                              ),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // 间隔
                        SizedBox(
                          height: ScreenAdaptor().getLengthByOrientation(
                            vertical: 6.w,
                            horizon: 4.w,
                          ),
                        ),
                        Text(
                          widget.items![0]["artists"][0]["name"],
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: ScreenAdaptor().getLengthByOrientation(
                              vertical: 22.sp,
                              horizon: 11.5.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
