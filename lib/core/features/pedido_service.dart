import 'dart:async';

import 'package:taka_taka_boneless/core/models/pedido.dart';
import 'package:taka_taka_boneless/core/models/cart_item.dart';

// id generation will be handled when creating a pedido

class PedidoService {
  // Mock data - replace with real DB calls
  static final List<Pedido> _mock = [
    Pedido(id: 'A001', customer: 'Juan Pérez', status: 'En Proceso', total: 12.50, createdAt: DateTime.now().subtract(const Duration(hours: 2))),
    Pedido(id: 'A002', customer: 'María López', status: 'Completados', total: 18.00, createdAt: DateTime.now().subtract(const Duration(days: 1))),
    Pedido(id: 'A003', customer: 'Carlos Ruiz', status: 'Cancelados', total: 9.75, createdAt: DateTime.now().subtract(const Duration(days: 3))),
    Pedido(id: 'A004', customer: 'Ana Gómez', status: 'En Proceso', total: 25.00, createdAt: DateTime.now().subtract(const Duration(minutes: 30))),
    Pedido(id: 'A005', customer: 'Luis Martínez', status: 'Completados', total: 14.20, createdAt: DateTime.now().subtract(const Duration(days: 2))),
  ];

  /// Fetch orders by status. In production this should query your database.
  static Future<List<Pedido>> fetchPedidosByStatus(String status) async {
    // Simulate network/database latency
    await Future.delayed(const Duration(milliseconds: 400));
    return _mock.where((p) => p.status == status).toList();
  }

  /// Create a Pedido from cart items (mock). Returns the created Pedido.
  static Future<Pedido> createPedidoFromCart(List<CartItem> items, {String customer = 'Cliente'}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final total = items.fold<double>(0.0, (s, i) => s + i.subtotal);
  final id = 'A${(_mock.length + 1).toString().padLeft(3, '0')}';
  final p = Pedido(id: id, customer: customer, status: 'En Proceso', total: total, createdAt: DateTime.now());
    _mock.add(p);
    return p;
  }

  /// Update the status of a pedido in the mock store. Returns true if updated.
  static Future<bool> updatePedidoStatus(String id, String newStatus) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final idx = _mock.indexWhere((p) => p.id == id);
    if (idx == -1) return false;
    final existing = _mock[idx];
    final updated = Pedido(
      id: existing.id,
      customer: existing.customer,
      status: newStatus,
      total: existing.total,
      createdAt: existing.createdAt,
    );
    _mock[idx] = updated;
    return true;
  }
}
