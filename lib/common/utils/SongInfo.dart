class SongInfo {
  SongInfo._privateConstructor();
  static final SongInfo _instance = SongInfo._privateConstructor();
  factory SongInfo() {
    return _instance;
  }

  // 获取副标题
  String getSubText(
      {required String subText, required Map<String, dynamic> item}) {
    if (subText == "appleMusic") {
      return "by Apple Music";
    } else if (subText == "artist") {
      if (item["artist"] != null) {
        return item["artist"]["name"];
      }

      if (item["artists"] != null) {
        return item["artists"][0]["name"];
      }
    } else if (subText == "updateFrequency") {
      return item["updateFrequency"];
    } else if (subText == "copywriter") {
      return item["copywriter"] ?? "";
    } else if (subText == "creator") {
      return "by ${item["creator"]["nickname"]}";
    }
    return "";
  }

  // 获取图片链接
  String getImageUrl(Map<String, dynamic> item) {
    if (item["img1v1Url"] != null) {
      var img1v1ID = item["img1v1Url"].split('/');
      img1v1ID = img1v1ID[img1v1ID.length - 1];

      if (img1v1ID == "5639395138885805.jpg") {
        // 没有头像的歌手，网易云返回的img1v1Url并不是正方形的 😅😅😅
        return "https://p2.music.126.net/VnZiScyynLG7atLIZ2YPkw==/18686200114669622.jpg?param=512y512";
      }

      return item["img1v1Url"] + "?param=512y512";
    }

    if (item["picUrl"] != null) {
      return item["picUrl"] + "?param=512y512";
    }

    return item["coverImgUrl"] + "?param=512y512";
  }
}
