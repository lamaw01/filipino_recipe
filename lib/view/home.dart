import 'package:filipino_recipe/services/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import '../provider/recipe_provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late RecipeProvider recipeProvider;
  @override
  void initState() {
    super.initState();
    recipeProvider = Provider.of<RecipeProvider>(context, listen: false);
    recipeProvider.getRecipe();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: const RecipeMain(),
    );
  }
}

class RecipeMain extends StatelessWidget {
  const RecipeMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recipeProvider = Provider.of<RecipeProvider>(context);
    if (recipeProvider.status == Status.loading) {
      return const Center(child: CircularProgressIndicator());
    } else if (recipeProvider.status == Status.error) {
      return const Center(child: Text('Error'));
    } else {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.separated(
          itemCount: recipeProvider.recipe.length,
          separatorBuilder: (ctx, i) => const SizedBox(width: 10.0),
          scrollDirection: Axis.horizontal,
          itemBuilder: (ctx, i) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                RecipeImage(image: recipeProvider.recipe[i].image),
                SizedBox(
                  width: 270.0,
                  height: 50.0,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recipeProvider.recipe[i].name,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "Cook Time: " +
                              recipeProvider.recipe[i].cookTime.toString() +
                              " min",
                          style: const TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );
    }
  }
}

class RecipeImage extends StatelessWidget {
  const RecipeImage({Key? key, required this.image}) : super(key: key);
  final String image;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: FBStorage.downloadUrl(image),
      builder: (ctx, snapshot) {
        if (snapshot.hasData) {
          return FadeInImage(
            height: 375.0,
            width: 270.0,
            fit: BoxFit.cover,
            placeholder: MemoryImage(kTransparentImage),
            image: NetworkImage(snapshot.data!),
            placeholderFit: BoxFit.fitWidth,
          );
        } else {
          return const SizedBox(
            height: 375.0,
            width: 270.0,
          );
        }
      },
    );
  }
}
