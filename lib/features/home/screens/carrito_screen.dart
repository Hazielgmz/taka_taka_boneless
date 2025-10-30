import 'package:flutter/material.dart';
import 'package:taka_taka_boneless/widgets/navbar.dart';
import 'package:taka_taka_boneless/widgets/appbar.dart' as custom;
import 'package:taka_taka_boneless/core/features/cart_service.dart';
import 'detalles/manage_detalles_carrito_screen.dart';
import 'package:taka_taka_boneless/core/features/pedido_service.dart';

class CarritoScreen extends StatefulWidget {
  const CarritoScreen({super.key});

  @override
  State<CarritoScreen> createState() => _CarritoScreenState();
}

class _CarritoScreenState extends State<CarritoScreen> {
  void _refresh() => setState(() {});

  Future<void> _confirmRemove(int index) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: const Text('¿Deseas eliminar este producto del carrito?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(c, true), child: const Text('Eliminar', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (ok == true) {
      CartService.removeAt(index);
      _refresh();
    }
  }

  Future<void> _realizarPedido() async {
    final items = CartService.getItems();
    if (items.isEmpty) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Confirmar pedido'),
        content: Text('Se creará un pedido por un total de \$${CartService.totalAmount().toStringAsFixed(2)}. ¿Deseas continuar?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(c, true), child: const Text('Confirmar')),
        ],
      ),
    );
    if (confirmed == true) {
      // Create pedido and clear cart
      try {
        await PedidoService.createPedidoFromCart(items);
      } catch (_) {
        // ignore errors in mock
      }
      CartService.clear();
      // Navigate back to menu after creating order
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/menu');
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = CartService.getItems();
    return Scaffold(
      body: Column(
        children: [
          custom.AppBar(title: 'Carrito' , showBack: false),
          Expanded(
            child: items.isEmpty
                ? const Center(child: Text('El carrito está vacío'))
                : ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final it = items[index];
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => ManageDetallesCarritoScreen(item: it)),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(it.product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Text('Cantidad: ${it.quantity}'),
                              ],
                            ),
                            Row(
                              children: [
                                Text('\$${it.subtotal.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(width: 8),
                                IconButton(
                                  onPressed: () => _confirmRemove(index),
                                  icon: const Icon(Icons.remove_circle, color: Colors.red),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),

          // Bottom area: total and Realizar Pedido
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total: \$${CartService.totalAmount().toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ElevatedButton(
                  onPressed: items.isEmpty ? null : _realizarPedido,
                  style: ElevatedButton.styleFrom(backgroundColor: items.isEmpty ? Colors.grey : Colors.green),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                    child: Text('Realizar Pedido', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      //En este apartado se mostraran todas las ordenes que se han mandado al carrito de compras
      //Y dichas ordenes se representaran con un boton
          //Todas las ordenes tendran un boton rojo a la derecha con un signo de "-" para eliminar la orden del carrito
          //Al usar el boton de eliminar, debera aparecer un mensaje para confirmar la eliminacion de la orden o cancelar su eliminacion
      //Por otro lado, al hacer clic en la orden se debera abrir el apartado "manage_detalles_carrito_screen.dart"

      //Al final de esta pantalla debera haber un boton verde que diga "Realizar Pedido"
      //Este boton debera estar habilitado solo si hay al menos un producto en el carrito
      //Se debera mostrar un mensaje de confirmacion al usuario antes de proceder con el pedido
      //Se creara un pedido que incluya todos los productos en el carrito
      //Luego, se vaciara el carrito de compras
      //Al presionar este boton se debera redirigir al usuario a el apartado de "menu_screen.dart"

      bottomNavigationBar: CustomNavBar(
        currentIndex: 1,
        onTap: (index) {
          switch (index) {
            case 0: // Menu
              Navigator.pushReplacementNamed(context, '/menu');
              break;
            case 1: // Carrito
              // Already on this screen
              break;
            case 2: // Pedidos
              Navigator.pushReplacementNamed(context, '/pedidos');
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
