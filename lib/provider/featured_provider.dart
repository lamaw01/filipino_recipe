import 'package:flutter/material.dart';

import '../model/recipe.dart';
import '../repository/recipe_repo.dart';

class FeaturedProvider with ChangeNotifier {
  var _loading = true;
  bool get loading => _loading;

  var _recipe = <Recipe>[];
  List<Recipe> get recipe => _recipe;

  Future<void> getRecipe() async {
    if (!_loading) {
      updateLoading(true);
    }
    try {
      _recipe = await RecipeRepo.get();
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
