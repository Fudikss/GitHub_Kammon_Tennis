import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MarketClickImage extends StatefulWidget {
  final String url;
  const MarketClickImage({Key? key, required this.url}) : super(key: key);

  @override
  _MarketClickImageState createState() => _MarketClickImageState(url);
}

class _MarketClickImageState extends State<MarketClickImage> {
  String image_url = "";

  _MarketClickImageState(this.image_url);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: PhotoView(imageProvider: NetworkImage(image_url)),
    );
  }
}
