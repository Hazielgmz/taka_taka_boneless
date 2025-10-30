import 'package:flutter/material.dart';
import 'package:taka_taka_boneless/widgets/navbar.dart';
import 'package:taka_taka_boneless/widgets/appbar.dart' as custom;
import 'package:taka_taka_boneless/core/models/product.dart';
import 'package:taka_taka_boneless/core/features/product_service.dart';
import 'manage_detalles_menu_screen.dart';

class ManageDetallesCategoriaScreen extends StatelessWidget {
  final String category;

  const ManageDetallesCategoriaScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          custom.AppBar(title: category, showBack: true),
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: ProductService.fetchProductsByCategory(category),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                final products = snapshot.data ?? [];
                if (products.isEmpty) {
                  return Center(child: Text('No hay productos en la categoría "$category"'));
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(12.0),
                  itemCount: products.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final prod = products[index];
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        elevation: 2,
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ManageDetallesMenuScreen(product: prod)),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${prod.number}. ${prod.name}', style: const TextStyle(fontWeight: FontWeight.w600)),
                          Text('\$${prod.price.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
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


      
      //Se mostrara una lista de productos disponibles segun la categoria seleccionada
      //Estos productos se obtendran de una base de datos
      // List<Product> products = await Database.getProducts();

      //Cada producto debe ser representado por un boton
      //Dicho boton debe contener el numero, el nombre y el precio del producto

      //Una vez seleccionado el producto, se debera abrir el apartado "manage_detalles_menu_screen.dart"



      bottomNavigationBar: CustomNavBar(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0: // Menu
              Navigator.pushReplacementNamed(context, '/menu');
              break;
            case 1: // Carrito
              Navigator.pushReplacementNamed(context, '/carrito');
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

