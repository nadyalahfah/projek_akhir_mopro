import 'package:flutter/material.dart';

Widget buildStarRating(double r, {double size = 16}) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: List.generate(5, (i) {
      return Icon(
        i < r.floor()
            ? Icons.star
            : (i < r ? Icons.star_half : Icons.star_outline),
        size: size,
        color: Colors.amber,
      );
    }),
  );
}
