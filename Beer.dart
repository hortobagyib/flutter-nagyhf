// ignore_for_file: file_names

class Beer {
  late final int id;
  final String name;
  final String imageUrl;
  final double abv;
  final String tagline;
  final String description;
  final double? ibu;
  final dynamic ingredients;
  int? rating;

  Beer({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.abv,
    required this.tagline,
    required this.description,
    required this.ibu,
    required this.ingredients,
    required this.rating,
  });

  static Beer fromJson(Map<String, dynamic> json) => Beer(
        id: json['id'],
        name: json['name'],
        imageUrl: json['image_url'],
        abv: json['abv'],
        tagline: json['tagline'],
        description: json['description'],
        ibu: json['ibu'],
        ingredients: json['ingredients'],
        rating: json['rating'],
      );
}
