import 'package:AFlutter/entity/animate.dart';
import 'package:AFlutter/http/http_client.dart';
import 'package:AFlutter/http/http_response.dart';
import 'package:AFlutter/model/base_list_view_model.dart';
import 'package:AFlutter/utils/json_utils.dart';
import 'package:flutter/foundation.dart';

class MovieViewModel extends BaseListViewModel {
  Future<List<Animate>> loadData(int pn, {String type}) async {
    pn ??= 0;
    List<Animate> list;
    String url =
        'https://sp0.baidu.com/8aQDcjqpAAV3otqbppnN2DJv/api.php?resource_id=28286&from_mid=1&&format=json&ie=utf-8&oe=utf-8&query=电影&sort_key=16&sort_type=1&stat0=&stat1=&stat2=&stat3=&pn=$pn&rn=10&cb=cbs';
    try {
      HttpResponse httpResponse = await HttpClient.instance.get(url);
      String result =
          httpResponse.data.replaceAll('cbs(', '').replaceAll(')', '');
      //print("result:$result");
      list = await compute(decodeListResult, result);
    } catch (e) {
      print(e);
    }
    return list;
  }

  Future<List<Animate>> loadMore(int pn) async {
    return loadData(pn);
  }

  static List<Animate> decodeListResult(String result) {
    //return json.decode(data);
    return JsonUtils.decodeAsMap(result)['data'][0]['result']
        .map<Animate>((dynamic json) => Animate.fromJson(json))
        .toList();
  }
}
