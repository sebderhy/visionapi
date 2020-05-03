import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';

class ImageCompare extends StatefulWidget {
  static String id = 'image_compare';
  final File origImg;
  final Uint8List enhancedImage;
  ImageCompare({@required this.origImg, @required this.enhancedImage});

  @override
  _ImageCompareState createState() => _ImageCompareState();
}

class _ImageCompareState extends State<ImageCompare> {
  bool isEnhanced = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isEnhanced = !isEnhanced;
        });
      },
//      child: isEnhanced
//          ? Image.memory(
//              this.widget.enhancedImage,
//              fit: BoxFit.cover,
//              height: double.infinity,
//              width: double.infinity,
//              alignment: Alignment.center,
//            )
//          : Image.file(
//              this.widget.origImg,
//              fit: BoxFit.cover,
//              height: double.infinity,
//              width: double.infinity,
//              alignment: Alignment.center,
//            ),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
//          image: FileImage(this.widget.origImg),
            image: isEnhanced
                ? MemoryImage(this.widget.enhancedImage)
                : FileImage(this.widget.origImg),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
