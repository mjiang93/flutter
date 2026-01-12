import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../domain/repositories/message_repository.dart';
import '../../../domain/usecases/get_unread_message_usecase.dart';
import '../../../domain/usecases/mark_message_read_usecase.dart';
import '../../../injection/locator.dart';
import '../../controllers/message_controller.dart';
import '../../widgets/refresh_load_more_list.dart';
import '../base_page.dart';
import 'widgets/message_item_widget.dart';

/// Message page - displays list of messages
/// 
/// Features:
/// - Message list with pagination
/// - Unread indicator on items
/// - Pull-to-refresh
/// - Load more on scroll
/// - Mark as read on tap
/// - Navigate to detail page
@RoutePage()
class MessagePage extends BasePage {
  const MessagePage({Key? key}) : super(key: key);

  @override
  String? get title => 'Messages';

  @override
  bool get showBackButton => false;

  @override
  Widget buildBody(BuildContext context) {
    // Inject controller with Get.put for lifecycle management
    // Get dependencies from getIt instead of Get.find
    final controller = Get.put(MessageController(
      getIt(),
      getIt(),
      getIt(),
    ));

    return Obx(() {
      return RefreshLoadMoreList(
        items: controller.messages,
        itemBuilder: (context, message, index) {
          return MessageItemWidget(
            message: message,
            onTap: () => controller.onMessageTap(message),
          );
        },
        onRefresh: controller.loadMessages,
        onLoadMore: controller.loadMore,
        hasMore: controller.hasMore,
        isLoading: controller.isLoading,
        isEmpty: controller.isEmpty,
        isError: controller.isError,
        errorMessage: controller.errorMessage,
        onRetry: controller.loadMessages,
      );
    });
  }
}
