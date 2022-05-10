import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:google_fonts/google_fonts.dart';

import '../provider/category_provider.dart';
import '../provider/featured_provider.dart';
import '../provider/new_provider.dart';
import '../provider/random_provider.dart';
import '../services/firebase_storage.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin<Home> {
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
    await context.read<NewProvider>().getNew();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: init,
        child: CustomScrollView(
          cacheExtent: 100,
          slivers: [
            //AppBar
            SliverAppBar(
              pinned: false,
              snap: false,
              floating: false,
              title: Text('Filipino Recipes', style: GoogleFonts.rubik()),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 10.0)),
            //Featured
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
            const SliverToBoxAdapter(child: SizedBox(height: 10.0)),
            //Random
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
                height: 149.0,
                child: RandomWidget(),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 10.0)),
            //Category
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
            const SliverToBoxAdapter(child: SizedBox(height: 10.0)),
            //Newly Added
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Newly Added',
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.rubik(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const NewWidget(),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
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
          addAutomaticKeepAlives: true,
        ),
      );
    }
  }
}

class NewWidget extends StatelessWidget {
  const NewWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NewProvider>(context);
    if (provider.loading) {
      return const SliverToBoxAdapter(
          child: Center(child: CircularProgressIndicator()));
    } else {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (ctx, i) {
            return Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  FutureBuilder<String>(
                    future: FBStorage.getImageUrl(
                        'thumbnail', provider.newRecipe[i].image),
                    builder: (ctx, snapshot) {
                      if (snapshot.hasData) {
                        return FadeInImage(
                          fit: BoxFit.cover,
                          height: 160.0,
                          width: 266.0,
                          placeholder: MemoryImage(kTransparentImage),
                          image: CachedNetworkImageProvider(snapshot.data!),
                          placeholderFit: BoxFit.fitWidth,
                        );
                      } else {
                        return const SizedBox(
                          height: 160.0,
                          width: 266.0,
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 10.0),
                  SizedBox(
                    // color: Colors.teal,
                    height: 165.0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            provider.newRecipe[i].name,
                            style: GoogleFonts.rubik(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          Text(
                            provider.newRecipe[i].description,
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 7,
                            style: GoogleFonts.rubik(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.blue,
                    ),
                    onPressed: () {},
                    child: Text(
                      'Continue Reading',
                      style: GoogleFonts.rubik(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.red,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                ],
              ),
            );
          },
          childCount: provider.newRecipe.length,
          addAutomaticKeepAlives: true,
        ),
      );
    }
  }
}
