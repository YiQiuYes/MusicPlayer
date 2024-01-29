import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicplayer/common/utils/ScreenAdaptor.dart';
import 'package:musicplayer/common/utils/SongInfo.dart';
import 'package:musicplayer/components/Cover.dart';

class RowCover extends StatelessWidget {
  const RowCover(
      {super.key,
      required this.items,
      this.subText,
      this.type,
      required this.imageWidth,
      required this.imageHeight,
      required this.horizontalSpacing,
      required this.fontMainSize,
      required this.fontSubSize,
      this.columnNumber = 5});

  // 专辑数据
  final List<dynamic> items;
  // 专辑副标题
  final String? subText;
  // 专辑类型
  final String? type;
  // 图片宽度
  final double imageWidth;
  // 图片高度
  final double imageHeight;
  // 水平组件间距
  final double horizontalSpacing;
  // 主字体大小
  final double fontMainSize;
  // 副字体大小
  final double fontSubSize;
  // 一行多少个
  final int columnNumber;

  @override
  Widget build(BuildContext context) {
    List<Widget> rowList = _buildRows(items);
    return SliverList.builder(
      itemCount: rowList.length,
      itemBuilder: (BuildContext context, int index) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: rowList[index],
        );
      },
    );
  }

  /// 单个列组件 playlist
  List<Widget> _singlePlayList(
      {required int index, required List<dynamic> items}) {
    return [
      SizedBox(
        width: imageWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(
                ScreenAdaptor().getLengthByOrientation(
                  vertical: 14.w,
                  horizon: 10.w,
                ),
              ),
              child: Cover(
                id: items[index]["id"],
                imageUrl: SongInfo().getImageUrl(items[index]),
                width: imageWidth,
                height: imageHeight,
              ),
            ),
            SizedBox(
              height: ScreenAdaptor().getLengthByOrientation(
                vertical: 10.w,
                horizon: 5.w,
              ),
            ),
            // 专辑文本
            Text(
              items[index]["name"],
              // 最多两行
              maxLines: 2,
              // 去除溢出
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: fontMainSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            // 副标题文本
            Visibility(
              visible: SongInfo()
                  .getSubText(item: items[index], subText: subText ?? "")
                  .isNotEmpty,
              child: Text(
                SongInfo().getSubText(
                  item: items[index],
                  subText: subText ?? "",
                ),
                // 去除溢出
                overflow: TextOverflow.ellipsis,
                // 最多两行
                maxLines: 2,
                style: TextStyle(
                  fontSize: fontSubSize,
                  color: Colors.black45,
                ),
              ),
            ),
            // 间距
            SizedBox(
              height: ScreenAdaptor().getLengthByOrientation(
                vertical: 40.w,
                horizon: 24.w,
              ),
            ),
          ],
        ),
      ),
      // 间距
      SizedBox(
        width: horizontalSpacing,
      ),
    ];
  }

  /// 单个列组件 artist
  List<Widget> _singleArtist(
      {required int index, required List<dynamic> items}) {
    // 外层为横型
    return [
      // 此组件为列形
      SizedBox(
        width: imageWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipOval(
              child: Cover(
                id: items[index]["id"],
                imageUrl: SongInfo().getImageUrl(items[index]),
                width: imageWidth,
                height: imageHeight,
              ),
            ),
            // 间距
            SizedBox(
              height: ScreenAdaptor().getLengthByOrientation(
                vertical: 10.w,
                horizon: 5.w,
              ),
            ),
            // 歌手名字
            Center(
              child: Text(
                items[index]["name"],
                // 最多两行
                maxLines: 2,
                // 去除溢出
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: fontMainSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // 间距
            SizedBox(
              height: ScreenAdaptor().getLengthByOrientation(
                vertical: 40.w,
                horizon: 24.w,
              ),
            ),
          ],
        ),
      ),
      // 间距
      SizedBox(
        width: horizontalSpacing,
      ),
    ];
  }

  /// 选择单个列组件
  List<Widget> _switchSingle(
      {required int index, required List<dynamic> items}) {
    switch (type) {
      case "playlist":
        return _singlePlayList(index: index, items: items);
      case "artist":
        return _singleArtist(index: index, items: items);
      case "album":
        return _singlePlayList(index: index, items: items);
      default:
        return [];
    }
  }

  /// 添加完整的
  List<Widget> _buildRows(List<dynamic> items) {
    List<Widget> list = [];
    for (int i = 0;
        i < items.length - items.length % columnNumber;
        i += columnNumber) {
      List<Widget> listRow = [];
      for (int j = i; j < i + columnNumber; j++) {
        listRow.addAll(
          _switchSingle(items: items, index: j),
        );
      }

      // 删除最后一个间距
      if (listRow.isNotEmpty) {
        listRow.removeLast();
      }

      list.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: listRow,
        ),
      );
    }

    // 如果还有剩余的
    if (items.length % columnNumber != 0) {
      List<Widget> listRow = [];
      for (int i = items.length - items.length % columnNumber;
          i < items.length;
          i++) {
        listRow.addAll(
          _switchSingle(items: items, index: i),
        );
      }
      // 删除最后一个间距
      if (listRow.isNotEmpty) {
        listRow.removeLast();
      }

      // 添加行
      list.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: listRow,
        ),
      );
    }
    return list;
  }
}
