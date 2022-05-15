import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../../provider/home_provider.dart';
import '../../detail/detail_view.dart';

class RandomWidget extends StatelessWidget {
  const RandomWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context);
    if (provider.randomState == RandomState.loading) {
      return const Center(child: CircularProgressIndicator());
    } else if (provider.randomState == RandomState.error) {
      return const Center(child: Text('Error getting data'));
    } else {
      return ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: provider.random.length,
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
                      builder: (ctx) => DetailView(
                        recipe: provider.random[i],
                      ),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FadeInImage(
                      fit: BoxFit.cover,
                      height: 102.0,
                      width: 170.0,
                      placeholder: MemoryImage(kTransparentImage),
                      image: CachedNetworkImageProvider(provider.random[i].url),
                      placeholderFit: BoxFit.fitWidth,
                      imageErrorBuilder: (ctx, obj, stc) {
                        return const SizedBox();
                      },
                    ),
                    const SizedBox(height: 5.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 170.0,
                          child: Text(
                            provider.random[i].name,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          "Cook Time: " + provider.random[i].cookTime,
                          style: const TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
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
