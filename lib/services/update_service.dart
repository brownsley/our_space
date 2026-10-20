import 'dart:io';

import 'package:bcall/ui/update_dialog.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';

class UpdateService {
  final String versionUrl =
      "https://raw.githubusercontent.com/brownsley/e-books/main/version.json";

  Future<void> checkForUpdate(BuildContext context) async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;

      final response = await http.get(Uri.parse(versionUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        String latestVersion = data['version'];
        String apkUrl = data['apkUrl'];
        String message = data['updateMessage'];

        if (latestVersion != currentVersion) {
          if (!context.mounted) return;
          _showUpdateDialog(context, apkUrl, message);
        } else {
          print("App က နောက်ဆုံး Version ဖြစ်နေပါပြီ။");
        }
      }
    } catch (e) {
      print("Error checking update: $e");
    }
  }

  void _showUpdateDialog(BuildContext context, String apkUrl, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => UpdateDialog(
        message: message,
        onUpdatePressed: () {
          // APK ဒေါင်းလုပ်ဆွဲပြီး Install လုပ်မည့် Method ကို ခေါ်သုံးခြင်း
          _downloadAndInstall(context, apkUrl);
        },
      ),
    );
  }

  Future<void> _downloadAndInstall(BuildContext context, String url) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("APK ဖိုင်ကို ဒေါင်းလုပ်ဆွဲနေပါပြီ...")),
      );

      Directory? tempDir = await getExternalStorageDirectory();
      String savePath = "${tempDir?.path}/update.apk";

      Dio dio = Dio();
      await dio.download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            double progress = (received / total * 100);
            print("Downloading: ${progress.toStringAsFixed(0)}%");
          }
        },
      );

      final result = await OpenFilex.open(savePath);
      if (result.type != ResultType.done) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Install လုပ်၍ မရပါ: ${result.message}")),
        );
      }
    } catch (e) {
      print("Download error: $e");
    }
  }
}
