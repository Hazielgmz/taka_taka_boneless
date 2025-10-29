import 'package:flutter/material.dart';
import 'package:taka_taka_boneless/widgets/navbar.dart';
import 'package:taka_taka_boneless/widgets/appbar.dart' as custom;

class AdministrationScreen extends StatelessWidget {
  const AdministrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          custom.AppBar(title: 'Administración'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              children: [
                // Dashboard Option
                _buildMenuItem(
                  context: context,
                  icon: Icons.dashboard,
                  title: 'Dashboard',
                  onTap: () {
                    Navigator.pushNamed(context, '/dashboard');
                  },
                ),
                const SizedBox(height: 16),

                // Products Option
                _buildMenuItem(
                  context: context,
                  icon: Icons.inventory_2,
                  title: 'Productos',
                  onTap: () {
                    Navigator.pushNamed(context, '/products');
                  },
                ),
                const SizedBox(height: 16),

                // Users Option
                _buildMenuItem(
                  context: context,
                  icon: Icons.people,
                  title: 'Usuarios',
                  onTap: () {
                    Navigator.pushNamed(context, '/users');
                  },
                ),
                const SizedBox(height: 16),

                // Categories Option
                _buildMenuItem(
                  context: context,
                  icon: Icons.category,
                  title: 'Categorías',
                  onTap: () {
                    Navigator.pushNamed(context, '/categories');
                  },
                ),
                const SizedBox(height: 16),

                // Sauces Option
                _buildMenuItem(
                  context: context,
                  icon: Icons.local_fire_department,
                  title: 'Salsas',
                  onTap: () {
                    Navigator.pushNamed(context, '/sauces');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: 3,
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

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    const primary = Color(0xFFe7292a);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 16,
              color: Colors.black.withValues(alpha: 0.08),
              offset: const Offset(0, 4),
            ),
          ],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 16, 8),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
                child: Text(
                  title,
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    height: 1.5,
                  ),
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
