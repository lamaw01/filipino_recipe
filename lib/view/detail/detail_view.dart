import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';

import '../../model/recipe_hive.dart';
import '../../service/recipe_box.dart';

bool checkisFavorite(String id) {
  bool isInTheBox = false;
  for (var boxes in RecipeBox.getFavorties().values) {
    if (boxes.id == id) {
      isInTheBox = true;
      break;
    }
  }
  return isInTheBox;
}

class DetailView extends StatelessWidget {
  const DetailView({Key? key, required this.recipe, this.isFeatured = false})
      : super(key: key);
  final RecipeHive recipe;
  final bool isFeatured;

  @override
  Widget build(BuildContext context) {
    final box = RecipeBox.getFavorties();
    bool isFavorite = checkisFavorite(recipe.id);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            centerTitle: false,
            pinned: false,
            snap: false,
            floating: true,
            title: Text(
              recipe.name + " Recipe",
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
            actions: [
              StatefulBuilder(
                builder: (ctx, setState) => IconButton(
                  // splashRadius: 30.0,
                  icon: isFavorite
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : const Icon(
                          Icons.favorite_border,
                        ),
                  onPressed: () {
                    if (!isFavorite) {
                      box.add(recipe);
                      setState(() {
                        isFavorite = checkisFavorite(recipe.id);
                      });
                    } else {
                      recipe.delete();
                      setState(() {
                        isFavorite = checkisFavorite(recipe.id);
                      });
                    }
                  },
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.only(right: 10.0, left: 10.0, bottom: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isFeatured) ...[
                    Hero(
                      tag: recipe.name,
                      child: Image(
                        height: 375.0,
                        width: 270.0,
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(recipe.image),
                      ),
                    ),
                  ] else ...[
                    Image(
                      height: 375.0,
                      width: 270.0,
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(recipe.image),
                    ),
                  ],
                  const SizedBox(height: 20.0),
                  Text(
                    recipe.description,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.local_dining),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            const TextSpan(
                              text: "Prep. Time ",
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: recipe.prepTime,
                              style: const TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5.0),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.local_fire_department),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            const TextSpan(
                              text: "Cook Time ",
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: recipe.cookTime,
                              style: const TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                    'Ingredients',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  for (var ingredient in recipe.ingredients) ...[
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "???",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 5.0),
                          Expanded(
                            child: SizedBox(
                              child: Text(
                                ingredient,
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5.0),
                  ],
                  const SizedBox(height: 20.0),
                  const Text(
                    'Instructions',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  for (int i = 0; i < recipe.instructions.length; i++) ...[
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${i + 1}.",
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 5.0),
                          Expanded(
                            child: SizedBox(
                              child: Text(
                                recipe.instructions[i],
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5.0),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
