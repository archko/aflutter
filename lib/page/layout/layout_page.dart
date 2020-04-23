import 'package:AFlutter/model/movie_provider.dart';
import 'package:AFlutter/model/movie_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/model/provider_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class LayoutPage extends StatefulWidget {
  LayoutPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LayoutPagePageState();
  }

  @override
  String toStringShort() {
    return "layout";
  }
}

class _LayoutPagePageState extends State<LayoutPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  RefreshController refreshController;
  MovieProvider _movieProvider;

  @override
  void initState() {
    super.initState();
    refreshController = RefreshController(initialRefresh: true);
    _movieProvider = MovieProvider(
        viewModel: MovieViewModel(), refreshController: refreshController);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return buildFlex(context);
  }

  Widget buildFlex(BuildContext context) {
    return MaterialApp(
      title: "水平布局",
      home: Scaffold(
        appBar: AppBar(
          title: Text("水平布局"),
        ),
        body: Container(
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.orange,
                      width: 8.0,
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          onPressed: () {},
                          color: Colors.red,
                          child: Container(
                            child: Text(
                              "红色按钮",
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 60,
                        child: RaisedButton(
                          onPressed: () {},
                          color: Colors.green,
                          child: Text(
                            "绿",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {},
                    color: Colors.blue,
                    child: Container(
                      child: Text(
                        "蓝色按钮",
                      ),
                    ),
                  ),
                  Container(
                    width: 70,
                    child: RaisedButton(
                      onPressed: () {},
                      color: Colors.yellow,
                      child: Text(
                        "黄",
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildStack(BuildContext context) {
    return ProviderWidget<MovieProvider>(
      model: _movieProvider,
      onModelInitial: (m) {},
      builder: (context, model, childWidget) {
        return Scaffold(
          body: Container(
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Image.asset(
                  'images/Stack.png',
                  fit: BoxFit.cover,
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(0.0, -1.0),
                      end: Alignment(0.0, -0.4),
                      colors: <Color>[Color(0x90000000), Color(0x00000000)],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    width: 100,
                    height: 100,
                    color: Colors.red,
                  ),
                ),
                Align(
                  alignment: Alignment.lerp(
                      Alignment.bottomCenter, Alignment.center, 0.5),
                  //位于Alignment.bottomCenter和Alignment.center的中央
                  child: Container(
                    width: 100,
                    height: 100,
                    color: Colors.yellow,
                  ),
                ),
                Align(
                  alignment: FractionalOffset(0, 0.5),
                  child: Container(
                    width: 100,
                    height: 100,
                    color: Colors.red,
                  ),
                ),
                Positioned(
                  top: 100,
                  right: 100,
                  width: 100,
                  height: 100,
                  child: Container(
                    color: Colors.red,
                  ),
                ),
                Positioned(
                  top: 200,
                  right: 100,
                  width: 200,
                  height: 200,
                  child: Container(
                    height: 200,
                    width: 200,
                    child: Text("这是一个Container容器"),
                    decoration: BoxDecoration(
                      color: Colors.red[200],
                      // shape: BoxShape.circle, //形状
                      border: Border.all(width: 10.0),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0.0, 100.0), //模糊偏移量
                          color: Color.fromRGBO(16, 20, 188, 1.0), //颜色
                          blurRadius: 10, //模糊
                          spreadRadius: -9.0, //在应用模糊之前阴影的膨胀量
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
