import 'dart:ui';

import 'package:AFlutter/entity/animate.dart';
import 'package:AFlutter/model/movie_view_model.dart';
import 'package:AFlutter/model/provider_widget.dart';
import 'package:AFlutter/model/test_provider.dart';
import 'package:AFlutter/model/test_provider2.dart';
import 'package:AFlutter/page/first_provider_page.dart';
import 'package:AFlutter/page/movie/movie_list_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TestProviderPage extends StatefulWidget {
  TestProviderPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new TestProviderPageState();
  }
}

class TestProviderPageState extends State<TestProviderPage>
    with AutomaticKeepAliveClientMixin {
  RefreshController _controller = RefreshController();

  var testProvider2 = TestProvider2();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      testProvider2.loadMovies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return build2(context);
  }

  Widget buildAppBar(BuildContext context) {
    return AppBar(
      title: Row(
        children: <Widget>[
          RaisedButton(
            onPressed: () {
              //model.loadMovies();
            },
            child: Text('load'),
          ),
          RaisedButton(
            onPressed: () {
              //model.clear();
            },
            child: Text('clear'),
          )
        ],
      ),
    );
  }

  Widget build1(BuildContext context) {
    return ProviderWidget<TestProvider>(
      model: TestProvider(
          viewModel: MovieViewModel(), refreshController: _controller),
      onModelInitial: (m) {
        m.refresh();
      },
      builder: (context, model, child) {
        return Scaffold(
          appBar: buildAppBar(context),
          body: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: TestText(
                  child: Text("_currVideoItem.data.title"),
                  onPressed: () {},
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return buildItem(context, index, model.getMovies());
                  },
                  childCount:
                      model.getMovies() == null ? 0 : model.getMovies().length,
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget build2(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (_) => testProvider2),
        ChangeNotifierProvider(builder: (_) => ValProvider()),
      ],
      child: Scaffold(
        appBar: buildAppBar(context),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Consumer(
                  builder: (BuildContext context, ValProvider model, _) {
                return TestText(
                  child: Text("_currVideoItem.data.title"),
                  onPressed: () {
                    print("before:${model.value}");
                    model.increment();
                    print("after:${model.value}");
                  },
                );
              }),
            ),
            ProviderWidget<TestProvider>(
              model: TestProvider(
                  viewModel: MovieViewModel()),
              onModelInitial: (m) {
                m.refresh();
              },
              builder: (context, model, child) {
                print("grid");
                return SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return buildGrid(context, index, model.getMovies());
                    },
                    childCount: model.getMovies() == null
                        ? 0
                        : model.getMovies().length,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    childAspectRatio: 0.8,
                  ),
                );
              },
            ),
            Consumer<TestProvider2>(
              builder: (context, model, _) {
                print("list");
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return buildItem(context, index, model.getMovies());
                    },
                    childCount: model.getMovies() == null
                        ? 0
                        : model.getMovies().length,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildList(List<Animate> movies) {
    print("buildList:${movies == null ? 0 : movies.length}");
    return ListView.builder(
      itemCount: movies == null ? 0 : movies.length,
      scrollDirection: Axis.vertical,
      physics: ClampingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) =>
          buildItem(context, index, movies),
    );
  }

  Widget buildItem(BuildContext context, int index, List<Animate> movies) {
    print("item:$index");
    return GestureDetector(
      child: MovieListItem(bean: movies[index]),
      onTap: () {},
    );
  }

  Widget buildGrid(BuildContext context, int index, List<Animate> movies) {
    return Image(
      image: CachedNetworkImageProvider('${movies[index].kg_pic_url}'),
      fit: BoxFit.cover,
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class TestText extends RaisedButton {
  TestText({
    Key key,
    @required VoidCallback onPressed,
    ValueChanged<bool> onHighlightChanged,
    ButtonTextTheme textTheme,
    Color textColor,
    Color disabledTextColor,
    Color color,
    Color disabledColor,
    Color focusColor,
    Color hoverColor,
    Color highlightColor,
    Color splashColor,
    Brightness colorBrightness,
    double elevation,
    double focusElevation,
    double hoverElevation,
    double highlightElevation,
    double disabledElevation,
    EdgeInsetsGeometry padding,
    ShapeBorder shape,
    Clip clipBehavior,
    FocusNode focusNode,
    bool autofocus = false,
    MaterialTapTargetSize materialTapTargetSize,
    Duration animationDuration,
    Widget child,
  }) : super(
          key: key,
          onPressed: onPressed,
          onHighlightChanged: onHighlightChanged,
          textTheme: textTheme,
          textColor: textColor,
          disabledTextColor: disabledTextColor,
          color: color,
          disabledColor: disabledColor,
          focusColor: focusColor,
          hoverColor: hoverColor,
          highlightColor: highlightColor,
          splashColor: splashColor,
          colorBrightness: colorBrightness,
          elevation: elevation,
          focusElevation: focusElevation,
          hoverElevation: hoverElevation,
          highlightElevation: highlightElevation,
          disabledElevation: disabledElevation,
          padding: padding,
          shape: shape,
          clipBehavior: clipBehavior,
          focusNode: focusNode,
          autofocus: autofocus,
          materialTapTargetSize: materialTapTargetSize,
          animationDuration: animationDuration,
          child: child,
        );

  @override
  Widget build(BuildContext context) {
    print("TestText.build:$child");
    return super.build(context);
  }
}
