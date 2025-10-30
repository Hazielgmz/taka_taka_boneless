
          
import 'package:flutter/material.dart';
import 'package:taka_taka_boneless/widgets/navbar.dart';
import 'package:taka_taka_boneless/widgets/appbar.dart' as custom;
import 'package:taka_taka_boneless/core/models/product.dart';
import 'package:taka_taka_boneless/core/models/extra.dart';
import 'package:taka_taka_boneless/core/features/extra_service.dart';
import 'package:taka_taka_boneless/core/features/cart_service.dart';
import 'package:taka_taka_boneless/core/models/cart_item.dart';

// Product details with quantity, optional extras and add-to-cart
class ManageDetallesMenuScreen extends StatefulWidget {
  final Product? product;

  const ManageDetallesMenuScreen({super.key, this.product});

  @override
  State<ManageDetallesMenuScreen> createState() => _ManageDetallesMenuScreenState();
}

class _ManageDetallesMenuScreenState extends State<ManageDetallesMenuScreen> {
  int _quantity = 1;
  final TextEditingController _qtyController = TextEditingController(text: '1');
  List<Extra> _availableExtras = [];
  final Map<String, int> _selectedExtrasQty = {}; // extraId -> qty
  final Map<String, TextEditingController> _extraControllers = {};
  final Map<String, Extra> _availableExtrasById = {};
  bool _loadingExtras = false;

  @override
  void initState() {
    super.initState();
    _qtyController.addListener(() {
      final v = int.tryParse(_qtyController.text) ?? 1;
      if (v < 1) {
        _qtyController.text = '1';
      } else {
        setState(() => _quantity = v);
      }
    });
    _loadExtrasIfNeeded();
  }

