import 'package:hive_flutter/hive_flutter.dart';

import '../model/recipe_hive.dart';

class RecipeBox {
  static Box<RecipeHive> getFavorties() {
    return Hive.box<RecipeHive>('favorites');
  }
}
