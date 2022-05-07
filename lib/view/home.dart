import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:google_fonts/google_fonts.dart';

import '../provider/recipe_provider.dart';
import '../services/firebase_storage.dart';

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
        title: Text('Filipino Recipes', style: GoogleFonts.rubik()),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Featured",
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.rubik(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(
              // color: Colors.pink,
              height: 425.0,
              child: RecipeMain(),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Desserts",
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.rubik(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
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
      return ListView.builder(
        itemCount: recipeProvider.recipe.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (ctx, i) {
          return Padding(
            padding: EdgeInsets.only(left: i == 0 ? 10.0 : 0.0, right: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                RecipeImage(image: recipeProvider.recipe[i].image),
                const SizedBox(height: 5.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipeProvider.recipe[i].name,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.rubik(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "Cook Time: " +
                            recipeProvider.recipe[i].cookTime.toString() +
                            " min",
                        style: GoogleFonts.rubik(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
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
