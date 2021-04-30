import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uimages/pages/image_viewer.dart';
import 'package:uimages/utils.dart';

class UploadPage extends StatefulWidget {
  final int maxImages = 10;
  final List images = [];

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final picker = ImagePicker();
  String photoPV = "";

  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    backgroundColor: Colors.grey.withOpacity(0.2),
    padding: EdgeInsets.all(12),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Images'),
        centerTitle: true,
      ),
      body: Container(
          child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                _imagePV(),
                _imagesPanel(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              style: flatButtonStyle,
              child: Row(
                children: <Widget>[
                  Spacer(),
                  Icon(
                    Icons.upload_file,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      "Upload",
                    ),
                  ),
                  Spacer(),
                ],
              ),
              onPressed: () {
                if (photoPV.isEmpty) {
                  print("ERROR: Image PV is required");
                  return;
                }

                // Generate file pbjects
                File photoPvFile = File.fromUri(Uri.tryParse('$photoPV'));
                List<File> autreImages = widget.images
                    .map((img) => File.fromUri(Uri.tryParse('$img')))
                    .toList();

                print("UPLOADING...");

                print("UPLOAD SUCCECCED");
              },
            ),
          ),
        ],
      )),
    );
  }

  Future<Null> _takePhoto(bool isPV) async {
    PickedFile imageFile =
        await picker.getImage(source: ImageSource.camera, maxWidth: 600);
    setState(() {
      if (isPV)
        photoPV = imageFile.path;
      else
        widget.images.add(imageFile.path);
    });
    print('${widget.images}');
  }

  Future<Null> _pickPhoto(bool isPV) async {
    final PickedFile imageFile =
        await picker.getImage(source: ImageSource.gallery, maxWidth: 600);
    setState(() {
      if (isPV)
        photoPV = imageFile.path;
      else
        widget.images.add(imageFile.path);
    });
  }

  Widget _imageItem(ImageProvider image) {
    return GestureDetector(
      onTap: image != null ? () => showImage(image) : null,
      child: Container(
        width: (MediaQuery.of(context).size.width - 56) / 3,
        height: (MediaQuery.of(context).size.width - 56) / 3,
        decoration: new BoxDecoration(
          color: Colors.blue.withOpacity(0.2),
          image: new DecorationImage(
            image: image ?? Image.asset('assets/img/add_image.png').image,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _imagesPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: RichText(
            text: new TextSpan(
              // Note: Styles for TextSpans must be explicitly defined.
              // Child text spans will inherit styles from parent
              style: new TextStyle(
                  fontSize: 14.0,
                  color: Colors.black54,
                  fontWeight: FontWeight.w300),
              children: <TextSpan>[
                TextSpan(
                  text: "Autres photos",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
                ),
                TextSpan(
                  text: "\n(Vous pouvez ajouter jusqu'à 10 photos)",
                ),
              ],
            ),
          ),
        ),
        widget.images.isEmpty
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  style: flatButtonStyle,
                  child: Row(
                    children: <Widget>[
                      Spacer(),
                      Icon(
                        Icons.camera_alt,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Ajouter des images",
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                  onPressed: () => _addImage(false),
                ),
              )
            : Container(
                width: 0,
                height: 0,
              ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: widget.images.isNotEmpty
              ? buildGridView()
              : Container(
                  width: 0,
                  height: 0,
                ),
        ),
      ],
    );
  }

  Widget _imagePV() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: RichText(
            text: new TextSpan(
              // Note: Styles for TextSpans must be explicitly defined.
              // Child text spans will inherit styles from parent
              style: new TextStyle(
                  fontSize: 14.0,
                  color: Colors.black54,
                  fontWeight: FontWeight.w300),
              children: <TextSpan>[
                TextSpan(
                  text: "Photo de PV",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: photoPV.isEmpty
                ? GestureDetector(
                    child: _imageItem(null),
                    onTap: () => _addImage(true),
                  )
                : _canRemovePV(_imageItem(
                    Image.file(File.fromUri(Uri.tryParse('$photoPV'))).image))),
      ],
    );
  }

  Widget buildGridView() {
    List imagesGrid = [];
    imagesGrid.addAll(widget.images.map((i) => Uri.parse(i)?.host != ""
        ? _imageItem(NetworkImage(i))
        : _imageItem(Image.file(File.fromUri(Uri.tryParse('$i'))).image)));
    int realLength = widget.images.length;
    if (imagesGrid.length < widget.maxImages) {
      imagesGrid.add(
        GestureDetector(
          child: _imageItem(null),
          onTap: () => _addImage(false),
        ),
      );
    }
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        children: List.generate(imagesGrid.length, (index) {
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: index < realLength
                ? _canRemove(imagesGrid[index], index)
                : imagesGrid[index],
          );
        }),
      ),
    );
  }

  void showCupertinoActionSheet({BuildContext context, Widget child}) {
    showCupertinoModalPopup<String>(
      context: context,
      builder: (BuildContext context) => child,
    ).then((String value) {
      print('[[[[ Selected Value ]]]] $value');
    });
  }

  _addImage(bool isPV) {
    if (widget.images.length == widget.maxImages) {
      Utils.showSnackBarError(
          context, "Vous pouvez attaché jusqu'a ${widget.maxImages} max !");
      return;
    }

    // bottom sheet with cupertino style
    showCupertinoActionSheet(
      context: context,
      child: CupertinoActionSheet(
          title: const Text('Ajouter une image'),
          message: const Text(
              'Veuillez sélectionner la méthode que vous souhaitez utiliser pour ajouter une image.'),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: const Text(
                'Utiliser la caméra',
                style: TextStyle(color: Colors.lightBlue),
              ),
              onPressed: () {
                Navigator.pop(context, 'Utiliser la caméra');
                _takePhoto(isPV);
              },
            ),
            CupertinoActionSheetAction(
              child: const Text(
                'Sélectionner dans la galerie',
                style: TextStyle(color: Colors.lightBlue),
              ),
              onPressed: () {
                Navigator.pop(context, 'Sélectionner dans la galerie');
                _pickPhoto(isPV);
              },
            )
          ],
          cancelButton: CupertinoActionSheetAction(
            child: const Text(
              'Annuler',
              style: TextStyle(color: Colors.blue),
            ),
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context, 'Annuler');
            },
          )),
    );
  }

  showImage(imageFile) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HeroPhotoViewWrapper(
                  imageProvider: imageFile,
                ),
            fullscreenDialog: true));
  }

  Widget _canRemove(Widget w, int index) {
    return Stack(
      children: <Widget>[
        w,
        IconButton(
          icon: Icon(
            FontAwesomeIcons.trash,
            color: Colors.lightBlue,
            size: 20,
          ),
          onPressed: () {
            setState(() {
              widget.images.removeAt(index);
            });
          },
          padding: EdgeInsets.all(0.0),
        ),
      ],
    );
  }

  Widget _canRemovePV(Widget w) {
    return Stack(
      children: <Widget>[
        w,
        IconButton(
          icon: Icon(
            FontAwesomeIcons.trash,
            color: Colors.lightBlue,
            size: 20,
          ),
          onPressed: () {
            setState(() {
              photoPV = "";
            });
          },
          padding: EdgeInsets.all(0.0),
        ),
      ],
    );
  }
}
