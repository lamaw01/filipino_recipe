import 'package:flutter/material.dart';
import 'dart:math';
import '../model/recipe.dart';
import '../repository/random_repo.dart';

enum RandomState { loading, error, success }

class RandomProvider with ChangeNotifier {
  final random = Random();

  var _state = RandomState.loading;
  RandomState get state => _state;

  // 0 = chicken, 1 = dessert
  late int _randomNum;
  int get randomNum => _randomNum;

  final _listRecipe = <String>[
    'Chicken',
    'Dessert',
    'Beef',
    'Pork',
    'Fish',
    'Vegetable'
  ];
  List<String> get listRecipe => _listRecipe;

  var _randomRecipe = <Recipe>[];
  List<Recipe> get randomRecipe => _randomRecipe;

  void initRandom() {
    _randomNum = random.nextInt(5);
  }

  Future<void> getRandom() async {
    if (_state != RandomState.loading) {
      updateState(RandomState.loading);
    }
    try {
      _randomRecipe =
          await RandomRepo.get(_listRecipe[_randomNum].toLowerCase());
      updateState(RandomState.success);
    } catch (e) {
      debugPrint(e.toString());
      updateState(RandomState.error);
    }
  }

  void updateState(RandomState state) {
    _state = state;
    notifyListeners();
  }
}
