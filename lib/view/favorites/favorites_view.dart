import 'package:filipino_recipe/view/detail/detail_view.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../model/recipe_hive.dart';
import '../../service/recipe_box.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favorites',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ValueListenableBuilder<Box<RecipeHive>>(
        valueListenable: RecipeBox.getFavorties().listenable(),
        builder: (ctx, box, child) {
          final recipe = box.values.toList().cast<RecipeHive>();
          if (recipe.isNotEmpty) {
            return ListView.separated(
              itemCount: recipe.length,
              separatorBuilder: (ctx, i) => const Divider(height: 0.0),
              itemBuilder: (ctx, i) {
                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => DetailView(
                          recipe: recipe[i],
                        ),
                      ),
                    );
                  },
                  title: Text(
                    recipe[i].name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      recipe[i].delete();
                    },
                    icon: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No Favorites added'));
          }
        },
      ),
    );
  }
}
