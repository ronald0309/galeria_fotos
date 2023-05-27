import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Grid extends StatelessWidget {
  final ScrollController scrollController;
  final List<dynamic> images;
  final bool isLoading;
  final int crossAxisCount;

  Grid({
    required this.scrollController,
    required this.images,
    required this.isLoading,
    required this.crossAxisCount,
  });

  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.countBuilder(
      controller: scrollController,
      crossAxisCount: crossAxisCount,
      itemCount: images.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index < images.length) {
          final image = images[index];
          final sizeFactor = index % 3 == 0 ? 2 : 1;
          return CachedNetworkImage(
            imageUrl: image['webformatURL'],
            fit: BoxFit.cover,
            height: 200 * sizeFactor.toDouble(),
          );
        } else if (isLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Container();
        }
      },
      staggeredTileBuilder: (int index) {
        final double sizeFactor = index % 3 == 0 ? 2 : 1;
        return StaggeredTile.count(1, sizeFactor);
      },
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
    );
  }
}
