import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../provider/category_provider.dart';

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
                    style: const TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.w600,
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
