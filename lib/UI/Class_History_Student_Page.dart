import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterwebacsfinal/Fire/Fire.dart';

class HistoryClassStudentPage extends StatefulWidget {
  HistoryClassStudentPage({this.docPeriodClassId,this.nameClass,this.timeToClass,this.docIdClass, Key key}) : super(key: key);
  final Timestamp timeToClass;
  final String docPeriodClassId,nameClass,docIdClass;

  @override
  _HistoryClassStudentPageState createState() => _HistoryClassStudentPageState();
}

class _HistoryClassStudentPageState extends State<HistoryClassStudentPage> {
  Fire _fire = new Fire();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Timestamp _time = widget.timeToClass;
    return Scaffold(
      appBar: AppBar(
        title: Text("Lịch Sử Điểm Danh Lớp "+widget.nameClass+"Vào Lúc: "+_time.toDate().hour.toString()+" Giờ "+_time.toDate().minute.toString()+" - "+_time.toDate().day.toString()+"/"+_time.toDate().month.toString()+"/"+_time.toDate().year.toString()),
      ),
      body: StreamBuilder(
        stream: _fire.listClassHistoryStudentStream(idClass: widget.docIdClass,idPeriod: widget.docPeriodClassId),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError)
            return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting: return new Text('Loading...');
            default:
              print(widget.docPeriodClassId);
              print(snapshot.data.documents.length);
              return new ListView(
                children: snapshot.data.documents.map((DocumentSnapshot document) {
                  var _time = document.data['TimeToClass'] as Timestamp;
                   return StreamBuilder(
                     stream: _fire.getInfoStudentByIdStream(IDClass: widget.docIdClass,IDStudent: document.data["IDStudent"]),
                     builder: (context, AsyncSnapshot<QuerySnapshot> snapshotStu) {
                        if (snapshot.hasError)
                          return new Text('Error: ${snapshot.error}');
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting: return new Text('Loading...');
                          default:
                            int bNghi = 0;
                            snapshotStu.data.documents.map((data) {
                              bNghi = data.data["Period Missed"];
                            });
                           return  Container(
                                height: 65,
                                width: size.width,
                                child:StreamBuilder(
                                  stream: _fire.getStudentByIdStream(ID: document.data["IDStudent"]),
                                  builder: (context,AsyncSnapshot<QuerySnapshot> student) {
                                    if (student.hasError)
                                      return new Text('Error: ${student.error}');
                                    switch (student.connectionState) {
                                      case ConnectionState.waiting: return new Text('Loading...');
                                      default:
                                        return new ListView(
                                          children: student.data.documents.map((DocumentSnapshot document) {
                                            return Container (
                                                decoration: new BoxDecoration (
                                                  color:bNghi < 2 ? Color(0x4042A5F5):bNghi >2 ? Color(0x40FF8A80):Color(0x40FFCA28),
                                                ),
                                                child: new ListTile(
                                                  title: new Text("Tên Sinh Viên: "+document['name']),
                                                  subtitle: new Text("Số Buổi Nghỉ: "+bNghi.toString()+" - Giờ Vào Lớp : "+ _time.toDate().hour.toString() +"Giờ "+ _time.toDate().minute.toString() ),
                                                )
                                            );


                                          }).toList(),
                                        );
                                    }

                                  },
                                ) ,
                            );


                        }
                     },
                   );
                  return new ListTile(
                    title: Text("Sinh Viên: "+document.data["IDStudent"]),
                    subtitle: new Text("giờ vào lớp : "+_time.toDate().hour.toString()+"Giờ"+_time.toDate().minute.toString()+ "Phút"),
                    onTap: (){

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