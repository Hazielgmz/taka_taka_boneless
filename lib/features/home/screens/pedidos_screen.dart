import 'package:flutter/material.dart';
import 'package:taka_taka_boneless/widgets/navbar.dart';
import 'package:taka_taka_boneless/widgets/appbar.dart' as custom;
import 'package:taka_taka_boneless/core/models/pedido.dart';
import 'package:taka_taka_boneless/core/features/pedido_service.dart';
import 'detalles/manage_detalles_pedido_screen.dart';

class PedidosScreen extends StatefulWidget {
  const PedidosScreen({super.key});

  @override
  State<PedidosScreen> createState() => _PedidosScreenState();
}

class _PedidosScreenState extends State<PedidosScreen> {
  final List<String> _statuses = ['En Proceso', 'Completados', 'Cancelados'];
  String _selectedStatus = 'En Proceso';

  void _selectStatus(String status) {
    setState(() {
      _selectedStatus = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          custom.AppBar(title: 'Pedidos', showBack: false),
          // Status filter buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _statuses.map((s) {
                final bool active = s == _selectedStatus;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: active ? Colors.red : Colors.grey[300],
                        foregroundColor: active ? Colors.white : Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () => _selectStatus(s),
                      child: Text(s, textAlign: TextAlign.center),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // List of pedidos for selected status
          Expanded(
            child: FutureBuilder<List<Pedido>>(
              future: PedidoService.fetchPedidosByStatus(_selectedStatus),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: \\${snapshot.error}'));
                }
                final pedidos = snapshot.data ?? [];
                if (pedidos.isEmpty) {
                  return const Center(child: Text('No hay pedidos para este estado'));
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(12.0),
                  itemCount: pedidos.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final p = pedidos[index];
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        // Navigate to details screen and pass the pedido
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ManageDetallesPedidoScreen(pedido: p),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Pedido: ${p.id}', style: const TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text('Cliente: ${p.customer}'),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('\$${p.total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text('${p.createdAt.day}/${p.createdAt.month}/${p.createdAt.year}'),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      //Arriba deberan existir botones para filtrar los pedidos por su status
          //Los status seran: En Proceso, Completados, Cancelados

      //El apartado que se mostrara por defecto al visitar "pedidos_screen.dart" seran los 
      //pedidos con el status de "En Proceso"
      //Y dichos pedidos se obtendran de una base de datos
        
      //Cada pedido debe ser representado por un boton
          //Al hacer clic en el boton del pedido se debera abrir el apartado "manage_detalles_pedido_screen.dart"


      bottomNavigationBar: CustomNavBar(
        currentIndex: 2,
        onTap: (index) {
          switch (index) {
            case 0: // Menu
              Navigator.pushReplacementNamed(context, '/menu');
              break;
            case 1: // Carrito
              Navigator.pushReplacementNamed(context, '/carrito');
              break;
            case 2: // Pedidos
              // Already on this screen
              break;
            case 3: // Admin
              Navigator.pushReplacementNamed(context, '/ajustes');
              break;
          }
        },
      ),
    );
  }
}
