import "dart:convert";

class Dish {
  final int id;
  final String name;
  final String description;
  final String price;
  final String category;
  final DateTime servingDate;
  final String additionalInfo;
  final String allergens;
  final String additives;
  final double rating;
  final int votes;

  Dish({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.servingDate,
    required this.additionalInfo,
    required this.allergens,
    required this.additives,
    required this.rating,
    required this.votes,
  });

  static Dish fromJson(json) {
    return Dish(
      id: json["id"] ?? 1000000,
      name: json["name"] ?? "N/A",
      description: json["description"] ?? "N/A",
      price: json["price"] ?? "N/A",
      category: json["category"] ?? "N/A",
      servingDate: DateTime.parse(json["servingDate"]),
      additionalInfo: json["additionalInfo"] ?? "N/A",
      allergens: json["allergens"] ?? "N/A",
      additives: json["additives"] ?? "N/A",
      rating: json["rating"] ?? 3.0,
      votes: json["votes"] ?? 0,
    );
  }

  @override
  String toString() {
    return "Dish: $name, $description, $price, $category, $servingDate, $additionalInfo, $allergens, $additives, $rating, $votes";
  }

  String toJson() {
    return json.encode({
      "id": id,
      "name": name,
      "description": description,
      "price": price,
      "category": category,
      "servingDate": servingDate.toString().substring(0, 10),
      "rating": rating,
      "votes": votes,
    });
  }
}
