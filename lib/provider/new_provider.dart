import 'package:flutter/material.dart';

import '../model/recipe.dart';
import '../repository/new_repo.dart';

enum NewState { loading, error, success }

class NewProvider with ChangeNotifier {
  var _state = NewState.loading;
  NewState get state => _state;

  var _newRecipe = <Recipe>[];
  List<Recipe> get newRecipe => _newRecipe;

  Future<void> getNew() async {
    if (_state != NewState.loading) {
      updateState(NewState.loading);
    }
    try {
      _newRecipe = await NewRepo.get();
      updateState(NewState.success);
    } catch (e) {
      debugPrint(e.toString());
      updateState(NewState.error);
    }
  }

  void updateState(NewState state) {
    _state = state;
    notifyListeners();
  }
}
