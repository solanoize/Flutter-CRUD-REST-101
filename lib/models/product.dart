class Product {
  final String id;
  final String title;
  final String price;
  final String image;
  final String description;

  Product(
      {required this.id,
      required this.title,
      required this.price,
      required this.image,
      required this.description});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        id: json['id'],
        title: json['title'],
        price: json['price'],
        image: json['image'],
        description: json['description']);
  }
}
