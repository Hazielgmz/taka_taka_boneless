import 'dart:async';

import 'package:taka_taka_boneless/core/models/extra.dart';

class ExtraService {
  // Mock extras repository. In a real app these would come from a DB per product or category.
  static final List<Extra> _mockExtras = [
    Extra(id: 'E001', name: 'Salsa BBQ', price: 0.50),
    Extra(id: 'E002', name: 'Extra Queso', price: 1.00),
    Extra(id: 'E003', name: 'Papas Grandes', price: 2.50),
    Extra(id: 'E004', name: 'Refresco 600ml', price: 2.50),
    Extra(id: 'E005', name: 'Salsa Picante', price: 0.50),
  ];

  /// Return extras relevant to a category. For Bebidas/Extras we return appropriate items.
  static Future<List<Extra>> fetchExtrasForCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 150));
    if (category == 'Bebidas') {
      return _mockExtras.where((e) => e.name.toLowerCase().contains('refresco')).toList();
    }
    if (category == 'Extras') {
      return _mockExtras.where((e) => e.name.toLowerCase().contains('salsa') || e.name.toLowerCase().contains('queso')).toList();
    }
    // Default: provide small selection
    return _mockExtras.take(3).toList();
  }
}
