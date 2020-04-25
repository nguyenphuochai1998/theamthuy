import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDialog {
  static void showMsgDialog(
      {BuildContext context,
        String title,
        Widget custom,
        List<Widget> button
      }) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: custom,
          actions: button
        ));
  }
  static hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop(CustomDialog);
  }
}
