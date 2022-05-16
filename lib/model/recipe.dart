// To parse this JSON data, do
//
//     final recipe = recipeFromJson(jsonString);

import 'dart:convert';

List<Recipe> recipeFromJson(String str) =>
    List<Recipe>.from(json.decode(str).map((x) => Recipe.fromJson(x)));

String recipeToJson(List<Recipe> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Recipe {
  Recipe({
    required this.id,
    required this.image,
    required this.description,
    required this.ingredients,
    required this.instructions,
    required this.name,
    required this.category,
    required this.cookTime,
    required this.prepTime,
    required this.url,
    required this.timestamp,
  });

  String id;
  String image;
  String description;
  List<String> ingredients;
  List<String> instructions;
  String name;
  String category;
  String cookTime;
  String prepTime;
  String url;
  int timestamp;

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
        id: json["id"],
        image: json["image"],
        description: json["description"],
        ingredients: List<String>.from(json["ingredients"].map((x) => x)),
        instructions: List<String>.from(json["instructions"].map((x) => x)),
        name: json["name"],
        category: json["category"],
        cookTime: json["cookTime"],
        prepTime: json["prepTime"],
        url: json["url"],
        timestamp: json["timestamp"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "description": description,
        "ingredients": List<dynamic>.from(ingredients.map((x) => x)),
        "instructions": List<dynamic>.from(instructions.map((x) => x)),
        "name": name,
        "category": category,
        "cookTime": cookTime,
        "prepTime": prepTime,
        "url": url,
        "timestamp": timestamp,
      };
}
