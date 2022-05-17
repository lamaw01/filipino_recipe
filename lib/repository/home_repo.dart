import 'dart:convert';
import 'dart:developer';

import 'package:filipino_recipe/model/category.dart';
import 'package:http/http.dart' as http;

import '../config.dart';
import '../model/recipe_hive.dart';

class HomeRepo {
  static Future<List<RecipeHive>> getRecipe(String url) async {
    var response = await http.get(
      Uri.parse(Config.server + "/$url"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).timeout(const Duration(seconds: 10));
    log(response.statusCode.toString());
    if (response.statusCode == 200) {
      return recipeFromJson(response.body);
    } else {
      throw Exception(json.decode(response.body)['message']);
    }
  }

  static Future<List<Category>> getCategory(String url) async {
    var response = await http.get(
      Uri.parse(Config.server + "/$url"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).timeout(const Duration(seconds: 10));
    log(response.statusCode.toString());
    if (response.statusCode == 200) {
      return categoryFromJson(response.body);
    } else {
      throw Exception(json.decode(response.body)['message']);
    }
  }

  static Future<List<RecipeHive>> getAdditional(int timestamp) async {
    var response = await http
        .post(
          Uri.parse(Config.server + "/additional_recent"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(
            <String, dynamic>{
              "timestamp": timestamp,
            },
          ),
        )
        .timeout(const Duration(seconds: 10));
    log(response.statusCode.toString());
    if (response.statusCode == 200) {
      return recipeFromJson(response.body);
    } else {
      throw Exception(json.decode(response.body)['message']);
    }
  }
}
