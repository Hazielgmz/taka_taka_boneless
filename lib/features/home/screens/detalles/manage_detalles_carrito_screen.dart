import 'package:flutter/material.dart';
import 'package:taka_taka_boneless/widgets/appbar.dart' as custom;
import 'package:taka_taka_boneless/core/models/cart_item.dart';
import 'package:taka_taka_boneless/core/features/extra_service.dart';
import 'package:taka_taka_boneless/core/models/extra.dart';
import 'package:taka_taka_boneless/core/features/cart_service.dart';

class ManageDetallesCarritoScreen extends StatefulWidget {
  final CartItem item;

  const ManageDetallesCarritoScreen({super.key, required this.item});

  @override
  State<ManageDetallesCarritoScreen> createState() => _ManageDetallesCarritoScreenState();
}

class _ManageDetallesCarritoScreenState extends State<ManageDetallesCarritoScreen> {
  late int _quantity;
  late TextEditingController _qtyController;
  List<Extra> _availableExtras = [];
  final Map<String, int> _selectedExtrasQty = {}; // extraId -> qty
  final Map<String, TextEditingController> _extraControllers = {};
  final Map<String, Extra> _availableExtrasById = {};
  bool _loadingExtras = false;

  @override
  void initState() {
    super.initState();
    _quantity = widget.item.quantity;
    _qtyController = TextEditingController(text: '$_quantity');

    // initialize selected extras from the CartItem
    for (final ce in widget.item.extras) {
      _selectedExtrasQty[ce.extra.id] = ce.quantity;
      // create controller for each selected extra so its quantity can be edited
      final ctrl = TextEditingController(text: '${ce.quantity}');
      ctrl.addListener(() {
        final v = int.tryParse(ctrl.text) ?? 1;
        setState(() => _selectedExtrasQty[ce.extra.id] = v < 1 ? 1 : v);
      });
      _extraControllers[ce.extra.id] = ctrl;
    }

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
    final product = widget.item.product;
    final cat = product.category;
    // Show extras for all categories except Bebidas and Extras, and use
    // the canonical 'Extras' category as the source so extras are consistent.
    if (cat != 'Bebidas' && cat != 'Extras') {
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
        _selectedExtrasQty[extraId] = _selectedExtrasQty[extraId] ?? 1;
        // ensure controller exists when extra is selected
        _extraControllers.putIfAbsent(extraId, () => TextEditingController(text: '${_selectedExtrasQty[extraId]}')..addListener(() {
          final v = int.tryParse(_extraControllers[extraId]!.text) ?? 1;
          setState(() => _selectedExtrasQty[extraId] = v < 1 ? 1 : v);
        }));
      } else {
        _selectedExtrasQty.remove(extraId);
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

  void _updateCart() {
    final product = widget.item.product;
    final extras = _selectedExtrasQty.entries
        .map((e) => CartExtra(extra: _availableExtrasById[e.key] ?? Extra(id: e.key, name: 'Extra', price: 0.0), quantity: e.value))
        .toList();
    final newItem = CartItem(product: product, quantity: _quantity, extras: extras);
    CartService.updateItem(widget.item, newItem);
    // Navigate back to carrito screen
    Navigator.pushReplacementNamed(context, '/carrito');
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return Scaffold(
      body: Column(
        children: [
          custom.AppBar(title: 'Detalle del Carrito', showBack: true),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Text(item.product.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Número: ${item.product.number}'),
                  const SizedBox(height: 8),
                  Text('Precio unitario: \$${item.product.price.toStringAsFixed(2)}'),
                  const SizedBox(height: 16),

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

                  const SizedBox(height: 12),
                  Text('Subtotal: \$${(item.product.price * _quantity + _selectedExtrasQty.entries.fold<double>(0.0, (s, e) { final ex = _availableExtrasById[e.key]; return s + (ex?.price ?? 0.0) * e.value; })).toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),

                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red, padding: const EdgeInsets.symmetric(vertical: 14)),
                    onPressed: _updateCart,
                    child: const Text('Actualizar Carrito', style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
//En este apartado se mostrara la informacion detallada del producto seleccionado y se permitira su edicion antes de agregarlo al carrito
      //Debera existir un boton para regresar a la pantalla anterior (carrito_screen.dart)

      //Se mostrara la informacion de los detalles del producto seleccionado
          //Esta informacion se obtendra de una base de datos
          // Product product = await Database.getCartItemDetails();

          //Deberan de existir dos botones uno a la izquierda "-" y otro a la derecha "+"
          //Estos botones serviran para disminuir o aumentar la cantidad del producto en el carrito
          //Y la cantidad se mostrara en el centro entre ambos botones
          //Ademas tambien se podra escribir la cantidad directamente en un campo de texto
          //Este area debera inicializarse en la cantidad actual del carrito y se llamara "Cantidad"

      //Si el producto seleccionado no forma parte de la categoria Bebidas o Extras, entonces no se mostrara un apartado para agregar extras
      //En caso contrario, se mostrara un apartado con una lista de extras disponibles para agregar al producto seleccionado
      //Una vez seleccionado los extras quiero que agreges otro area de "Cantidad" para cada extra seleccionado

      //Al final de esta pantalla debera haber un boton rojo que diga "Actualizar Carrito"
      //Al presionar este boton se debera actualizar el producto seleccionado con la nueva cantidad, extras y bebidas en el carrito de compras
      //Y se redirijira al usuario a el apartado de "carrito_screen.dart"