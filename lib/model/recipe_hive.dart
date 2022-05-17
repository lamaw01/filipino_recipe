import 'dart:convert';
import 'package:hive/hive.dart';
part 'recipe_hive.g.dart';

// To parse this JSON data, do
//
//     final recipe = recipeFromJson(jsonString);

List<RecipeHive> recipeFromJson(String str) =>
    List<RecipeHive>.from(json.decode(str).map((x) => RecipeHive.fromJson(x)));

String recipeToJson(List<RecipeHive> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@HiveType(typeId: 0)
class RecipeHive extends HiveObject {
  RecipeHive({
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

  @HiveField(0)
  String id;

  @HiveField(1)
  String image;

  @HiveField(2)
  String description;

  @HiveField(3)
  List<String> ingredients;

  @HiveField(4)
  List<String> instructions;

  @HiveField(5)
  String name;

  @HiveField(6)
  String category;

  @HiveField(7)
  String cookTime;

  @HiveField(8)
  String prepTime;

  @HiveField(9)
  String url;

  @HiveField(10)
  int timestamp;

  factory RecipeHive.fromJson(Map<String, dynamic> json) => RecipeHive(
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
