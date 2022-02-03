import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view_gallery.dart';

class MarketClickImage extends StatefulWidget {
  // final String url;
  final List url;
  const MarketClickImage({Key? key, required this.url}) : super(key: key);

  @override
  _MarketClickImageState createState() => _MarketClickImageState(url);
}

class _MarketClickImageState extends State<MarketClickImage> {
  // String image_url = "";
  List image_url = [];

  _MarketClickImageState(this.image_url);

  @override
  Widget build(BuildContext context) {
    print(image_url.toString());
    // return Container(
    //     child: ListView.builder(
    //         scrollDirection: Axis.horizontal,
    //         itemCount: image_url.length,
    //         itemBuilder: (context, int) {
    //           return PhotoView(imageProvider: NetworkImage(image_url[int]));
    //         })
    //     // child: PhotoView(imageProvider: NetworkImage(image_url))),
    //     );
    return Container(
        child: PhotoViewGallery.builder(
      scrollPhysics: const BouncingScrollPhysics(),
      builder: (BuildContext context, int index) {
        return PhotoViewGalleryPageOptions(
          imageProvider: NetworkImage(image_url[index]),
          initialScale: PhotoViewComputedScale.contained * 0.8,
          // heroAttributes: PhotoViewHeroAttributes(tag: galleryItems[index].id),
        );
      },
      itemCount: image_url.length,
      loadingBuilder: (context, event) => Center(
        child: Container(
          width: 20.0,
          height: 20.0,
          child: CircularProgressIndicator(),
        ),
      ),
      // backgroundDecoration: widget.backgroundDecoration,
      // pageController: widget.pageController,
      // onPageChanged: onPageChanged,
    ));
  }
}
