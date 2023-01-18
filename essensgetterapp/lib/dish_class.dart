
import 'dart:convert';

class Dish {
  Dish({
    required this.name,
    required this.servingDate,
    required this.category,
    required this.price,
    required this.description,
    required this.rating
  });

  final String category;
  final String servingDate;
  final String description;
  final String name;
  final String price;
  final double rating;

  @override
  String toString() {
    return "Gerich: Es gibt am $servingDate $name mit $description zum Preis von $price und einer Bewertung von $rating Sternen.";
  }

  static Dish fromJson(json) {
    return Dish(
        name: json["name"] ?? "keine Angaben",
        servingDate: json["servingDate"] ?? "keine Angaben",
        category: json["category"] ?? "keine Angaben",
        price: json["price"] ?? "keine Angaben",
        description: json["description"] ?? "keine Angaben",
        rating: json["rating"] ?? 0.0);
  }

  String toJson() {
    return json.encode({
      'name': name,
      'servingDate': servingDate,
      'category': category,
      'price': price,
      'description': description,
      "rating": rating
    });
  }
}