import 'package:flutter/material.dart';
import 'package:taka_taka_boneless/config/routes.dart';

void main() {
  runApp(const MainApp());
}

class NoAnimationPageRoute<T> extends MaterialPageRoute<T> {
  NoAnimationPageRoute({
    required super.builder,
    super.settings,
  });

  @override
  Duration get transitionDuration => Duration.zero;
  
  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taka Taka Boneless',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: routes,
      onGenerateRoute: (RouteSettings settings) {
        // Get the route generator function from our routes map
        WidgetBuilder? builder = routes[settings.name];
        // If we found a builder function, create a NoAnimationPageRoute
        if (builder != null) {
          return NoAnimationPageRoute(
            builder: builder,
            settings: settings,
          );
        }
        return null;
      },
    );
  }
}
