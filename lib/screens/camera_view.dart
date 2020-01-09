import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

Future<CameraDescription> getCameras() async {
  final cameras = await availableCameras();
  return cameras.first;
}


class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {

  Future<void> _initializeControllerFuture;
  CameraController _controller;

  @override
  void initState() async {
    // TODO: implement initState
    super.initState();
    var camera = await getCameras();
    _controller = CameraController(camera,ResolutionPreset.medium,);
    var _initializeControllerFuture = _controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    final firstCamera = getCameras();
    return Scaffold(

        appBar: AppBar(title: Text(  'Take Picture',),),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[

            Center(
                child: FloatingActionButton(
                  child: Icon(Icons.camera),
                  onPressed: ()async{
                    //todo open camera
                    var camera = await getCameras();



                    print(camera);
                  },
                )),
            SizedBox(height: 30,),
          ],
        ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return Center(child: CircularProgressIndicator());
          }
        },
      )


    );
  }
}
