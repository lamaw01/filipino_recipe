import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:google_fonts/google_fonts.dart';

import '../provider/category_provider.dart';
import '../provider/featured_provider.dart';
import '../provider/random_provider.dart';
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
    context.read<RandomProvider>().initRandom();
    init();
  }

  Future<void> init() async {
    await context.read<FeaturedProvider>().getRecipe();
    await context.read<CategoryProvider>().getCategory();
    await context.read<RandomProvider>().getRandom();
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
                padding: const EdgeInsets.only(left: 10.0, top: 10.0),
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
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Consumer<RandomProvider>(
                  builder: (ctx, provider, child) {
                    return Text(
                      provider.listRecipe[provider.randomNum],
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.rubik(
                        fontSize: 22.0,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 225.0,
                child: RandomWidget(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeaturedWidget extends StatelessWidget {
  const FeaturedWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FeaturedProvider>(context);
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
                        image: CachedNetworkImageProvider(snapshot.data!),
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
                          image: CachedNetworkImageProvider(snapshot.data!),
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

class RandomWidget extends StatelessWidget {
  const RandomWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RandomProvider>(context);
    if (provider.loading) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: provider.randomRecipe.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (ctx, i) {
          return Padding(
            padding: EdgeInsets.only(left: i == 0 ? 10.0 : 0.0, right: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                FutureBuilder<String>(
                  future: FBStorage.getImageUrl(
                      'thumbnail', provider.randomRecipe[i].image),
                  builder: (ctx, snapshot) {
                    if (snapshot.hasData) {
                      return FadeInImage(
                        fit: BoxFit.cover,
                        height: 102.0,
                        width: 170.0,
                        placeholder: MemoryImage(kTransparentImage),
                        image: CachedNetworkImageProvider(snapshot.data!),
                        placeholderFit: BoxFit.fitWidth,
                      );
                    } else {
                      return const SizedBox(
                        height: 102.0,
                        width: 170.0,
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
                        provider.randomRecipe[i].name,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.rubik(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "Cook Time: " +
                            provider.randomRecipe[i].cookTime.toString() +
                            " min",
                        style: GoogleFonts.rubik(
                          fontSize: 12.0,
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
