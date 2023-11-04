// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_excel/excel.dart';
import 'package:path/path.dart' ;
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:survey_app/model/survey_model.dart';
import '../widget/common_dialogue.dart';


// void exportToCSV(List<List<dynamic>> dataToExport) async {
  // Set up the CSV file path
 // String csvFilePath = '${await getFilePath()}/survey.csv';

  // Convert data to a CSV format string
  //String csvData = const ListToCsvConverter().convert(dataToExport);

  // Write the CSV data to a file
 // File csvFile = File(csvFilePath);
 // await csvFile.writeAsString(csvData);

  //print('CSV file has been created at: $csvFilePath');

  // print(await getFilePath());
// }

// Future<String> getFilePath() async {
//   Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
//   return appDocumentsDirectory.path;
// }


void exportToExcel(BuildContext context, List<SurveyModel> surveyData) async {
  // Create an Excel workbook and sheet
  var excel = Excel.createExcel();
  var sheet = excel['Sheet1'];

  // Add headers to the Excel sheet
  sheet.appendRow([
    'Name',
    'Age',
    'PhoneNumber',
    'Address',
    'FamilyMember',
    'Gender',
    'Additional',
    'CreatedAt'
  ]);

  // Add product data to the Excel sheet
  for (var servey in surveyData) {
    sheet.appendRow([
      servey.name,
      servey.age,
      servey.phoneNumber,
      servey.address,
      servey.familyMembers,
      genderChecker(servey.gender),
      servey.additional,
      servey.createdDate
    ]);
  }
  var fileBytes = excel.save();
  var directory = await getDir();
  String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
  String excelFileName = 'survey_data_$timestamp.xlsx';

  File(join("$directory/$excelFileName"))
    ..createSync(recursive: true)
    ..writeAsBytesSync(fileBytes!);

  // Show a dialog with the file path
  showAlertDialogForExcel(
      context,
      'Export Complete',
      'Excel file saved at: $directory/$excelFileName',
      directory.toString(),
      excelFileName.toString());
}

String genderChecker(int gender){
  String genderStr = "";
  if(gender == 0){
      genderStr += "Gay";
    }else if(gender == 1){
      genderStr += "Lesbian";
    }else if(gender == 2){
      genderStr += "Bisexual";
    }else if(gender == 3){
      genderStr += "Queer/Questioning";
    }else if(gender == 4){
      genderStr += "Transgender";
    }else if(gender == 5){
      genderStr += "Others";
    }
  return genderStr;
}

Future<String> getDir() async {
  const folderName = "survey";
  final path = Directory("storage/emulated/0/$folderName");
  //ask for permission
  await Permission.manageExternalStorage.request();
  var status = await Permission.manageExternalStorage.status;
  if (status.isDenied) {
    return 'Permission Denied';
  }

  if (await Permission.storage.isRestricted) {
    return 'Permission Denied';
  }

  if (status.isGranted) {
    if ((await path.exists())) {
      return path.path;
    } else {
      path.create();
      return path.path;
    }
  }
  return path.path;
}