/**
    {
    "_id": "5e8c80ae2bce50b3ceaa80f0",
    "author": "\u9e22\u5a9b",
    "category": "Girl",
    "createdAt": "2020-04-11 08:00:00",
    "desc": "\u6211\u6ca1\u90a3\u4e48\u575a\u5f3a\uff0c\u53ea\u662f\u4e60\u60ef\u4e86\u4ec0\u4e48\u4e8b\u90fd\u81ea\u5df1\u625b\u3002 \u200b\u200b\u200b\u200b",
    "images": ["http://gank.io/images/1c5cebd307fd49eaa75b368b11118b61"],
    "likeCounts": 0,
    "publishedAt": "2020-04-11 08:00:00",
    "stars": 1,
    "title": "\u7b2c52\u671f",
    "type": "Girl",
    "url": "http://gank.io/images/1c5cebd307fd49eaa75b368b11118b61",
    "views": 274
    }
 */
class GankBean {
  String id;
  String author;
  String category;
  String createdAt;
  String desc;
  String publishedAt;
  int likeCounts;
  int stars;
  String title;
  String type;
  String url;
  int views;
  List<String> images;

  GankBean.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    author = json['author'];
    category = json['category'];
    createdAt = json['createdAt'];
    desc = json['desc'];
    publishedAt = json['publishedAt'];
    likeCounts = json['likeCounts'];
    stars = json['stars'];
    title = json['title'];
    type = json['type'];
    url = json['url'];
    views = json['views'];

    if (json.containsKey('images')) {
      var tags = json['images'];
      images = tags.map<String>((json) => json.toString()).toList();
    }
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "author": author,
        "category": category,
        "createdAt": createdAt,
        'desc': desc,
        "publishedAt": publishedAt,
        "likeCounts": likeCounts,
        "stars": stars,
        "title": title,
        'type': type,
        "url": url,
        "views": views,
        'images': images,
      };

  @override
  String toString() {
    return 'GankBean{id: $id, author: $author, category: $category, createdAt: $createdAt, desc: $desc, publishedAt: $publishedAt, likeCounts: $likeCounts, stars: $stars, title: $title, type: $type, url: $url, views: $views, images: $images}';
  }
}
