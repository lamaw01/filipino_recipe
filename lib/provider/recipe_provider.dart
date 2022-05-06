import 'dart:developer';

import 'package:flutter/material.dart';

import '../model/recipe.dart';
import '../repository/recipe_repo.dart';

enum Status { loading, error, success }

class RecipeProvider with ChangeNotifier {
  var _status = Status.loading;
  Status get status => _status;

  var _recipe = <Recipe>[];
  List<Recipe> get recipe => _recipe;

  Future<void> getRecipe() async {
    try {
      _recipe = await RecipeRepo.get();
      _status = Status.success;
    } catch (e) {
      log(e.toString());
      _status = Status.error;
    }
    notifyListeners();
  }
}
