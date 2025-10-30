import 'package:flutter/material.dart';
import 'package:taka_taka_boneless/widgets/navbar.dart';
import 'package:taka_taka_boneless/widgets/appbar.dart' as custom;
import 'detalles/manage_detalles_categoria_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          custom.AppBar(title: 'Menú', showBack: false),
          // Top area: large 2x2 squares for the 4 primary categories
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  // Use flex so the top grid gets more space (flex 3) on short screens
                  Expanded(
                    flex: 3,
                    child: GridView.count(
                      crossAxisCount: 2,
                      // increased spacing so buttons don't overlap on very small screens
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      // slightly reduce vertical size so squares don't push into the bottom button
                      childAspectRatio: 0.95,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                      children: [
                        // Explicit top 4 categories in desired order
                        'Promociones',
                        'Boneless',
                        'Bebidas',
                        'Extras',
                      ].map((cat) {
                        // color per category
                        final Color bgColor;
                        switch (cat) {
                          case 'Promociones':
                            bgColor = const Color(0xFFF6A623); // orange
                            break;
                          case 'Boneless':
                            bgColor = const Color(0xFFDD6B20); // deep orange
                            break;
                          case 'Bebidas':
                            bgColor = const Color(0xFF3498DB); // blue
                            break;
                          case 'Extras':
                          default:
                            bgColor = const Color(0xFF2ECC71); // green
                            break;
                        }
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: bgColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: EdgeInsets.zero,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ManageDetallesCategoriaScreen(category: cat),
                              ),
                            );
                          },
                          child: Center(child: Text(cat, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700), textAlign: TextAlign.center)),
                        );
                      }).toList(),
                    ),
                  ),
                  // more gap to ensure the bottom button doesn't overlap
                  const SizedBox(height: 24),
                  // Bottom wide rectangle: Acompañamientos
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8E44AD), // purple
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ManageDetallesCategoriaScreen(category: 'Acompañamientos'),
                          ),
                        );
                      },
                      child: const Center(child: Text('Acompañamientos', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),


      //Al entrar al menu se debera mostrar los botones de las diferentes categorias
      //Estas categorias seran: Promociones, Boneless, Acompañamientos, Bebidas, Extras

      //Una vez seleccionada la categoria, se debera abrir el apartado "manage_detalles_categoria_screen.dart"

      bottomNavigationBar: CustomNavBar(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0: // Menu
              // Already on this screen
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
