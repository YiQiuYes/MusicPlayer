import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicplayer/common/utils/ScreenAdaptor.dart';
import 'package:musicplayer/common/utils/SongInfo.dart';
import 'package:musicplayer/components/Cover.dart';

class RowCover extends StatelessWidget {
  const RowCover(
      {super.key, required this.items, required this.subText, this.type});

  // 专辑数据
  final List<dynamic> items;
  // 专辑副标题
  final String subText;
  // 专辑类型
  final String? type;

  @override
  Widget build(BuildContext context) {
    List<Widget> rowList = _buildPlayListRows(items);
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: rowList.length,
        (BuildContext context, int index) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: rowList[index],
          );
        },
      ),
    );
  }

  // 单个列组件
  List<Widget> _singleCover(
      {required int index, required List<dynamic> items}) {
    return [
      SizedBox(
        width: ScreenAdaptor().getLengthByOrientation(
          vertical: 250.w,
          horizon: 120.w,
        ),
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
                width: ScreenAdaptor().getLengthByOrientation(
                  vertical: 250.w,
                  horizon: 120.w,
                ),
                height: ScreenAdaptor().getLengthByOrientation(
                  vertical: 250.w,
                  horizon: 120.w,
                ),
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
                fontSize: ScreenAdaptor().getLengthByOrientation(
                  vertical: 30.sp,
                  horizon: 13.sp,
                ),
                fontWeight: FontWeight.bold,
              ),
            ),
            // 副标题文本
            Visibility(
              visible: SongInfo()
                  .getSubText(
                    item: items[index],
                    subText: subText,
                  )
                  .isNotEmpty,
              child: Text(
                SongInfo().getSubText(
                  item: items[index],
                  subText: subText,
                ),
                // 去除溢出
                overflow: TextOverflow.ellipsis,
                // 最多两行
                maxLines: 2,
                style: TextStyle(
                  fontSize: ScreenAdaptor().getLengthByOrientation(
                    vertical: 22.sp,
                    horizon: 10.sp,
                  ),
                  color: Colors.black45,
                ),
              ),
            ),
            // 间距
            SizedBox(
              height: ScreenAdaptor().getLengthByOrientation(
                vertical: 10.w,
                horizon: 5.w,
              ),
            ),
          ],
        ),
      ),
      // 间距
      SizedBox(
        width: ScreenAdaptor().getLengthByOrientation(
          vertical: 30.w,
          horizon: 16.w,
        ),
      ),
    ];
  }

  // 添加完整的
  List<Widget> _buildPlayListRows(List<dynamic> items) {
    List<Widget> list = [];
    for (int i = 0; i < items.length; i += 5) {
      List<Widget> listRow = [];
      for (int j = i; j < i + 5; j++) {
        listRow.addAll(
          _singleCover(items: items, index: j),
        );
      }

      // 删除最后一个间距
      if (listRow.isNotEmpty) {
        listRow.removeLast();
      }

      list.add(
        Row(
          children: listRow,
        ),
      );
    }

    // 如果还有剩余的
    if (items.length % 5 != 0) {
      List<Widget> listRow = [];
      for (int i = items.length - items.length % 5; i < items.length; i++) {
        listRow.addAll(
          _singleCover(items: items, index: i),
        );
      }
      // 删除最后一个间距
      if (listRow.isNotEmpty) {
        listRow.removeLast();
      }

      // 添加行
      list.add(
        Row(
          children: listRow,
        ),
      );
    }
    return list;
  }
}
