import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dart:developer' as developer;

import 'package:musicplayer/common/utils/ScreenAdaptor.dart';
import 'package:musicplayer/components/TrackListItem.dart';

class TrackList extends StatelessWidget {
  const TrackList(
      {super.key,
      required this.type,
      required this.tracks,
      this.columnCount = 4,
      this.isShowSongAlbumNameAndTimes = false});

  // 类型
  final String type;
  // 歌单列表
  final List tracks;
  // 显示几列
  final int columnCount;
  // 是否显示歌曲的专辑和歌曲时间信息
  final bool isShowSongAlbumNameAndTimes;

  String _getMusicID(String type, Map item) {
    switch (type) {
      case "playlist":
        return item["id"].toString();
      case "sliverCloudDisk":
        return item["song"]["id"].toString();
    }
    return "0";
  }

  Map _getTrack(String type, Map item) {
    switch (type) {
      case "playlist":
        return item;
      case "sliverCloudDisk":
        return item["simpleSong"];
    }
    return item;
  }

  Widget _bulidTrackList() {
    return GridView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columnCount,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        childAspectRatio: ScreenAdaptor().getLengthByOrientation(
          vertical: 3.33,
          horizon: 3.14,
        ),
      ),
      itemCount: 12,
      itemBuilder: (context, index) {
        return TrackListItem(
          track: tracks[index],
          subTitleAndArtistPaddingLeft: [88.w, 52.w],
          subTitleAndArtistPaddingRight: [15.w, 2.w],
          artistPaddingTop: [33.w, 25.w],
          subTitleFontSize: [20.sp, 12.sp],
          artistFontSize: [17.sp, 9.sp],
        );
      },
    );
  }

  Widget _buildSliverSongsList(String type) {
    // developer.log(tracks[0].toString());
    return SliverAlignedGrid.count(
      crossAxisCount: columnCount,
      mainAxisSpacing: 5,
      itemCount: tracks.length,
      itemBuilder: (BuildContext context, int index) {
        return SizedBox(
          height: ScreenAdaptor().getLengthByOrientation(
            vertical: 80.h,
            horizon: 85.h,
          ),
          child: TrackListItem(
            track: _getTrack(type, tracks[index]),
            subTitleAndArtistPaddingTop: [18.w, 11.w],
            subTitleAndArtistPaddingLeft: [120.w, 70.w],
            subTitleAndArtistPaddingRight: [350.w, 330.w],
            artistPaddingTop: [55.w, 32.w],
            subTitleFontSize: [24.sp, 14.sp],
            artistFontSize: [18.sp, 11.sp],
            isShowSongAlbumNameAndTimes: isShowSongAlbumNameAndTimes,
            albumNamePaddingLeft: [360.w, 300.w],
            albumNamePaddingRight: [100.w, 60.w],
            albumNamePaddingTop: [28.w, 18.w],
            albumNameFontSize: [22.sp, 13.sp],
            timePaddingTop: [31.w, 19.w],
            timeFontSize: [21.sp, 13.sp],
          ),
        );
      },
    );
  }

  Widget _buildSliverTrackList() {
    // developer.log(tracks[0].toString());
    return SliverAlignedGrid.count(
      crossAxisCount: columnCount,
      mainAxisSpacing: 5,
      itemCount: tracks.length,
      itemBuilder: (BuildContext context, int index) {
        return SizedBox(
          height: ScreenAdaptor().getLengthByOrientation(
            vertical: 80.h,
            horizon: 85.h,
          ),
          child: TrackListItem(
            track: tracks[index]["song"],
            subTitleAndArtistPaddingTop: [18.w, 11.w],
            subTitleAndArtistPaddingLeft: [120.w, 70.w],
            subTitleAndArtistPaddingRight: [180.w, 100.w],
            artistPaddingTop: [55.w, 32.w],
            subTitleFontSize: [24.sp, 14.sp],
            artistFontSize: [18.sp, 11.sp],
            isShowCount: true,
            playCount: tracks[index]["playCount"].toString(),
            countPaddingTop: [22.w, 13.w],
            countFontSize: [28.sp, 18.sp],
          ),
        );
      },
    );
  }

  Widget switchType(String type) {
    switch (type) {
      case "tracklist":
        return _bulidTrackList();
      case "sliverCloudDisk":
        return _buildSliverSongsList(type);
      case "sliverTrackList":
        return _buildSliverTrackList();
      case "playlist":
        return _buildSliverSongsList(type);
      default:
        return _bulidTrackList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return switchType(type);
  }
}
