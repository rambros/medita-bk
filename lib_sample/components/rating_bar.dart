import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:line_icons/line_icons.dart';

class RatingViewer extends StatelessWidget {
  final double rating;
  final bool? showText;
  const RatingViewer({super.key, required this.rating, this.showText});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        RatingBarIndicator(
          itemSize: 16,
          rating: rating,
          itemPadding: const EdgeInsets.symmetric(vertical: 3, horizontal: 1.0),
          itemCount: 5,
          unratedColor: Colors.grey.shade400,
          itemBuilder: (context, index) => const Icon(
            LineIcons.starAlt,
            color: Colors.orange,
          ),
        ),
        Visibility(
          visible: showText ?? true,
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              rating.toStringAsFixed(1),
              style: const TextStyle(fontSize: 13, color: Colors.deepOrange, fontWeight: FontWeight.w600),
            ),
          ),
        )
      ],
    );
  }
}
