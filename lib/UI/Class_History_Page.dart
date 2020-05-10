import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterwebacsfinal/Fire/Fire.dart';

import 'Class_History_Student_Page.dart';

class HistoryClassPage extends StatefulWidget {
  HistoryClassPage({this.docClassId,this.nameClass, Key key}) : super(key: key);

  final String docClassId,nameClass;

  @override
  _HistoryClassPageState createState() => _HistoryClassPageState();
}

class _HistoryClassPageState extends State<HistoryClassPage> {
  Fire _fire = new Fire();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lịch Sử Buổi Học Lớp "+widget.nameClass),
      ),
      body: StreamBuilder(
        stream: _fire.listClassHistoryStreamByIDClass(id: widget.docClassId),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError)
            return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting: return new Text('Loading...');
            default:
              print(widget.docClassId);
              print(snapshot.data.documents.length);
              return new ListView(
                children: snapshot.data.documents.map((DocumentSnapshot document) {
                  var _time = document.data['Start time'] as Timestamp;
                  return new ListTile(
                    title: Text("Lớp: "+widget.nameClass),
                    subtitle: new Text("Buổi học : "+_time.toDate().hour.toString()+"Giờ"+_time.toDate().minute.toString()+ "Phút, Ngày "+ _time.toDate().day.toString()+" Tháng "+_time.toDate().month.toString()+" Năm "+_time.toDate().year.toString()),
                    onTap: (){
                      print(document.documentID);
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>HistoryClassStudentPage(docIdClass: widget.docClassId,docPeriodClassId: document.documentID,nameClass: widget.nameClass,timeToClass: _time,)));
                    },
                  );
                }).toList(),
              );
          }
        },
      ),
    );
  }

}