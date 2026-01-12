import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../domain/entities/message_entity.dart';
import '../../../core/utils/format_util.dart';
import '../base_page.dart';

/// Message detail page - displays a single message
/// 
/// Features:
/// - Message title
/// - Full message content
/// - Timestamp
/// - Type badge
@RoutePage()
class MessageDetailPage extends BasePage {
  final String id;

  const MessageDetailPage({
    Key? key,
    @PathParam('id') required this.id,
  }) : super(key: key);

  @override
  String? get title => 'Message Detail';

  @override
  Widget buildBody(BuildContext context) {
    // Get message from navigation arguments
    final message = Get.arguments?['message'] as MessageEntity?;

    if (message == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Message not found',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      );
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Type badge
          _buildTypeBadge(context, message.type),
          const SizedBox(height: 16),
          
          // Title
          Text(
            message.title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          // Timestamp
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 16,
                color: colorScheme.outline,
              ),
              const SizedBox(width: 6),
              Text(
                FormatUtil.formatDate(message.createdAt),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.outline,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Divider
          Divider(color: colorScheme.outlineVariant),
          const SizedBox(height: 24),
          
          // Content
          Text(
            message.content,
            style: theme.textTheme.bodyLarge?.copyWith(
              height: 1.6,
            ),
          ),
        ],
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
        label = 'System Message';
        break;
      case MessageType.notification:
        backgroundColor = colorScheme.secondaryContainer;
        textColor = colorScheme.onSecondaryContainer;
        label = 'Notification';
        break;
      case MessageType.promotion:
        backgroundColor = colorScheme.tertiaryContainer;
        textColor = colorScheme.onTertiaryContainer;
        label = 'Promotion';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
