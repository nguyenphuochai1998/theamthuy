import 'package:flutter/material.dart';
import 'package:easy_dialog/easy_dialog.dart';
class NotificationDialog{
  static void showNotificationDialog({BuildContext context,String msg,Function onClickOkButton}){
    Size _size = MediaQuery.of(context).size;
    showDialog(context: context,builder:
    EasyDialog(
        closeButton: false,
        cornerRadius: 10.0,
        fogOpacity: 0.1,
        width: _size.width*0.4,
        height: _size.height*0.5,
        title: Text(
          "Thông Báo!",
          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.greenAccent),
          textScaleFactor: 1.2,

        ),
        descriptionPadding:
        EdgeInsets.only(left: 17.5, right: 17.5, bottom: 15.0),
        description: Text(
            msg
        ),
        // Needed for the button design
        contentList: [
          Container(
            width: 300,
            height: 45.0,
            decoration: BoxDecoration(
                color: Colors.greenAccent,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0))),
            child: FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
                onClickOkButton();
              },
              child: Text("Okay",
                textScaleFactor: 1.3,
              ),),
          ),
        ]).show(context)
    );
  }
  static hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop(NotificationDialog);
  }
}