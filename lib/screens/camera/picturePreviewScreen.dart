import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class DisplayPictureScreen extends StatefulWidget {
  DisplayPictureScreen({this.imagePath});

  final String imagePath;

  @override
  _DisplayPictureScreenState createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Picture Preview",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
        actions: <Widget>[
          FlatButton(
            child: Text(
              "Save",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            onPressed: () {
              print("photo saved");
            },
          ),
        ],
      ),
      body: Image.file(
        File(widget.imagePath),
      ),
    );
  }
}
