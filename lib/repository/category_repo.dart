import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../config.dart';
import '../model/recipe_hive.dart';

class CategoryRepo {
  static Future<List<RecipeHive>> get(String category) async {
    var response = await http.get(
      Uri.parse(Config.server + "/recipe/$category"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).timeout(const Duration(seconds: 20));
    log(response.statusCode.toString());
    if (response.statusCode == 200) {
      return recipeFromJson(response.body);
    } else {
      throw Exception(json.decode(response.body)['message']);
    }
  }
}
