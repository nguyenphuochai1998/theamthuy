

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterwebacsfinal/Fire/Fire.dart';
import 'package:flutterwebacsfinal/UI/Dialog/LoadDialog.dart';
import 'package:flutterwebacsfinal/UI/Home_Page.dart';

class AttendancePage extends StatefulWidget {
  AttendancePage({this.docId, Key key}) : super(key: key);

  final String docId;

  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  Set<String> listStudent = {};
  String idClass;
  String ClassName = "";
  Timestamp TimeInClass;
  Fire _fire = new Fire();
  @override
  Future initState() {
    print(widget.docId);
    Firestore.instance
        .collection('Class')
        .document(widget.docId)
        .collection('Period')
        .orderBy('Start time', descending: true)
        .limit(1)
        .getDocuments()
        .asStream()
        .listen((event) {
      event.documents.forEach((element) {
        print(element.documentID);
        setState(() {
          idClass = element.documentID;
          TimeInClass = element.data['Start time'];
          print("time:${TimeInClass.toDate().hour}");
        });
      });
    });
    Firestore.instance
        .collection('Class')
        .document(widget.docId)
        .get()
        .then((value) {
      ClassName = value.data['Name'];
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return WillPopScope(child:
    Scaffold(
      appBar: AppBar(
        title: Column(
          children: <Widget>[
            ClassName.isEmpty ? Text("") : Text("Lớp:  $ClassName"),
            TimeInClass == null
                ? Text("")
                : Text(
                "Giờ vào Lớp: ${TimeInClass.toDate().hour} giờ ${TimeInClass.toDate().minute} ngày ${TimeInClass.toDate().day}/ ${TimeInClass.toDate().month}/ ${TimeInClass.toDate().year} ")
          ],
        ),
        actions: [
          FlatButton(
            child: Text("Đóng Điểm Danh"),
            onPressed: () async {
              LoadingDialog.showLoadingDialog(context, "Vui lòng đợi");
              // điểm danh gửi gmail v.v
              await _fire.getListStudentClassStream(DocID: widget.docId).listen((event) {
                event.documents.forEach((element) async {
                  if(listStudent.add(element.data["ID"])){
                   await _fire.updatePointStudentInClass(
                      idDocClass: widget.docId,
                     idDocStudent: element.documentID,
                     pointNow: element.data["Period Missed"]
                    );

                  }
                });


              });
              await _fire.endAttendance(docID: widget.docId).then((value) {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
              });

            },
          )
        ],
      ),
      body: Container(
          child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection('Class')
                .document(widget.docId)
                .collection('Period')
                .document(idClass)
                .collection('Student')
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return new Text('Loading...');
                default:
                  return new ListView(
                    children:
                    snapshot.data.documents.map((DocumentSnapshot document) {
                      if (snapshot.hasError)
                        return new Text('Error: ${snapshot.error}');
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting: return new Text('Loading...');
                        default:
                          var _timeDate=new DateTime(2020);
                          String id ="";
                          snapshot.data.documents.forEach((element) {
                            var _time = element.data['TimeToClass'] as Timestamp;
                            _timeDate = _time.toDate();
                            id = document.data['IDStudent'];
                          });
                          // them vao cuc bo
                          listStudent.add(id);
                          return Container(
                            height: 65,
                            width: _size.width,
                            child: StreamBuilder(
                              stream: _fire.getStudentByIdStream(ID: id),
                              builder: (context,  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasError)
                                  return new Text('Error: ${snapshot.error}');
                                switch (snapshot.connectionState) {
                                  case ConnectionState.waiting: return new Text('Loading...');
                                  default:
                                    String name = "";
                                    print(snapshot.data.documents.length.toString() + "aaaaaaaaaaaaaaaaaaa");
                                    snapshot.data.documents.forEach((element) {
                                      name = element.data["name"];
                                    });
                                    return StreamBuilder(
                                      stream: _fire.getStudentClassStream(DocID: widget.docId,StudentID: id),
                                      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                        if (snapshot.hasError)
                                          return new Text('Error: ${snapshot.error}');
                                        switch (snapshot.connectionState) {
                                          case ConnectionState.waiting: return new Text('Loading...');
                                          default:
                                            int bNghi =0;
                                            snapshot.data.documents.forEach((element) {
                                              bNghi = element.data['Period Missed'];
                                            });
                                            String timeInClass = "${_timeDate.hour} giờ ${_timeDate.minute} phút - ngày : ${_timeDate.day}/${_timeDate.month}/${_timeDate.year}";
                                            return Container (
                                                decoration: new BoxDecoration (
                                                  color:bNghi < 2 ? Color(0x4042A5F5):bNghi >2 ? Color(0x40FF8A80):Color(0x40FFCA28),
                                                ),
                                                child: new ListTile(
                                                  title: new Text("Tên Sinh Viên: "+name),
                                                  subtitle: new Text("Số Buổi Nghỉ: "+bNghi.toString() +"\n"+ "Giờ Vào Lớp :"+timeInClass),
                                                )
                                            );



                                        }
                                      },
                                    );
                                }

                              },
                            ),
                          );
                      }

                    }).toList(),
                  );
              }
            },
          )),
    ), onWillPop: (){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
    });
  }


}
