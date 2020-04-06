import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:provider/provider.dart';
import 'package:reimbursement/providers/user_provider.dart';
import 'package:reimbursement/screens/misc_reusable/constants.dart';
import 'package:reimbursement/screens/misc_reusable/routes.dart';
import 'package:reimbursement/screens/misc_reusable/widgets.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(kTabBarColor);
    return Consumer<UserProvider>(
      builder: (context, userData, child) {
        return Scaffold(
          backgroundColor: Colors.lightBlueAccent,
          body: SafeArea(
            child: Container(
              padding: EdgeInsets.all(50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Hero(
                      tag: 'dollar',
                      child: CircleAvatar(
                        child: Icon(
                          Icons.attach_money,
                          size: 60,
                          color: Colors.white,
                        ),
                        radius: 40,
                        backgroundColor: Colors.greenAccent,
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                      child: Text(
                    'Reimbursements',
                    style: kTitleStyle,
                  )),
                  SizedBox(
                    height: 40,
                  ),
                  SubmitButton(
                    label: 'Login',
                    onTapped: () {
                      Navigator.pushNamed(context, Routes.loginScreen);
                    },
                  ),
                  SubmitButton(
                    label: 'Register',
                    onTapped: () {
                      Navigator.pushNamed(context, Routes.registerScreen);
                    },
                  ),
                  FlatButton(
                    child: Text(
                      'forgot your password?',
                      style: TextStyle(color: Colors.black45),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.resetPasswordScreen);
                    },
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
