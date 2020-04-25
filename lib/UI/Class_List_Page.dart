import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterwebacsfinal/Fire/Fire.dart';
import 'package:flutterwebacsfinal/UI/Class_Page.dart';

class ClassListPage extends StatefulWidget {
  ClassListPage({Key key, this.idTeacher}) : super(key: key);

  final String idTeacher;

  @override
  _ClassListPageState createState() => _ClassListPageState();
}

class _ClassListPageState extends State<ClassListPage> {
  Fire _fire = new Fire();
  StreamController<Widget> _funcController = new StreamController<Widget>();
  @override
  void initState() {
    _funcController.add(listClass());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _funcController.stream,
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting: return new Text('Loading...');
            default:
              return snapshot.data;
          }
        },
      );
  }
  Widget listClass(){
    return Scaffold(

        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Center(child: Text("Danh Sách Lớp Học Đang Dạy Hiện Tại"),),
        ),
        body:StreamBuilder(
          stream: _fire.listClassStreamByIDTeacher(id: widget.idTeacher),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting: return new Text('Loading...');
              default:
                print(widget.idTeacher);
                print(snapshot.data.documents.length);
                return new ListView(
                  children: snapshot.data.documents.map((DocumentSnapshot document) {
                    return new ListTile(
                      title: document.data["isOpen"]==true ?  Text(document.data['Name']+"(Đang Dạy Và Điểm Danh)"):Text(document.data['Name']),
                      subtitle: new Text(" Mã Môn Học :"+document.data['IDClass']),
                      onTap: (){
                          _funcController.add(ClassPage(funcController: _funcController,idDocClass: document.documentID,nameClass: document.data['Name'],));
                      },
                    );
                  }).toList(),
                );
            }
          },
        )
    );

  }
}