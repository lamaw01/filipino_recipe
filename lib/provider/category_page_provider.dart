import 'package:flutter/material.dart';
import 'dart:math';
import '../model/recipe.dart';
import '../repository/random_repo.dart';

enum CategoryPageState { loading, error, success }

class CategoryPageProvider with ChangeNotifier {
  final random = Random();

  var _state = CategoryPageState.loading;
  CategoryPageState get state => _state;

  var _categoryRecipe = <Recipe>[];
  List<Recipe> get categoryRecipe => _categoryRecipe;

  Future<void> getRecipe(String category) async {
    if (_state != CategoryPageState.loading) {
      updateState(CategoryPageState.loading);
    }
    try {
      _categoryRecipe = await RandomRepo.get(category);
      updateState(CategoryPageState.success);
    } catch (e) {
      debugPrint(e.toString());
      updateState(CategoryPageState.error);
    }
  }

  void updateState(CategoryPageState state) {
    _state = state;
    notifyListeners();
  }
}
