import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Grid extends StatelessWidget {
  final dynamic image;
  final int sizeFactor;
  final VoidCallback onRemove;

  const Grid({
    required Key? key,
    required this.image,
    required this.sizeFactor,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageUrl = image['webformatURL'];

    return GestureDetector(
      onTap: onRemove,
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
      ),
    );
  }
}
