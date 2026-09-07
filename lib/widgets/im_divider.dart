import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// Divisor con texto centrado estilo "◆ SECCIÓN ◆"
class IMSectionDivider extends StatelessWidget {
  final String? texto;

  const IMSectionDivider({super.key, this.texto});

  @override
  Widget build(BuildContext context) {
    if (texto == null) {
      return const Divider(color: AppColors.divider, height: 32);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          const Expanded(child: Divider(color: AppColors.border)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              texto!.toUpperCase(),
              style: AppTextStyles.caption,
            ),
          ),
          const Expanded(child: Divider(color: AppColors.border)),
        ],
      ),
    );
  }
}
