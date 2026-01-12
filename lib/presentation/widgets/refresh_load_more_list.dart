import 'package:flutter/material.dart';
import 'dart:async';
import 'empty_widget.dart';
import 'loading_widget.dart';
import 'optimized_image.dart';

/// Refresh and load more list widget
/// 
/// Provides:
/// - Pull-to-refresh
/// - Load more on scroll
/// - Loading, empty, error states
/// - Preload threshold (1.5x screen height)
/// - Scroll-aware image loading optimization
class RefreshLoadMoreList<T> extends StatefulWidget {
  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final Future<void> Function() onRefresh;
  final Future<void> Function()? onLoadMore;
  final bool hasMore;
  final bool isLoading;
  final bool isEmpty;
  final bool isError;
  final String? errorMessage;
  final VoidCallback? onRetry;
  final EdgeInsetsGeometry? padding;
  final bool enableScrollAwareImageLoading;

  const RefreshLoadMoreList({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.onRefresh,
    this.onLoadMore,
    this.hasMore = false,
    this.isLoading = false,
    this.isEmpty = false,
    this.isError = false,
    this.errorMessage,
    this.onRetry,
    this.padding,
    this.enableScrollAwareImageLoading = true,
  });

  @override
  State<RefreshLoadMoreList<T>> createState() => _RefreshLoadMoreListState<T>();
}

class _RefreshLoadMoreListState<T> extends State<RefreshLoadMoreList<T>> {
  final ScrollController _scrollController = ScrollController();
  final ScrollAwareImageController _imageController = ScrollAwareImageController();
  bool _isLoadingMore = false;
  Timer? _scrollEndTimer;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _scrollEndTimer?.cancel();
    _imageController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Handle scroll-aware image loading
    if (widget.enableScrollAwareImageLoading) {
      _handleScrollStateForImages();
    }

    // Handle load more
    if (_isLoadingMore || !widget.hasMore || widget.onLoadMore == null) {
      return;
    }

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final screenHeight = MediaQuery.of(context).size.height;

    // Preload when 1.5x screen height from bottom
    if (currentScroll >= maxScroll - (screenHeight * 1.5)) {
      _loadMore();
    }
  }

  void _handleScrollStateForImages() {
    // Cancel previous timer
    _scrollEndTimer?.cancel();

    // Set scrolling state to true
    _imageController.setScrolling(true);

    // Set timer to detect scroll end (100ms after last scroll event)
    _scrollEndTimer = Timer(const Duration(milliseconds: 100), () {
      if (mounted) {
        _imageController.setScrolling(false);
      }
    });
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      await widget.onLoadMore!();
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading on initial load
    if (widget.isLoading && widget.items.isEmpty) {
      return const LoadingWidget.local();
    }

    // Show error state
    if (widget.isError && widget.items.isEmpty) {
      return EmptyWidget(
        type: EmptyType.error,
        customMessage: widget.errorMessage,
        onRetry: widget.onRetry,
      );
    }

    // Show empty state
    if (widget.isEmpty && widget.items.isEmpty) {
      return const EmptyWidget(
        type: EmptyType.noData,
      );
    }

    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      child: ListView.builder(
        controller: _scrollController,
        padding: widget.padding ?? const EdgeInsets.all(16),
        itemCount: widget.items.length + (widget.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          // Show load more indicator
          if (index == widget.items.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          // Wrap each list item with RepaintBoundary to isolate repaints
          return RepaintBoundary(
            child: _ScrollAwareImageProvider(
              controller: _imageController,
              child: widget.itemBuilder(context, widget.items[index], index),
            ),
          );
        },
      ),
    );
  }
}

/// InheritedWidget to provide ScrollAwareImageController to descendants
class _ScrollAwareImageProvider extends InheritedWidget {
  final ScrollAwareImageController controller;

  const _ScrollAwareImageProvider({
    required this.controller,
    required super.child,
  });

  static ScrollAwareImageController? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_ScrollAwareImageProvider>()
        ?.controller;
  }

  @override
  bool updateShouldNotify(_ScrollAwareImageProvider oldWidget) {
    return controller != oldWidget.controller;
  }
}
