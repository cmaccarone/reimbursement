import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reimbursement/constants.dart';
import 'package:reimbursement/model/user.dart';
import 'package:reimbursement/screens/cameraPreviewScreen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    List<CameraDescription> cameras;
    CameraDescription firstCamera;

    Future<CameraDescription> _getCameras() async {
      cameras = await availableCameras();
      firstCamera = cameras.first;

      // Get a specific camera from the list of available cameras.
    }

    FirebaseAuth _auth = FirebaseAuth.instance;

    return Consumer<User>(
      builder: (context, userData, child) {
        return Scaffold(
          backgroundColor: Colors.lightBlueAccent,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Container(
                    padding: EdgeInsets.all(60),
                    child: Text(
                      'Profile & Settings',
                      style: kTitleStyle,
                    )),
              ),
              FlatButton(
                child: CircleAvatar(
                  radius: 85,
                  child: Icon(
                    Icons.photo_camera,
                    size: 50,
                  ),
                ),
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
              ),
              FlatButton(
                child: Text(
                  'Sign Out',
                  style: kRegularText.copyWith(color: Colors.black54),
                ),
                onPressed: () async {
                  await _auth.signOut();
                  Navigator.pop(context);
                },
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '${userData.currentUserEmail}',
                style: kSubHeadingText,
              ),
              SizedBox(
                height: 40,
              ),
              Column(
                children: <Widget>[
                  Text(
                    'Address:',
                    style: kSubTitleText,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '   ${userData.address}\n   ${userData.city} ${userData.state}, ${userData.zipCode}',
                    style: kRegularText,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    'Payment Method:',
                    style: kSubTitleText,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '   ${userData.paymentMethod ?? "0"}',
                    style: kRegularText,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    'User Type:',
                    style: kSubTitleText,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '   ${userData.userType ?? "0"}',
                    style: kRegularText,
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
