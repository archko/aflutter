/// {
//      "image": "http://gank.io/images/cfb4028bfead41e8b6e34057364969d1",
//      "title": "\u5e72\u8d27\u96c6\u4e2d\u8425\u65b0\u7248\u66f4\u65b0",
//      "url": "https://gank.io/migrate_progress"
//    }
class GankBanner {
  String image;
  String title;
  String url;

  GankBanner.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    title = json['title'];
    url = json['url'];
  }

  @override
  String toString() {
    return 'GankBanner{image: $image, title: $title, url: $url}';
  }
}
