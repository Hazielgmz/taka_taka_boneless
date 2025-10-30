class Product {
  final String id;
  final int number;
  final String name;
  final double price;
  final String category;

  Product({
    required this.id,
    required this.number,
    required this.name,
    required this.price,
    required this.category,
  });

  factory Product.fromMap(Map<String, dynamic> m) {
    return Product(
      id: m['id'] as String,
      number: m['number'] as int,
      name: m['name'] as String,
      price: (m['price'] as num).toDouble(),
      category: m['category'] as String,
    );
  }
}
