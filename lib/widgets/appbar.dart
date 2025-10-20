import 'package:flutter/material.dart';

class AppBar extends StatelessWidget {
  final String title;
  final bool showBack;
  final VoidCallback? onBack;

  const AppBar({
    super.key,
    required this.title,
    this.showBack = true,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsetsDirectional.fromSTEB(20, 19, 0, 16),
      child: Row(
        children: [
          if (showBack)
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFFe7292a), size: 28),
              onPressed: onBack ?? () => Navigator.of(context).maybePop(),
              splashRadius: 24,
            ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
