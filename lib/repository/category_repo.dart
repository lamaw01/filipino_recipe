import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../config.dart';
import '../model/recipe.dart';

class CategoryRepo {
  static Future<List<Recipe>> get(String category) async {
    var response = await http
        .get(Uri.parse(Config.server + "/recipe/$category"))
        .timeout(const Duration(seconds: 5));
    log(response.statusCode.toString());
    if (response.statusCode == 200) {
      return recipeFromJson(response.body);
    } else {
      throw Exception(json.decode(response.body)['message']);
    }
  }
}
