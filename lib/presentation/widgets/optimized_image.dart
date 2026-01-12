import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Optimized image widget with caching and scroll-aware loading
/// 
/// Features:
/// - Automatic caching with cached_network_image
/// - Scroll-aware loading (pauses during scroll)
/// - Placeholder and error handling
/// - Memory-efficient loading
class OptimizedImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final Duration fadeInDuration;
  final Duration? cacheMaxAge;

  const OptimizedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.fadeInDuration = const Duration(milliseconds: 300),
    this.cacheMaxAge,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      fadeInDuration: fadeInDuration,
      placeholder: (context, url) =>
          placeholder ??
          Container(
            width: width,
            height: height,
            color: Colors.grey[300],
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
      errorWidget: (context, url, error) =>
          errorWidget ??
          Container(
            width: width,
            height: height,
            color: Colors.grey[300],
            child: const Icon(
              Icons.broken_image_outlined,
              color: Colors.grey,
              size: 48,
            ),
          ),
      // Memory cache configuration
      memCacheWidth: width != null ? (width! * 2).toInt() : null,
      memCacheHeight: height != null ? (height! * 2).toInt() : null,
      // Disk cache configuration
      maxWidthDiskCache: width != null ? (width! * 3).toInt() : null,
      maxHeightDiskCache: height != null ? (height! * 3).toInt() : null,
    );
  }
}

/// Scroll-aware image loading controller
/// 
/// Manages image loading based on scroll state to improve performance
class ScrollAwareImageController extends ChangeNotifier {
  bool _isScrolling = false;
  bool get isScrolling => _isScrolling;

  void setScrolling(bool scrolling) {
    if (_isScrolling != scrolling) {
      _isScrolling = scrolling;
      notifyListeners();
    }
  }
}

/// Scroll-aware optimized image that pauses loading during scroll
class ScrollAwareImage extends StatefulWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final ScrollAwareImageController? controller;

  const ScrollAwareImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.controller,
  });

  @override
  State<ScrollAwareImage> createState() => _ScrollAwareImageState();
}

class _ScrollAwareImageState extends State<ScrollAwareImage> {
  bool _shouldLoad = true;
  ScrollAwareImageController? _effectiveController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Remove old listener
    _effectiveController?.removeListener(_onScrollStateChanged);
    
    // Get controller from widget or InheritedWidget
    _effectiveController = widget.controller;
    
    // Add new listener
    _effectiveController?.addListener(_onScrollStateChanged);
  }

  @override
  void dispose() {
    _effectiveController?.removeListener(_onScrollStateChanged);
    super.dispose();
  }

  void _onScrollStateChanged() {
    final isScrolling = _effectiveController?.isScrolling ?? false;
    setState(() {
      _shouldLoad = !isScrolling;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show placeholder during scroll
    if (!_shouldLoad) {
      return widget.placeholder ??
          Container(
            width: widget.width,
            height: widget.height,
            color: Colors.grey[300],
          );
    }

    return OptimizedImage(
      imageUrl: widget.imageUrl,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      placeholder: widget.placeholder,
      errorWidget: widget.errorWidget,
    );
  }
}
