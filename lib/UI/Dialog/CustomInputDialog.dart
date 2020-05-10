import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomInputDialog {
  static void showMsgDialog(
      {BuildContext context,
      String title,
      Widget custom,
      Function onClickOK,
      String okButton}) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(title),
              content: custom,
              actions: <Widget>[
                FlatButton(
                  child: Text(okButton),
                  onPressed: () {

                    onClickOK();
                  },
                ),
                FlatButton(
                  child: Text("Đóng"),
                  onPressed: () {
                    Navigator.of(context).pop(CustomInputDialog);
                  },
                )
              ],
            ));
  }
  static hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop(CustomInputDialog);
  }
}
