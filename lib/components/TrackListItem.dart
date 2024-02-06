import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'dart:developer' as developer;

import 'package:musicplayer/common/utils/ScreenAdaptor.dart';

class TrackListItem extends StatelessWidget {
  const TrackListItem(
      {super.key,
      required this.track,
      this.subTitleAndArtistPaddingTop,
      required this.subTitleAndArtistPaddingLeft,
      required this.subTitleAndArtistPaddingRight,
      required this.artistPaddingTop,
      required this.subTitleFontSize,
      required this.artistFontSize,
      this.isShowSongAlbumNameAndTimes = false,
      this.albumNamePaddingLeft,
      this.albumNamePaddingRight,
      this.albumNamePaddingTop,
      this.albumNameFontSize,
      this.timeFontSize,
      this.timePaddingTop,
      this.isShowCount = false,
      this.playCount = "0",
      this.countPaddingTop,
      this.countFontSize});

  final Map track;
  // 歌曲标题和歌手边距
  final List<double>? subTitleAndArtistPaddingTop;
  final List<double> subTitleAndArtistPaddingLeft;
  final List<double> subTitleAndArtistPaddingRight;
  final List<double> artistPaddingTop;
  // 歌曲标题和歌手字体大小
  final List<double> subTitleFontSize;
  final List<double> artistFontSize;

  // 是否显示歌曲的专辑和歌曲时间信息
  final bool isShowSongAlbumNameAndTimes;
  // 专辑名字位置
  final List<double>? albumNamePaddingTop;
  final List<double>? albumNamePaddingLeft;
  final List<double>? albumNamePaddingRight;
  final List<double>? timePaddingTop;
  // 字体大小
  final List<double>? albumNameFontSize;
  final List<double>? timeFontSize;

