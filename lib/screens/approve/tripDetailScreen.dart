import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reimbursement/model/tripApproval.dart';
import 'package:reimbursement/providers/reimbursement_provider.dart';
import 'package:reimbursement/screens/misc_reusable/constants.dart';

class TripDetailScreen extends StatelessWidget {
  final TripApproval trip;

  TripDetailScreen({this.trip});

  @override
  Widget build(BuildContext context) {
    print("screen displayed");
    return Scaffold(
      backgroundColor: kBackGroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(trip.tripName),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(kPadding, 33, kPadding, kPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "${trip.requestedBy}",
                  style: kTitleStyle.copyWith(color: kSoftWhiteTextColor),
                ),
                Text(
                  "${trip.tripName}",
                  style: kTitleStyle.copyWith(
                      fontSize: 30, color: kSoftWhiteTextColor),
                ),
                SizedBox(height: 60),
                Row(
                  children: <Widget>[
                    Text("Dates:",
                        style: kSoftSubtitleTextStyle.copyWith(
                            color: kSoftWhiteTextColor, fontSize: 20)),
                    Text(
                      "  ${trip.tripStartDate.month}/${trip.tripStartDate.day}/${trip.tripStartDate.year} - ${trip.tripEndDate.month}/${trip.tripEndDate.day}/${trip.tripEndDate.year} ",
                      style:
                          TextStyle(color: kSoftWhiteTextColor, fontSize: 20),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: <Widget>[
                    Text(
                      "Estimated Cost:",
                      style: TextStyle(
                          color: kSoftWhiteTextColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "  ${trip.requestedCost}",
                      style:
                          TextStyle(color: kSoftWhiteTextColor, fontSize: 20),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: <Widget>[
                    Text(
                      "Remaining Budget:",
                      style: TextStyle(
                          color: kSoftWhiteTextColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      " Feature Still in \n Development",
                      style: TextStyle(
                        color: kSoftWhiteTextColor,
                        fontSize: 20,
                      ),
                      maxLines: 5,
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    FlatButton(
                      child: CircleAvatar(
                        backgroundColor: kTealColor,
                        child: Icon(Icons.close),
                      ),
                      onPressed: () {
                        trip.approved = ApprovalState.denied;
                        Provider.of<ReimbursementProvider>(context,
                                listen: false)
                            .approveOrDenyTrip(tripApproval: trip);
                        Navigator.of(context).pop();
                      },
                    ),
                    Text(
                      "Deny",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    FlatButton(
                      child: CircleAvatar(
                        backgroundColor: kApprovalGreen,
                        child: Icon(Icons.check),
                      ),
                      onPressed: () {
                        trip.approved = ApprovalState.approved;
                        Provider.of<ReimbursementProvider>(context,
                                listen: false)
                            .approveOrDenyTrip(tripApproval: trip);
                        Navigator.of(context).pop();
                      },
                    ),
                    Text(
                      "Approve",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
