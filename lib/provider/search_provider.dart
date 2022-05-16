import 'package:flutter/material.dart';

import '../model/recipe.dart';
import '../repository/search_repo.dart';

enum SearchStatus { idle, loading, error, success }

class SearchProvider with ChangeNotifier {
  var _state = SearchStatus.idle;
  SearchStatus get state => _state;

  var _search = <Recipe>[];
  List<Recipe> get search => _search;

  Future<void> getSearch(String keyword) async {
    if (_state != SearchStatus.loading) {
      updateSearchstate(SearchStatus.loading);
    }
    try {
      _search = await SearchRepo.getSearch(keyword);
      updateSearchstate(SearchStatus.success);
    } catch (e) {
      updateSearchstate(SearchStatus.error);
    }
  }

  void updateSearchstate(SearchStatus state) {
    _state = state;
    notifyListeners();
  }
}
