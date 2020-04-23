/**
 * {
    "_id": "5c4572419d212264cbcc5bd7",
    "createdAt": "2019-01-21T07:18:25.158Z",
    "desc": "此库应用视频过滤器生成Mp4和ExoPlayer视频以及使用Camera2进行视频录制。",
    "images": [
    "https://ww1.sinaimg.cn/large/0073sXn7ly1fze97qh5sxg308w050tkd",
    "https://ww1.sinaimg.cn/large/0073sXn7ly1fze97s5aung308w050qks",
    "https://ww1.sinaimg.cn/large/0073sXn7ly1fze97u1e6mg308w050nh3"
    ],
    "publishedAt": "2019-04-10T00:00:00.0Z",
    "source": "chrome",
    "type": "Android",
    "url": "https://github.com/MasayukiSuda/GPUVideo-android",
    "used": true,
    "who": "lijinshanmx"
    }
 */
class GankBean {
  String id;
  String createdAt;
  String desc;
  String publishedAt;
  String source;
  String type;
  String url;
  bool used;
  String who;
  List<String> images;

  GankBean.fromJson(Map<String, dynamic> json) {
    //print("item:$json");
    id = json['_id'];
    createdAt = json['createdAt'];
    desc = json['desc'];
    publishedAt = json['publishedAt'];
    source = json['source'];
    type = json['type'];
    url = json['url'];
    used = json['used'];
    desc = json['desc'];
    who = json['who'];
    images =
        json['images']?.map<String>((image) => image as String)?.toList() ?? [];
    if ((images == null || images.length == 0) && "福利" == type) {
      images = List();
      images.add(url);
    }
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "createdAt": createdAt,
        'desc': desc,
        "publishedAt": publishedAt,
        "source": source,
        'type': type,
        "url": url,
        "used": used,
        'desc': desc,
        'who': who,
        'images': images,
      };

  @override
  String toString() {
    return 'GankBean{ who: $who,$images}';
  }
}
