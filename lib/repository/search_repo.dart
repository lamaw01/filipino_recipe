import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../config.dart';
import '../model/recipe.dart';

class SearchRepo {
  static Future<List<Recipe>> getSearch(String keyword) async {
    var response = await http
        .post(
          Uri.parse(Config.server + "/search"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(
            <String, dynamic>{
              "name": keyword,
            },
          ),
        )
        .timeout(const Duration(seconds: 5));
    log(response.statusCode.toString());
    if (response.statusCode == 200) {
      return recipeFromJson(response.body);
    } else {
      throw Exception(json.decode(response.body)['message']);
    }
  }
}
