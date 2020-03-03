import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reimbursement/providers/user_provider.dart';
import 'package:reimbursement/screens/SignIn/welcome.dart';
import 'package:reimbursement/screens/camera/takePictureScreen.dart';
import 'package:reimbursement/screens/misc_reusable/constants.dart';
import 'package:reimbursement/screens/profile/SubmitBug.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    List<CameraDescription> cameras;
    CameraDescription firstCamera;

    void _getCameras() async {
      cameras = await availableCameras();
      firstCamera = cameras.first;

      // Get a specific camera from the list of available cameras.
    }

    FirebaseAuth _auth = FirebaseAuth.instance;

    return Consumer<UserProvider>(
      builder: (context, userData, child) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: kAppbarColor,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: () async {
                    _getCameras();
                    Navigator.push(
                      (context),
                      MaterialPageRoute(
                        builder: (context) => TakePictureScreen(
                          cameras: cameras,
                          camera: firstCamera,
                        ),
                      ),
                    );
                  },
                  child: Stack(
                    children: <Widget>[
                      Container(
                          child: Image(
                              //todo add in user profile Image
                              image: AssetImage("assets/profilePic.jpg"))),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(60, 40, 60, 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        "${userData.firstName} ${userData.lastName}",
                        style: kProfileTitleTextStyle,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      //insert ListView Builder Here
                      Row(
                        children: <Widget>[
                          UserTypePill(userType: userData.userType)
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),

                      Text(
                        "EMAIL",
                        style: kSoftSubtitleTextStyle,
                      ),
                      Text(
                        userData.email,
                        style: kProfileTitleTextStyle,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "ADDRESS",
                        style: kSoftSubtitleTextStyle,
                      ),
                      Text(
                        '${userData.address}\n${userData.city} ${userData.state}, ${userData.zipCode}',
                        style: kProfileTitleTextStyle,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "ACH",
                        style: kSoftSubtitleTextStyle,
                      ),
                      Text(
                        userData.payMeBy.toUpperCase(),
                        style: kProfileTitleTextStyle,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 2,
                        color: kSoftWhiteTextColor,
                      )
                    ],
                  ),
                ),
                FlatButton(
                  child: Text(
                    'SIGN OUT',
                    style: kRegularText.copyWith(color: Colors.black54),
                  ),
                  onPressed: () async {
                    await _auth.signOut();
                    Navigator.of(context, rootNavigator: true)
                        .pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => WelcomeScreen()),
                            (_) => false);
                  },
                ),
                FlatButton(
                  child: Text(
                    'REPORT A BUG',
                    style: kRegularText.copyWith(color: kEmployeePillColor),
                  ),
                  onPressed: () async {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => SubmitBug()));
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class UserTypePill extends StatelessWidget {
  UserTypePill({this.userType});
  final String userType;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: userType == Users.employee
            ? kEmployeePillColor
            : userType == Users.admin ? kAdminPillColor : kTreasuryPillColor,
      ),
      child: Text(
        userType.toUpperCase(),
        style: kPillTextStyle,
      ),
    );
  }
}
