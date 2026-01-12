import 'package:flutter/material.dart';

/// Unread badge widget
/// 
/// Displays a small red dot indicator for unread messages
class UnreadBadgeWidget extends StatelessWidget {
  final double size;

  const UnreadBadgeWidget({
    super.key,
    this.size = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.error,
        shape: BoxShape.circle,
      ),
    );
  }
}
