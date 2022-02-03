import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class MatchKDKTableView extends StatefulWidget {
  const MatchKDKTableView({ Key? key }) : super(key: key);

  @override
  _MatchKDKTableViewState createState() => _MatchKDKTableViewState();
}

class _MatchKDKTableViewState extends State<MatchKDKTableView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: PhotoView(imageProvider: AssetImage('assets/images/PNG/kdk.png')),
      //child: PhotoView(imageProvider: NetworkImage('assets/images/PNG/kdk.png')),
    );
  }
}