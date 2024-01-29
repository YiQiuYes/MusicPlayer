enum ShareDataType {
  pageState,
}

class ShareData {
  ShareData(
      {required this.typeList, this.isReFreshPage = false, this.pageOthers});

  // 数据类型
  final List<ShareDataType> typeList;

  /// pageState数据区
  bool isReFreshPage; // 是否刷新页面数据
  Map? pageOthers; // 页面状态其他信息

  /// 通过ShareDataType获取相对应的值
  Map _getValuesByShareDataType(ShareDataType shareDataType) {
    switch (shareDataType) {
      case ShareDataType.pageState:
        return {
          "isReFreshPage": isReFreshPage,
          "pageOthers": pageOthers,
        };
      default:
        return {};
    }
  }

  /// 获取相应数据
  Map<ShareDataType, Map> get mapData {
    Map<ShareDataType, Map> map = {};
    for (ShareDataType shareDataType in typeList) {
      map[shareDataType] = _getValuesByShareDataType(shareDataType);
    }
    return map;
  }
}
