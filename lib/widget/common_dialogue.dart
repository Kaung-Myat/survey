import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

void showAlertDialogForExcel(BuildContext context, String title, String content, String path, String file) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Okay'),
          ),
          // TextButton(
          //   onPressed: () {
          //     showShareDialog(path, file);
          //     Navigator.of(context).pop();
          //   },
          //   child: const Text('Share'),
          // ),
        ],
      );
    },
  );
}

Future<void> showShareDialog(String directoryPath, String file) async {
  final files = <XFile>[];
  String filePath = path.join(directoryPath, file);
  files.add(XFile(filePath, name: filePath));

  await Share.shareXFiles(
    files,
    text: 'Sharing File', // Optional: add a message to accompany the file
    subject: 'File Sharing', // Optional: specify the subject of the share
  );
}