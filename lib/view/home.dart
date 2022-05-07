import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:google_fonts/google_fonts.dart';

import '../provider/category_provider.dart';
import '../provider/recipe_provider.dart';
import '../services/firebase_storage.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await context.read<RecipeProvider>().getRecipe();
    await context.read<CategoryProvider>().getCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: init,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: false,
              snap: false,
              floating: false,
              title: Text('Filipino Recipes', style: GoogleFonts.rubik()),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 10.0),
            ),
            SliverToBoxAdapter(
              child: Padding(
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
            ),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 425.0,
                child: FeaturedWidget(),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "Category",
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.rubik(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SliverPadding(
              padding: EdgeInsets.all(10.0),
              sliver: CategoryWidget(),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CategoryProvider>(context);
    if (provider.loading) {
      return const SliverToBoxAdapter(
          child: Center(child: CircularProgressIndicator()));
    } else {
      return SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 5.0,
          crossAxisSpacing: 5.0,
          childAspectRatio: 1.6625,
        ),
        delegate: SliverChildBuilderDelegate(
          (ctx, i) {
            return Stack(
              alignment: Alignment.center,
              children: [
                FutureBuilder<String>(
                  future: FBStorage.getImageUrl(
                      'category', provider.category[i].image),
                  builder: (ctx, snapshot) {
                    if (snapshot.hasData) {
                      return Opacity(
                        opacity: 0.8,
                        child: FadeInImage(
                          fit: BoxFit.cover,
                          placeholder: MemoryImage(kTransparentImage),
                          image: NetworkImage(snapshot.data!),
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    provider.category[i].name,
                    style: GoogleFonts.rubik(
                      fontSize: 22.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            );
          },
          childCount: provider.category.length,
        ),
      );
    }
  }
}

class FeaturedWidget extends StatelessWidget {
  const FeaturedWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RecipeProvider>(context);
    if (provider.loading) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: provider.recipe.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (ctx, i) {
          return Padding(
            padding: EdgeInsets.only(left: i == 0 ? 10.0 : 0.0, right: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                FutureBuilder<String>(
                  future:
                      FBStorage.getImageUrl('images', provider.recipe[i].image),
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
                ),
                const SizedBox(height: 5.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        provider.recipe[i].name,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.rubik(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "Cook Time: " +
                            provider.recipe[i].cookTime.toString() +
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
