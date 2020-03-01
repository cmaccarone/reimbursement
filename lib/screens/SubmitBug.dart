import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:reimbursement/constants.dart';
import 'package:reimbursement/model/bug.dart';
import 'package:reimbursement/providers/reimbursement_provider.dart';
import 'package:reimbursement/providers/user_provider.dart';

class SubmitBug extends StatefulWidget {
  @override
  _SubmitBugState createState() => _SubmitBugState();
}

class _SubmitBugState extends State<SubmitBug> {
  String reportText;
  bool _isTextFieldAndButtonVisible = true;
  double _paddings = 24.5;
  double _height = 2000;
  double _width = 20000;
  String _thankYou = "SUBMIT A BUG REPORT";
  TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userData, child) =>
          AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Scaffold(
            backgroundColor: kBackGroundColor,
            body: SafeArea(
              child: AnimatedPadding(
                duration: Duration(milliseconds: 180),
                padding: EdgeInsets.fromLTRB(24.5, _paddings, 24.5, _paddings),
                child: AnimatedContainer(
                  duration: Duration(seconds: 1),
                  onEnd: () {
                    Navigator.pop(context);
                  },
                  width: _width,
                  height: _height,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(33, 26, 33, 29),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                          _thankYou,
                          style: kTitleStyle.copyWith(fontSize: 26),
                        ),
                        _isTextFieldAndButtonVisible
                            ? Expanded(
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(0, 28, 0, 19),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: kSoftWhiteTextColor),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          19.5, 19.5, 19.5, 19.5),
                                      child: TextField(
                                        onChanged: (value) {
                                          setState(() {
                                            reportText = value;
                                            print(value);
                                          });
                                        },
                                        controller: controller,
                                        style: TextStyle(
                                            color: Color.fromRGBO(3, 11, 21, 1),
                                            fontSize: 16),
                                        decoration: InputDecoration(
                                            border: InputBorder.none),
                                        maxLength: 700,
                                        maxLines: 500,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox(),
                        _isTextFieldAndButtonVisible
                            ? Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: kTealColor),
                                child: FlatButton(
                                  onPressed: () async {
                                    setState(() {
                                      _paddings = 360;
                                      _height = 100;
                                      _thankYou = "Thanks!";
                                      _isTextFieldAndButtonVisible = false;
                                    });
                                    Bug bug = Bug(
                                        reporterEmail: userData.email,
                                        reporterName:
                                            "${userData.firstName} ${userData.lastName}",
                                        reportText: reportText,
                                        reporterUserType: userData.userType);
                                    Provider.of<ReimbursementProvider>(context,
                                            listen: false)
                                        .reportBug(bug: bug);
                                  },
                                  child: Text(
                                    'Submit Report',
                                    style: kSubmitBugReportStlye,
                                  ),
                                ),
                              )
                            : SizedBox(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
