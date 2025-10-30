import 'package:taka_taka_boneless/core/models/product.dart';
import 'package:taka_taka_boneless/core/models/extra.dart';

class CartItem {
  final Product product;
  final int quantity;
  final List<CartExtra> extras;

  CartItem({required this.product, required this.quantity, required this.extras});

  double get subtotal {
    final extrasTotal = extras.fold<double>(0.0, (s, e) => s + e.price * e.quantity);
    return (product.price * quantity) + extrasTotal;
  }
}

class CartExtra {
  final Extra extra;
  final int quantity;

  CartExtra({required this.extra, required this.quantity});

  double get price => extra.price;
}
