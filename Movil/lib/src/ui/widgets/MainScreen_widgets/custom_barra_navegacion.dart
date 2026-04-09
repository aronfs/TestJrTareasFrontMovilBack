import 'package:flutter/material.dart';
import 'package:sistema_ventas_app_v1/src/models/menu_model.dart';
import 'package:sistema_ventas_app_v1/src/theme/app_theme.dart';
import 'package:sistema_ventas_app_v1/src/ui/widgets/MainScreen_widgets/menu_widgets.dart';

class CustomBarraNavegacion extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final List<MenuModel> menus;

  const CustomBarraNavegacion({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.menus,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: AppTheme.ink,
          borderRadius: BorderRadius.circular(28),
          boxShadow: const [
            BoxShadow(
              color: Color(0x2212323B),
              blurRadius: 24,
              offset: Offset(0, 12),
            ),
          ],
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(menus.length, (index) {
              final menu = menus[index];
              final isSelected = selectedIndex == index;
              final iconData = iconMap[menu.icono] ?? Icons.help_outline;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: InkWell(
                  borderRadius: BorderRadius.circular(22),
                  onTap: () => onItemTapped(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutCubic,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0x26FFFFFF)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          iconData,
                          size: 22,
                          color: isSelected
                              ? AppTheme.paper
                              : AppTheme.paper.withOpacity(0.72),
                        ),
                        if (isSelected) ...[
                          const SizedBox(width: 8),
                          Text(
                            menu.nombre,
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(color: AppTheme.paper),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
