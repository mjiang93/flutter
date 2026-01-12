import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import '../../core/errors/exceptions.dart';

/// UI state enumeration
enum UIState {
  idle,
  loading,
  success,
  error,
  empty,
}

/// Base controller for all GetX controllers
/// 
/// Provides common state management functionality:
/// - UI state management (loading, success, error, empty)
/// - Error message handling
/// - Either result handling
abstract class BaseController extends GetxController {
  final _uiState = UIState.idle.obs;
  final _errorMessage = ''.obs;

  UIState get uiState => _uiState.value;
  String get errorMessage => _errorMessage.value;

  bool get isIdle => _uiState.value == UIState.idle;
  bool get isLoading => _uiState.value == UIState.loading;
  bool get isSuccess => _uiState.value == UIState.success;
  bool get isError => _uiState.value == UIState.error;
  bool get isEmpty => _uiState.value == UIState.empty;

  /// Set UI state to loading
  void setLoading() {
    _uiState.value = UIState.loading;
  }

  /// Set UI state to success
  void setSuccess() {
    _uiState.value = UIState.success;
  }

  /// Set UI state to error with message
  void setError(String message) {
    _uiState.value = UIState.error;
    _errorMessage.value = message;
  }

  /// Set UI state to empty
  void setEmpty() {
    _uiState.value = UIState.empty;
  }

  /// Set UI state to idle
  void setIdle() {
    _uiState.value = UIState.idle;
  }

  /// Handle Either result from use cases
  /// 
  /// Automatically handles error state and calls appropriate callbacks
  void handleResult<T>(
    Either<BaseException, T> result, {
    required Function(T data) onSuccess,
    Function(BaseException error)? onError,
  }) {
    result.fold(
      (error) {
        setError(error.message);
        onError?.call(error);
      },
      (data) {
        onSuccess(data);
      },
    );
  }

  /// Handle Either result with loading state
  /// 
  /// Shows loading before executing and handles result
  Future<void> handleResultWithLoading<T>(
    Future<Either<BaseException, T>> Function() action, {
    required Function(T data) onSuccess,
    Function(BaseException error)? onError,
  }) async {
    setLoading();
    final result = await action();
    handleResult(
      result,
      onSuccess: onSuccess,
      onError: onError,
    );
  }
}
