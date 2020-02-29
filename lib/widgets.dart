import 'package:flutter/material.dart';
import 'package:reimbursement/model/tripApproval.dart';

import 'constants.dart';
import 'model/my_custom_icons_icons.dart';
import 'screens/approve_screen.dart';
import 'screens/completedTripsScreen.dart';
import 'screens/profile_screen.dart';
import 'screens/requestApprovalScreen.dart';

class ReimbursementCell extends StatelessWidget {
  Function onPressed;
  final String title;
  final bool approvalStatus;
  final String reimbursementTotal;

  ReimbursementCell(
      {this.onPressed,
      this.title,
      this.reimbursementTotal,
      this.approvalStatus});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: onPressed,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                Icons.airplanemode_active,
                color: Colors.blueAccent,
                size: 50,
              ),
              SizedBox(
                width: 50,
              ),
              Column(
                children: <Widget>[
                  Text(title),
                  Text(
                    approvalStatus ? "approved" : "denied" ?? "pending",
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
              SizedBox(
                width: 50,
              ),
              Text(
                reimbursementTotal,
                style: TextStyle(color: Colors.green),
              )
            ],
          ),
          Text("--------------------------------------------")
        ],
      ),
    );
  }
}

class TripCell extends StatelessWidget {
  Function onPressed;
  final String title;
  final String approvalStatus;
  final String reimbursementTotal;
  Function(DismissDirection) onDismissed;

  TripCell(
      {this.onDismissed,
      this.onPressed,
      this.title,
      this.reimbursementTotal,
      this.approvalStatus});

  @override
  Widget build(BuildContext context) {
    return approvalStatus == ApprovalState.pending ||
            approvalStatus == ApprovalState.denied
        ? Dismissible(
            onDismissed: (direction) {
              onDismissed(direction);
            },
            direction: DismissDirection.endToStart,
            background: Container(
                padding: EdgeInsets.all(10),
                alignment: Alignment.centerRight,
                color: kCancelColor,
                child: Text(
                  "CANCEL",
                  style: TextStyle(color: Colors.white),
                )),
            key: UniqueKey(),
            child: FlatButton(
              color: kTripCellColor,
              onPressed: onPressed,
              child: Container(
                color: kTripCellColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(
                              Icons.airplanemode_active,
                              color: Colors.blueAccent,
                              size: 30,
                            ),
                            SizedBox(
                              width: 40,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(title),
                                Text(approvalStatus,
                                    style: approvalStatus ==
                                            ApprovalState.approved
                                        ? TextStyle(color: Colors.green)
                                        : approvalStatus == ApprovalState.denied
                                            ? TextStyle(color: Colors.red)
                                            : TextStyle(color: Colors.orange)

//                    approvalStatus == ApprovalState.approved
//                        ?
//                        : ,
                                    ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              reimbursementTotal,
                              style: TextStyle(color: Colors.green),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      color: kTripCellShaddow,
                      height: 4,
                    ),
                  ],
                ),
              ),
            ),
          )
        : Dismissible(
            onDismissed: (direction) {
              onDismissed(direction);
            },
            background: Container(
                padding: EdgeInsets.all(10),
                alignment: Alignment.centerRight,
                color: kTealColor,
                child: Text(
                  "COMPLETE",
                  style: TextStyle(color: Colors.white),
                )),
            key: UniqueKey(),
            child: FlatButton(
              color: kTripCellColor,
              onPressed: onPressed,
              child: Container(
                color: kTripCellColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(
                              Icons.airplanemode_active,
                              color: Colors.blueAccent,
                              size: 30,
                            ),
                            SizedBox(
                              width: 40,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(title),
                                Text(approvalStatus,
                                    style: approvalStatus ==
                                            ApprovalState.approved
                                        ? TextStyle(color: Colors.green)
                                        : approvalStatus == ApprovalState.denied
                                            ? TextStyle(color: Colors.red)
                                            : TextStyle(color: Colors.orange)

//                    approvalStatus == ApprovalState.approved
//                        ?
//                        : ,
                                    ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              reimbursementTotal,
                              style: TextStyle(color: Colors.green),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      color: kTripCellShaddow,
                      height: 4,
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}

class ExpandedSection extends StatefulWidget {
  final Widget child;
  final bool expand;
  ExpandedSection({this.expand = false, this.child});

  @override
  _ExpandedSectionState createState() => _ExpandedSectionState();
}

class _ExpandedSectionState extends State<ExpandedSection>
    with SingleTickerProviderStateMixin {
  AnimationController expandController;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    prepareAnimations();
  }

  ///Setting up the animation
  void prepareAnimations() {
    expandController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    Animation curve = CurvedAnimation(
      parent: expandController,
      curve: Curves.fastOutSlowIn,
    );
    animation = Tween(begin: 0.0, end: 1.0).animate(curve)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void didUpdateWidget(ExpandedSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.expand) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
        axisAlignment: 1.0, sizeFactor: animation, child: widget.child);
  }
}

class SubmitButton extends StatelessWidget {
  SubmitButton({@required this.label, @required this.onTapped});

  final String label;
  final Function onTapped;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RaisedButton(
        color: kAppBarColor,
        child: Text(
          label,
          style: kFlatButtonTextStlye,
        ),
        onPressed: onTapped,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

class SignInTextFields extends StatelessWidget {
  SignInTextFields(
      {this.inputAction = TextInputAction.continueAction,
      @required this.inputLabel,
      this.hideText = false,
      @required this.onChanged,
      this.inputType,
      this.controller});

  final TextEditingController controller;
  final String inputLabel;
  final bool hideText;
  final Function onChanged;
  final TextInputAction inputAction;
  final TextInputType inputType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
          keyboardType: inputType,
          controller: controller,
          textInputAction: inputAction,
          onChanged: onChanged,
          obscureText: hideText,
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
          autofocus: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.blue,
            hintText: inputLabel,
            labelText: inputLabel,
            labelStyle: TextStyle(color: Colors.white),
            hintStyle:
                TextStyle(color: Colors.white30, fontStyle: FontStyle.italic),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.blueAccent)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                    color: Colors.redAccent, style: BorderStyle.solid)),
            disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.grey)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.white)),
          )),
    );
  }
}

List<Widget> adminTabs = [
  Tab(
    icon: Icon(
      Icons.person_outline,
    ),
  ),
  Tab(
    icon: Icon(Icons.attach_money),
  ),
  Tab(
    icon: Icon(Icons.list),
  ),
  Tab(
    icon: Icon(
      Icons.check,
    ),
  ),
];

List<Widget> treasuryTabs = [
  Tab(
    icon: Icon(
      Icons.person_outline,
    ),
  ),
  Tab(
    icon: Icon(Icons.attach_money),
  ),
  Tab(
    icon: Icon(Icons.list),
  ),
  Tab(
    icon: Icon(
      MyCustomIcons.account_cash__1_,
    ),
  ),
];

List<Widget> employeeTabs = [
  Tab(
    icon: Icon(
      Icons.person_outline,
    ),
  ),
  Tab(
    icon: Icon(Icons.attach_money),
  ),
  Tab(
    icon: Icon(Icons.list),
  ),
];

List<Widget> employeeScreens = [
  ProfileScreen(),
  RequestApprovalScreen(),
  CompletedTripsScreen(),
];

List<Widget> adminScreens = [
  ProfileScreen(),
  RequestApprovalScreen(),
  CompletedTripsScreen(),
  ApproveTripScreen()
];

List<Widget> treasuryScreens = [
  ProfileScreen(),
  RequestApprovalScreen(),
  CompletedTripsScreen(),
  ApproveTripScreen()
];
