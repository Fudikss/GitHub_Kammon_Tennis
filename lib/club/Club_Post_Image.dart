import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ClubClickImage extends StatefulWidget {
  final String url;
  const ClubClickImage({Key? key, required this.url}) : super(key: key);

  @override
  _ClubClickImageState createState() => _ClubClickImageState(url);
}

class _ClubClickImageState extends State<ClubClickImage> {
  String image_url = "";

  _ClubClickImageState(this.image_url);

  @override
  Widget build(BuildContext context) {
    return Container(child: PhotoView(imageProvider: NetworkImage(image_url)));
  }
}
