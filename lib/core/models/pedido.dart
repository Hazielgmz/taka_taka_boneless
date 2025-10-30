class Pedido {
  final String id;
  final String customer;
  final String status;
  final double total;
  final DateTime createdAt;

  Pedido({
    required this.id,
    required this.customer,
    required this.status,
    required this.total,
    required this.createdAt,
  });

  factory Pedido.fromMap(Map<String, dynamic> m) {
    return Pedido(
      id: m['id'] as String,
      customer: m['customer'] as String,
      status: m['status'] as String,
      total: (m['total'] as num).toDouble(),
      createdAt: DateTime.parse(m['createdAt'] as String),
    );
  }
}
