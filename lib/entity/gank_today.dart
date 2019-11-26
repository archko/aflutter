import 'gank_bean.dart';

/**
 * {
    "category": [
    "App",
    "iOS",
    "拓展资源",
    "瞎推荐",
    "Android",
    "前端",
    "福利",
    "休息视频"
    ],
    "error": false,
    "results": {
    "Android": [
    {
    "_id": "5bbb01af9d21226111b86f0d",
    "createdAt": "2018-10-08T07:05:19.297Z",
    "desc": "适用于Android的灵活，强大且轻量级的插件框架【爱奇艺】",
    "publishedAt": "2019-04-10T00:00:00.0Z",
    "source": "chrome",
    "type": "Android",
    "url": "https://github.com/iqiyi/Neptune",
    "used": true,
    "who": "潇湘剑雨"
    }],
    App:[
    {
    "_id": "5771ce2b421aa931d274f244",
    "createdAt": "2016-06-28T09:08:59.622Z",
    "desc": "一款类似豆瓣读书的APP，提供一个书籍查看、搜索、交流的平台，数据来自豆瓣（爬虫），后端LeanCloud。",
    "images": [
    "http://img.gank.io/0b7e425d-f61c-4eff-ae9c-8b5613020be9",
    "http://img.gank.io/c0cc0c8b-17b6-4321-bfdc-1cb0732edd4d",
    "http://img.gank.io/0203a555-edc1-4577-b83b-42a8a723dd87",
    "http://img.gank.io/8671a3f2-5546-4f0b-9d5c-538ad51aa8cf"
    ],
    "publishedAt": "2019-08-06T11:58:37.715Z",
    "source": "web",
    "type": "App",
    "url": "https://github.com/Blankeer/SoleBooks",
    "used": true,
    "who": "潇湘剑雨"
    }]
 */
class GankToday {
  bool error;
  List<String> category;
  Map<String, List<GankBean>> items = Map();

  List<GankBean> beans = [];

  GankToday(this.category);

  GankToday.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    category = List<String>.from(json['category']);
    //print('json:' + category.toString());

    var results = json['results'];
    results.forEach((key, listVal) {
      if (key != '福利') {
        items[key] = _parseGankBeanFromJson(key, listVal);
      }
    });
    print("decode end");
  }

  List<GankBean> _parseGankBeanFromJson(key, listVal) {
    var list =
        listVal.map<GankBean>((item) => GankBean.fromJson(item)).toList();
    beans.addAll(list);
    return list;
  }

  @override
  String toString() {
    return 'GankToday{error: $error, category: $category, results: $items}';
  }
}
