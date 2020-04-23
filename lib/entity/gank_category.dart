/**
    {
    "_id": "5e59ec146d359d60b476e621",
    "coverImageUrl": "http://gank.io/images/b9f867a055134a8fa45ef8a321616210",
    "desc": "Always deliver more than expected.（Larry Page）",
    "title": "Android",
    "type": "Android"
    }
 */
class GankCategory {
  String id;
  String coverImageUrl;
  String desc;
  String title;
  String type;

  GankCategory({
    this.id,
    this.coverImageUrl,
    this.desc,
    this.title,
    this.type,
  });

  GankCategory.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    coverImageUrl = json['coverImageUrl'];
    desc = json['desc'];
    title = json['title'];
    type = json['type'];
  }

  @override
  String toString() {
    return 'GankCategory{id: $id, coverImageUrl: $coverImageUrl, desc: $desc, title: $title, type: $type}';
  }
}
