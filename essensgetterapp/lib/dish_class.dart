import "dart:convert";

class Dish {
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

  final int id;
  final String name;
  final String description;
  final String price;
  final String category;
  final DateTime servingDate;
  final int responseCode;
  final double rating;
  final int votes;

  @override
  String toString() {
    return "$responseCode Gericht ID: $id: Es gibt am $servingDate $name mit $description zum Preis von $price und einer Bewertung von $rating Sternen.";
  }

  static Dish fromJson(json) {
    return Dish(
      id: json["id"] ?? 10000,
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
