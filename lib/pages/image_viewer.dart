
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
//import 'package:photo_view/photo_view.dart';

class HeroPhotoViewWrapper extends StatelessWidget {
  const HeroPhotoViewWrapper(
      {this.imageProvider,
        this.backgroundDecoration,
        this.minScale,
        this.maxScale});

  final ImageProvider imageProvider;
  final Decoration backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(backgroundColor: Colors.transparent, elevation: 0,),
      backgroundColor: Colors.black,
      body: Container(
          constraints: BoxConstraints.expand(
            height: MediaQuery.of(context).size.height,
          ),
         child: PhotoView(
           imageProvider: imageProvider,
           backgroundDecoration: backgroundDecoration,
           minScale: minScale,
           maxScale: maxScale,
         )
      ),
    );
  }
}