import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../../provider/category_provider.dart';
import '../../detail/detail_view.dart';

class CategoryRecipeWidget extends StatelessWidget {
  const CategoryRecipeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CategoryProvider>(context);
    if (provider.state == CategoryState.loading) {
      return SliverToBoxAdapter(
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 2,
          width: MediaQuery.of(context).size.width / 2,
          child: const Center(child: CircularProgressIndicator()),
        ),
      );
    } else if (provider.state == CategoryState.error) {
      return SliverToBoxAdapter(
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 2,
          width: MediaQuery.of(context).size.width / 2,
          child: const Center(
            child: Text('Error getting data'),
          ),
        ),
      );
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
                    image: CachedNetworkImageProvider(
                        provider.categoryRecipe[i].image),
                    placeholderFit: BoxFit.fitWidth,
                    imageErrorBuilder: (ctx, obj, stc) {
                      return const SizedBox();
                    },
                  ),
                  const SizedBox(height: 10.0),
                  SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            provider.categoryRecipe[i].name,
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          Text(
                            provider.categoryRecipe[i].description,
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 7,
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => DetailView(
                            recipe: provider.categoryRecipe[i],
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'Continue Reading',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
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
          childCount: provider.categoryRecipe.length,
          addAutomaticKeepAlives: true,
        ),
      );
    }
  }
}
