import 'package:flutter/material.dart';
import 'package:taka_taka_boneless/features/auth/screens/login_screen.dart';
import 'package:taka_taka_boneless/features/home/screens/menu_screen.dart';
import 'package:taka_taka_boneless/features/home/screens/carrito_screen.dart';
import 'package:taka_taka_boneless/features/home/screens/pedidos_screen.dart';
import 'package:taka_taka_boneless/features/admin/screens/settings_screen.dart';
import 'package:taka_taka_boneless/features/admin/screens/dashboard_screen.dart';
import 'package:taka_taka_boneless/features/admin/screens/administration.dart';

final Map<String, WidgetBuilder> routes = {
  '/': (context) => const LoginScreen(),
  '/menu': (context) => const MenuScreen(),
  '/carrito': (context) => const CarritoScreen(),
  '/pedidos': (context) => const PedidosScreen(),
  '/ajustes': (context) => const SettingsScreen(),
  '/dashboard': (context) => const DashboardScreen(),
  '/administration': (context) => const AdministrationScreen(),
};