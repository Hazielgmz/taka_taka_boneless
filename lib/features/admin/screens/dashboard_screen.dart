import 'package:flutter/material.dart';
import 'package:taka_taka_boneless/widgets/appbar.dart' as custom;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedYear = 2025;
  int selectedMonth = 10;
  // Vista tipo wallet: mostramos total del mes y pequeñas cards de ingresos

  // Datos de ejemplo con año y mes
  final List<Map<String, dynamic>> dailyIncome = [
    {'year': 2025, 'month': 10, 'day': 1, 'cash': 1200.0, 'transfer': 800.0},
    {'year': 2025, 'month': 10, 'day': 2, 'cash': 900.0, 'transfer': 1100.0},
    {'year': 2025, 'month': 10, 'day': 3, 'cash': 1500.0, 'transfer': 700.0},
    {'year': 2025, 'month': 10, 'day': 4, 'cash': 1000.0, 'transfer': 1200.0},
    {'year': 2025, 'month': 10, 'day': 5, 'cash': 1600.0, 'transfer': 200.0},        {'year': 2025, 'month': 10, 'day': 5, 'cash': 1300.0, 'transfer': 900.0},
    {'year': 2025, 'month': 10, 'day': 6, 'cash': 1300.0, 'transfer': 200.0},
    {'year': 2025, 'month': 10, 'day': 7, 'cash': 13300.0, 'transfer': 700.0},
    {'year': 2025, 'month': 10, 'day': 8, 'cash': 12300.0, 'transfer': 900.0},
    {'year': 2025, 'month': 10, 'day': 9, 'cash': 300.0, 'transfer': 500.0},
    {'year': 2025, 'month': 10, 'day': 10, 'cash': 1300.0, 'transfer': 1900.0},
    {'year': 2025, 'month': 10, 'day': 11, 'cash': 11300.0, 'transfer': 9900.0},

    {'year': 2025, 'month': 9, 'day': 1, 'cash': 800.0, 'transfer': 600.0},
    {'year': 2024, 'month': 10, 'day': 1, 'cash': 700.0, 'transfer': 500.0},
  ];

  List<int> get availableYears {
    final years = <int>{};
    for (final d in dailyIncome) {
      years.add(d['year'] as int);
    }
    return years.toList()..sort();
  }

  List<int> get availableMonths {
    final months = <int>{};
    for (final d in dailyIncome.where((e) => e['year'] == selectedYear)) {
      months.add(d['month'] as int);
    }
    return months.toList()..sort();
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFFe7292a);
    final filteredIncome = dailyIncome.where((d) => d['year'] == selectedYear && d['month'] == selectedMonth).toList();
    // Totales para resumen
    final totalCash = filteredIncome.fold<double>(0, (sum, d) => sum + (d['cash'] as double));
    final totalTransfer = filteredIncome.fold<double>(0, (sum, d) => sum + (d['transfer'] as double));
    final total = totalCash + totalTransfer;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          custom.AppBar(title: 'Dashboard', showBack: true),
          
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Selectores de año y mes
                Row(
                  children: [
                    const Text('Año:', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    DropdownButton<int>(
                      value: selectedYear,
                      items: availableYears.map((y) => DropdownMenuItem(value: y, child: Text('$y'))).toList(),
                      onChanged: (y) {
                        if (y != null) setState(() { selectedYear = y; selectedMonth = availableMonths.first; });
                      },
                    ),
                    const SizedBox(width: 24),
                    const Text('Mes:', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    DropdownButton<int>(
                      value: selectedMonth,
                      items: availableMonths.map((m) => DropdownMenuItem(value: m, child: Text('$m'))).toList(),
                      onChanged: (m) {
                        if (m != null) setState(() { selectedMonth = m; });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Card tipo wallet con total del mes
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(color: primary.withValues(alpha: 0.25), blurRadius: 16, offset: const Offset(0, 8)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Total del mes', style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 6),
                      Text('\$${total.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _dot(color: Colors.white),
                          const SizedBox(width: 6),
                          Text('Efectivo: \$${totalCash.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _dot(color: Colors.white),
                          const SizedBox(width: 6),
                          Text('Transferencia: \$${totalTransfer.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Pequeñas cards por ingreso (todas, ordenadas por fecha: recientes arriba)
                Builder(builder: (context) {
                  final latest = List<Map<String, dynamic>>.from(filteredIncome)
                    ..sort((a, b) => (b['day'] as int).compareTo(a['day'] as int));

                  final cards = <Widget>[];
                  for (final d in latest) {
                    // Efectivo
                    cards.add(_IncomeItemCard(
                      title: 'Ingreso en efectivo',
                      subtitle: 'Día ${d['day']}',
                      amount: (d['cash'] as double),
                      color: Colors.green,
                      icon: Icons.payments_rounded,
                    ));
                    cards.add(const SizedBox(height: 10));
                    // Transferencia
                    cards.add(_IncomeItemCard(
                      title: 'Ingreso por transferencia',
                      subtitle: 'Día ${d['day']}',
                      amount: (d['transfer'] as double),
                      color: Colors.green,
                      icon: Icons.swap_horiz_rounded,
                    ));
                    cards.add(const SizedBox(height: 10));
                  }
                  if (cards.isNotEmpty) {
                    cards.removeLast(); // quita el último espacio extra
                  }
                  return Column(children: cards);
                }),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Punto pequeño para leyenda
Widget _dot({required Color color}) => Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );

// Card pequeña para un ingreso
class _IncomeItemCard extends StatelessWidget {
  const _IncomeItemCard({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.color,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final double amount;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
              BoxShadow(
                blurRadius: 12,
                color: Colors.black.withValues(alpha: 0.06),
                offset: const Offset(0, 4),
              ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: Text(
          '\$${amount.toStringAsFixed(2)}',
          style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}
