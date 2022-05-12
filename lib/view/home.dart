import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:google_fonts/google_fonts.dart';

import '../provider/category_provider.dart';
import '../provider/featured_provider.dart';
import '../provider/new_provider.dart';
import '../provider/random_provider.dart';
import 'webview_widget.dart';

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
    // var name = "https://panlasangpinoy.com";
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: init,
        child: CustomScrollView(
          slivers: [
            //AppBar
            SliverAppBar(
              centerTitle: true,
              pinned: false,
              snap: false,
              floating: false,
              title: Text(
                'Filipino Recipes',
                style: GoogleFonts.rubik(
                  color: Colors.black,
                ),
              ),
              backgroundColor: Colors.white,
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
            SliverToBoxAdapter(
              child: Container(
                height: 50.0,
                color: Colors.black87,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Recipes and Images are all credit to',
                      style: GoogleFonts.rubik(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Panlasang Pinoy ',
                            style: GoogleFonts.rubik(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          TextSpan(
                            text: 'https://panlasangpinoy.com',
                            style: GoogleFonts.rubik(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (ctx) => const WebViewWidget(),
                                  ),
                                );
                              },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

// class WebUrl with ChangeNotifier {
//   var _url = "https://panlasangpinoy.com";
//   String get url => _url;

//   void updateUrl(String newUrl) {
//     _url = newUrl;
//     notifyListeners();
//   }
// }

class FeaturedWidget extends StatelessWidget {
  const FeaturedWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FeaturedProvider>(context);
    if (provider.state == FeaturedState.loading) {
      return const Center(child: CircularProgressIndicator());
    } else if (provider.state == FeaturedState.error) {
      return const Center(child: Text('Error getting data'));
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
                FadeInImage(
                  height: 375.0,
                  width: 270.0,
                  fit: BoxFit.cover,
                  placeholder: MemoryImage(kTransparentImage),
                  image: CachedNetworkImageProvider(provider.recipe[i].url),
                  placeholderFit: BoxFit.fitWidth,
                  imageErrorBuilder: (ctx, obj, stc) {
                    return const SizedBox();
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
    if (provider.state == RandomState.loading) {
      return const Center(child: CircularProgressIndicator());
    } else if (provider.state == RandomState.error) {
      return const Center(child: Text('Error getting data'));
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
                FadeInImage(
                  fit: BoxFit.cover,
                  height: 102.0,
                  width: 170.0,
                  placeholder: MemoryImage(kTransparentImage),
                  image:
                      CachedNetworkImageProvider(provider.randomRecipe[i].url),
                  placeholderFit: BoxFit.fitWidth,
                  imageErrorBuilder: (ctx, obj, stc) {
                    return const SizedBox();
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
    if (provider.state == CategoryState.loading) {
      return const SliverToBoxAdapter(
          child: Center(child: CircularProgressIndicator()));
    } else if (provider.state == CategoryState.error) {
      return const Center(child: Text('Error getting data'));
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
                Opacity(
                  opacity: 0.8,
                  child: FadeInImage(
                    fit: BoxFit.cover,
                    placeholder: MemoryImage(kTransparentImage),
                    image: CachedNetworkImageProvider(provider.category[i].url),
                    imageErrorBuilder: (ctx, obj, stc) {
                      return const SizedBox();
                    },
                  ),
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
    if (provider.state == NewState.loading) {
      return const SliverToBoxAdapter(
          child: Center(child: CircularProgressIndicator()));
    } else if (provider.state == FeaturedState.error) {
      return const Center(child: Text('Error getting data'));
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
                  FadeInImage(
                    fit: BoxFit.cover,
                    height: 160.0,
                    width: 266.0,
                    placeholder: MemoryImage(kTransparentImage),
                    image:
                        CachedNetworkImageProvider(provider.newRecipe[i].url),
                    placeholderFit: BoxFit.fitWidth,
                    imageErrorBuilder: (ctx, obj, stc) {
                      return const SizedBox();
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
