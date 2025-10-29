import 'package:flutter/material.dart';
import 'package:taka_taka_boneless/features/auth/screens/login_screen.dart';
import 'package:taka_taka_boneless/features/home/screens/menu_screen.dart';
import 'package:taka_taka_boneless/features/home/screens/carrito_screen.dart';
import 'package:taka_taka_boneless/features/home/screens/pedidos_screen.dart';
import 'package:taka_taka_boneless/features/admin/screens/settings_screen.dart';
import 'package:taka_taka_boneless/features/admin/screens/dashboard_screen.dart';
import 'package:taka_taka_boneless/features/admin/screens/administration.dart';
import 'package:taka_taka_boneless/features/admin/screens/password_screen.dart';
import 'package:taka_taka_boneless/features/admin/screens/cash_register_screen.dart';
import 'package:taka_taka_boneless/features/admin/screens/products/index_screen.dart';
import 'package:taka_taka_boneless/features/admin/screens/products/create_screen.dart';
import 'package:taka_taka_boneless/features/admin/screens/users/index_screen.dart';
import 'package:taka_taka_boneless/features/admin/screens/users/create_screen.dart';
import 'package:taka_taka_boneless/features/admin/screens/category/index_screen.dart';
import 'package:taka_taka_boneless/features/admin/screens/category/create_screen.dart';
import 'package:taka_taka_boneless/features/admin/screens/sauce/index.dart';
import 'package:taka_taka_boneless/features/admin/screens/sauce/create.dart';

final Map<String, WidgetBuilder> routes = {
  '/': (context) => const LoginScreen(),
  '/menu': (context) => const MenuScreen(),
  '/carrito': (context) => const CarritoScreen(),
  '/pedidos': (context) => const PedidosScreen(),
  '/ajustes': (context) => const SettingsScreen(),
  '/dashboard': (context) => const DashboardScreen(),
  '/password': (context) => const PasswordScreen(
        requiredRoles: ['Gerente'],
        title: 'Verificar acceso',
        subtitle: 'Solo Gerentes pueden acceder a Administración',
        nextRoute: '/administration',
      ),
  '/administration': (context) => const AdministrationScreen(),
  '/cash-register-password': (context) => const PasswordScreen(
        requiredRoles: ['Gerente', 'Encargado'],
        title: 'Verificar acceso a Caja',
        subtitle: 'Solo Gerentes y Encargados pueden acceder',
        nextRoute: '/cash-register',
      ),
  '/cash-register': (context) => const CashRegisterScreen(),
  '/products': (context) => const ProductsIndexScreen(),
  '/products/create': (context) => const ProductCreateScreen(),
  '/users': (context) => const UsersIndexScreen(),
  '/users/create': (context) => const UserCreateScreen(),
  '/categories': (context) => const CategoriesIndexScreen(),
  '/categories/create': (context) => const CategoryCreateScreen(),
  '/sauces': (context) => const SaucesIndexScreen(),
  '/sauces/create': (context) => const SauceCreateScreen(),
};