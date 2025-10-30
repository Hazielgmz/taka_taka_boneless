import 'dart:async';

import 'package:taka_taka_boneless/core/models/product.dart';

class ProductService {
  static final List<Product> _mock = [
    Product(id: 'P001', number: 1, name: 'Promo Familiar', price: 29.99, category: 'Promociones'),
    Product(id: 'P002', number: 2, name: 'Boneless 8pz', price: 12.50, category: 'Boneless'),
    Product(id: 'P003', number: 3, name: 'Papas Fritas', price: 4.00, category: 'Acompañamientos'),
    Product(id: 'P004', number: 4, name: 'Refresco 600ml', price: 2.50, category: 'Bebidas'),
    Product(id: 'P005', number: 5, name: 'Extra Salsa', price: 0.75, category: 'Extras'),
    Product(id: 'P006', number: 6, name: 'Boneless 12pz', price: 18.00, category: 'Boneless'),
    Product(id: 'P007', number: 7, name: 'Ensalada', price: 5.50, category: 'Acompañamientos'),
  ];

  /// Fetch products for a given category. Replace with DB call in production.
  static Future<List<Product>> fetchProductsByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 250));
    return _mock.where((p) => p.category == category).toList();
  }
}
