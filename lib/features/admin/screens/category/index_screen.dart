import 'package:flutter/material.dart';
import 'package:taka_taka_boneless/widgets/navbar.dart';
import 'package:taka_taka_boneless/widgets/appbar.dart' as custom;
import 'package:taka_taka_boneless/features/admin/screens/category/edit_screen.dart';

class CategoriesIndexScreen extends StatefulWidget {
  const CategoriesIndexScreen({super.key});

  @override
  State<CategoriesIndexScreen> createState() => _CategoriesIndexScreenState();
}

class _CategoriesIndexScreenState extends State<CategoriesIndexScreen> {
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Boneless'},
    {'name': 'Promociones'},
    {'name': 'Bebidas'},
    {'name': 'Extras'},
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
    final filtered = _categories.where((c) => c['name'].toString().toLowerCase().contains(query)).toList();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            custom.AppBar(title: 'Categorías'),

            // Search Field
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 0),
              child: TextFormField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  isDense: false,
                  hintText: 'Buscar categoría',
                  hintStyle: const TextStyle(
                    fontSize: 17,
                    color: Colors.black38,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFFF5F5F5),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: primary,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF5F5F5),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.black38,
                    size: 20,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 17,
                  color: Colors.black,
                ),
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
                          'Todas las categorías',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () async {
                            final messenger = ScaffoldMessenger.of(context);
                            final result = await Navigator.pushNamed(context, '/categories/create');
                            if (!mounted) return;
                            if (result is Map<String, dynamic>) {
                              setState(() {
                                _categories.add(result);
                              });
                              messenger.showSnackBar(
                                const SnackBar(content: Text('Categoría creada')),
                              );
                            }
                          },
                          icon: const Icon(Icons.add, size: 20),
                          label: const Text('Agregar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  ...filtered.map((c) => _buildCategoryCard(c)),
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

  Widget _buildCategoryCard(Map<String, dynamic> category) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              blurRadius: 16,
              color: Colors.black.withValues(alpha: 0.08),
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ListTile(
          title: Text(
            category['name'],
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                tooltip: 'Editar',
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () async {
                  final updated = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CategoryEditScreen(category: category),
                    ),
                  );
                  if (!mounted) return;
                  if (updated is Map<String, dynamic>) {
                    setState(() {
                      category['name'] = updated['name'];
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Categoría actualizada')),
                    );
                  }
                },
              ),
              const SizedBox(width: 4),
              IconButton(
                tooltip: 'Eliminar',
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Eliminar categoría'),
                      content: Text('¿Seguro que deseas eliminar "${category['name']}"?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                  if (!mounted) return;
                  if (confirm == true) {
                    setState(() {
                      _categories.remove(category);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Categoría eliminada')),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
