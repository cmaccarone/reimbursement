import 'package:provider/provider.dart';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Collections {
 static final String users = 'users';
 static final String reimbursements = 'reimbursements';
}

class UserFields {
  static final String address = 'address';
  static final String city = 'city';
  static final String state = 'state';
  static final String zipCode = 'zipCode';
  static final String userType = 'userType';
  static final String payMeBy = 'PayMeBy';
  static final String email = 'email';
}

class ReimbursementFields {
  static final String pictureURLs = 'pictureURLs';
  static final String reimbursed = 'reimbursed';
  static final String reimbursement = 'reimbursement';
}