import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../entity/gank_bean.dart';

class GankListImageItem extends StatelessWidget {
  GankListImageItem({Key key, this.bean, this.onPressed}) : super(key: key);
  final GankBean bean;
  final VoidCallback onPressed;

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
                  Text('${bean.who}',
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
            Container(
              margin: const EdgeInsets.all(5.0),
              child: Image(
                image: CachedNetworkImageProvider('${bean.images[0]}'),
                fit: BoxFit.fitWidth,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
