import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/weddly_colors.dart';

/// Auth screen common AppBar: weddly logo (top) + screen title (bottom)
class WeddlyAuthAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const WeddlyAuthAppBar({required this.title, super.key});

  @override
  Size get preferredSize => const Size.fromHeight(65 + 1); // toolbar 65 + divider 1

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 65,
      leading: IconButton(
        icon: const Icon(Icons.chevron_left, size: 26),
        onPressed: () => Navigator.pop(context),
      ),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'weddly',
            style: TextStyle(
              color: AppColors.primary,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w900,
              fontSize: 13,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(
              color: context.wTextPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ],
      ),
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: context.wBorderLight, height: 1),
      ),
    );
  }
}
