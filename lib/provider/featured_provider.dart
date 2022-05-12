import 'package:flutter/material.dart';

import '../model/recipe.dart';
import '../repository/recipe_repo.dart';

enum FeaturedState { loading, error, success }

class FeaturedProvider with ChangeNotifier {
  var _state = FeaturedState.loading;
  FeaturedState get state => _state;

  var _recipe = <Recipe>[];
  List<Recipe> get recipe => _recipe;

  Future<void> getRecipe() async {
    if (_state != FeaturedState.loading) {
      updateState(FeaturedState.loading);
    }
    try {
      _recipe = await RecipeRepo.get();
      updateState(FeaturedState.success);
    } catch (e) {
      debugPrint(e.toString());
      updateState(FeaturedState.error);
    }
  }

  void updateState(FeaturedState state) {
    _state = state;
    notifyListeners();
  }
}
