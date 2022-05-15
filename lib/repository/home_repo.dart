import 'dart:convert';
import 'dart:developer';

import 'package:filipino_recipe/model/category.dart';
import 'package:http/http.dart' as http;

import '../config.dart';
import '../model/recipe.dart';

class HomeRepo {
  static Future<List<Recipe>> getRecipe(String url) async {
    var response = await http
        .get(Uri.parse(Config.server + "/$url"))
        .timeout(const Duration(seconds: 5));
    log(response.statusCode.toString());
    if (response.statusCode == 200) {
      return recipeFromJson(response.body);
    } else {
      throw Exception(json.decode(response.body)['message']);
    }
  }

  static Future<List<Category>> getCategory(String url) async {
    var response = await http
        .get(Uri.parse(Config.server + "/$url"))
        .timeout(const Duration(seconds: 5));
    log(response.statusCode.toString());
    if (response.statusCode == 200) {
      return categoryFromJson(response.body);
    } else {
      throw Exception(json.decode(response.body)['message']);
    }
  }
}
