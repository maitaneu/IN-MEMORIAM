import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/theme.dart';

/// Avatar circular con fallback a iniciales.
class IMAvatarWidget extends StatelessWidget {
  final String? imageUrl;
  final String nombre;
  final double size;
  final Color? backgroundColor;

  const IMAvatarWidget({
    super.key,
    this.imageUrl,
    required this.nombre,
    this.size = AppSpacing.avatarMd,
    this.backgroundColor,
  });

  String get _initials {
    final partes = nombre.trim().split(' ');
    if (partes.length >= 2) {
      return '${partes[0][0]}${partes[1][0]}'.toUpperCase();
    }
    return nombre.isNotEmpty ? nombre[0].toUpperCase() : '?';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor ?? AppColors.goldLight,
      ),
      clipBehavior: Clip.hardEdge,
      child: imageUrl != null && imageUrl!.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: imageUrl!,
              fit: BoxFit.cover,
              placeholder: (_, __) => _Initials(initials: _initials, size: size),
              errorWidget: (_, __, ___) => _Initials(initials: _initials, size: size),
            )
          : _Initials(initials: _initials, size: size),
    );
  }
}

class _Initials extends StatelessWidget {
  final String initials;
  final double size;

  const _Initials({required this.initials, required this.size});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        initials,
        style: AppTextStyles.labelMedium.copyWith(
          fontSize: size * 0.38,
          color: AppColors.goldDark,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
