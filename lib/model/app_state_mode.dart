import 'package:AFlutter/entity/gank_bean.dart';
import 'package:scoped_model/scoped_model.dart';

class AppStateModel extends Model {
  // All the available products.
  List<GankBean> _availableProducts;

  void loadProducts() {
    _availableProducts = [];//;ProductsRepository.loadProducts(Category.all);
    notifyListeners();
  }
}
