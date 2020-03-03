import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'picturePreviewScreen.dart';

// #1 Add the required dependencies.
// #2 Get a list of the available cameras.
// #3 Create and initialize the CameraController.
// #4 Use a CameraPreview to display the camera’s feed.
// #5 Take a picture with the CameraController.
// #6 Display the picture with an Image widget.

class TakePictureScreen extends StatefulWidget {
  TakePictureScreen({this.camera, this.cameras});

  final CameraDescription camera;
  final List<CameraDescription> cameras;
  @override
  _TakePictureScreenState createState() => _TakePictureScreenState();
}

class _TakePictureScreenState extends State<TakePictureScreen> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  CameraDescription chosenCamera;
  List<CameraDescription> cameras;

  @override
  void initState() {
    super.initState();
    chosenCamera = widget.camera;
    cameras = widget.cameras;
    _controller = CameraController(chosenCamera, ResolutionPreset.veryHigh);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future _initCameraController(CameraDescription cameraDescription) async {
    if (_controller != null) {
      await _controller.dispose();
    }

    // 3
    _controller = CameraController(cameraDescription, ResolutionPreset.high);

    // If the controller is updated then update the UI.
    // 4
    _controller.addListener(() {
      // 5
      if (mounted) {
        setState(() {});
      }

      if (_controller.value.hasError) {
        print('Camera error ${_controller.value.errorDescription}');
      }
    });

    // 6
    try {
      await _controller.initialize();
    } on CameraException catch (e) {
      print(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

//toggles front and back cameras
  Future<void> _onCameraSwitch() async {
    CameraDescription camera =
        (_controller.description == cameras[0]) ? cameras[1] : cameras[0];
    _initCameraController(camera);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Take Picture",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Stack(
        children: <Widget>[
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return CameraPreview(_controller);
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FloatingActionButton(
                    heroTag: null,
                    child: Icon(
                      CupertinoIcons.switch_camera,
                    ),
                    onPressed: () {
                      setState(() {
                        _onCameraSwitch();
                      });
                    },
                  ),
                  FloatingActionButton(
                    heroTag: null,
                    child: Icon(
                      Icons.camera_alt,
                    ),
                    // Provide an onPressed callback.
                    onPressed: () async {
                      // Take the Picture in a try / catch block. If anything goes wrong,
                      // catch the error.
                      try {
                        // Ensure that the camera is initialized.
                        await _initializeControllerFuture;

                        // Construct the path where the image should be saved using the
                        // pattern package.
                        final path = join(
                          // Store the picture in the temp directory.
                          // Find the temp directory using the `path_provider` plugin.
                          (await getTemporaryDirectory()).path,
                          '${DateTime.now()}.png',
                        );

                        // Attempt to take a picture and log where it's been saved.
                        await _controller.takePicture(path);

                        // If the picture was taken, display it on a new screen.
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DisplayPictureScreen(imagePath: path),
                          ),
                        );
                      } catch (e) {
                        // If an error occurs, log the error to the console.
                        print(e);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
