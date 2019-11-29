import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../entity/gank_bean.dart';

class GankDetailPage extends StatefulWidget {
  GankDetailPage({Key key, this.bean}) : super(key: key);

  final GankBean bean;

  @override
  _GankDetailPageState createState() => new _GankDetailPageState();
}

class _GankDetailPageState extends State<GankDetailPage> {

  @override
  Widget build(BuildContext context) {
    return _detail(widget.bean);
  }

  Widget _detail(GankBean gankBean) {
    var children = <Widget>[];
    var descWidget = Container(
      child: Padding(
          padding:
              EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
          child: Text("${widget.bean.desc}")),
    );
    var headerWidget = Container(
      margin: const EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${widget.bean.who}',
              style: TextStyle(fontSize: 14.0, color: Colors.blue)),
          Text("  ${widget.bean.type}", style: TextStyle(fontSize: 13.0)),
          Text("  ${widget.bean.publishedAt}",
              style: TextStyle(fontSize: 13.0)),
        ],
      ),
    );
    if (gankBean.images != null && gankBean.images.length > 0) {
      children = <Widget>[
        headerWidget,
        descWidget,
        Container(
          margin: const EdgeInsets.all(5.0),
          child: CachedNetworkImage(
            imageUrl: gankBean.images[0],
            placeholder: (context, url) => new CircularProgressIndicator(),
            fit: BoxFit.fitWidth,
          ),
        ),
      ];
    } else {
      children = <Widget>[
        headerWidget,
        descWidget,
      ];
    }

    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: children,
          )
        ],
      ),
    );
    /*if (gankBean.images != null && gankBean.images.length > 0) {
      return new Scaffold(
        appBar: new AppBar(),
        body: ListView(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  margin:
                      const EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${widget.bean.who}',
                          style: TextStyle(fontSize: 14.0, color: Colors.blue)),
                      Text("  ${widget.bean.type}",
                          style: TextStyle(fontSize: 13.0)),
                      Text("  ${widget.bean.publishedAt}",
                          style: TextStyle(fontSize: 13.0)),
                    ],
                  ),
                ),
                Container(
                  child: Padding(
                      padding: EdgeInsets.only(
                          left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
                      child: Text("${widget.bean.desc}")),
                ),
                Container(
                  margin: const EdgeInsets.all(5.0),
                  child: CachedNetworkImage(
                    imageUrl: gankBean.images[0],
                    placeholder: (context, url) =>
                        new CircularProgressIndicator(),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return new Scaffold(
        appBar: new AppBar(),
        body: ListView(
          children: <Widget>[
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    margin:
                        const EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${widget.bean.who}',
                            style:
                                TextStyle(fontSize: 14.0, color: Colors.blue)),
                        Text("  ${widget.bean.type}",
                            style: TextStyle(fontSize: 13.0)),
                        Text("  ${widget.bean.publishedAt}",
                            style: TextStyle(fontSize: 13.0)),
                      ],
                    ),
                  ),
                  Container(
                    child: Padding(
                        padding: EdgeInsets.only(
                            left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
                        child: Text("${widget.bean.desc}")),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }*/
  }
}
