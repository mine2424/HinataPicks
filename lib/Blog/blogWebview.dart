import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';
import 'package:image_picker_saver/image_picker_saver.dart';

class BlogWebView extends StatefulWidget {
  var blogData;
  BlogWebView({Key key, @required this.blogData}) : super(key: key);
  @override
  _BlogWebViewState createState() => _BlogWebViewState();
}

class _BlogWebViewState extends State<BlogWebView> {
  List<String> _imageSelects = [];
  int count = 0;

  @override
  void initState() {
    super.initState();
    for (int i = 1; i < widget.blogData.length - 3; i++) {
      if (i == 1) {
        _imageSelects.add(widget.blogData['image']);
      } else {
        _imageSelects.add(widget.blogData['image$i']);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: GlobalKey(),
      appBar: AppBar(
        title: const Text("HinataPicks", style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        brightness: Brightness.light,
        centerTitle: true,
      ),
      body: WebView(
        key: GlobalKey(),
        initialUrl: widget.blogData["href"],
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }

  // void getImage(url) async {
  //   var response = await http.get(url);
  //   var filePath =
  //       await ImagePickerSaver.saveFile(fileData: response.bodyBytes);
  //   var savedFile = File.fromUri(Uri.file(filePath));
  //   print(savedFile);
  // }
}
