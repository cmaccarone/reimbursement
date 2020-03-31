import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
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

  Future getImage() async {
    var image;

    //todo add dialog to choose between gallery and camera.

    Popup popup = Popup(
      title: "Choose a Photo",
      subtitle: "Pick a Source",
      firstButtonText: "Gallery",
      secondButtonText: "Take Picture",
      cancelText: "Cancel",
      onPressedFirst: () async {
        Navigator.of(context, rootNavigator: true).pop();
        image = await ImagePicker.pickImage(source: ImageSource.gallery);
        setState(() {
          _image = image;
        });
      },
      onPressedSecond: () async {
        Navigator.of(context, rootNavigator: true).pop();
        image = await ImagePicker.pickImage(source: ImageSource.camera);
        setState(() {
          _image = image;
        });
      },
    );
    popup.show(context);
    print(image);
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
                    getImage();
                  },
                  child: Stack(
                    children: <Widget>[
                      Container(
                          child: Image(
                              fit: BoxFit.cover,
                              height: queryData.size.height / 3,
                              width: double.infinity,
                              //todo add in user profile Image
                              image: _image == null
                                  ? AssetImage("assets/profilePic.jpg")
                                  : FileImage(_image))),
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

class Popup {
  Popup(
      {@required this.title,
      this.subtitle,
      this.firstButtonText,
      this.secondButtonText,
      this.cancelText,
      @required this.onPressedFirst,
      @required this.onPressedSecond});

  String title;
  String subtitle;
  String cancelText;
  String firstButtonText;
  String secondButtonText;
  Function onPressedFirst;
  Function onPressedSecond;
  bool topIsDefault;

  AlertDialog _showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget firstButton = FlatButton(
      child: Text(firstButtonText),
      onPressed: onPressedFirst,
    );
    Widget secondButton = FlatButton(
      child: Text(secondButtonText),
      onPressed: onPressedSecond,
    );
    Widget cancelButton = FlatButton(
      child: Text(cancelText),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(subtitle),
      actions: [firstButton, secondButton, cancelButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<Widget> show(BuildContext context) async {
    return Platform.isIOS
        ? showCupertinoModalPopup(
            context: context,
            builder: (BuildContext context) => CupertinoActionSheet(
                  message: Text(subtitle),
                  title: Text(title),
                  cancelButton: CupertinoActionSheetAction(
                    onPressed: () {
                      Navigator.pop(context, 'cancel');
                    },
                    isDefaultAction: false,
                    isDestructiveAction: false,
                    child: Text(cancelText),
                  ),
                  actions: <Widget>[
                    CupertinoActionSheetAction(
                      onPressed: onPressedFirst,
                      isDestructiveAction: false,
                      child: Text(firstButtonText),
                    ),
                    CupertinoActionSheetAction(
                      onPressed: onPressedSecond,
                      isDestructiveAction: false,
                      child: Text(secondButtonText),
                    )
                  ],
                ))
        : _showAlertDialog(context);
  }
}
