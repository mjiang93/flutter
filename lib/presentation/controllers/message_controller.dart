import 'package:get/get.dart';
import '../../core/configs/app_config.dart';
import '../../core/constants/route_names.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/usecases/get_unread_message_usecase.dart';
import '../../domain/usecases/mark_message_read_usecase.dart';
import '../../domain/repositories/message_repository.dart';
import 'base_controller.dart';

/// Message page controller
/// 
/// Manages message page state including:
/// - Message list with pagination
/// - Unread count badge
/// - Mark as read functionality
/// - Pull-to-refresh
/// - Load more
/// - Message navigation
class MessageController extends BaseController {
  final MessageRepository _messageRepository;
  final GetUnreadMessageUseCase _getUnreadMessageUseCase;
  final MarkMessageReadUseCase _markMessageReadUseCase;

  MessageController(
    this._messageRepository,
    this._getUnreadMessageUseCase,
    this._markMessageReadUseCase,
  );

  // Observable variables
  final _messages = <MessageEntity>[].obs;
  final _unreadCount = 0.obs;
  final _currentPage = 1.obs;
  final _hasMore = true.obs;

  // Getters
  List<MessageEntity> get messages => _messages;
  int get unreadCount => _unreadCount.value;
  int get currentPage => _currentPage.value;
  bool get hasMore => _hasMore.value;

  @override
  void onInit() {
    super.onInit();
    loadMessages();
    loadUnreadCount();
  }

  /// Load messages (first page or refresh)
  /// 
  /// Called on page init and pull-to-refresh
  Future<void> loadMessages() async {
    setLoading();
    _currentPage.value = 1;

    final result = await _messageRepository.getMessageList(
      page: _currentPage.value,
      pageSize: AppConfig.defaultPageSize,
    );

    handleResult(
      result,
      onSuccess: (data) {
        _messages.value = data;
        _hasMore.value = data.length >= AppConfig.defaultPageSize;
        
        if (data.isEmpty) {
          setEmpty();
        } else {
          setSuccess();
        }
      },
      onError: (error) {
        // Error state is already set by handleResult
      },
    );
  }

  /// Load more messages (next page)
  /// 
  /// Called when user scrolls to bottom
  Future<void> loadMore() async {
    if (!_hasMore.value || isLoading) return;

    _currentPage.value++;

    final result = await _messageRepository.getMessageList(
      page: _currentPage.value,
      pageSize: AppConfig.defaultPageSize,
    );

    handleResult(
      result,
      onSuccess: (data) {
        _messages.addAll(data);
        _hasMore.value = data.length >= AppConfig.defaultPageSize;
      },
      onError: (error) {
        // Revert page increment on error
        _currentPage.value--;
      },
    );
  }

  /// Load unread message count
  /// 
  /// Updates the badge count displayed on the tab
  Future<void> loadUnreadCount() async {
    final result = await _getUnreadMessageUseCase();

    handleResult(
      result,
      onSuccess: (count) {
        _unreadCount.value = count;
      },
      onError: (error) {
        // Silently fail - don't show error for badge count
      },
    );
  }

  /// Mark message as read
  /// 
  /// Updates both remote and local state
  Future<void> markAsRead(String messageId) async {
    final result = await _markMessageReadUseCase(messageId);

    handleResult(
      result,
      onSuccess: (_) {
        // Update local message list
        final index = _messages.indexWhere((m) => m.id == messageId);
        if (index != -1) {
          final updatedMessage = _messages[index].copyWith(isRead: true);
          _messages[index] = updatedMessage;
        }

        // Decrement unread count
        if (_unreadCount.value > 0) {
          _unreadCount.value--;
        }
      },
      onError: (error) {
        // Silently fail - don't block navigation
      },
    );
  }

  /// Handle message tap
  /// 
  /// Mark as read and navigate to detail page
  Future<void> onMessageTap(MessageEntity message) async {
    // Mark as read if not already read
    if (!message.isRead) {
      await markAsRead(message.id);
    }

    // Navigate to detail page
    Get.toNamed(
      RouteNames.messageDetail,
      arguments: {'message': message},
    );
  }
}
