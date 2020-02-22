import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:reimbursement/model/receipt.dart';
import 'package:reimbursement/model/tripApproval.dart';
import 'package:uuid/uuid.dart';

import 'databaseFields.dart';

class Reimbursement {
  final String reimbursementID;
  DateTime timeSubmitted = DateTime.now();
  DateTime timeReimbursed;
  List<Receipt> receipts;
  bool approved;
  double amount;
  bool reimbursed = false;
  String reimburseTo;
  String approvedBy;
  String submittedByUUID;
  List<String> photoURLS;
  String description;
  String notes;
  TripApproval tripApproval;

  Reimbursement(
      {@required this.submittedByUUID,
      this.reimbursed = false,
      this.amount,
      this.photoURLS,
      this.approved,
      this.approvedBy,
      this.receipts,
      this.timeReimbursed,
      this.description,
      this.notes,
      this.reimburseTo,
      this.tripApproval})
      : this.reimbursementID = Uuid().v1();

  Reimbursement.fromSnapshot({DocumentSnapshot snapshot})
      : amount = double.parse(snapshot[ReimbursementFields.amount]),
        timeSubmitted = snapshot[ReimbursementFields.timeSubmitted],
        reimburseTo = snapshot[ReimbursementFields.submittedBy],
        timeReimbursed = snapshot[ReimbursementFields.timeReimbursed],
        submittedByUUID = snapshot[ReimbursementFields.submittedByID],
        reimbursementID = snapshot[ReimbursementFields.reimbursementID],
        notes = snapshot[ReimbursementFields.notes],
        description = snapshot[ReimbursementFields.description],
        tripApproval = TripApproval.fromSnapshot(
            snapshotData: snapshot[ReimbursementFields.tripApproval]);

  Map<String, dynamic> toMap(Reimbursement reimbursement) {
    return {
      ReimbursementFields.reimbursementID: reimbursement.reimbursementID,
      ReimbursementFields.amount: reimbursement.amount.toString(),
      ReimbursementFields.timeReimbursed: reimbursement.timeReimbursed,
      ReimbursementFields.submittedBy: reimbursement.reimburseTo,
      ReimbursementFields.pictureURLs: reimbursement.photoURLS,
      ReimbursementFields.reimbursed: reimbursement.reimbursed,
      ReimbursementFields.timeSubmitted: reimbursement.timeSubmitted,
      ReimbursementFields.notes: reimbursement.notes,
      ReimbursementFields.description: reimbursement.description,
      ReimbursementFields.tripApproval: tripApproval.toMap(tripApproval)
    };
  }
}

//class AutoInsurance extends Reimbursement {
//
//
//  int remunerationRate;
//  DateTime policyStartingDate;
//  DateTime policyEndingDate;
//
//  double premium1;
//  double premium2;
//
//  double getReimbursementAmount() {
//    double average;
//    double numberOfVehiclesAllowanceFactor;
//    if (premium1 != null && premium2 != null) {
//      average = (premium1 + premium2) / 2;
//      numberOfVehiclesAllowanceFactor = 1.6;
//    } else {
//      average = premium1;
//      numberOfVehiclesAllowanceFactor = 1;
//    }
//    double maxReimbursement = average * numberOfVehiclesAllowanceFactor;
//    return maxReimbursement - _getDeductible();
//  }
//
//  //todo: when reimbursement has been approved add it to a master AASI list to be downloaded into the CSV file.
//
//  double _policyLength({DateTime startDate, DateTime endDate}) {
//    return endDate.difference(startDate).inDays / 30;
//  }
//
//  int _getDeductible() {
//    int deductible =
//        (((_policyLength() / 12) * .165) * remunerationRate).round();
//    return _roundToNearest(input: deductible.toDouble(), roundTo: 5);
//  }
//
//  int _roundToNearest({double input, double roundTo}) {
//    int divisor = (input ~/ roundTo);
//    return (divisor * roundTo).toInt();
//  }
//}
//
//class SpecialTravel extends Reimbursement {
//  @override
//  void set approved(bool _approved) {
//    // TODO: implement approved
//    super.approved = _approved;
//  }
//}
