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
import 'package:path_provider/path_provider.dart';

class URLImageAnalyzer extends StatefulWidget {
  static String id = 'home_screen';

  final String modelPath;
  URLImageAnalyzer({@required this.modelPath});

  @override
  _URLImageAnalyzerState createState() => _URLImageAnalyzerState();
}

class _URLImageAnalyzerState extends State<URLImageAnalyzer> {
  File img;
  String imgURL;
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
            "Here is the output image! Click on it to see it in full screen, then tap to switch between the original and processed version";
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
            "Enter the URL of the image you want to process",
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

  void downloadImage(urlImg) async {
    //comment out the next two lines to prevent the device from getting
    // the image from the web in order to prove that the picture is
    // coming from the device instead of the web.
//    var url =
//        "https://www.tottus.cl/static/img/productos/20104355_2.jpg"; // <-- 1
    var url = urlImg; // <-- 1
    var response = await http.get(url); // <--2
    var documentDirectory = await getApplicationDocumentsDirectory();
    var firstPath = documentDirectory.path + "/images";
    var filePathAndName = documentDirectory.path + '/images/pic.jpg';
    //comment out the next three lines to prevent the image from being saved
    //to the device to show that it's coming from the internet
    await Directory(firstPath).create(recursive: true); // <-- 1
    File file2 = new File(filePathAndName); // <-- 2
    file2.writeAsBytesSync(response.bodyBytes); // <-- 3
    img = file2;
    upload(img);
    setState(() {
      status = STATUS_IMAGE_LOADED;
    });
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
                status == STATUS_WAIT
                    ? TextField(
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.top,
                        style: TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          fillColor: Colors.blue,
                          hintText: 'Image URL',
                        ),
                        onChanged: (text) {
                          imgURL = text;
                        },
                      )
                    : Text(""),
                RaisedButton(
                  child: Text("Analyze !"),
                  onPressed: () {
                    downloadImage(imgURL);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
