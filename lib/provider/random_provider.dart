import 'package:flutter/material.dart';
import 'dart:math';
import '../model/recipe.dart';
import '../repository/random_repo.dart';

class RandomProvider with ChangeNotifier {
  final random = Random();

  // 0 = chicken, 1 = dessert
  late int _randomNum;
  int get randomNum => _randomNum;

  final _listRecipe = <String>['Chicken', 'Dessert'];
  List<String> get listRecipe => _listRecipe;

  var _loading = true;
  bool get loading => _loading;

  var _randomRecipe = <Recipe>[];
  List<Recipe> get randomRecipe => _randomRecipe;

  void initRandom() {
    _randomNum = random.nextInt(2);
    // _randomNum = 1;
  }

  Future<void> getRandom() async {
    if (!_loading) {
      updateLoading(true);
    }
    try {
      _randomRecipe =
          await RandomRepo.get(_listRecipe[_randomNum].toLowerCase());
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
