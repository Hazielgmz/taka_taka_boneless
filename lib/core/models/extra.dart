class Extra {
  final String id;
  final String name;
  final double price;

  Extra({required this.id, required this.name, required this.price});

  factory Extra.fromMap(Map<String, dynamic> m) => Extra(
        id: m['id'] as String,
        name: m['name'] as String,
        price: (m['price'] as num).toDouble(),
      );
}
