import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../provider/featured_provider.dart';
import '../detail/detail.dart';

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
            child: Ink(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => RecipeDetail(
                        recipe: provider.recipe[i],
                      ),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Hero(
                      tag: provider.recipe[i].name,
                      child: FadeInImage(
                        height: 375.0,
                        width: 270.0,
                        fit: BoxFit.cover,
                        placeholder: MemoryImage(kTransparentImage),
                        image:
                            CachedNetworkImageProvider(provider.recipe[i].url),
                        placeholderFit: BoxFit.fitWidth,
                        imageErrorBuilder: (ctx, obj, stc) {
                          return const SizedBox();
                        },
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            provider.recipe[i].name,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "Cook Time: " +
                                provider.recipe[i].cookTime.toString() +
                                " min",
                            style: const TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
  }
}
