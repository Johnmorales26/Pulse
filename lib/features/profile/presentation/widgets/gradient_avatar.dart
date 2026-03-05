import 'package:flutter/material.dart';

class GradientAvatar extends StatelessWidget {
  const GradientAvatar({
    super.key,
    this.size = 90,
    this.icon = Icons.person_outline,
    this.photoUrl,
    this.isUploading = false,
  });

  final double size;
  final IconData icon;
  final String? photoUrl;
  final bool isUploading;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFF8E2DE2), Color(0XFF4A00E0)],
        ),
      ),
      padding: const EdgeInsets.all(3.0),
      child: ClipOval(
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (isUploading) {
      return Container(
        color: const Color(0xFF1E2633),
        child: const Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    if (photoUrl != null) {
      return Image.network(
        photoUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _defaultIcon(),
      );
    }

    return _defaultIcon();
  }

  Widget _defaultIcon() {
    return Container(
      color: const Color(0xFF1E2633),
      child: Center(child: Icon(icon, size: 36, color: const Color(0XFF6C7A89))),
    );
  }
}