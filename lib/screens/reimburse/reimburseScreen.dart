import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reimbursement/screens/misc_reusable/constants.dart';

class ReimburseScreen extends StatelessWidget {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    print(path);
    return File('$path/counter.txt');
  }

  Future<File> writeCounter() async {
    final file = await _localFile;

    // Write the file.
    print(file.toString());
    return file.writeAsString(
      '123 this is a test file to test the sharing capacity of this app.',
      mode: FileMode.append,
    );
  }

  @override
  Widget build(BuildContext context) {
    writeCounter();
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: FloatingActionButton(
            backgroundColor: kTealColor,
            child: Text("Share"),
            onPressed: () async {
              String path = await _localPath;
              // add share plugin here
//              FlutterShare.shareFile(
//                  title: "apsImport", filePath: '$path/counter.txt');
              print('pressed');
            },
          ),
        ),
      ),
    );
  }
}
