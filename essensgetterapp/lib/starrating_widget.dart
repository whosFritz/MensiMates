import 'package:flutter/material.dart';

class StarRating extends StatefulWidget {
  const StarRating({super.key});

  @override
  StarRatingState createState() => StarRatingState();
}

class StarRatingState extends State<StarRating> {
  int _selectedStars = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedStars = index + 1;
            });
          },
          child: Icon(
            index < _selectedStars ? Icons.star : Icons.star_border,
            color: Colors.yellow,
          ),
        );
      }),
    );
  }
}
