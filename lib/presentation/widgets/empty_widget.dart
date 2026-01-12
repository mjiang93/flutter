import 'package:flutter/material.dart';

/// Empty state type enumeration
enum EmptyType {
  noData,
  network,
  error,
  permission,
}

/// Empty state widget
/// 
/// Displays different empty states with icon, message, and optional retry button
class EmptyWidget extends StatelessWidget {
  final EmptyType type;
  final String? customMessage;
  final VoidCallback? onRetry;

  const EmptyWidget({
    super.key,
    this.type = EmptyType.noData,
    this.customMessage,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Icon(
              _getIcon(),
              size: 80,
              color: colorScheme.outline,
            ),
            const SizedBox(height: 24),

            // Message
            Text(
              customMessage ?? _getDefaultMessage(),
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Description
            Text(
              _getDescription(),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),

            // Retry button
            if (onRetry != null) ...[
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('重试'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getIcon() {
    switch (type) {
      case EmptyType.noData:
        return Icons.inbox_outlined;
      case EmptyType.network:
        return Icons.wifi_off_outlined;
      case EmptyType.error:
        return Icons.error_outline;
      case EmptyType.permission:
        return Icons.lock_outline;
    }
  }

  String _getDefaultMessage() {
    switch (type) {
      case EmptyType.noData:
        return '暂无数据';
      case EmptyType.network:
        return '网络连接失败';
      case EmptyType.error:
        return '出错了';
      case EmptyType.permission:
        return '没有权限';
    }
  }

  String _getDescription() {
    switch (type) {
      case EmptyType.noData:
        return '这里还没有任何内容';
      case EmptyType.network:
        return '请检查网络连接后重试';
      case EmptyType.error:
        return '请稍后再试';
      case EmptyType.permission:
        return '您没有访问此内容的权限';
    }
  }
}
