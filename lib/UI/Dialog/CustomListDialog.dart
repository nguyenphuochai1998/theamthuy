import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomListDialog {
  static void showMsgDialog(
      {BuildContext context,
        String title,
        Widget custom}) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: custom,
          actions: <Widget>[
            FlatButton(
              child: Text("Đóng"),
              onPressed: () {
                Navigator.of(context).pop(CustomListDialog);
              },
            )
          ],
        ));
  }
  static hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop(CustomListDialog);
  }
}
