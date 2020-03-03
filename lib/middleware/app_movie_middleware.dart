import 'package:AFlutter/entity/animate.dart';
import 'package:AFlutter/model/movie_view_model.dart';
import 'package:AFlutter/redux/app_list_redux.dart';

class ListMiddleware extends AbsListMiddleware<Animate> {
  MovieViewModel _movieViewModel;

  ListMiddleware() {
    _movieViewModel = MovieViewModel();
  }

  @override
  Future<List<Animate>> refresh() async {
    List<Animate> list = await _movieViewModel.loadData(0);
    return list;
  }

  @override
  Future<List<Animate>> loadMore() async {
    List<Animate> list = await _movieViewModel.loadMore(0);
    return list;
  }
}
