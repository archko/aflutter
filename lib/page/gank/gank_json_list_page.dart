import 'package:AFlutter/entity/gank_bean.dart';
import 'package:AFlutter/entity/gank_today.dart';
import 'package:AFlutter/http/http_client.dart';
import 'package:AFlutter/http/http_response.dart';
import 'package:AFlutter/model/base_list_view_model.dart';
import 'package:AFlutter/model/gank_view_model.dart';
import 'package:AFlutter/page/gank/gank_detail_page.dart';
import 'package:AFlutter/page/gank/gank_list_image_item.dart';
import 'package:AFlutter/page/gank/gank_list_noimage_item.dart';
import 'package:AFlutter/utils/json_utils.dart';
import 'package:AFlutter/widget/list/pull_to_refresh_widget.dart';
import 'package:flutter/material.dart';


class GankJsonListPage extends StatefulWidget {
  GankJsonListPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _GankJsonListPageState createState() => new _GankJsonListPageState();
}

class _GankJsonListPageState extends State<GankJsonListPage>
    with AutomaticKeepAliveClientMixin {
  BaseListViewModel viewModel = new GankViewModel();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  //Future<String> loadAsset() async {
  //  return await rootBundle.loadString('assets/album.json');
  //}

  Future<Null> loadData() async {
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
      if (mounted) {
        var gankToday = GankToday.fromJson(JsonUtils.decodeAsMap(httpResponse.data));
        viewModel.addData(gankToday.beans);
        print(
            "length:${gankToday?.category}, content:${gankToday?.items
                ?.length}");
      }
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
    return null;
  }

  @override
  bool get wantKeepAlive => true;

  Future _pullToRefresh() async {
    viewModel.setPage(0);
    return loadData();
  }

  void detail(GankBean bean) {
    Navigator.of(context).push(
      new MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return new GankDetailPage(
            bean: bean,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new PullToRefreshWidget(
      itemBuilder: (BuildContext context, int index) =>
          _renderItem(index, context),
      listCount: viewModel.data.length,
      onLoadMore: loadData,
      onRefresh: _pullToRefresh,
    );
  }

  /**
   * 列表的ltem
   */
  _renderItem(index, context) {
    var bean = viewModel.data[index];
    if (bean.images == null || bean.images.length < 1) {
      return GankListNoImageItem(
          bean: bean,
          onPressed: () {
            detail(bean);
          });
    } else {
      return GankListImageItem(
          bean: bean,
          onPressed: () {
            detail(bean);
          });
    }
  }
}
