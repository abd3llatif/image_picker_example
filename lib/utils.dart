import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uimages/pages/image_viewer.dart';

class Utils {

  static showSnackBarError(context, String msg, {Color color = Colors.red}) {
    showSnackBar(context, msg, color: Colors.red);

  }

  static showImage({imageUrl, context}) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HeroPhotoViewWrapper(
              imageProvider: Image.network(imageUrl).image,
            ),
            fullscreenDialog: true
        ));
  }


  static showSnackBar(context, String msg, {Color color = Colors.black87, onPressed}) {
    SnackBar snackBar = SnackBar(
      content: Text(
        msg != null ? msg : 'Error!',
        style: TextStyle(
          fontWeight: FontWeight.w900,
        ),
      ),
      duration: Duration(seconds: 10),
      backgroundColor: color,
      action: SnackBarAction(
        label: 'OK',
        onPressed: onPressed != null ? onPressed : (){},
      ),
    );

    Scaffold.of(context).showSnackBar(snackBar);

  }

}
