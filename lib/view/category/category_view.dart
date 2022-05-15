import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/category_provider.dart';
import 'widgets/category_widget.dart';

class CategoryView extends StatefulWidget {
  const CategoryView({Key? key, required this.category}) : super(key: key);
  final String category;

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      context.read<CategoryProvider>().getRecipe(widget.category.toLowerCase());
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
