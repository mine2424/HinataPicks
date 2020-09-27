import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getwidget/getwidget.dart';
import 'dart:math';

var cardAspectRatio = 12.0 / 16.0;
var widgetAspectRatio = cardAspectRatio * 1.2;

class BlogCardWidget extends StatelessWidget {
  var dataDocs;

  BlogCardWidget({this.dataDocs});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              color: Colors.black12, offset: Offset(3.0, 6.0), blurRadius: 10.0)
        ]),
        child: AspectRatio(
          aspectRatio: cardAspectRatio,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Image.network(dataDocs.get('imageUrl'), fit: BoxFit.cover),
              Align(
                alignment: Alignment.bottomLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Text(dataDocs.get('title'),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontFamily: "SF-Pro-Text-Regular")),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0, bottom: 12.0),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 22.0, vertical: 6.0),
                        decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Text("あとで読む",
                            style: TextStyle(color: Colors.white)),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
