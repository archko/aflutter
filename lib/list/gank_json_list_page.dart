import 'dart:async';

import 'package:AFlutter/api/http_client.dart';
import 'package:AFlutter/api/http_response.dart';
import 'package:AFlutter/list/gank_detail_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../model/gank_bean.dart';
import '../model/gank_today.dart';

class GankJsonListPage extends StatefulWidget {
  GankJsonListPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _GankJsonListPageState createState() => new _GankJsonListPageState();
}

class _GankJsonListPageState extends State<GankJsonListPage> {
  ListView buildListView() => ListView.builder(
      itemCount: length,
      itemBuilder: (BuildContext context, int position) {
        return buildRow(position);
      });

  Widget buildRow(int i) {
    var beans = gankToday.beans;
    //print('bean i:$i data:$beans');
    if (beans == null) {
      return Text("no items:");
    }
    var bean = beans[i];
    if (bean.images == null || bean.images.length < 1) {
      return GestureDetector(
        onTap: () {
          setState(() {
            detail(bean);
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: EdgeInsets.only(
                    left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                child: Text("Title:${bean.publishedAt}")),
            Padding(
                padding: EdgeInsets.only(
                    left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                child: Text("Title:${bean.desc}")),
          ],
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {
          setState(() {
            detail(bean);
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: EdgeInsets.only(
                    left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                child: Text("Title:${bean.publishedAt}")),
            Padding(
                padding: EdgeInsets.only(
                    left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                child: Text("Url:${bean.images[0]}")),
            Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Image(
                image: CachedNetworkImageProvider(bean.images[0]),
                //width: album.images.width.toDouble(),
                //height: album.images.height.toDouble(),
                fit: BoxFit.fitWidth,
              ),
            ),
          ],
        ),
      );
    }
  }

  void detail(GankBean gankBean) {
    Navigator.of(context).push(
      new MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return new GankDetailPage(
            gankBean: gankBean,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildListView(),
    );
  }

  GankToday gankToday = GankToday([]);
  var length = 0;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  //Future<String> loadAsset() async {
  //  return await rootBundle.loadString('assets/album.json');
  //}

  loadData() async {
    String dataURL = "http://gank.io/api/today";
    //http.Response response = await http.get(dataURL);
    //setState(() {
    //  Map<String, dynamic> decodeJson = json.decode(response.body);
    //  gankToday = GankToday.fromJson(decodeJson);
    //  length = gankToday.items[gankToday.category[0]].length;
    //  print(
    //      "length:${gankToday.category}, content:${gankToday.items.length}");
    //});
    HttpResponse httpResponse = await HttpClient.instance.get(dataURL);
    setState(() {
      gankToday = GankToday.fromJson(httpResponse.data);
      length = gankToday.beans.length;
      print("length:${gankToday.category}, content:${gankToday.items.length}");
    });

    /*loadAsset().then((value) {
      setState(() {
        var raw = json.decode(value);
        //it's a Map<>,translate to List:raw.map().toList()
        albums =
            new List<Album>.from(raw.map((i) => Album.fromJson(i)).toList());
        print(albums[0]);
      });
    });*/
  }
}
