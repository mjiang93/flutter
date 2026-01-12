import 'package:flutter/material.dart';
import '../../../../domain/entities/message_entity.dart';
import '../../../../core/utils/format_util.dart';
import 'unread_badge_widget.dart';

/// Message item widget
/// 
/// Displays a single message item with:
/// - Title
/// - Content preview
/// - Timestamp
/// - Unread indicator
/// - Type badge
/// - Tap handling
class MessageItemWidget extends StatelessWidget {
  final MessageEntity message;
  final VoidCallback onTap;

  const MessageItemWidget({
    super.key,
    required this.message,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: message.isRead ? 0 : 2,
      color: message.isRead 
          ? colorScheme.surface 
          : colorScheme.primaryContainer.withOpacity(0.1),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Unread indicator
              if (!message.isRead) ...[
                const UnreadBadgeWidget(),
                const SizedBox(width: 12),
              ],
              
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and type badge
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            message.title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: message.isRead 
                                  ? FontWeight.normal 
                                  : FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildTypeBadge(context, message.type),
                      ],
                    ),
                    const SizedBox(height: 8),
                    
                    // Content preview
                    Text(
                      message.content,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    
                    // Timestamp
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: colorScheme.outline,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          FormatUtil.formatRelativeTime(message.createdAt),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Arrow icon
              Icon(
                Icons.chevron_right,
                color: colorScheme.outline,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeBadge(BuildContext context, MessageType type) {
    final colorScheme = Theme.of(context).colorScheme;
    
    Color backgroundColor;
    Color textColor;
    String label;

    switch (type) {
      case MessageType.system:
        backgroundColor = colorScheme.primaryContainer;
        textColor = colorScheme.onPrimaryContainer;
        label = 'System';
        break;
      case MessageType.notification:
        backgroundColor = colorScheme.secondaryContainer;
        textColor = colorScheme.onSecondaryContainer;
        label = 'Notice';
        break;
      case MessageType.promotion:
        backgroundColor = colorScheme.tertiaryContainer;
        textColor = colorScheme.onTertiaryContainer;
        label = 'Promo';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
