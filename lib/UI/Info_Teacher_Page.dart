import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterwebacsfinal/Fire/Fire.dart';

class InfoTeacherPage extends StatefulWidget {
  InfoTeacherPage({Key key, this.idTeacher,this.user}) : super(key: key);
  final FirebaseUser user;
  final String idTeacher;

  @override
  _InfoTeacherPageState createState() => _InfoTeacherPageState();
}

class _InfoTeacherPageState extends State<InfoTeacherPage> {
  Fire _fire = new Fire();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("Tên Giáo Viên : " + widget.user.displayName ,style: TextStyle(color: Colors.blue),),
        Text("Email : " + widget.user.email ,style: TextStyle(color: Colors.blue),),

        StreamBuilder(
          stream: _fire.getTeacherByIdStream(ID: widget.idTeacher),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting: return new Text('Loading...');
              default:
                return Text("SĐT : " + snapshot.data.documents[0].data["phone"] ,style: TextStyle(color: Colors.blue),);
            }
          },
        ),
        Text("Có bất kì trục trặc nào thầy cô vui lòng liên hệ trung tâm ASW!\n- email :nguyen123mitu@gmail.com(ADMIN Nguyên) \n- SĐT:0905516925(ADMIN Thúy)",style: TextStyle(color: Colors.redAccent),)
      ],
    );
  }

}