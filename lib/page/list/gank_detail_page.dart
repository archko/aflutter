import 'package:AFlutter/entity/gank_bean.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class GankDetailPage extends StatefulWidget {
  GankDetailPage({Key key, this.bean}) : super(key: key);

  final GankBean bean;

  @override
  _GankDetailPageState createState() => _GankDetailPageState();
}

class _GankDetailPageState extends State<GankDetailPage> {
  Widget detail(GankBean gankBean) {
    if (gankBean.images != null && gankBean.images.length > 0) {
      return Scaffold(
        appBar: AppBar(),
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
                      Text('${widget.bean.author}',
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
                    placeholder: (context, url) => CircularProgressIndicator(),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ],
            ),
            /*Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: EdgeInsets.only(
                        left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                    child: Text("who:${gankBean.who}")),
                Padding(
                    padding: EdgeInsets.only(
                        left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                    child: Text("type:${gankBean.type}")),
                Padding(
                    padding: EdgeInsets.only(
                        left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                    child: Text("description:${gankBean.desc}")),
                Padding(
                    padding: EdgeInsets.only(
                        left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                    child: Text("published:${gankBean.publishedAt}")),
                Padding(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  child: CachedNetworkImage(
                    key:  ValueKey<String>(gankBean.images[0]),
                    imageUrl: gankBean.images[0],
                    placeholder: (context, url) =>
                         CircularProgressIndicator(),
                  ),
                ),
              ],
            ),*/
          ],
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(),
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
                        Text('${widget.bean.author}',
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
                      child: Text("${widget.bean.desc}"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return detail(widget.bean);
  }
}
