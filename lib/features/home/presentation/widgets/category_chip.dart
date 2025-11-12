import 'package:flutter/material.dart';

/// Category chip widget for story categories
class CategoryChip extends StatelessWidget {
  final String label;
  final String iconAssetPath;
  final Color backgroundColor;

  const CategoryChip({
    super.key,
    required this.label,
    required this.iconAssetPath,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30.0,
            backgroundColor: backgroundColor,
            child: Image.asset(
              iconAssetPath,
              width: 32.0,
              height: 32.0,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.category,
                  color: Colors.white,
                  size: 32.0,
                );
              },
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            label,
            style: textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
