import 'package:flutter/material.dart';
import 'package:taka_taka_boneless/widgets/navbar.dart';
import 'package:taka_taka_boneless/widgets/appbar.dart' as custom;
import 'package:taka_taka_boneless/widgets/deletesauce.dart';
import 'package:taka_taka_boneless/features/admin/screens/sauce/edit.dart';

class SaucesIndexScreen extends StatefulWidget {
  const SaucesIndexScreen({super.key});

  @override
  State<SaucesIndexScreen> createState() => _SaucesIndexScreenState();
}

class _SaucesIndexScreenState extends State<SaucesIndexScreen> {
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();

  final List<Map<String, dynamic>> _sauces = [
    {'name': 'BBQ', 'status': 'Activo'},
    {'name': 'Búfalo', 'status': 'Activo'},
    {'name': 'Mango Habanero', 'status': 'Inactivo'},
    {'name': 'Ranch', 'status': 'Activo'},
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
    final filtered = _sauces.where((s) => s['name'].toString().toLowerCase().contains(query)).toList();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            custom.AppBar(title: 'Salsas'),

            // Search Field
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 0),
              child: TextFormField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  isDense: false,
                  hintText: 'Buscar salsa',
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
                          'Todas las salsas',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () async {
                            final messenger = ScaffoldMessenger.of(context);
                            final result = await Navigator.pushNamed(context, '/sauces/create');
                            if (!mounted) return;
                            if (result is Map<String, dynamic>) {
                              setState(() {
                                _sauces.add(result);
                              });
                              messenger.showSnackBar(
                                const SnackBar(content: Text('Salsa creada')),
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

                  ...filtered.map((s) => _buildSauceCard(s)),
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

  Widget _buildSauceCard(Map<String, dynamic> sauce) {
    const primary = Color(0xFFe7292a);
    final isActive = sauce['status'] == 'Activo';

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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  sauce['name'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isActive ? primary.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  sauce['status'],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isActive ? primary : Colors.grey,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                tooltip: 'Editar',
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () async {
                  final updated = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SauceEditScreen(sauce: sauce),
                    ),
                  );
                  if (!mounted) return;
                  if (updated is Map<String, dynamic>) {
                    setState(() {
                      sauce['name'] = updated['name'];
                      sauce['status'] = updated['status'];
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Salsa actualizada')),
                    );
                  }
                },
              ),
              const SizedBox(width: 4),
              IconButton(
                tooltip: 'Eliminar',
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  _showDeleteDialog(sauce);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(Map<String, dynamic> sauce) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: DeleteSauceWidget(
          sauceName: sauce['name'],
          onTapDelete: () {
            setState(() {
              _sauces.remove(sauce);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Salsa eliminada')),
            );
          },
        ),
      ),
    );
  }
}
