import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../config.dart';
import '../model/category.dart';

class CategoryRepo {
  static Future<List<Category>> get() async {
    var response = await http
        .get(Uri.parse(Config.server + "/category"))
        .timeout(const Duration(seconds: 8));
    log(response.statusCode.toString());
    // log(response.body);
    if (response.statusCode == 200) {
      return categoryFromJson(response.body);
    } else {
      throw Exception(json.decode(response.body)['message']);
    }
  }
}
