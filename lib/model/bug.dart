import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reimbursement/model/databaseFields.dart';
import 'package:uuid/uuid.dart';

class Bug {
  String id = Uuid().v1();
  DateTime timeReported = DateTime.now();
  String reporterName;
  String reporterEmail;
  String reporterUserType;
  String reportText;

  Bug(
      {this.reporterName,
      this.reportText,
      this.reporterUserType,
      this.reporterEmail});

  Bug.fromSnapshot({DocumentSnapshot snapshot}) {
    id = snapshot.data[BugFields.id];
    reporterName = snapshot.data[BugFields.reporterName];
    reporterEmail = snapshot.data[BugFields.reporterEmail];
    reporterUserType = snapshot.data[BugFields.reporterUserType];
    reportText = snapshot.data[BugFields.reportText];
    timeReported = snapshot.data[BugFields.timeReported];
  }

  Map<String, dynamic> toMap(Bug bug) {
    return {
      BugFields.id: bug.id,
      BugFields.timeReported: bug.timeReported,
      BugFields.reporterName: bug.reporterName,
      BugFields.reporterEmail: bug.reporterEmail,
      BugFields.reporterUserType: bug.reporterUserType,
      BugFields.reportText: bug.reportText
    };
  }
}
