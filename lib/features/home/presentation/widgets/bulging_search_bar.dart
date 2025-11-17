import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Custom search bar with a bulging/convex shape in the middle
class BulgingSearchBar extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onVoiceSearch;
  final TextEditingController? controller;

  const BulgingSearchBar({
    super.key,
    this.hintText = 'Search for a story',
    this.onChanged,
    this.onVoiceSearch,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.0,
      decoration: ShapeDecoration(
        color: AppColors.surfaceVariant,
        shape: _BulgingShapeBorder(),
      ),
      child: Row(
        children: [
          const SizedBox(width: 20.0),
          const Icon(
            Icons.search,
            color: AppColors.textSecondary,
            size: 24.0,
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: const TextStyle(
                fontSize: 16.0,
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(
                  fontSize: 16.0,
                  color: AppColors.textLight,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          const SizedBox(width: 12.0),
          GestureDetector(
            onTap: onVoiceSearch,
            child: Container(
              width: 40.0,
              height: 40.0,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.mic,
                color: Colors.white,
                size: 20.0,
              ),
            ),
          ),
          const SizedBox(width: 12.0),
        ],
      ),
    );
  }
}

/// Custom shape border that creates a bulging effect in the middle
class _BulgingShapeBorder extends ShapeBorder {
  const _BulgingShapeBorder();

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return getOuterPath(rect, textDirection: textDirection);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final path = Path();

    // Calculate bulge factor (5% increase in the middle)
    final bulgeFactor = rect.height * 0.05;
    final width = rect.width;
    final height = rect.height;
    final top = rect.top;
    final left = rect.left;
    final bottom = rect.bottom;
    final right = rect.right;

    // Start from top-left corner
    path.moveTo(left + height / 2, top);

    // Top edge with bulge (convex curve upward)
    path.quadraticBezierTo(
      left + width / 2, // control point X (middle)
      top - bulgeFactor, // control point Y (bulge upward)
      right - height / 2, // end point X
      top, // end point Y
    );

    // Top-right corner
    path.arcToPoint(
      Offset(right, top + height / 2),
      radius: Radius.circular(height / 2),
      clockwise: true,
    );

    // Right edge
    path.lineTo(right, bottom - height / 2);

    // Bottom-right corner
    path.arcToPoint(
      Offset(right - height / 2, bottom),
      radius: Radius.circular(height / 2),
      clockwise: true,
    );

    // Bottom edge with bulge (convex curve downward)
    path.quadraticBezierTo(
      left + width / 2, // control point X (middle)
      bottom + bulgeFactor, // control point Y (bulge downward)
      left + height / 2, // end point X
      bottom, // end point Y
    );

    // Bottom-left corner
    path.arcToPoint(
      Offset(left, bottom - height / 2),
      radius: Radius.circular(height / 2),
      clockwise: true,
    );

    // Left edge
    path.lineTo(left, top + height / 2);

    // Top-left corner
    path.arcToPoint(
      Offset(left + height / 2, top),
      radius: Radius.circular(height / 2),
      clockwise: true,
    );

    path.close();
    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    // No painting needed
  }

  @override
  ShapeBorder scale(double t) => this;
}
