import 'package:flutter/material.dart';
import 'package:taka_taka_boneless/widgets/navbar.dart';
import 'package:taka_taka_boneless/widgets/appbar.dart' as custom;
import 'package:taka_taka_boneless/widgets/deleteproduct.dart';
import 'package:taka_taka_boneless/features/admin/screens/products/edit_screen.dart';

class ProductsIndexScreen extends StatefulWidget {
  const ProductsIndexScreen({super.key});

  @override
  State<ProductsIndexScreen> createState() => _ProductsIndexScreenState();
}

class _ProductsIndexScreenState extends State<ProductsIndexScreen> {
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();

  final List<String> _categories = ['Boneless', 'Promociones', 'Bebidas', 'Extras'];

  final List<Map<String, dynamic>> _products = [
    {
      'name': 'Boneless 10 piezas',
      'description': 'Orden de 10 boneless con papas',
      'price': 129.0,
      'category': 'Boneless',
      'hasSauces': true,
      'maxSauces': 2,
      'status': 'Activo',
    },
    {
      'name': 'Refresco 600ml',
      'description': 'Sabor a elegir',
      'price': 25.0,
      'category': 'Bebidas',
      'hasSauces': false,
      'maxSauces': 0,
      'status': 'Inactivo',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFFe7292a);
    final query = _searchController.text.trim().toLowerCase();
    final filtered = _products.where((p) => p['name'].toString().toLowerCase().contains(query)).toList();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            custom.AppBar(title: 'Productos'),

            // Search Field
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 0),
              child: TextFormField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  isDense: false,
                  hintText: 'Buscar producto',
                  hintStyle: const TextStyle(fontSize: 17, color: Colors.black38),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFF5F5F5), width: 2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: primary, width: 2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF5F5F5),
                  prefixIcon: const Icon(Icons.search, color: Colors.black38, size: 20),
                ),
                style: const TextStyle(fontSize: 17, color: Colors.black),
              ),
            ),

            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(20, 24, 20, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Todos los productos',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        ElevatedButton.icon(
                          onPressed: () async {
                            final messenger = ScaffoldMessenger.of(context);
                            final result = await Navigator.pushNamed(context, '/products/create');
                            if (!mounted) return;
                            if (result is Map<String, dynamic>) {
                              setState(() {
                                _products.add(result);
                              });
                              messenger.showSnackBar(const SnackBar(content: Text('Producto creado')));
                            }
                          },
                          icon: const Icon(Icons.add, size: 20),
                          label: const Text('Agregar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ],
                    ),
                  ),

                  ...filtered.map((p) => _buildProductCard(p)),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: CustomNavBar(
          currentIndex: 3,
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
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    const primary = Color(0xFFe7292a);
    final isActive = product['status'] == 'Activo';
    final price = (product['price'] as num).toDouble();

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(blurRadius: 16, color: Colors.black.withValues(alpha: 0.08), offset: const Offset(0, 4)),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product['name'],
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          product['description'],
                          style: const TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _chip(text: 'Precio: \$${price.toStringAsFixed(2)}'),
                            _chip(text: 'Categoría: ${product['category']}'),
                            _chip(text: 'Salsas: ${product['hasSauces'] ? 'Sí (máx ${product['maxSauces']})' : 'No'}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isActive ? primary.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      product['status'],
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isActive ? primary : Colors.grey),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    tooltip: 'Editar',
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () async {
                      final updated = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductEditScreen(product: product, categories: _categories),
                        ),
                      );
                      if (!mounted) return;
                      if (updated is Map<String, dynamic>) {
                        setState(() {
                          product
                            ..['name'] = updated['name']
                            ..['description'] = updated['description']
                            ..['price'] = updated['price']
                            ..['category'] = updated['category']
                            ..['hasSauces'] = updated['hasSauces']
                            ..['maxSauces'] = updated['maxSauces']
                            ..['status'] = updated['status'];
                        });
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Producto actualizado')));
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    tooltip: 'Eliminar',
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _showDeleteDialog(product);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chip({required String text}) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Text(text, style: const TextStyle(fontSize: 12, color: Colors.black87)),
      );

  void _showDeleteDialog(Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: DeleteProductWidget(
          productName: product['name'],
          onTapDelete: () {
            setState(() {
              _products.remove(product);
            });
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Producto eliminado')));
          },
        ),
      ),
    );
  }
}
