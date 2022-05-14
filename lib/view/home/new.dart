import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../provider/new_provider.dart';
import '../detail/detail.dart';

class NewWidget extends StatelessWidget {
  const NewWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NewProvider>(context);
    if (provider.state == NewState.loading) {
      return const SliverToBoxAdapter(
          child: Center(child: CircularProgressIndicator()));
    } else if (provider.state == NewState.error) {
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
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          Text(
                            provider.newRecipe[i].description,
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
                          builder: (ctx) => RecipeDetail(
                            recipe: provider.newRecipe[i],
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
          childCount: provider.newRecipe.length,
          addAutomaticKeepAlives: true,
        ),
      );
    }
  }
}
