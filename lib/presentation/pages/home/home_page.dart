import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home_controller.dart';
import '../../widgets/refresh_load_more_list.dart';
import '../base_page.dart';
import 'widgets/home_banner_widget.dart';
import 'widgets/home_list_item_widget.dart';

/// Home page - main landing page of the application
/// 
/// Features:
/// - Banner carousel at top
/// - List items with pagination
/// - Pull-to-refresh
/// - Load more on scroll
/// - Item tap navigation
@RoutePage()
class HomePage extends BasePage {
  const HomePage({Key? key}) : super(key: key);

  @override
  String? get title => 'Home';

  @override
  bool get showBackButton => false;

  @override
  Widget buildBody(BuildContext context) {
    // Inject controller with Get.put for lifecycle management
    final controller = Get.put(HomeController(Get.find()));

    return Obx(() {
      return RefreshLoadMoreList(
        items: controller.listItems,
        itemBuilder: (context, item, index) {
          // First item includes banner
          if (index == 0 && controller.banners.isNotEmpty) {
            return Column(
              children: [
                HomeBannerWidget(banners: controller.banners),
                const SizedBox(height: 16),
                HomeListItemWidget(
                  item: item,
                  onTap: () => controller.onItemTap(item),
                ),
              ],
            );
          }
          
          return HomeListItemWidget(
            item: item,
            onTap: () => controller.onItemTap(item),
          );
        },
        onRefresh: controller.loadData,
        onLoadMore: controller.loadMore,
        hasMore: controller.hasMore,
        isLoading: controller.isLoading,
        isEmpty: controller.isEmpty,
        isError: controller.isError,
        errorMessage: controller.errorMessage,
        onRetry: controller.loadData,
        padding: const EdgeInsets.all(0),
      );
    });
  }
}
