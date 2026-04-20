import 'package:flutter/material.dart';
import '../theme/weddly_colors.dart';

class WeddlyFooter extends StatelessWidget {
  const WeddlyFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Text(
          '(C) 2025 Weddly. All rights reserved.',
          style: TextStyle(fontSize: 11, color: context.wTextHint),
        ),
      ),
    );
  }
}
