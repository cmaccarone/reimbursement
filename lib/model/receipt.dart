import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:reimbursement/model/tripApproval.dart';
import 'package:uuid/uuid.dart';

import 'databaseFields.dart';

class Receipt {
  double amount;
  String vendor;
  DateTime receiptDate;
  String pictureURL;
  bool mightHaveAlreadyBeenSubmitted;
  final String reimbursementID;
  DateTime timeSubmitted = DateTime.now();
  DateTime timeReimbursed;
  List<Receipt> receipts;
  bool reimbursed = false;
  String reimburseTo;
  String approvedBy;
  String submittedByUUID;
  List<String> photoURLS;
  String description;
  String notes;
  TripApproval tripApproval;

  Receipt(
      {@required this.submittedByUUID,
      this.reimbursed = false,
      this.amount,
      this.photoURLS,
      this.approvedBy,
      this.receipts,
      this.timeReimbursed,
      this.description,
      this.notes,
      this.reimburseTo,
      this.tripApproval})
      : this.reimbursementID = Uuid().v1();

  Receipt.fromSnapshot({DocumentSnapshot snapshot})
      : amount = double.parse(snapshot[ReceiptFields.amount]),
        vendor = snapshot[ReceiptFields.vendor],
        timeSubmitted = snapshot[ReceiptFields.timeSubmitted],
        reimburseTo = snapshot[ReceiptFields.submittedBy],
        timeReimbursed = snapshot[ReceiptFields.timeReimbursed],
        submittedByUUID = snapshot[ReceiptFields.submittedByID],
        reimbursementID = snapshot[ReceiptFields.reimbursementID],
        notes = snapshot[ReceiptFields.notes],
        description = snapshot[ReceiptFields.description],
        tripApproval = TripApproval.fromSnapshot(
            snapshotData: snapshot[ReceiptFields.tripApproval]);

  Map<String, dynamic> toMap(Receipt reimbursement) {
    return {
      ReceiptFields.receiptDate: receiptDate,
      ReceiptFields.vendor: reimbursement.vendor,
      ReceiptFields.reimbursementID: reimbursement.reimbursementID,
      ReceiptFields.amount: reimbursement.amount.toString(),
      ReceiptFields.timeReimbursed: reimbursement.timeReimbursed,
      ReceiptFields.submittedBy: reimbursement.reimburseTo,
      ReceiptFields.pictureURLs: reimbursement.photoURLS,
      ReceiptFields.reimbursed: reimbursement.reimbursed,
      ReceiptFields.timeSubmitted: reimbursement.timeSubmitted,
      ReceiptFields.notes: reimbursement.notes,
      ReceiptFields.description: reimbursement.description,
      ReceiptFields.tripApproval: tripApproval.toMap(tripApproval)
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
