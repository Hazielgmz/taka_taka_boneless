import 'package:taka_taka_boneless/core/models/cart_item.dart';

class CartService {
  static final List<CartItem> _items = [];

  static void addToCart(CartItem item) {
    // In a real app you'd merge items, persist to DB / local storage, handle ids, etc.
    _items.add(item);
    // For quick debugging in development
    // ignore: avoid_print
    print('CartService: added ${item.product.name} x${item.quantity} (+ ${item.extras.length} extras)');
  }

  /// Replace an existing cart item with a new one. We try to match by identity
  /// first (the same object reference passed from UI). If that fails we fall
  /// back to matching by product id (first occurrence).
  static void updateItem(CartItem oldItem, CartItem newItem) {
    final idx = _items.indexWhere((i) => identical(i, oldItem) || i.product.id == oldItem.product.id);
    if (idx != -1) {
      _items[idx] = newItem;
      // ignore: avoid_print
      print('CartService: updated ${newItem.product.name} to qty ${newItem.quantity} (+ ${newItem.extras.length} extras)');
    }
  }

  static List<CartItem> getItems() => List.unmodifiable(_items);

  static int itemCount() => _items.length;

  static double totalAmount() {
    return _items.fold<double>(0.0, (s, i) => s + i.subtotal);
  }

  static void removeAt(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
    }
  }

  static void clear() => _items.clear();
}
