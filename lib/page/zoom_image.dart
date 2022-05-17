import 'package:cached_network_image/cached_network_image.dart';
import 'package:clinic/source/source.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ZoomImagePage extends StatefulWidget {
  const ZoomImagePage(
      {Key? key, required this.title, required this.imageSource})
      : super(key: key);
  final String imageSource;
  final String title;

  @override
  State<ZoomImagePage> createState() => _ZoomImagePageState();
}

class _ZoomImagePageState extends State<ZoomImagePage> {
  late PhotoViewController photoviewController;
  @override
  void initState() {
    photoviewController = PhotoViewController();
    super.initState();
  }

  @override
  void dispose() {
    PaintingBinding.instance?.imageCache?.clear();
    PaintingBinding.instance?.imageCache?.clearLiveImages();
    photoviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: PhotoView.customChild(
          controller: photoviewController,
          initialScale: PhotoViewComputedScale.contained,
          minScale: PhotoViewComputedScale.contained * 0.8,
          maxScale: PhotoViewComputedScale.contained * 3,
          child: CachedNetworkImage(
            imageUrl: urlImg + '/${widget.imageSource}',
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) =>
                const Icon(Icons.error, color: Colors.red, size: 100),
          ),
        ),
      ),
    );
  }
}
