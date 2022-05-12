import 'package:flutter/material.dart';

import '../model/category.dart';
import '../repository/category_repo.dart';

enum CategoryState { loading, error, success }

class CategoryProvider with ChangeNotifier {
  var _state = CategoryState.loading;
  CategoryState get state => _state;

  var _category = <Category>[];
  List<Category> get category => _category;

  Future<void> getCategory() async {
    if (_state != CategoryState.loading) {
      updateState(CategoryState.loading);
    }
    try {
      _category = await CategoryRepo.get();
      updateState(CategoryState.success);
    } catch (e) {
      debugPrint(e.toString());
      updateState(CategoryState.error);
    }
  }

  void updateState(CategoryState state) {
    _state = state;
    notifyListeners();
  }
}
