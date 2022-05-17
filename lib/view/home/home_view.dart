import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/home_provider.dart';
import '../favorites/favorites_view.dart';
import '../search/search_view.dart';
import 'widgets/categories_widget.dart';
import 'widgets/featured_widget.dart';
import 'widgets/footer_widget.dart';
import 'widgets/recent_widget.dart';
import 'widgets/random_widget.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with AutomaticKeepAliveClientMixin<HomeView> {
  final sc = ScrollController();
  @override
  void initState() {
    super.initState();
    context.read<HomeProvider>().initRandom();
    init();
    sc.addListener(() {
      if (sc.offset >= sc.position.maxScrollExtent && !sc.position.outOfRange) {
        if (context.read<HomeProvider>().recent.length < 15) {
          context.read<HomeProvider>().getAdditionalRecent();
        }
      }
    });
  }

  Future<void> init() async {
    await context.read<HomeProvider>().getFeatured();
    await context.read<HomeProvider>().getRandom();
    await context.read<HomeProvider>().getCategory();
    await context.read<HomeProvider>().getRecent();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: init,
        child: CustomScrollView(
          controller: sc,
          slivers: [
            //AppBar
            SliverAppBar(
              centerTitle: true,
              pinned: false,
              snap: false,
              floating: true,
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'Filipino Recipes',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Image(
                    image: AssetImage("assets/images/ph_icon.png"),
                    width: 50.0,
                    fit: BoxFit.fitWidth,
                  )
                ],
              ),
              actions: [
                IconButton(
                  // splashRadius: 30.0,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => const SearchView(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.search),
                ),
              ],
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 10.0)),
            // Featured
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "Featured",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
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
            // Random
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Consumer<HomeProvider>(
                  builder: (ctx, provider, child) {
                    return Text(
                      provider.listRecipe[provider.randomNum],
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
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
            // Category
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(left: 10.0, top: 10.0),
                child: Text(
                  "Categories",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SliverPadding(
              padding: EdgeInsets.all(10.0),
              sliver: CategoriesWidget(),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 10.0)),
            //Newly Added
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Newly Added',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const RecentWidget(),
            const FooterWidget(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.favorite,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => const FavoritesView(),
            ),
          );
        },
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
