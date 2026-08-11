import 'package:flutter/material.dart';

import '../widgets/photo_placeholder.dart';

/// Fullscreen multi-photo viewer with pinch-zoom / pan. No editing.
class PhotoViewerScreen extends StatefulWidget {
  const PhotoViewerScreen({
    super.key,
    required this.imagePaths,
    this.initialIndex = 0,
    this.variant = 0,
    this.semanticsLabel = 'Photo',
  });

  final List<String> imagePaths;
  final int initialIndex;
  final int variant;
  final String semanticsLabel;

  @override
  State<PhotoViewerScreen> createState() => _PhotoViewerScreenState();
}

class _PhotoViewerScreenState extends State<PhotoViewerScreen> {
  late final PageController _pageController;
  late int _index;
  final Map<int, TransformationController> _transforms = {};

  @override
  void initState() {
    super.initState();
    final max = widget.imagePaths.isEmpty ? 0 : widget.imagePaths.length - 1;
    _index = widget.initialIndex.clamp(0, max);
    _pageController = PageController(initialPage: _index);
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (final t in _transforms.values) {
      t.dispose();
    }
    super.dispose();
  }

  TransformationController _controllerFor(int index) {
    return _transforms.putIfAbsent(index, TransformationController.new);
  }

  void _handleDoubleTap(int index) {
    final transform = _controllerFor(index);
    if (transform.value != Matrix4.identity()) {
      transform.value = Matrix4.identity();
      return;
    }
    transform.value = Matrix4.identity()..scaleByDouble(2, 2, 2, 1);
  }

  @override
  Widget build(BuildContext context) {
    final count = widget.imagePaths.isEmpty ? 1 : widget.imagePaths.length;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: PageView.builder(
                controller: _pageController,
                itemCount: count,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (context, index) {
                  final path = widget.imagePaths.isEmpty
                      ? null
                      : widget.imagePaths[index];
                  final transform = _controllerFor(index);
                  return GestureDetector(
                    onDoubleTap: () => _handleDoubleTap(index),
                    child: InteractiveViewer(
                      transformationController: transform,
                      minScale: 1,
                      maxScale: 5,
                      child: Center(
                        child: Semantics(
                          label: widget.semanticsLabel,
                          child: MemoryPhoto(
                            imagePath: path,
                            height: MediaQuery.sizeOf(context).height * 0.85,
                            borderRadius: BorderRadius.zero,
                            variant: widget.variant + index,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              top: 8,
              left: 8,
              child: IconButton(
                tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                style: IconButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.black54,
                ),
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.close_rounded),
              ),
            ),
            if (widget.imagePaths.length > 1)
              Positioned(
                top: 16,
                right: 16,
                child: Text(
                  '${_index + 1}/${widget.imagePaths.length}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Opens [PhotoViewerScreen] without dismissing the underlying route/sheet.
Future<void> openPhotoViewer(
  BuildContext context, {
  List<String>? imagePaths,
  String? imagePath,
  int initialIndex = 0,
  int variant = 0,
  String semanticsLabel = 'Photo',
}) {
  final paths =
      imagePaths ??
      (imagePath == null || imagePath.isEmpty
          ? const <String>[]
          : <String>[imagePath]);
  return Navigator.of(context).push(
    PageRouteBuilder<void>(
      opaque: true,
      pageBuilder: (context, animation, secondary) {
        return FadeTransition(
          opacity: animation,
          child: PhotoViewerScreen(
            imagePaths: paths,
            initialIndex: initialIndex,
            variant: variant,
            semanticsLabel: semanticsLabel,
          ),
        );
      },
    ),
  );
}
