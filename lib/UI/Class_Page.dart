import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterwebacsfinal/Fire/Fire.dart';
import 'package:flutterwebacsfinal/UI/Attendance_Page.dart';
import 'package:flutterwebacsfinal/UI/Class_History_Page.dart';
import 'package:flutterwebacsfinal/UI/Class_List_Page.dart';
import 'package:flutterwebacsfinal/UI/Dialog/CustomDialog.dart';
import 'package:flutterwebacsfinal/UI/Dialog/LoadDialog.dart';
import 'package:timer_count_down/timer_count_down.dart';


class ClassPage extends StatefulWidget {
  ClassPage({Key key, this.idDocClass,this.funcController,this.nameClass}) : super(key: key);
  final StreamController<Widget> funcController;
  final String idDocClass;
  final String nameClass;


  @override
  _ClassPageState createState() => _ClassPageState();
}

class _ClassPageState extends State<ClassPage> {
  StreamController<String> _studentPointController = new StreamController<String>();
  String _all = "All",_2PeriodMissed = "2",_BigPeriodMissed = "big";
  Fire _fire = new Fire();
  @override
  void initState() {
    _studentPointController.add(_all);

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Lớp "+widget.nameClass),
          ),
          body: Column(
            children: [
              Container(
                height: _size.height*0.3,
                child: _MenuClassManagemant(),
              ),
              Container(
                width: _size.width,
                height: _size.height*0.47,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Color(0x501E88E5),
                      width: 3.0,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: _size.width,
                      height: 35,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color(0x501E88E5),
                            width: 3.0,
                          ),
                        ),
                      ),
                      child: Text("Danh Sách Sinh Viên Lớp"),
                    ),
                    Container(
                      width: _size.width,
                      height: (_size.height*0.47)-40,
                      child: _ListStudent(_size),
                    )
                  ],
                ),
              )
            ],
          )

        ),
        onWillPop: (){
          widget.funcController.add(ClassListPage());
        });
  }
  var _nameTagTM = ["Xem Lịch Sử Buổi Học", "Bắt Đầu Điểm Danh Buổi Học"];
  var _iconTagTM = ["ic_history.png", "ic_join.png"];
  Widget _MenuClassManagemant() {
    return GridView.builder(
      itemCount: _iconTagTM.length,
      scrollDirection: Axis.horizontal,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1, childAspectRatio: 1, crossAxisSpacing: 1),
      itemBuilder: (BuildContext context, int index) {
        return Center(
          child: GestureDetector(
              onTap: () {
                ClickFuncClass(context: context, index: index);
              },
              child: Center(
                child: _BuildTagName(
                  icon: _iconTagTM[index],
                  nameTag: _nameTagTM[index],
                ),
              )),
        );
      },
    );
  }
  void ClickFuncClass({int index, BuildContext context}) {
    switch (index) {
      case 0:
        {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>HistoryClassPage(nameClass: widget.nameClass,docClassId: widget.idDocClass,)));
        }
        break;
      case 1:
        {
          LoadingDialog.showLoadingDialog(context, "Vui lòng đợi");
          AttendanceClass(context);

        }
        break;
    }
  }
  void AttendanceClass( BuildContext context){
    LoadingDialog.hideLoadingDialog(context);
    _fire.getClassStream(DocID: widget.idDocClass).listen((event) {
      if(event.data["isOpen"] == true){
        print("Lớp Mở");
        CustomDialog.hideLoadingDialog(context);
        Navigator.push(context, MaterialPageRoute(builder: (context)=>AttendancePage(docId: widget.idDocClass,)));
      }
    });
    _fire.createNewUuidClass(idDocClass: widget.idDocClass,
    isSuccess: (){
      CustomDialog.showMsgDialog(
        button: <Widget>[
          FlatButton(
            child: Text("Hủy"),
            onPressed: (){
              CustomDialog.hideLoadingDialog(context);
            },
          )
        ],
          context: context,
          title: "Bắt đầu điểm danh",
          custom: Container(
            width: 400,
            height: 400,
            child: Column(
              children: [
                Container(
                  width: 400,
                  height: 150,
                  child: StreamBuilder(
                    stream: _fire.getClassStream(DocID: widget.idDocClass),
                    builder: (context,AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasError)
                        return new Text('Error: ${snapshot.error}');
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting: return new Text('Loading...');
                        default:
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Nhập mã số này vào phần mềm nhận diện",style: TextStyle(
                                  fontSize: 25
                                ),),
                                Text(snapshot.data.data["uuidClass"],style: TextStyle(
                                    fontSize: 50
                                ),),
                                Row(
                                  children: [
                                    Text("Hủy Sau :"),
                                    CountDown(
                                      seconds: 20,
                                      onTimer: () {
                                        // Make some logic
                                        CustomDialog.hideLoadingDialog(context);
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                      }

                    },
                  ),
                )
              ],
            ),
          ),
      );

    }
    );

  }
  Widget _BuildTagName({String nameTag, String icon}) {
    return Card(
      margin: EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Container(
                child: Stack(
                  children: <Widget>[
                    Image.asset(
                      icon,
                      height: 100,
                      width: 100,
                    ),
                  ],
                )),
          ),
          Text(
            nameTag,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _ListStudent(Size size){

    return StreamBuilder(
      stream: _studentPointController.stream,
      builder: (context, snapshotAll) {
        Stream<QuerySnapshot> _stream =_fire.getListStudentClassStream(DocID: widget.idDocClass);
        Stream<QuerySnapshot> _stream2PeriodMissed = _fire.getListStudentPeriodMissed2ClassStream(DocID: widget.idDocClass);
        Stream<QuerySnapshot> _streamBigPeriodMissed = _fire.getListStudentPeriodMissedBigClassStream(DocID: widget.idDocClass);
        return StreamBuilder(
          stream: snapshotAll.data == _all ? _stream : snapshotAll.data == _2PeriodMissed ? _stream2PeriodMissed : _streamBigPeriodMissed,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting: return new Text('Loading...');
              default:
                String thongBao="";
                if(snapshotAll.data == _all){
                  thongBao = "Lớp này chưa có sinh viên";
                }else{
                  if(snapshotAll.data ==_2PeriodMissed){
                    thongBao = "Lớp này không có sinh viên nào vắng 2 buổi";
                  }else{
                    thongBao = "Lớp này không có sinh viên nào vắng bằng hoặc trên 3 buổi";
                  }
                }
                return Column(
                  children: [
                    Container(
                      height: 50,
                      width: size.width,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buttonPeriodStu(stream: _fire.getListStudentClassStream(DocID: widget.idDocClass),color: Colors.blue,txt: "Tất cả",onTap: (){
                            _studentPointController.add(_all);
                          }),
                          _buttonPeriodStu(stream: _fire.getListStudentPeriodMissed2ClassStream(DocID: widget.idDocClass),color: Colors.amber,txt: "Vắng 2 buổi",onTap: (){
                            _studentPointController.add(_2PeriodMissed);
                          }),
                          _buttonPeriodStu(stream: _fire.getListStudentPeriodMissedBigClassStream(DocID: widget.idDocClass),color: Colors.redAccent,txt: "Vắng quá 2 buổi",onTap: (){
                            _studentPointController.add(_BigPeriodMissed);
                          })
                        ],
                      ),
                    ),
                    Container(
                      height: (size.height*0.47)-40-50,
                      child: snapshot.data.documents.length == 0 ? Container(
                        child: Text(thongBao),
                      ) : Container(
                        child: ListView(
                          children: snapshot.data.documents.map((DocumentSnapshot document) {
                            String id = document['ID'];
                            int bNghi = document['Period Missed'];
                            return Container(
                              height: 65,
                              width: size.width,
                              child: StreamBuilder(
                                stream: _fire.getStudentByIdStream(ID: id),
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
                                                subtitle: new Text("Số Buổi Nghỉ: "+bNghi.toString()),
                                              )
                                          );


                                        }).toList(),
                                      );
                                  }

                                },
                              ),
                            );

                          }).toList(),
                        ),

                      ),

                    )

                  ],


                );
            }
          },
        );
      },
    );
  }
  Widget _buttonPeriodStu({Function onTap,String txt,Stream<QuerySnapshot> stream,Color color}){
    return StreamBuilder(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {


        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return new Text('Loading...');
          default:
            int sv = snapshot.data.documents.length;
            print("nut svvvv"+sv.toString());

            return Container(
              height: 20,
              child: FlatButton(
                color: color,
                child: Text(  txt+": "+sv.toString()+" sv"),
                onPressed: (){
                  onTap();
                },
              ),
            );
        }
      },
    );
  }

}