  @override
  void dispose() {
    _qtyController.dispose();
    for (final c in _extraControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _loadExtrasIfNeeded() async {
    final product = widget.product;
    if (product == null) return;
    final cat = product.category;
    // Show extras for all categories except Bebidas and Extras
    if (cat != 'Bebidas' && cat != 'Extras') {
      // When offering extras for other categories, use the extras defined
      // in the canonical 'Extras' category so the same extras are offered
      // everywhere (per project requirement).
      setState(() => _loadingExtras = true);
      final list = await ExtraService.fetchExtrasForCategory('Extras');
      setState(() {
        _availableExtras = list;
        _availableExtrasById.clear();
        for (final e in list) {
          _availableExtrasById[e.id] = e;
        }
        _loadingExtras = false;
      });
    }
  }

  void _changeQty(int delta) {
    final newQty = (_quantity + delta).clamp(1, 999);
    setState(() {
      _quantity = newQty;
      _qtyController.text = newQty.toString();
    });
  }

  void _toggleExtra(String extraId, bool selected) {
    setState(() {
      if (selected) {
        _selectedExtrasQty[extraId] = 1;
        // create controller for this extra so user can type quantity
        final ctrl = TextEditingController(text: '1');
        ctrl.addListener(() {
          final v = int.tryParse(ctrl.text) ?? 1;
          setState(() => _selectedExtrasQty[extraId] = v < 1 ? 1 : v);
        });
        _extraControllers[extraId] = ctrl;
      } else {
        _selectedExtrasQty.remove(extraId);
        // dispose and remove controller
        final c = _extraControllers.remove(extraId);
        c?.dispose();
      }
    });
  }

  void _changeExtraQty(String extraId, int delta) {
    final cur = _selectedExtrasQty[extraId] ?? 1;
    final next = (cur + delta).clamp(1, 99);
    setState(() {
      _selectedExtrasQty[extraId] = next;
      final ctrl = _extraControllers[extraId];
      if (ctrl != null) ctrl.text = next.toString();
    });
  }

  void _addToCart() {
    final product = widget.product;
    if (product == null) return;
    final extras = _selectedExtrasQty.entries.map((e) => CartExtra(extra: _availableExtrasById[e.key]!, quantity: e.value)).toList();
    final item = CartItem(product: product, quantity: _quantity, extras: extras);
    CartService.addToCart(item);
    // Navigate back to menu (consistent with other screens)
    Navigator.pushReplacementNamed(context, '/menu');
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    return Scaffold(
      body: Column(
        children: [
          custom.AppBar(title: 'Detalles del Producto', showBack: true),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: product == null
                  ? const Center(child: Text('Pantalla de Detalles del Producto'))
                  : ListView(
                      children: [
                        Text(product.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text('Número: ${product.number}'),
                        const SizedBox(height: 8),
                        Text('Precio: \$${product.price.toStringAsFixed(2)}'),
                        const SizedBox(height: 16),

                        // Quantity selector
                        const Text('Cantidad', style: TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            IconButton(onPressed: () => _changeQty(-1), icon: const Icon(Icons.remove_circle_outline)),
                            Expanded(
                              child: TextField(
                                controller: _qtyController,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(border: OutlineInputBorder()),
                              ),
                            ),
                            IconButton(onPressed: () => _changeQty(1), icon: const Icon(Icons.add_circle_outline)),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Extras (only for Bebidas or Extras categories)
                        if (_loadingExtras) const Center(child: CircularProgressIndicator()),
                        if (!_loadingExtras && _availableExtras.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          const Text('Extras disponibles', style: TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          ..._availableExtras.map((ex) {
                            final selected = _selectedExtrasQty.containsKey(ex.id);
                            
                            return Column(
                              children: [
                                CheckboxListTile(
                                  value: selected,
                                  title: Text('${ex.name} (\$${ex.price.toStringAsFixed(2)})'),
                                  onChanged: (v) => _toggleExtra(ex.id, v ?? false),
                                ),
                                if (selected)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('Cantidad extra:'),
                                        Row(
                                          children: [
                                            IconButton(onPressed: () => _changeExtraQty(ex.id, -1), icon: const Icon(Icons.remove)),
                                            SizedBox(
                                              width: 64,
                                              child: TextField(
                                                controller: _extraControllers[ex.id],
                                                keyboardType: TextInputType.number,
                                                textAlign: TextAlign.center,
                                                decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true, contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8)),
                                              ),
                                            ),
                                            IconButton(onPressed: () => _changeExtraQty(ex.id, 1), icon: const Icon(Icons.add)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                const Divider(),
                              ],
                            );
                          }),
                        ],

                        const SizedBox(height: 24),
                        // Add to cart button
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red, padding: const EdgeInsets.symmetric(vertical: 14)),
                          onPressed: _addToCart,
                          child: const Text('Agregar al Carrito', style: TextStyle(fontSize: 16, color: Colors.white)),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),


      //Debera existir un boton para regresar a la pantalla anterior (manage_detalles_categoria_screen.dart)

      //Se mostrara la informacion de los detalles del producto seleccionado
          //Esta informacion se obtendra de una base de datos
          // Product product = await Database.getProductDetails();

          //Deberan de existir dos botones uno a la izquierda "-" y otro a la derecha "+"
          //Estos botones serviran para disminuir o aumentar la cantidad del producto a agregar al carrito
          //Y la cantidad se mostrara en el centro entre ambos botones
          //Ademas tambien se podra escribir la cantidad directamente en un campo de texto
          //Este area debera inicializarse en 1 y se llamara "Cantidad"

      //Si el producto seleccionado no forma parte de la categoria Bebidas o Extras, entonces no se mostrara un apartado para agregar extras
      //En caso contrario, se mostrara un apartado con una lista de extras disponibles para agregar al producto seleccionado
      //Una vez seleccionado los extras quiero que agreges otro area de "Cantidad" para cada extra seleccionado

      //Al final de esta pantalla debera haber un boton rojo que diga "Agregar al Carrito"
      //Al presionar este boton se debera agregar el producto seleccionado con la cantidad, extras y bebidas al carrito de compras
      //Y se redirijira al usuario a el apartado de "menu_screen.dart"

      
      

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