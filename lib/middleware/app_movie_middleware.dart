import 'package:AFlutter/entity/animate.dart';
import 'package:AFlutter/model/movie_view_model.dart';
import 'package:AFlutter/redux/app_redux.dart';

class ListMiddleware extends AbsListMiddleware<Animate> {
  @override
  Future<List<Animate>> refresh() async {
    List<Animate> list = await MovieViewModel().loadData(0);
    return list;
  }

  @override
  Future<List<Animate>> loadMore() async {
    List<Animate> list = await MovieViewModel().loadMore(0);
    return list;
  }
}
