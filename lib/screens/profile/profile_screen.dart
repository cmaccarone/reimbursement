import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:option_picker/option_picker.dart';
import 'package:provider/provider.dart';
import 'package:reimbursement/providers/reimbursement_provider.dart';
import 'package:reimbursement/providers/user_provider.dart';
import 'package:reimbursement/screens/SignIn/welcome.dart';
import 'package:reimbursement/screens/misc_reusable/constants.dart';
import 'package:reimbursement/screens/misc_reusable/widgets.dart';
import 'package:reimbursement/screens/profile/SubmitBug.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File _image;
  FirebaseUser user;
  bool isVisible = false;
  double currentProgress;
  Color color = Colors.white;

  void uploadImage({ImageSource source, BuildContext context}) async {
    var image = await ImagePicker.pickImage(source: source, imageQuality: 50);
    Provider.of<ReimbursementProvider>(context, listen: false)
        .uploadProfilePicture(
            file: image,
            fileUploading: (progress) {
              currentProgress = progress;
              if (progress < 1) {
                setState(() {
                  isVisible = true;
                });
              } else {
                setState(() {
                  isVisible = false;
                  _image = image;
                });
              }
            });
  }

  Future getImage(BuildContext context) async {
    var image;

    //todo add dialog to choose between gallery and camera.

    OptionPicker.show(
      context: context,
      title: "Choose a Photo",
      subtitle: "Pick a Source",
      firstButtonText: "Gallery",
      secondButtonText: "Take Picture",
      cancelText: "Cancel",
      onPressedFirst: () async {
        uploadImage(source: ImageSource.gallery, context: context);
      },
      onPressedSecond: () async {
        uploadImage(source: ImageSource.camera, context: context);
      },
    );
  }

  void getUser() async {
    user = await FirebaseAuth.instance.currentUser();
  }

  bool toggle({bool bool}) {
    if (bool == null) {
      return bool = true;
    } else if (bool == true) {
      return bool = false;
    } else {
      return bool = true;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
    _image = File("assets/profilePic.jpg");
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    FirebaseAuth _auth = FirebaseAuth.instance;

    return Consumer<UserProvider>(
      builder: (context, userData, child) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: kAppbarColor,
            body: ConstrainedScrollView(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () async {
                    getImage(context);
                  },
                  child: Stack(
                    children: <Widget>[
                      Container(
                        child: isVisible
                            ? Padding(
                                padding: EdgeInsets.all(40),
                                child: Center(
                                  child: Container(
                                    color: Colors.white.withOpacity(.3),
                                    width: double.infinity,
                                    height: 50,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 24.0),
                                    child: LiquidLinearProgressIndicator(
                                      direction: Axis.horizontal,
                                      valueColor:
                                          AlwaysStoppedAnimation(Colors.blue),
                                      center: Text(
                                        "Uploading Image ${(currentProgress * 100).round()}%",
                                        style: TextStyle(
                                            color: Colors.lightBlueAccent),
                                      ),
                                      value: currentProgress,
                                      backgroundColor:
                                          Colors.black12.withOpacity(.2),
                                      borderColor: Colors.white,
                                      borderRadius: 22,
                                      borderWidth: 0,
                                    ),
                                  ),
                                ),
                              )
                            : Image(
                                fit: BoxFit.cover,
                                height: queryData.size.height / 3,
                                width: double.infinity,
                                //todo add in user profile Image
                                image: userData.profilePicURL != null
                                    ? NetworkImage(userData.profilePicURL)
                                    : FileImage(_image)),
                      )
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
                    'REPORT A BUG / SUGGEST IMPROVEMENT',
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
