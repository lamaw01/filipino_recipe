import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/category_page_provider.dart';
import 'category_recipe.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key, required this.category}) : super(key: key);
  final String category;

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      context
          .read<CategoryPageProvider>()
          .getRecipe(widget.category.toLowerCase());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          //AppBar
          SliverAppBar(
            centerTitle: false,
            pinned: false,
            snap: false,
            floating: true,
            title: Text(
              widget.category,
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 5.0)),
          const CategoryRecipeWidget(),
        ],
      ),
    );
  }
}
