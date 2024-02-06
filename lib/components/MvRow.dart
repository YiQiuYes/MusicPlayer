import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicplayer/common/utils/ScreenAdaptor.dart';

class MvRow extends StatelessWidget {
  const MvRow(
      {super.key,
      required this.items,
      required this.imageWidth,
      required this.imageHeight,
      required this.horizontalSpacing,
      required this.fontMainSize,
      required this.fontSubSize,
      this.columnNumber = 5});

  // 专辑数据
  final List<dynamic> items;
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

  String _getImageUrl(item) {
    String url = item["imgurl16v9"] ?? item["cover"] ?? item["coverUrl"];
    return "$url?param=464y260";
  }

  /// 单个列组件
  List<Widget> _singleComponent(
      {required int index, required List<dynamic> items}) {
    // 外层为横型
    return [
      // 此组件为列形
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
              child: CachedNetworkImage(
                imageUrl: _getImageUrl(items[index]),
                width: imageWidth,
                height: imageHeight,
                fit: BoxFit.cover,
              ),
            ),
            // 间距
            SizedBox(
              height: ScreenAdaptor().getLengthByOrientation(
                vertical: 10.w,
                horizon: 5.w,
              ),
            ),
            // 标题文本
            Center(
              child: Text(
                items[index]["title"],
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
            // 副标题
            Text(
              items[index]["creator"][0]["userName"],
              // 去除溢出
              overflow: TextOverflow.ellipsis,
              // 最多两行
              maxLines: 2,
              style: TextStyle(
                fontSize: fontSubSize,
                color: Colors.black45,
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

  /// 添加完整的
  List<Widget> _buildRows(List<dynamic> items) {
    List<Widget> list = [];
    for (int i = 0;
    i < items.length - items.length % columnNumber;
    i += columnNumber) {
      List<Widget> listRow = [];
      for (int j = i; j < i + columnNumber; j++) {
        listRow.addAll(
          _singleComponent(items: items, index: j),
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
          _singleComponent(items: items, index: i),
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
