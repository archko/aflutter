import 'gank_bean.dart';

class GankListBean {
  int page;
  int page_count;
  int status;
  int total_counts;

  bool error;
  List<GankBean> beans = [];

  GankListBean();

  GankListBean.fromJson(Map<dynamic, dynamic> json) {
    page = json['page'];
    page_count = json['page_count'];
    status = json['status'];
    total_counts = json['total_counts'];

    var results = json["data"];
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
