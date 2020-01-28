import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reimbursement/model/receipt.dart';

import 'databaseFields.dart';

class Reimbursement {
  List<Receipt> receipts;
  bool approved;
  DateTime submitted;
  double amount;
  bool completed;
  String reimburseTo;
  String approvedBy;
  DateTime dateSubmitted;
  List<String> photoURLS;

  List<String> reimbursementTypes = [];

  Reimbursement.fromSnapshot({DocumentSnapshot snapshot})
      : amount = snapshot[ReimbursementFields.amount],
        submitted = snapshot[ReimbursementFields.dateSubmitted],
        reimburseTo = snapshot[ReimbursementFields.submittedBy];
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
