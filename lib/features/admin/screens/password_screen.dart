import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taka_taka_boneless/widgets/appbar.dart' as custom;

class PasswordScreen extends StatefulWidget {
  const PasswordScreen({
    super.key,
    this.requiredRoles = const ['Gerente'],
    this.title = 'Verificar clave',
    this.subtitle = 'Solo Gerentes pueden acceder',
    this.nextRoute = '/administration',
  });

  final List<String> requiredRoles;
  final String title;
  final String subtitle;
  final String nextRoute;

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _employeeController = TextEditingController();
  final _passwordController = TextEditingController();

  // Lista de usuarios del sistema
  final List<Map<String, dynamic>> _users = [
    {
      'employeeNumber': '0001',
      'password': '1234',
      'role': 'Gerente',
    },
    {
      'employeeNumber': '0002',
      'password': '5678',
      'role': 'Encargado',
    },
  ];

  @override
  void dispose() {
    _employeeController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          custom.AppBar(title: widget.title, showBack: true),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              children: [
                Text(
                  widget.subtitle,
                  style: const TextStyle(
                    fontSize: 17,
                    color: Colors.black,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _employeeController,
                        keyboardType: TextInputType.number,
                        maxLength: 4,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4),
                        ],
                        decoration: InputDecoration(
                          labelText: 'Número de empleado',
                          hintText: 'Ej: 0001',
                          counterText: '',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Color(0xFFe7292a), width: 2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        style: const TextStyle(fontSize: 17, color: Colors.black),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingresa el número de empleado';
                          }
                          if (value.length != 4) {
                            return 'Debe tener 4 dígitos';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        maxLength: 4,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4),
                        ],
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          hintText: '4 dígitos',
                          counterText: '',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Color(0xFFe7292a), width: 2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        style: const TextStyle(fontSize: 17, color: Colors.black),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingresa la contraseña';
                          }
                          if (value.length != 4) {
                            return 'Debe tener 4 dígitos';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _continue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFe7292a),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text(
                      'Continuar',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _continue() {
    if (_formKey.currentState?.validate() ?? false) {
      final employeeNumber = _employeeController.text;
      final password = _passwordController.text;

      // Validar credenciales
      final user = _users.firstWhere(
        (u) => u['employeeNumber'] == employeeNumber && u['password'] == password,
        orElse: () => {},
      );

      if (user.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Credenciales incorrectas'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Validar rol
      if (!widget.requiredRoles.contains(user['role'])) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No tienes permisos para acceder'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Acceso concedido
      Navigator.pushReplacementNamed(context, widget.nextRoute);
    }
  }
}