  // 是否显示听歌次数
  final bool isShowCount;
  final String playCount;
  final List<double>? countPaddingTop;
  // 字体大小
  final List<double>? countFontSize;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 图片
        Positioned(
          top: ScreenAdaptor().getLengthByOrientation(
            vertical: 8.w,
            horizon: 5.w,
          ),
          left: ScreenAdaptor().getLengthByOrientation(
            vertical: 8.w,
            horizon: 5.w,
          ),
          bottom: ScreenAdaptor().getLengthByOrientation(
            vertical: 8.w,
            horizon: 5.w,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              ScreenAdaptor().getLengthByOrientation(
                vertical: 12.w,
                horizon: 6.w,
              ),
            ),
            child: CachedNetworkImage(
              imageUrl: getImageUrl(track),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // 歌曲标题
        Positioned(
          top: ScreenAdaptor().getLengthByOrientation(
            vertical: subTitleAndArtistPaddingTop?[0] ?? 8.w,
            horizon: subTitleAndArtistPaddingTop?[1] ?? 5.w,
          ),
          left: ScreenAdaptor().getLengthByOrientation(
            vertical: subTitleAndArtistPaddingLeft[0],
            horizon: subTitleAndArtistPaddingLeft[1],
          ),
          right: ScreenAdaptor().getLengthByOrientation(
            vertical: subTitleAndArtistPaddingRight[0],
            horizon: subTitleAndArtistPaddingRight[1],
          ),
          child: Text.rich(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            TextSpan(
              style: TextStyle(
                fontSize: ScreenAdaptor().getLengthByOrientation(
                  vertical: subTitleFontSize[0],
                  horizon: subTitleFontSize[1],
                ),
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(text: track["name"]),
                TextSpan(
                  text: getSuTitle(track),
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                )
              ],
            ),
          ),
        ),
        // 歌手
        Positioned(
          top: ScreenAdaptor().getLengthByOrientation(
            vertical: artistPaddingTop[0],
            horizon: artistPaddingTop[1],
          ),
          left: ScreenAdaptor().getLengthByOrientation(
            vertical: subTitleAndArtistPaddingLeft[0],
            horizon: subTitleAndArtistPaddingLeft[1],
          ),
          right: ScreenAdaptor().getLengthByOrientation(
            vertical: subTitleAndArtistPaddingRight[0],
            horizon: subTitleAndArtistPaddingRight[1],
          ),
          child: Text(
            getArtists(track),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: ScreenAdaptor().getLengthByOrientation(
                vertical: artistFontSize[0],
                horizon: artistFontSize[1],
              ),
              color: Colors.grey,
            ),
          ),
        ),
        // 显示专辑名称
        Visibility(
          visible: isShowSongAlbumNameAndTimes,
          child: Positioned(
            top: ScreenAdaptor().getLengthByOrientation(
              vertical: albumNamePaddingTop?[0] ?? 0,
              horizon: albumNamePaddingTop?[1] ?? 0,
            ),
            left: ScreenAdaptor().getLengthByOrientation(
              vertical: albumNamePaddingLeft?[0] ?? 0,
              horizon: albumNamePaddingLeft?[1] ?? 0,
            ),
            right: ScreenAdaptor().getLengthByOrientation(
              vertical: albumNamePaddingRight?[0] ?? 0,
              horizon: albumNamePaddingRight?[1] ?? 0,
            ),
            child: Text(
              getAlbumName(track),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: ScreenAdaptor().getLengthByOrientation(
                  vertical: albumNameFontSize?[0] ?? 17.sp,
                  horizon: albumNameFontSize?[1] ?? 12.sp,
                ),
                color: const Color.fromRGBO(0, 0, 0, 0.8),
              ),
            ),
          ),
        ),
        // 显示时间
        Visibility(
          visible: isShowSongAlbumNameAndTimes,
          child: Positioned(
            right: ScreenAdaptor().getLengthByOrientation(
              vertical: 10.w,
              horizon: 8.w,
            ),
            top: ScreenAdaptor().getLengthByOrientation(
              vertical: timePaddingTop?[0] ?? 0,
              horizon: timePaddingTop?[1] ?? 0,
            ),
            child: Text(
              getSongTime(track),
              style: TextStyle(
                color: const Color.fromRGBO(0, 0, 0, 0.8),
                fontSize: ScreenAdaptor().getLengthByOrientation(
                  vertical: timeFontSize?[0] ?? 17.sp,
                  horizon: timeFontSize?[1] ?? 12.sp,
                ),
              ),
            ),
          ),
        ),
        // 显示听歌次数
        Visibility(
          visible: isShowCount,
          child: Positioned(
            right: ScreenAdaptor().getLengthByOrientation(
              vertical: 25.w,
              horizon: 12.w,
            ),
            top: ScreenAdaptor().getLengthByOrientation(
              vertical: countPaddingTop?[0] ?? 0,
              horizon: countPaddingTop?[1] ?? 0,
            ),
            child: Text(
              playCount,
              style: TextStyle(
                color: const Color.fromRGBO(0, 0, 0, 0.8),
                fontSize: ScreenAdaptor().getLengthByOrientation(
                  vertical: countFontSize?[0] ?? 17.sp,
                  horizon: countFontSize?[1] ?? 12.sp,
                ),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 获取歌曲标题信息
  String getSuTitle(Map item) {
    String tn = "";
    if (item["tns"] != null &&
        item["tns"].isNotEmpty &&
        item["name"] != item["tns"][0]) {
      tn = item["tns"][0];
    }

    String alia = "";
    if (item["alia"] != null) {
      alia = item["alia"].isNotEmpty ? item["alia"][0] : "";
    } else {
      alia = "";
    }

    // 优先显示alia
    if (tn != "" || alia != "") {
      if (alia != "") {
        return "（$alia）";
      } else {
        return "（$tn）";
      }
    } else {
      return tn;
    }
  }

  // 获取图片链接
  String getImageUrl(Map item) {
    String imageUrl = item["al"]?["picUrl"] ??
        item["album"]?["picUrl"] ??
        "https://p2.music.126.net/UeTuwE7pvjBpypWLudqukA==/3132508627578625.jpg";

    return "$imageUrl?param=224y224";
  }

  // 获取歌手信息
  String getArtists(Map item) {
    if (item["ar"] != null) {
      if (item["ar"].isNotEmpty) {
        String name = item["ar"].map((e) => e["name"]).join(", ");
        if (name == "null") return "";
        return name;
      }
    } else if (item["artists"] != null) {
      if (item["artists"].isNotEmpty) {
        String name = item["artists"].map((e) => e["name"]).join(", ");
        if (name == "null") return "";
        return name;
      }
    }
    return "";
  }

  // 获取专辑名字
  String getAlbumName(Map item) {
    if (item["album"] != null) {
      return item["album"]["name"] ?? "";
    } else if (item["al"] != null) {
      return item["al"]["name"] ?? "";
    }
    return "";
  }

  // 获取歌曲时间
  String getSongTime(Map item) {
    // 歌曲时间
    double dt = item["dt"] / 1000;
    if (dt == 0) return "0:00";
    // 获取秒
    int second = (dt % 60).truncate();
    return "${dt ~/ 60}:${second < 10 ? "0$second" : second}";
  }
}
