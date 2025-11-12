import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

/// Accessibility utilities and helpers
class AccessibilityUtils {
  AccessibilityUtils._();

  /// Check if screen reader is enabled
  static bool isScreenReaderEnabled(BuildContext context) {
    return MediaQuery.of(context).accessibleNavigation;
  }

  /// Announce to screen reader
  static void announce(BuildContext context, String message) {
    if (isScreenReaderEnabled(context)) {
      SemanticsService.announce(message, TextDirection.ltr);
    }
  }

  /// Create semantic label for story card
  static String storyCardLabel({
    required String title,
    required String author,
    int? pageCount,
    bool? isFavorite,
  }) {
    final buffer = StringBuffer('Story: $title. By $author.');
    if (pageCount != null) {
      buffer.write(' $pageCount pages.');
    }
    if (isFavorite == true) {
      buffer.write(' Marked as favorite.');
    }
    return buffer.toString();
  }

  /// Create semantic label for kid profile
  static String kidProfileLabel({
    required String name,
    required int age,
    String? interests,
  }) {
    final buffer = StringBuffer('Child profile: $name, age $age.');
    if (interests != null && interests.isNotEmpty) {
      buffer.write(' Interests: $interests.');
    }
    return buffer.toString();
  }

  /// Create semantic label for button with count
  static String buttonWithCountLabel({
    required String action,
    required int count,
  }) {
    return '$action. $count items.';
  }

  /// Create semantic label for progress
  static String progressLabel({
    required String action,
    required double progress,
  }) {
    final percent = (progress * 100).round();
    return '$action. $percent percent complete.';
  }
}

/// Widget wrapper for better accessibility
class AccessibleWidget extends StatelessWidget {
  const AccessibleWidget({
    super.key,
    required this.child,
    this.label,
    this.hint,
    this.value,
    this.isButton = false,
    this.isHeader = false,
    this.isLink = false,
    this.isImage = false,
    this.onTap,
    this.excludeSemantics = false,
  });

  final Widget child;
  final String? label;
  final String? hint;
  final String? value;
  final bool isButton;
  final bool isHeader;
  final bool isLink;
  final bool isImage;
  final VoidCallback? onTap;
  final bool excludeSemantics;

  @override
  Widget build(BuildContext context) {
    if (excludeSemantics) {
      return ExcludeSemantics(child: child);
    }

    return Semantics(
      label: label,
      hint: hint,
      value: value,
      button: isButton,
      header: isHeader,
      link: isLink,
      image: isImage,
      onTap: onTap,
      child: child,
    );
  }
}

/// Custom tooltip with better accessibility
class AccessibleTooltip extends StatelessWidget {
  const AccessibleTooltip({
    super.key,
    required this.message,
    required this.child,
    this.waitDuration = const Duration(milliseconds: 500),
  });

  final String message;
  final Widget child;
  final Duration waitDuration;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      waitDuration: waitDuration,
      child: Semantics(
        tooltip: message,
        child: child,
      ),
    );
  }
}

/// Icon button with proper accessibility
class AccessibleIconButton extends StatelessWidget {
  const AccessibleIconButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.tooltip,
    this.color,
    this.size,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? color;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final button = IconButton(
      icon: Icon(icon, size: size),
      color: color,
      onPressed: onPressed,
      tooltip: tooltip ?? label,
    );

    return Semantics(
      label: label,
      button: true,
      enabled: onPressed != null,
      child: button,
    );
  }
}

/// Text with semantic header
class AccessibleHeader extends StatelessWidget {
  const AccessibleHeader({
    super.key,
    required this.text,
    this.style,
  });

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: Text(text, style: style),
    );
  }
}

/// Card with better tap accessibility
class AccessibleCard extends StatelessWidget {
  const AccessibleCard({
    super.key,
    required this.child,
    this.onTap,
    this.semanticLabel,
    this.margin,
    this.elevation,
  });

  final Widget child;
  final VoidCallback? onTap;
  final String? semanticLabel;
  final EdgeInsetsGeometry? margin;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    final card = Card(
      margin: margin,
      elevation: elevation,
      child: child,
    );

    if (onTap != null) {
      return Semantics(
        label: semanticLabel,
        button: true,
        child: InkWell(
          onTap: onTap,
          child: card,
        ),
      );
    }

    return semanticLabel != null
        ? Semantics(
            label: semanticLabel,
            child: card,
          )
        : card;
  }
}

/// List tile with enhanced accessibility
class AccessibleListTile extends StatelessWidget {
  const AccessibleListTile({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.semanticLabel,
  });

  final Widget? leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      button: onTap != null,
      child: ListTile(
        leading: leading,
        title: title,
        subtitle: subtitle,
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}

/// Focus detector for keyboard navigation
class FocusableWidget extends StatefulWidget {
  const FocusableWidget({
    super.key,
    required this.child,
    this.onFocus,
    this.autofocus = false,
  });

  final Widget child;
  final VoidCallback? onFocus;
  final bool autofocus;

  @override
  State<FocusableWidget> createState() => _FocusableWidgetState();
}

class _FocusableWidgetState extends State<FocusableWidget> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      widget.onFocus?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      child: widget.child,
    );
  }
}
