import 'dart:math';

import 'package:get/get.dart';
import 'package:musicplayer/api/AuthApi.dart';
import 'package:musicplayer/api/PlayListApi.dart';
import 'package:musicplayer/api/TrackApi.dart';
import 'package:musicplayer/api/UserApi.dart';
import 'package:musicplayer/common/utils/RequestUtils.dart';

import 'state.dart';

class MusicLibraryLogic extends GetxController {
  final MusicLibraryState state = MusicLibraryState();

  /// 页面初始化
  void pageInit() {
    // 加载数据
    state.futureUserInfoMap = loadUserInfoMap().obs;
    state.futureLikeSongs = loadUserLikeSongs().obs;
    state.futureUserPlayList = loadUserPlayList().obs;
    state.futureUserLikedAlbums = loadUserLikedAlbums().obs;
    state.futureUserLikedArtists = loadUserLikedArtists().obs;
    state.futureUserLikedMVs = loadUserLikedMVs().obs;
    state.futureCloudDiskSongs = loadCloudDisk().obs;
    state.futureHistorySongsRankLastWeek = loadHistorySongsRankLastWeek().obs;
    state.futureHistorySongsRankAllTime = loadHistorySongsRankAllTime().obs;
    // 获取随机歌词
    loadRandomLyric();
  }

  /// 获取随机歌词
  Future<void> loadRandomLyric() async {
    List likeSongs = await state.futureLikeSongs.value;
    if (likeSongs.isEmpty) {
      return;
    }
    // developer.log(likeSongs[0]["id"].runtimeType.toString());
    int id = likeSongs[Random().nextInt(likeSongs.length)]["id"];
    TrackApi().getLyric(id: id.toString()).then((value) {
      var result = RequestUtils.transformResponse(value);
      String lyric = result["lrc"] != null ? result["lrc"]["lyric"] : "";
      // developer.log(lyric.runtimeType.toString());
      List isInstrumental = lyric
          .split("\n")
          .where((element) => !element.contains("纯音乐，请欣赏"))
          .toList();
      if (isInstrumental.isNotEmpty) {
        List<String> lyrics = lyric.split("\n");
        state.randomLyric.value = pickedLyric(lyrics);
      }
    });
  }

  /// 摘取三行歌词
  String pickedLyric(List<String> lyrics) {
    // developer.log(state.randomLyric.toString());
    List lyricLines = lyrics
        .where((line) =>
            !line.contains("作词") &&
            !line.contains("作曲") &&
            line.split("]").last != " ")
        .toList();
    // 获取随机三行歌词
    int lyricsToPick = min(lyricLines.length, 3);
    int randomUpperBound = lyricLines.length - lyricsToPick;

    // 防止为0的时候报错
    if (randomUpperBound == 0) {
      return lyricLines.map((e) {
        return e.split("]").last;
      }).join("\n");
    }

    int startLyricLineIndex = Random().nextInt(randomUpperBound - 1);
    return lyricLines
        .sublist(startLyricLineIndex, startLyricLineIndex + lyricsToPick)
        .map((e) {
      return e.split("]").last;
    }).join("\n");
  }

  /// 获取云盘歌曲
  Future<List> loadCloudDisk() async {
    return UserApi().userCloudDisk(limit: 99999, offset: 0).then((value) {
      var userCloudDisk = RequestUtils.transformResponse(value);
      return userCloudDisk["data"];
    });
  }

  /// 获取用户收藏的MV
  Future<List> loadUserLikedMVs() async {
    return await UserApi().userLikedMVs().then((value) {
      var userLikedMVs = RequestUtils.transformResponse(value);
      return userLikedMVs["data"];
    });
  }

  /// 获取用户收藏的艺人
  Future<List> loadUserLikedArtists() async {
    return await UserApi().userLikedArtists().then((value) {
      var userLikedArtists = RequestUtils.transformResponse(value);
      return userLikedArtists["data"];
    });
  }

  /// 获取用户收藏的专辑
  Future<List> loadUserLikedAlbums() async {
    return await UserApi().userLikedAlbums().then((value) {
      var userLikedAlbums = RequestUtils.transformResponse(value);
      return userLikedAlbums["data"];
    });
  }

  /// 获取用户信息
  Future<Map> loadUserInfoMap() async {
    return await AuthApi().loginStatus().then((value) {
      Map profile = RequestUtils.transformResponse(value)["profile"];
      return profile;
    });
  }

  /// 获取用户歌单
  Future<List> loadUserPlayList() async {
    return await state.futureUserInfoMap.value.then((userInfo) async {
      return await UserApi()
          .userPlayList(uid: userInfo["userId"])
          .then((value) {
        var result = RequestUtils.transformResponse(value);
        return result["playlist"].sublist(1);
      });
    });
  }

  /// 获取我喜欢的歌曲
  Future<List> loadUserLikeSongs() async {
    return await state.futureUserInfoMap.value.then((userInfo) async {
      // 获取我喜欢的音乐列表
      return await UserApi()
          .userPlayList(uid: userInfo["userId"])
          .then((value) async {
        var result = RequestUtils.transformResponse(value);
        // 通过id获取我喜欢的音乐信息
        return await PlayListApi()
            .getPlaylistDetail(id: result["playlist"][0]["id"])
            .then((playList) {
          var data = RequestUtils.transformResponse(playList);
          return data["playlist"]["tracks"];
        });
      });
    });
  }

  /// 获取听歌排行最近一周歌曲
  Future<List> loadHistorySongsRankLastWeek() async {
    return await state.futureUserInfoMap.value.then((userInfo) async {
      // 听歌排行最近一周歌曲
      return await UserApi()
          .userPlayHistory(uid: userInfo["userId"].toString(), type: 1)
          .then((value) async {
        var result = RequestUtils.transformResponse(value);
        return result["weekData"];
      });
    });
  }

  /// 获取听歌排行所有时间歌曲
  Future<List> loadHistorySongsRankAllTime() async {
    return await state.futureUserInfoMap.value.then((userInfo) async {
      // 听歌排行所有时间歌曲
      return await UserApi()
          .userPlayHistory(uid: userInfo["userId"].toString(), type: 0)
          .then((value) async {
        var result = RequestUtils.transformResponse(value);
        return result["allData"];
      });
    });
  }

  /// 听歌排行TabBar切换逻辑
  void historySongsRankChange(int index) {
    if(index == 5) {
      state.historySongsRankIsTrue.value = true;
    } else {
      state.historySongsRankIsTrue.value = false;
    }
  }
}
