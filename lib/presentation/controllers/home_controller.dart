import 'package:get/get.dart';
import '../../core/configs/app_config.dart';
import '../../core/constants/route_names.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/usecases/get_home_data_usecase.dart';
import 'base_controller.dart';

/// Home page controller
/// 
/// Manages home page state including:
/// - Banner data
/// - List items with pagination
/// - Pull-to-refresh
/// - Load more
/// - Item navigation
class HomeController extends BaseController {
  final GetHomeDataUseCase _getHomeDataUseCase;

  HomeController(this._getHomeDataUseCase);

  // Observable variables
  final _banners = <String>[].obs;
  final _listItems = <MessageEntity>[].obs;
  final _currentPage = 1.obs;
  final _hasMore = true.obs;

  // Getters
  List<String> get banners => _banners;
  List<MessageEntity> get listItems => _listItems;
  int get currentPage => _currentPage.value;
  bool get hasMore => _hasMore.value;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  /// Load initial data (banners + first page of list)
  /// 
  /// Called on page init and pull-to-refresh
  Future<void> loadData() async {
    setLoading();
    _currentPage.value = 1;

    // In a real app, banners would come from a separate API
    // For now, we'll use mock data
    _banners.value = [
      'https://via.placeholder.com/800x400/FF6B6B/FFFFFF?text=Banner+1',
      'https://via.placeholder.com/800x400/4ECDC4/FFFFFF?text=Banner+2',
      'https://via.placeholder.com/800x400/45B7D1/FFFFFF?text=Banner+3',
    ];

    // Load first page of list items
    final result = await _getHomeDataUseCase(
      page: _currentPage.value,
      pageSize: AppConfig.defaultPageSize,
    );

    handleResult(
      result,
      onSuccess: (data) {
        _listItems.value = data;
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

  /// Load more data (next page)
  /// 
  /// Called when user scrolls to bottom
  Future<void> loadMore() async {
    if (!_hasMore.value || isLoading) return;

    _currentPage.value++;

    final result = await _getHomeDataUseCase(
      page: _currentPage.value,
      pageSize: AppConfig.defaultPageSize,
    );

    handleResult(
      result,
      onSuccess: (data) {
        _listItems.addAll(data);
        _hasMore.value = data.length >= AppConfig.defaultPageSize;
      },
      onError: (error) {
        // Revert page increment on error
        _currentPage.value--;
      },
    );
  }

  /// Handle item tap
  /// 
  /// Navigate to detail page with item ID
  void onItemTap(MessageEntity item) {
    Get.toNamed(
      RouteNames.homeDetail,
      arguments: {'id': item.id},
    );
  }
}
