import 'package:flutter/material.dart';

import '../model/recipe.dart';
import '../repository/new_repo.dart';

class NewProvider with ChangeNotifier {
  var _loading = true;
  bool get loading => _loading;

  var _newRecipe = <Recipe>[];
  List<Recipe> get newRecipe => _newRecipe;

  Future<void> getNew() async {
    if (!_loading) {
      updateLoading(true);
    }
    try {
      _newRecipe = await NewRepo.get();
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
