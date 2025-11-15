import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
              TextButton(onPressed: () => Navigator.pop(context), child: Text(Labels.AcceptButton)),
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
              TextButton(onPressed: () => Navigator.pop(context), child: Text(Labels.AcceptButton)),
            ],
          ),
    );
  }

  returnInfo(String message) async {
    return showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) => AlertDialog(title: Text(Labels.GeneralError), content: Text(message)),
    );
  }

  showLoading(String message) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(margin: const EdgeInsets.only(left: 12), child: Text(message)),
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

  Future<Enum?> showWarningDialogWithOptions(
    String title,
    String subtitle,
    Map<Enum, String> options,
  ) async {
    final result = showDialog<Enum>(
      context: navigatorKey.currentContext!,
      builder:
          (context) => Dialog(
            backgroundColor: Colors.transparent,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 50),
                  padding: const EdgeInsets.fromLTRB(10, 60, 10, 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 220,
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'PetronaVariable',
                            fontSize: 21,
                            color: Color(0xFFEC4C4C),
                            height: 1.2,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'PetronaVariable',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children:
                            options.entries.map((entry) {
                              return ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context, entry.key);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  entry.value,
                                  style: const TextStyle(fontFamily: 'Petrona', fontSize: 14),
                                ),
                              );
                            }).toList(),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: -9,
                  child: SvgPicture.asset(
                    'assets/images/warning_sign.svg',
                    width: 135,
                    height: 135,
                  ),
                ),
              ],
            ),
          ),
    );

    return result;
  }

  hideLoading() {
    Navigator.pop(navigatorKey.currentContext!);
  }
}
