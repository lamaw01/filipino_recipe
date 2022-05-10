import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../config.dart';
import '../model/recipe.dart';

class NewRepo {
  static Future<List<Recipe>> get() async {
    var response = await http
        .get(Uri.parse(Config.server + "/new"))
        .timeout(const Duration(seconds: 8));
    log(response.statusCode.toString());
    log(response.body);
    if (response.statusCode == 200) {
      return recipeFromJson(response.body);
    } else {
      throw Exception(json.decode(response.body)['message']);
    }
  }
}
