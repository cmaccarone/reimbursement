import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reimbursement/model/databaseFields.dart';
import 'package:reimbursement/model/receipt.dart';

class ReimbursementExporter {
  List<Receipt> _receipts;
  List<List<dynamic>> _rows = List<List<dynamic>>();

  Firestore _firestore = Firestore.instance;

  //todo get the local directory path
  //todo deal with exported CSV file (email or make it available for download.)
  //todo create three columns
  // - Data Item, Employee ID, Amount
  Future<Receipt> getReceipts() async {
    DocumentSnapshot data = await _firestore
        .collection(Collections.reimbursementCache)
        .document(Collections.specialTravel)
        .get();
  }

  createCSV() async {
    _rows.add([
      "EmployeeID",
      "DataItem",
      "Amount",
    ]);
    _rows.add([1844, 11357, 24000.47]);
  }
}
