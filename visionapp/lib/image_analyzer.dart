import 'dart:convert';
import 'dart:ui';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:typed_data';
import 'image_compare.dart';
import 'constants.dart';

class ImageAnalyzer extends StatefulWidget {
  static String id = 'home_screen';

  final String modelPath;
  ImageAnalyzer({@required this.modelPath});

  @override
  _ImageAnalyzerState createState() => _ImageAnalyzerState();
}

class _ImageAnalyzerState extends State<ImageAnalyzer> {
  File img;
  Uint8List enhancedImage;
  int status = STATUS_WAIT;
  String strResponse = '';

  // The function which will upload the image as a file
  void upload(File imageFile) async {
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();

    String base = "http://visionapi.cloud/";

    var uri = Uri.parse(base + 'img2img/${widget.modelPath}/');

    var request = new http.MultipartRequest("POST", uri);
    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: basename(imageFile.path));

    request.files.add(multipartFile);
    var response = await request.send();
    enhancedImage = await response.stream.toBytes();

    setState(() {
      status = STATUS_FINISHED;
    });
  }

  void imagePicker(int a) async {
    setState(() {});
    debugPrint("Image Picker Activated");
    if (a == 0) {
      img = await ImagePicker.pickImage(source: ImageSource.camera);
    } else {
      img = await ImagePicker.pickImage(source: ImageSource.gallery);
    }

//    txt = "Analyzing...";
    debugPrint(img.toString());
    upload(img);
    setState(() {
      status = STATUS_IMAGE_LOADED;
    });
  }

  Widget textComments(BuildContext context) {
    String comment = '';
    switch (status) {
      case STATUS_WAIT:
        comment = "";
        break;
      case STATUS_IMAGE_LOADED:
        comment = "Processing image...";
        break;
      case STATUS_FINISHED:
        comment =
            "Here is the output image! Tap on it to see it in full screen. Then tap to switch between the original and processed version";
        break;
    }

    return Center(
      child: new Text(
        comment,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24.0,
        ),
      ),
    );
  }

  Widget result(BuildContext context) {
    if (enhancedImage != null) {
      return Image.memory(enhancedImage, fit: BoxFit.contain);
    } else {
      if (img != null) {
        return Image.file(img, fit: BoxFit.contain);
      } else {
        return Center(
          child: new Text(
            "Upload/capture the image you want to process",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text(APP_NAME),
      ),
      body: new Container(
        padding: EdgeInsets.symmetric(vertical: 25, horizontal: 25),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ImageCompare(
                                origImg: img,
                                enhancedImage: enhancedImage,
                              )),
                    );
                  },
                  child: result(context),
                ),
                textComments(context),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new FloatingActionButton(
                      heroTag: "camera",
                      onPressed: () {
                        imagePicker(0);
                      },
                      child: new Icon(Icons.camera_alt),
                    ),
                    new FloatingActionButton(
                        heroTag: "image_picker",
                        onPressed: () {
                          imagePicker(1);
                        },
                        child: new Icon(Icons.file_upload)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
