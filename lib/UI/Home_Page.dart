
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterwebacsfinal/Fire/Fire.dart';
import 'package:flutterwebacsfinal/UI/Class_Page.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Class_List_Page.dart';


class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseUser _user ;
  String _idTeacher;
  Widget _func = new Container();
  Fire _fire = new Fire();
  @override
  void initState()  {
    FirebaseAuth.instance.currentUser().then((value) {
      _fire.getTeacherByEmail(Email: value.email).then((value) {
        setState(() {
          _idTeacher = value.data["uid"];
        });
      });
      setState(() {
        _user = value;
      });

    });


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size _sizeScreen = MediaQuery.of(context).size;
    Size _sizeTopBaner = new Size(_sizeScreen.width , _sizeScreen.height*0.15);
    Size _sizeMenu = new Size(_sizeScreen.width * 0.3, _sizeScreen.height - _sizeTopBaner.height);
    Size _sizeFunc = new Size(_sizeScreen.width - _sizeMenu.width, _sizeScreen.height - _sizeTopBaner.height);
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Container(
              height: _sizeTopBaner.height,
              child: Row(
                children: [
                  Container(
                    width: _sizeTopBaner.width*0.3,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("ASW",style:GoogleFonts.roboto(
                            color: Colors.blue,
                            fontSize: 48,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.italic,

                          )),
                          _user == null ? Text("",style:GoogleFonts.roboto(
                            color: Colors.blue,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.italic,

                          )):Text(_user.displayName,style:GoogleFonts.roboto(
                            color: Colors.blue,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.italic,

                          ))
                        ],
                      ),
                    )
                  )
                ],
              )
            ),
            Stack(
              children: <Widget>[
                //giao dien chuc nang
                Container(
                  margin: EdgeInsets.only(left: _sizeMenu.width),
                  width: _sizeFunc.width,
                  height: _sizeFunc.height,
                  child: _func,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: Color(0x501E88E5),
                        width: 3.0,
                      ),
                      top: BorderSide(
                        color: Color(0x501E88E5),
                        width: 3.0,
                      ),
                    ),
                  ),
                  child: _Menu(),
                  height: _sizeMenu.height,
                  width: _sizeMenu.width,
                ),
              ],
            ),
          ],
        )
      ),
    );
  }
  Widget _Menu() {
    Color _colorTextMenu = Color(0xffE64C4E);
    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        ListTile(
          title: Text("Thông Tin Cá Nhân"),
          onTap: () {
            setState(() {

            });
          },
        ),
        ListTile(
          title: Text("Quản Lý Lớp Học"),
          onTap: () {
            setState(() {
              if(_idTeacher != null){
                _func = ClassListPage(idTeacher: _idTeacher,);
              }

            });
          },
        ),
      ],
    );
  }
}
