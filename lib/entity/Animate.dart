class Animate {
  Animate({
    this.additional,
    this.ename,
    this.jumplink,
    this.jumpquery,
    this.kg_pic_url,
    this.name,
    this.pic_6n_161,
    this.searchp,
    this.selpic,
    this.sort,
    this.statctl,
    this.statlst,
  });

  factory Animate.fromJson(Map<String, dynamic> json) {
    return Animate(
      additional: json['additional'],
      ename: json['ename'],
      jumplink: json['jumplink'],
      jumpquery: json['jumpquery'],
      kg_pic_url: json['kg_pic_url'],
      name: json['name'],
      pic_6n_161: json['pic_6n_161'],
      searchp: json['searchp'],
      selpic: json['selpic'],
      sort: json['sort'],
      statctl: json['statctl'],
      statlst: json['statlst'],
    );
  }

  final String additional;
  final String ename;
  final String jumplink;
  final String jumpquery;
  final String kg_pic_url;
  final String name;
  final String pic_6n_161;
  final String searchp;
  final String selpic;
  final String sort;
  final String statctl;
  final String statlst;
}