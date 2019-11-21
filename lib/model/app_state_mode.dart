import 'dart:convert';

import 'package:scoped_model/scoped_model.dart';

import '../api/http_client.dart';
import '../api/http_response.dart';
import '../list/movie_list_page.dart';

class AppStateModel extends Model {
  List<Animate> _animates;

  List<Animate> getMovies() {
    if (_animates == null) {
      return <Animate>[];
    }

    return _animates;
  }

  void loadMovies() async {
    _animates = await loadData();
    notifyListeners();
  }

  loadData() async {
    List<Animate> list;
    final String url =
        'https://sp0.baidu.com/8aQDcjqpAAV3otqbppnN2DJv/api.php?resource_id=28286&from_mid=1&&format=json&ie=utf-8&oe=utf-8&query=电影&sort_key=16&sort_type=1&stat0=&stat1=&stat2=&stat3=&pn=20&rn=12&cb=cbs';
    try {
      HttpResponse httpResponse = await HttpClient.instance.get(url);
      var result = httpResponse.data.replaceAll('cbs(', '').replaceAll(')', '');
      print("result:$result");
      list = json
          .decode(result)['data'][0]['result']
          .map<Animate>((dynamic json) => Animate.fromJson(json))
          .toList();
    } catch (e) {
      print(e);
    }
    return list;
  }
}
