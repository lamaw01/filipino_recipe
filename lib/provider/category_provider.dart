import 'package:flutter/material.dart';

import '../model/category.dart';
import '../repository/category_repo.dart';

class CategoryProvider with ChangeNotifier {
  var _loading = true;
  bool get loading => _loading;

  var _category = <Category>[];
  List<Category> get category => _category;

  Future<void> getCategory() async {
    if (!_loading) {
      updateLoading(true);
    }
    try {
      _category = await CategoryRepo.get();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      updateLoading(false);
    }
  }

  void updateLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
}
