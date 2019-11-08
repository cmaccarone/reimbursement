import 'package:flutter/material.dart';
import 'dart:math';

abstract class Reimbursement {
  bool approved;
  DateTime submitted;
  double amount;
  bool completed;
  String reimburseTo;
  String approvedBy;

  List<String> reimbursementTypes = [];
}

class AutoInsurance extends Reimbursement {

  AutoInsurance({@required this.policyStartingDate,@required this.policyEndingDate,@required this.premium1,this.premium2,this.remunerationRate});


  int remunerationRate;
  DateTime policyStartingDate;
  DateTime policyEndingDate;


  double premium1;
  double premium2;

  double getReimbursementAmount(){
    double average;
    double numberOfVehiclesAllowanceFactor;
    if (premium1 !=null && premium2 !=null) {
      average = (premium1+premium2)/2;
      numberOfVehiclesAllowanceFactor = 1.6;

    } else {
      average = premium1;
      numberOfVehiclesAllowanceFactor = 1;
    }
    double maxReimbursement = average*numberOfVehiclesAllowanceFactor;
    return maxReimbursement - _getDeductible();

  }

  double _policyLength({DateTime startDate,DateTime endDate}) {
    return endDate.difference(startDate).inDays/30;
  }

  int _getDeductible(){
    int deductible = (((_policyLength()/12)*.165)*remunerationRate).round();
    return _roundToNearest(input: deductible.toDouble(),roundTo: 5);
  }

  int _roundToNearest({double input,double roundTo}) {
    int divisor = (input~/roundTo);
    return (divisor * roundTo).toInt();
  }

}

class SpecialTravel extends Reimbursement {


  @override
  void set approved(bool _approved) {
    // TODO: implement approved
    super.approved = _approved;
  }
}

