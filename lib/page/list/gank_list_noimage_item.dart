import 'package:AFlutter/entity/gank_bean.dart';
import 'package:flutter/material.dart';

class GankListNoImageItem extends StatefulWidget {
  GankListNoImageItem({Key key, this.bean, this.onPressed}) : super(key: key);
  final GankBean bean;
  final VoidCallback onPressed;

  @override
  _GankListNoImageItemState createState() =>
      new _GankListNoImageItemState(bean, onPressed);
}

class _GankListNoImageItemState extends State<GankListNoImageItem> {
  _GankListNoImageItemState(this.bean, this.onPressed);

  GankBean bean;
  VoidCallback onPressed;

  void detail(GankBean bean) {}

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${bean.author}',
                      style: TextStyle(fontSize: 14.0, color: Colors.blue)),
                  Text("  ${bean.type}", style: TextStyle(fontSize: 13.0)),
                  Text("  ${bean.publishedAt}",
                      style: TextStyle(fontSize: 13.0)),
                ],
              ),
            ),
            Container(
              child: Padding(
                  padding: EdgeInsets.only(
                      left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
                  child: Text("${bean.desc}")),
            ),
          ],
        ),
      ),
    );
  }
}
