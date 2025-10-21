import 'package:flutter/material.dart';
import 'package:tourdecks/global/labels.dart';
import 'package:tourdecks/main.dart';

class DialogUtils {
  showInfo(String message) async {
    showDialog(
      context: navigatorKey.currentContext!,
      builder:
          (context) => AlertDialog(
            title: Text(Labels.GeneralError),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(Labels.AcceptButton),
              ),
            ],
          ),
    );
  }

  Future<void> showInfoWithTitle(String message, {String title = ""}) async {
    await showDialog(
      context: navigatorKey.currentContext!,
      builder:
          (context) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(Labels.AcceptButton),
              ),
            ],
          ),
    );
  }

  returnInfo(String message) async {
    return showDialog(
      context: navigatorKey.currentContext!,
      builder:
          (context) => AlertDialog(
            title: Text(Labels.GeneralError),
            content: Text(message),
          ),
    );
  }

  showLoading(String message) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(
            margin: const EdgeInsets.only(left: 12),
            child: Text(message),
          ),
        ],
      ),
    );

    showDialog(
      barrierDismissible: false,
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<Enum?> showDialogWithOptions(Map<Enum, String> options) async {
    final result = showDialog<Enum>(
      context: navigatorKey.currentContext!,
      builder:
          (context) => SimpleDialog(
            title: Text(Labels.GeneralOptions),
            children:
                options.entries.map((entry) {
                  return SimpleDialogOption(
                    onPressed: () {
                      Navigator.pop(context, entry.key);
                    },
                    child: Text(entry.value),
                  );
                }).toList(),
          ),
    );

    return result;
  }

  hideLoading() {
    Navigator.pop(navigatorKey.currentContext!);
  }
}
