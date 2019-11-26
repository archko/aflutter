import 'gank_bean.dart';

class GankListBean {
  bool error;
  List<GankBean> beans = [];

  GankListBean();

  GankListBean.fromJson(Map<dynamic, dynamic> json) {
    error = json['error'];

    var results = json["results"];
    beans = List();
    for (var item in results) {
      //print("item:$item,");
      beans.add(GankBean.fromJson(item));
    }

    //results.forEach((key, value) {
    //  print("key:$key,val:$value");
    //  beans.add(GankBean.fromJson(value));
    //});
    print("decode end");
  }

  @override
  String toString() {
    return 'GankListBean{error: $error, beans: $beans}';
  }
}
