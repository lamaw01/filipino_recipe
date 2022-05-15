import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/category_provider.dart';
import '../../provider/featured_provider.dart';
import '../../provider/new_provider.dart';
import '../../provider/random_provider.dart';
import 'categories.dart';
import 'featured.dart';
import 'footer.dart';
import 'new.dart';
import 'random.dart';

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
                  splashRadius: 30.0,
                  onPressed: () {},
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
                child: Consumer<RandomProvider>(
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
              sliver: CategoryWidget(),
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
            const NewWidget(),
            const FooterWidget(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.favorite,
        ),
        onPressed: () {},
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
