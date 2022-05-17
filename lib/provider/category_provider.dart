import 'package:flutter/material.dart';

import '../model/recipe_hive.dart';
import '../repository/category_repo.dart';

enum CategoryState { loading, error, success }

class CategoryProvider with ChangeNotifier {
  var _state = CategoryState.loading;
  CategoryState get state => _state;

  var _categoryRecipe = <RecipeHive>[];
  List<RecipeHive> get categoryRecipe => _categoryRecipe;

  Future<void> getRecipe(String category) async {
    if (_state != CategoryState.loading) {
      updateState(CategoryState.loading);
    }
    try {
      _categoryRecipe = await CategoryRepo.get(category);
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
