import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../model/category.dart';
import '../model/recipe.dart';
import '../repository/home_repo.dart';

enum FeaturedState { loading, error, success }

enum RandomState { loading, error, success }

enum CategoryState { loading, error, success }

enum RecentState { loading, error, success }

class HomeProvider with ChangeNotifier {
  final randomMath = math.Random();

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

  var _featuredState = FeaturedState.loading;
  FeaturedState get featuredState => _featuredState;

  var _randomState = RandomState.loading;
  RandomState get randomState => _randomState;

  var _categoryState = CategoryState.loading;
  CategoryState get categoryState => _categoryState;

  var _recentState = RecentState.loading;
  RecentState get recentState => _recentState;

  var _featured = <Recipe>[];
  List<Recipe> get featured => _featured;

  var _random = <Recipe>[];
  List<Recipe> get random => _random;

  var _category = <Category>[];
  List<Category> get category => _category;

  var _recent = <Recipe>[];
  List<Recipe> get recent => _recent;

  Future<void> getFeatured() async {
    if (_featuredState != FeaturedState.loading) {
      updateFeaturedState(FeaturedState.loading);
    }
    try {
      _featured = await HomeRepo.getRecipe("featured");
      updateFeaturedState(FeaturedState.success);
    } catch (e) {
      updateFeaturedState(FeaturedState.error);
    }
  }

  Future<void> getRandom() async {
    if (_randomState != RandomState.loading) {
      updateRandomState(RandomState.loading);
    }
    try {
      _random = await HomeRepo.getRecipe(
          "recipe/${_listRecipe[_randomNum].toLowerCase()}");
      updateRandomState(RandomState.success);
    } catch (e) {
      log(e.toString());
      updateRandomState(RandomState.error);
    }
  }

  Future<void> getCategory() async {
    if (_categoryState != CategoryState.loading) {
      updateCategoryState(CategoryState.loading);
    }
    try {
      _category = await HomeRepo.getCategory("category");
      updateCategoryState(CategoryState.success);
    } catch (e) {
      log(e.toString());
      updateCategoryState(CategoryState.error);
    }
  }

  Future<void> getRecent() async {
    if (_recentState != RecentState.loading) {
      updateRecentState(RecentState.loading);
    }
    try {
      _recent = await HomeRepo.getRecipe("recent");
      updateRecentState(RecentState.success);
    } catch (e) {
      log(e.toString());
      updateRecentState(RecentState.error);
    }
  }

  void initRandom() => _randomNum = randomMath.nextInt(5);

  void updateRandomState(RandomState state) {
    _randomState = state;
    notifyListeners();
  }

  void updateFeaturedState(FeaturedState state) {
    _featuredState = state;
    notifyListeners();
  }

  void updateCategoryState(CategoryState state) {
    _categoryState = state;
    notifyListeners();
  }

  void updateRecentState(RecentState state) {
    _recentState = state;
    notifyListeners();
  }

  Future<void> getAdditionalRecent() async {
    try {
      var result = await HomeRepo.getAdditional(_recent.last.timestamp);
      _recent.addAll(result);
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }
}
