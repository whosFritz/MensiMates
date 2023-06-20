import "dart:convert";

class Dish {
  final int id;
  final String name;
  final String description;
  final String price;
  final String category;
  final DateTime servingDate;
  final int responseCode;
  final double rating;
  final int votes;

  Dish({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.servingDate,
    required this.responseCode,
    required this.rating,
    required this.votes,
  });

  static Dish fromJson(json) {
    return Dish(
      id: json["id"] ?? 1000000,
      name: json["name"] ?? "keine Angaben",
      description: json["description"] ?? "keine Angaben",
      price: json["price"] ?? "keine Angaben",
      category: json["category"] ?? "keine Angaben",
      servingDate: DateTime.parse(json["servingDate"]),
      responseCode: json["responseCode"] ?? 200,
      rating: json["rating"] ?? 3.0,
      votes: json["votes"] ?? 0,
    );
  }

  @override
  String toString() {
    return 'Dish: $name, Category: $category, Price: ${price.substring(0, 5)}';
  }

  String toJson() {
    return json.encode({
      "id": id,
      "name": name,
      "description": description,
      "price": price,
      "category": category,
      "servingDate": servingDate.toString().substring(0, 10),
      "responseCode": responseCode,
      "rating": rating,
      "votes": votes,
    });
  }
}
