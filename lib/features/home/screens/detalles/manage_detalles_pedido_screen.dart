import 'package:flutter/material.dart';
import 'package:taka_taka_boneless/widgets/navbar.dart';
import 'package:taka_taka_boneless/widgets/appbar.dart' as custom;
import 'package:taka_taka_boneless/core/models/pedido.dart';
import 'package:taka_taka_boneless/core/features/pedido_service.dart';

class ManageDetallesPedidoScreen extends StatefulWidget {
  final Pedido? pedido;

  const ManageDetallesPedidoScreen({super.key, this.pedido});

  @override
  State<ManageDetallesPedidoScreen> createState() => _ManageDetallesPedidoScreenState();
}

class _ManageDetallesPedidoScreenState extends State<ManageDetallesPedidoScreen> {
  Pedido? _pedido;
  bool _processing = false;

  @override
  void initState() {
    super.initState();
    _pedido = widget.pedido;
  }

  Future<void> _updateStatus(String newStatus) async {
    if (_pedido == null) return;
  setState(() => _processing = true);
  final ok = await PedidoService.updatePedidoStatus(_pedido!.id, newStatus);
  if (!mounted) return;
  setState(() => _processing = false);
  if (ok) {
      // Update local model to reflect change
      setState(() => _pedido = Pedido(id: _pedido!.id, customer: _pedido!.customer, status: newStatus, total: _pedido!.total, createdAt: _pedido!.createdAt));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Pedido ${_pedido!.id} actualizado a "$newStatus"')));
      // Navigate back to pedidos list to reflect change
      Navigator.pushReplacementNamed(context, '/pedidos');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No se pudo actualizar el pedido')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          custom.AppBar(title: 'Detalles del Pedido', showBack: true),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _pedido == null
                  ? const Center(child: Text('No se encontró información del pedido'))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Pedido: ${_pedido!.id}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text('Cliente: ${_pedido!.customer}'),
                        const SizedBox(height: 8),
                        Text('Estado: ${_pedido!.status}'),
                        const SizedBox(height: 8),
                        Text('Total: \$${_pedido!.total.toStringAsFixed(2)}'),
                        const SizedBox(height: 8),
                        Text('Fecha: ${_pedido!.createdAt}'),
                        const SizedBox(height: 16),
                        // Placeholder for more details
                        const Text('Aquí se mostrará la información completa del pedido (productos, cantidades, dirección, etc.)'),
                        const SizedBox(height: 20),
                        // Action buttons: Confirm (green) and Cancel (red)
                        // Use LayoutBuilder to make each button square (height == half available width minus spacing)
                        LayoutBuilder(builder: (context, constraints) {
                          final available = constraints.maxWidth;
                          // spacing between buttons
                          const spacing = 12.0;
                          final side = (available - spacing) / 2;
                          return Row(
                            children: [
                              SizedBox(
                                width: side,
                                height: side,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  onPressed: _processing ? null : () => _updateStatus('Completados'),
                                  child: _processing
                                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                      : const Text('Confirmar\nCompletado', textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                                ),
                              ),
                              const SizedBox(width: spacing),
                              SizedBox(
                                width: side,
                                height: side,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  onPressed: _processing ? null : () => _updateStatus('Cancelados'),
                                  child: _processing
                                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                      : const Text('Cancelar\nPedido', textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                                ),
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: 2,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/menu');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/carrito');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/pedidos');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/ajustes');
              break;
          }
        },
      ),
    );
  }
}
