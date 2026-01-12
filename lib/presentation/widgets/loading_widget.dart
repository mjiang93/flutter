import 'package:flutter/material.dart';

/// Loading widget
/// 
/// Displays loading indicator with optional message
/// Supports both global (full screen) and local loading states
class LoadingWidget extends StatelessWidget {
  final String? message;
  final bool isGlobal;

  const LoadingWidget({
    super.key,
    this.message,
    this.isGlobal = false,
  });

  /// Create global loading (full screen with barrier)
  const LoadingWidget.global({
    super.key,
    this.message,
  }) : isGlobal = true;

  /// Create local loading (inline)
  const LoadingWidget.local({
    super.key,
    this.message,
  }) : isGlobal = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final content = RepaintBoundary(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            color: colorScheme.primary,
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );

    if (isGlobal) {
      return Container(
        color: Colors.black.withOpacity(0.3),
        child: Center(child: content),
      );
    }

    return Center(child: content);
  }
}
