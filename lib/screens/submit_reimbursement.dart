import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reimbursement/constants.dart';
import 'package:reimbursement/providers/user_provider.dart';

import 'cameraPreviewScreen.dart';

class SubmitReimbursementScreen extends StatelessWidget {
  List<CameraDescription> cameras;
  CameraDescription firstCamera;

  Future<CameraDescription> _getCameras() async {
    cameras = await availableCameras();
    firstCamera = cameras.first;

    // Get a specific camera from the list of available cameras.
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userData, child) {
        return Scaffold(
          backgroundColor: Colors.lightBlueAccent,
          body: Container(
            padding: EdgeInsets.only(top: 60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding:
                      EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
                  color: Colors.white70,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        'pending approval..',
                        style: TextStyle(color: Colors.black45),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: <Widget>[
                            CircleAvatar(
                              backgroundColor: Colors.green,
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: Icon(
                                Icons.airplanemode_active,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            CircleAvatar(
                              child: Icon(
                                Icons.school,
                                color: Colors.white,
                              ),
                              backgroundColor: Colors.blue,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'Select Category',
                  style: kTitleStyle,
                ),
                FlatButton(
                  child: CircleAvatar(child: Icon(Icons.photo_camera)),
                  onPressed: () async {
                    await _getCameras();
                    print("cameras $cameras");
                    Navigator.push(
                      (context),
                      MaterialPageRoute(
                        builder: (context) => CameraPreviewScreen(
                          cameras: cameras,
                          camera: firstCamera,
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
