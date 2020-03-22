import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path/path.dart';

class DisplayPictureScreen extends StatefulWidget {
  DisplayPictureScreen({this.imagePath});

  final String imagePath;

  @override
  _DisplayPictureScreenState createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Firestore _firestore = Firestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;

  void uploadImage(Image image) {
    basename(widget.imagePath);
  }

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
