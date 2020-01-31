import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:reimbursement/model/receipt.dart';
import 'package:uuid/uuid.dart';

import 'databaseFields.dart';

class Reimbursement {
  final String reimbursementID = Uuid().v1();
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

  Reimbursement({
    @required this.submittedByUUID,
    this.reimbursed = false,
    this.amount,
    this.photoURLS,
    this.approved,
    this.approvedBy,
    this.receipts,
    this.timeReimbursed,
    this.reimburseTo,
  });

  Reimbursement.fromSnapshot({DocumentSnapshot snapshot})
      : amount = snapshot[ReimbursementFields.amount],
        timeSubmitted = snapshot[ReimbursementFields.timeSubmitted],
        reimburseTo = snapshot[ReimbursementFields.submittedBy],
        timeReimbursed = snapshot[ReimbursementFields.timeReimbursed],
        submittedByUUID = snapshot[ReimbursementFields.submittedByID];

  Map<String, dynamic> toMap(Reimbursement reimbursement) {
    return {
      ReimbursementFields.reimbursementID: reimbursement.reimbursementID,
      ReimbursementFields.amount: reimbursement.amount,
      ReimbursementFields.timeReimbursed: reimbursement.timeReimbursed,
      ReimbursementFields.submittedBy: reimbursement.reimburseTo,
      ReimbursementFields.pictureURLs: reimbursement.photoURLS,
      ReimbursementFields.reimbursed: reimbursement.reimbursed,
      ReimbursementFields.timeSubmitted: reimbursement.timeSubmitted
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
