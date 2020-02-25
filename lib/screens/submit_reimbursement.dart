import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:reimbursement/constants.dart';
import 'package:reimbursement/model/receipt.dart';
import 'package:reimbursement/providers/reimbursement_provider.dart';
import 'package:reimbursement/providers/user_provider.dart';
import 'package:reimbursement/widgets.dart';

import 'cameraPreviewScreen.dart';

class SubmitReimbursementScreen extends StatefulWidget {
  @override
  _SubmitReimbursementScreenState createState() =>
      _SubmitReimbursementScreenState();
}

class _SubmitReimbursementScreenState extends State<SubmitReimbursementScreen> {
  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Please fill in all the fields"),
          content: new Text("We need all info to submit the reimbursement"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  List<CameraDescription> cameras;

  CameraDescription firstCamera;

  void _getCameras() async {
    cameras = await availableCameras();
    firstCamera = cameras.first;

    // Get a specific camera from the list of available cameras.
  }

  String description;

  String notes;

  String amountField;

  String picturePath;

  TextEditingController descriptionController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  TextEditingController amountController = TextEditingController();

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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      SignInTextFields(
                        hideText: false,
                        inputLabel: "Description",
                        controller: descriptionController,
                        onChanged: (value) {
                          description = value;
                          print(value);
                        },
                      ),
                      SignInTextFields(
                        hideText: false,
                        inputLabel: "notes",
                        controller: notesController,
                        onChanged: (value) {
                          notes = value;
                          print(value);
                        },
                      ),
                      SignInTextFields(
                        hideText: false,
                        inputLabel: "amount",
                        inputType: TextInputType.numberWithOptions(
                            signed: false, decimal: true),
                        controller: amountController,
                        onChanged: (value) {
                          amountField = value;
                          print(value);
                        },
                      ),
                    ],
                  ),
                ),
                FlatButton(
                  child: CircleAvatar(child: Icon(Icons.photo_camera)),
                  onPressed: () async {
                    _getCameras();
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
                SubmitButton(
                  label: "Submit Reimbursement",
                  onTapped: () async {
                    setState(() {
                      if ((description != null) &&
                          (amountField != null) &&
                          (description != null)) {
                        Receipt reimbursement = Receipt(
                            submittedByUUID: userData.currentUser.uid,
                            reimbursed: false,
                            amount: double.parse(amountField),
                            approvedBy: "",
                            description: description,
                            notes: notes,
                            reimburseTo: userData.currentUser.email);
                        print(amountField);
                        print(notes);
                        Provider.of<ReimbursementProvider>(context,
                                listen: false)
                            .requestReimbursement(
                                reimbursement: reimbursement,
                                approvedTrip: reimbursement.tripApproval);
                        notesController.clear();
                        descriptionController.clear();
                        amountController.clear();
                      } else {
                        _showDialog();
                      }
                    });
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
