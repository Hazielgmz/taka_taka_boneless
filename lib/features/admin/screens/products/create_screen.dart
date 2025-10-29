import 'package:flutter/material.dart';
import 'package:taka_taka_boneless/widgets/appbar.dart' as custom;

class ProductCreateScreen extends StatefulWidget {
  const ProductCreateScreen({super.key});

  @override
  State<ProductCreateScreen> createState() => _ProductCreateScreenState();
}

class _ProductCreateScreenState extends State<ProductCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();

  // Catálogo de categorías local (coincide con Index)
  final List<String> _categories = ['Boneless', 'Promociones', 'Bebidas', 'Extras'];
  String? _selectedCategory;
  bool _hasSauces = false;
  int _maxSauces = 1;
  String _status = 'Activo';

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFFe7292a);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            custom.AppBar(title: 'Agregar producto', showBack: true),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Información del producto',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      const SizedBox(height: 24),

                      // Nombre
                      const Text('Nombre', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _nameController,
                        decoration: _inputDecoration(hintText: 'Ej: Boneless 10 piezas'),
                        style: const TextStyle(fontSize: 17, color: Colors.black),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Por favor ingresa el nombre' : null,
                      ),
                      const SizedBox(height: 16),

                      // Descripción
                      const Text('Descripción', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _descController,
                        maxLines: 3,
                        decoration: _inputDecoration(hintText: 'Ej: Orden con papas incluidas'),
                        style: const TextStyle(fontSize: 17, color: Colors.black),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Por favor ingresa la descripción' : null,
                      ),
                      const SizedBox(height: 16),

                      // Precio
                      const Text('Precio', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _priceController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: _inputDecoration(hintText: 'Ej: 129.00'),
                        style: const TextStyle(fontSize: 17, color: Colors.black),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Por favor ingresa el precio';
                          final val = double.tryParse(v.replaceAll(',', '.'));
                          if (val == null || val < 0) return 'Ingresa un precio válido';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Categoría
                      const Text('Categoría', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        items: _categories
                            .map((c) => DropdownMenuItem<String>(value: c, child: Text(c)))
                            .toList(),
                        onChanged: (v) => setState(() => _selectedCategory = v),
                        decoration: _inputDecoration(hintText: 'Selecciona una categoría'),
                        validator: (v) => v == null ? 'Selecciona una categoría' : null,
                      ),
                      const SizedBox(height: 16),

                      // Lleva salsas
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Lleva salsas', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
                          Switch.adaptive(
                            value: _hasSauces,
                            activeColor: primary,
                            onChanged: (v) => setState(() => _hasSauces = v),
                          ),
                        ],
                      ),
                      if (_hasSauces) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Text('Máximo de salsas:', style: TextStyle(fontSize: 14, color: Colors.black87)),
                            const SizedBox(width: 12),
                            _qtyButton(icon: Icons.remove, onTap: () => setState(() => _maxSauces = (_maxSauces > 1) ? _maxSauces - 1 : 1)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text('$_maxSauces', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                            ),
                            _qtyButton(icon: Icons.add, onTap: () => setState(() => _maxSauces++)),
                          ],
                        ),
                      ],
                      const SizedBox(height: 16),

                      // Estado
                      const Text('Estado', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _status,
                        items: const [
                          DropdownMenuItem(value: 'Activo', child: Text('Activo')),
                          DropdownMenuItem(value: 'Inactivo', child: Text('Inactivo')),
                        ],
                        onChanged: (v) => setState(() => _status = v ?? 'Activo'),
                        decoration: _inputDecoration(hintText: 'Selecciona el estado'),
                      ),
                      const SizedBox(height: 32),

                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: primary),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: const Text('Cancelar', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: primary)),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _onSave,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primary,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: const Text('Guardar', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) return;
    final price = double.parse(_priceController.text.replaceAll(',', '.'));
    final data = {
      'name': _nameController.text.trim(),
      'description': _descController.text.trim(),
      'price': price,
      'category': _selectedCategory,
      'hasSauces': _hasSauces,
      'maxSauces': _hasSauces ? _maxSauces : 0,
      'status': _status,
    };
    Navigator.pop(context, data);
  }

  InputDecoration _inputDecoration({required String hintText}) {
    const primary = Color(0xFFe7292a);
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 17, color: Colors.black38),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: primary, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  Widget _qtyButton({required IconData icon, required VoidCallback onTap}) {
    return SizedBox(
      width: 36,
      height: 36,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(padding: EdgeInsets.zero, side: BorderSide(color: Colors.grey.shade300), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
        child: Icon(icon, size: 18, color: Colors.black87),
      ),
    );
  }
}
