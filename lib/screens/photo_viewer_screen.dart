import 'package:flutter/material.dart';

import '../widgets/photo_placeholder.dart';

/// Fullscreen photo viewer with pinch-zoom / pan. No editing.
class PhotoViewerScreen extends StatefulWidget {
  const PhotoViewerScreen({
    super.key,
    required this.imagePath,
    this.variant = 0,
    this.semanticsLabel = 'Photo',
  });

  final String? imagePath;
  final int variant;
  final String semanticsLabel;

  @override
  State<PhotoViewerScreen> createState() => _PhotoViewerScreenState();
}

class _PhotoViewerScreenState extends State<PhotoViewerScreen> {
  final _transform = TransformationController();

  @override
  void dispose() {
    _transform.dispose();
    super.dispose();
  }

  void _handleDoubleTap() {
    if (_transform.value != Matrix4.identity()) {
      _transform.value = Matrix4.identity();
      return;
    }
    _transform.value = Matrix4.identity()..scaleByDouble(2, 2, 2, 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onDoubleTap: _handleDoubleTap,
                child: InteractiveViewer(
                  transformationController: _transform,
                  minScale: 1,
                  maxScale: 5,
                  child: Center(
                    child: Semantics(
                      label: widget.semanticsLabel,
                      child: MemoryPhoto(
                        imagePath: widget.imagePath,
                        height: MediaQuery.sizeOf(context).height * 0.85,
                        borderRadius: BorderRadius.zero,
                        variant: widget.variant,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
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
          ],
        ),
      ),
    );
  }
}

/// Opens [PhotoViewerScreen] without dismissing the underlying route/sheet.
Future<void> openPhotoViewer(
  BuildContext context, {
  required String? imagePath,
  int variant = 0,
  String semanticsLabel = 'Photo',
}) {
  return Navigator.of(context).push(
    PageRouteBuilder<void>(
      opaque: true,
      pageBuilder: (context, animation, secondary) {
        return FadeTransition(
          opacity: animation,
          child: PhotoViewerScreen(
            imagePath: imagePath,
            variant: variant,
            semanticsLabel: semanticsLabel,
          ),
        );
      },
    ),
  );
}
