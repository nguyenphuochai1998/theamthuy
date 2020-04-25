import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterwebacsfinal/Bloc/BlocClass.dart';
import 'package:flutterwebacsfinal/Bloc/BlocDialog.dart';
import 'package:flutterwebacsfinal/Fire/Fire.dart';
import 'package:flutterwebacsfinal/UI/Dialog/CustomInputDialog.dart';
import 'package:flutterwebacsfinal/UI/Dialog/CustomListDialog.dart';
import 'package:flutterwebacsfinal/UI/Dialog/LoadDialog.dart';
import 'Dialog/ErrorDialog.dart';
import 'Dialog/NotificationDialog.dart';


class ClassManagerAdminPage extends StatefulWidget {
  ClassManagerAdminPage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _ClassManagerAdminPageState createState() => _ClassManagerAdminPageState();
}

class _ClassManagerAdminPageState extends State<ClassManagerAdminPage> {
  Fire _fire = new Fire();

  @override
  Widget build(BuildContext context) {

    return _TeacherManagement();
  }

  Widget _TeacherManagement() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Container(
          alignment: Alignment.center,
          child: Text("Quản Lý Lớp Học"),
        ),
      ),
      body: _MenuTecherManagemant(),
    );
  }

  // ui cho menu lớp
  var _nameTagTM = ["Thêm Lớp Học", "Sửa thông tin Lớp Học","Thêm Sinh Viên Vào Lớp"];
  var _iconTagTM = ["ic_class.png", "ic_class2.png","ic_join.png"];
  Widget _MenuTecherManagemant() {
    return GridView.builder(
      itemCount: _iconTagTM.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 1, crossAxisSpacing: 1),
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
    ClassBloc _bloc = new ClassBloc();
    switch (index) {
      case 0:
        {
          _FuncAddClass(_bloc,context);

        }
        break;
      case 1:
        {
          _FuncEditClass(_bloc,context);
        }
        break;
      case 2:
        {
          _FuncAddStudentClass(_bloc,context);
        }
        break;
    }
  }
  void _FuncAddClass(ClassBloc bloc, BuildContext context){
    final TextEditingController _idClassController = TextEditingController();
    final TextEditingController _nameClassController = TextEditingController();
    final TextEditingController _teacherController = TextEditingController();
    final StreamController _teacherCControllerStream = new StreamController();

    CustomInputDialog.showMsgDialog(
        context: context,
        okButton: "thêm lớp",
        onClickOK: () {

          bool _isTeacher,_isName,_isID;
          _isID = bloc.CheckID(_idClassController.text);
          _isName = bloc.CheckNameClass(_nameClassController.text);
          _isTeacher = _teacherController.text.isNotEmpty;

          if(_isID && _isName && _isTeacher ){

            _fire.addClass(
              nameClass: _nameClassController.text,
              idClass: _idClassController.text,
              idTeacher: _teacherController.text,
              isSuccess: (msg){
                LoadingDialog.hideLoadingDialog(context);
                NotificationDialog.showNotificationDialog(
                    context: context,
                    msg: msg,
                    onClickOkButton: (){

                    }
                );

              }
            );

          }


        },
        custom: Container(
          width: 500,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10),
                child: StreamBuilder(
                  stream: bloc.idClassStream,
                  builder: (context, snapshot) => TextField(
                    controller: _idClassController,
                    style:
                    TextStyle(fontSize: 18, color: Colors.blue),

                    decoration: InputDecoration(
                        labelText: "ID CLass",
                        errorText:
                        snapshot.hasError ? snapshot.error : null,
                        prefixIcon: Container(
                            padding: EdgeInsets.fromLTRB(6, 6, 6, 6),
                            width: 50,
                            child: Image.asset("ic_id.png")),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xFFA8DBA8), width: 1),
                            borderRadius:
                            BorderRadius.all(Radius.circular(6)))),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: StreamBuilder(
                  stream: bloc.nameClassStream,
                  builder: (context, snapshot) => TextField(
                    controller: _nameClassController,
                    style:
                    TextStyle(fontSize: 18, color: Colors.blue),
                    decoration: InputDecoration(
                        labelText: "Nhập Tên Môn Học",
                        errorText:
                        snapshot.hasError ? snapshot.error : null,
                        prefixIcon: Container(
                            padding: EdgeInsets.fromLTRB(6, 6, 6, 6),
                            width: 50,
                            child: Image.asset("ic_id.png")),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xFFA8DBA8), width: 1),
                            borderRadius:
                            BorderRadius.all(Radius.circular(6)))),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child:  StreamBuilder(
                stream: _teacherCControllerStream.stream,
                builder: (context, snapshot) {
                  return Row(
                    children: [
                      Expanded(
                        child: snapshot.hasError ? Text(snapshot.error):
                        snapshot.hasData ?Text("Giáo Viên : ${snapshot.data['name']}"):Text("Bạn chưa chọn giáo viên nào cho lớp này"),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0,0, 20,0),
                          child: SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: RaisedButton(
                              onPressed: () async {

                                CustomListDialog.showMsgDialog(
                                  title: "Chọn Giáo Viên Cho Lớp",
                                  context: context,
                                  custom: Container(
                                    width: 300,
                                    child: StreamBuilder<QuerySnapshot>(
                                      stream: _fire.listTeacherStream(),
                                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                        if (snapshot.hasError)
                                          return new Text('Error: ${snapshot.error}');
                                        switch (snapshot.connectionState) {
                                          case ConnectionState.waiting: return new Text('Loading...');
                                          default:
                                            print(snapshot.data.documents.length);
                                            return new ListView(
                                              children: snapshot.data.documents.map((DocumentSnapshot document) {

                                                return Expanded(
                                                  child: ListTile(
                                                    title: new Text(document.data['name']),
                                                    subtitle: new Text(document.data['email']),
                                                    onTap: (){
                                                      _teacherCControllerStream.add(document);
                                                      CustomListDialog.hideLoadingDialog(context);
                                                      _teacherController.text = document.data['uid'];
                                                    },
                                                  ),
                                                );
                                              }).toList(),
                                            );
                                        }
                                      },
                                    ),
                                  )
                                );
                              },
                              child: Text(
                                "Thêm  Giáo Viên",
                                style: TextStyle(color: Colors.white, fontSize: 18),
                              ),
                              color: Colors.redAccent,

                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(6))),
                            ),
                          ),
                        ),

                      ),
                    ],
                  );
                },
              )
              ),
            ],
          ),
        ),
        title: "Thêm Giáo Viên");
  }
  void _FuncEditClass(ClassBloc bloc, BuildContext context){
    final TextEditingController _idClassController = TextEditingController();
    final TextEditingController _nameClassController = TextEditingController();
    final TextEditingController _teacherController = TextEditingController();
    final TextEditingController _docController = TextEditingController();
    CustomInputDialog.showMsgDialog(
        context: context,
        okButton: "Sửa",
        onClickOK: () {
          _fire.editClass(
            name: _nameClassController.text,
            idDoc: _docController.text,
            teacher: _teacherController.text,
            idClass: _idClassController.text,
            isSuccess: (msg){
              LoadingDialog.hideLoadingDialog(context);
              NotificationDialog.showNotificationDialog(
                  context: context,
                  msg: msg,
                  onClickOkButton: (){

                  }
              );

            }

          );
        },
        custom: _editC(
            bloc: bloc,
            idController: _idClassController,
          docClassController: _docController,
          nameClassController: _nameClassController,
          teacherController: _teacherController,
            context: context
        ),
        title: "Sửa Lớp");
  }

   Widget _editC({ClassBloc bloc,TextEditingController idController,TextEditingController teacherController,TextEditingController nameClassController,TextEditingController docClassController,BuildContext context}){
    StreamController<String> _idClassController = new StreamController<String>.broadcast();
    StreamController<String> _classDocController = new StreamController<String>.broadcast();
    final StreamController _teacherCControllerStream = new StreamController();
    _classDocController.add(null);
    return Container(
      width: 500,
      child: Column(
        children: [
          Text("Nhập Id Giáo Viên Bạn Muốn Sửa"),

          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: StreamBuilder(
                    stream: _idClassController.stream,
                    builder: (context, snapshot) => TextField(
                      controller: idController,
                      style:
                      TextStyle(fontSize: 18, color: Colors.blue),
                      decoration: InputDecoration(
                          labelText: "ID Lớp",
                          errorText:
                          snapshot.hasError ? snapshot.error : null,
                          prefixIcon: Container(
                              padding: EdgeInsets.fromLTRB(6, 6, 6, 6),
                              width: 50,
                              child: Image.asset("ic_id.png")),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFFA8DBA8), width: 1),
                              borderRadius:
                              BorderRadius.all(Radius.circular(6)))),
                    ),
                  ),
                ),
              ),

              // nut tim gv
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0,0, 20,0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: RaisedButton(
                      onPressed: () async {
                        _classDocController.add(null);
                        await _fire.getClassIDDoc(
                            ID: idController.text,
                            isClassNull: (txt){
                              nameClassController.text = "";
                              _idClassController.sink.addError(txt);
                              _classDocController.add(null);
                            },
                            haveClass: (txt){
                              print(txt);
                              _classDocController.add(txt);
                            }
                        );
                      },
                      child: Text(
                        "Tìm",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      color: Colors.redAccent,

                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6))),
                    ),
                  ),
                ),

              )
            ],
          ),
          StreamBuilder(
            stream: _classDocController.stream,
            builder: (context, snapshot) {
              Stream _streamT = _fire.getClassStream(DocID: snapshot.data);
              return snapshot.data == null ? Container() :
              StreamBuilder(
                stream:_streamT,
                builder: (context,  snapshot) {

                  if (snapshot.hasError)
                    return new Text('Error: ${snapshot.error}');
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting: return new Text('Loading...');
                    default:
                      final DocumentSnapshot  ds = snapshot.data;
                      print(snapshot.data["Name"]);
                      docClassController.text = ds.documentID;
                      nameClassController.text = ds.data['Name'];
                      teacherController.text = ds.data['Teacher'];
                      print(teacherController.text);
                      print("run");
                      _fire.getTeacherByID(TeacherID:  teacherController.text).then((value) {
                        print(value);
                        _teacherCControllerStream.add(value);
                        teacherController.text = value.data['uid'];
                        print(value.data['uid']);
                      });
                      print("run");
                      return Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: StreamBuilder(
                              stream: bloc.nameClassStream,
                              builder: (context, snapshot) => TextField(
                                controller: nameClassController,
                                style:
                                TextStyle(fontSize: 18, color: Colors.blue),

                                decoration: InputDecoration(
                                    labelText: "Tên LỚp",
                                    errorText:
                                    snapshot.hasError ? snapshot.error : null,
                                    prefixIcon: Container(
                                        padding: EdgeInsets.fromLTRB(6, 6, 6, 6),
                                        width: 50,
                                        child: Image.asset("ic_id.png")),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFFA8DBA8), width: 1),
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(6)))),
                              ),
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.all(10),
                              child:  StreamBuilder(
                                stream: _teacherCControllerStream.stream,
                                builder: (context, snapshot) {
                                  return Row(
                                    children: [
                                      Expanded(
                                        child: snapshot.hasError ? Text(snapshot.error):
                                        snapshot.hasData ?Text("Giáo Viên : ${snapshot.data['name'] + ""}"):Text(""),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(0,0, 20,0),
                                          child: SizedBox(
                                            width: double.infinity,
                                            height: 52,
                                            child: RaisedButton(
                                              onPressed: () async {

                                                CustomListDialog.showMsgDialog(
                                                    title: "Chọn Giáo Viên Cho Lớp",
                                                    context: context,
                                                    custom: Container(
                                                      width: 300,
                                                      child: StreamBuilder<QuerySnapshot>(
                                                        stream: _fire.listTeacherStream(),
                                                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                                          if (snapshot.hasError)
                                                            return new Text('Error: ${snapshot.error}');
                                                          switch (snapshot.connectionState) {
                                                            case ConnectionState.waiting: return new Text('Loading...');
                                                            default:
                                                              print(snapshot.data.documents.length);
                                                              return new ListView(
                                                                children: snapshot.data.documents.map((DocumentSnapshot document) {

                                                                  return Expanded(
                                                                    child: ListTile(
                                                                      title: new Text(document.data['name']),
                                                                      subtitle: new Text(document.data['email']),
                                                                      onTap: (){
                                                                        _teacherCControllerStream.add(document);
                                                                        CustomListDialog.hideLoadingDialog(context);
                                                                        teacherController.text = document.data['uid'];
                                                                      },
                                                                    ),
                                                                  );
                                                                }).toList(),
                                                              );
                                                          }
                                                        },
                                                      ),
                                                    )
                                                );
                                              },
                                              child: Text(
                                                "Thêm  Giáo Viên",
                                                style: TextStyle(color: Colors.white, fontSize: 18),
                                              ),
                                              color: Colors.redAccent,

                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.all(Radius.circular(6))),
                                            ),
                                          ),
                                        ),

                                      ),
                                    ],
                                  );
                                },
                              )
                          ),
                        ],
                      );
                  }



                },
              );
            },
          )
        ],
      ),
    );





  }
  void _FuncAddStudentClass(ClassBloc bloc, BuildContext context){
    final TextEditingController _idClassController = TextEditingController();
    final TextEditingController _docController = TextEditingController();
    var student = [];
    CustomInputDialog.showMsgDialog(
        context: context,
        okButton: "Sửa",
        onClickOK: () {

        },
        custom: _editStudentInClass(
            bloc: bloc,
            idController: _idClassController,
            docClassController: _docController,
          contextS: context

        ),
        title: "Thêm Sinh Viên Vào Lớp");
  }
  Widget _editStudentInClass({ClassBloc bloc,TextEditingController idController,TextEditingController docClassController,BuildContext contextS}){
    Set<String> _listStudent=new Set<String>();
    StreamController<String> _idClassController = new StreamController<String>.broadcast();
    StreamController<String> _classDocController = new StreamController<String>.broadcast();
    final StreamController _teacherCControllerStream = new StreamController();
    _classDocController.add(null);
    return Container(
      width: 500,
      child: Column(
        children: [
          Text("Nhập Id Lớp Bạn Muốn Thêm Sinh Viên"),

          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: StreamBuilder(
                    stream: bloc.idClassStream,
                    builder: (context, snapshot) => TextField(
                      controller: idController,
                      style:
                      TextStyle(fontSize: 18, color: Colors.blue),
                      decoration: InputDecoration(
                          labelText: "ID Lớp",
                          errorText:
                          snapshot.hasError ? snapshot.error : null,
                          prefixIcon: Container(
                              padding: EdgeInsets.fromLTRB(6, 6, 6, 6),
                              width: 50,
                              child: Image.asset("ic_id.png")),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFFA8DBA8), width: 1),
                              borderRadius:
                              BorderRadius.all(Radius.circular(6)))),
                    ),
                  ),
                ),
              ),

              // nut tim gv
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0,0, 20,0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: RaisedButton(
                      onPressed: () async {
                        bloc.CheckID(idController.text);
                        _classDocController.add(null);
                        await _fire.getClassIDDoc(
                            ID: idController.text,
                            isClassNull: (txt){
                              _idClassController.sink.addError(txt);
                              _classDocController.add(null);
                            },
                            haveClass: (txt){
                              print(txt);
                              _classDocController.add(txt);
                            }
                        );
                      },
                      child: Text(
                        "Tìm",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      color: Colors.redAccent,

                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6))),
                    ),
                  ),
                ),

              )
            ],
          ),
          StreamBuilder(
            stream: _classDocController.stream,
            builder: (context, snapshot) {
              Stream _streamT = _fire.getClassStream(DocID: snapshot.data);
              return snapshot.data == null ? Container() :
              StreamBuilder(
                stream:_streamT,
                builder: (context,  snapshot) {

                  if (snapshot.hasError)
                    return new Text('Error: ${snapshot.error}');
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting: return new Text('Loading...');
                    default:
                      final DocumentSnapshot  ds = snapshot.data;
                      docClassController.text = ds.documentID;

                      return Column(
                        children: [
                          Text("Danh Sách Sinh Viên Lớp ${snapshot.data["Name"]}"),
                          Container(
                            height: MediaQuery.of(context).size.height*0.5,
                            child: StreamBuilder(
                              stream: _fire.getListStudentClassStream(DocID:ds.documentID),
                              builder: (context,  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasError)
                                  return new Text('Error: ${snapshot.error}');
                                switch (snapshot.connectionState) {
                                  case ConnectionState.waiting: return new Text('Loading...');
                                  default:
                                    return  snapshot.data.documents.length >0 ?  ListView.builder(
                                      itemExtent: 80.0,
                                      itemCount: snapshot.data.documents.length,
                                      itemBuilder: (context, index){
                                        DocumentSnapshot Val;
                                        StreamController<DocumentSnapshot> _StudentController = new StreamController<DocumentSnapshot>();
                                        Stream<DocumentSnapshot> StreamStudent=_StudentController.stream;
                                        String ID = snapshot.data.documents[index]["ID"];
                                        _fire.getStudentByID(StudentID: ID).then((value){
                                          Val = value;
                                          _StudentController.add(value);
                                        });
                                        return StreamBuilder(
                                          stream: StreamStudent,
                                          builder: (context,AsyncSnapshot<DocumentSnapshot> snapshot) {
                                            switch (snapshot.connectionState) {
                                              case ConnectionState.waiting: return new Text('Loading...');
                                              default:
                                                _listStudent.add(snapshot.data.data["ID"].toString());
                                                return ListTile(
                                                  title: Text("Sinh viên :"+snapshot.data.data["name"]),
                                                  subtitle: Text("MSSV :"+snapshot.data.data["ID"]),
                                                );
                                            }
                                          },
                                        );
                                      }
                                          ,
                                    ):Text("Lớp Này Chưa Có Sinh Viên");
                                }

                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0,0, 20,0),
                            child: SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: RaisedButton(
                                onPressed: () async {

                                  CustomListDialog.showMsgDialog(
                                      title: "Thêm Sinh Viên Vào Lớp",
                                      context: context,
                                      custom: Container(
                                        width: 300,
                                        child: StreamBuilder<QuerySnapshot>(
                                          stream: _fire.listStudentStream(),
                                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                            if (snapshot.hasError)
                                              return new Text('Error: ${snapshot.error}');
                                            switch (snapshot.connectionState) {
                                              case ConnectionState.waiting: return new Text('Loading...');
                                              default:
                                                print(snapshot.data.documents.length);
                                                return new ListView(
                                                  children: snapshot.data.documents.map((DocumentSnapshot document) {

                                                    return Expanded(
                                                      child: ListTile(
                                                        title: new Text(document.data['name']),
                                                        subtitle: new Text(document.data['ID'].toString()),
                                                        onTap: (){
                                                          if(_listStudent.add(document.data['ID'].toString())){
                                                            // thêm sinh viên vào class thôi
                                                            _fire.addStudentClass(
                                                              id: document.data['ID'],
                                                              docID: docClassController.text,
                                                              isSuccess: (msg){
                                                              CustomListDialog.hideLoadingDialog(context);


                                                            },
                                                              isError: (txt){
                                                                ErrorDialog.showErrorDialog(
                                                                  context: context,
                                                                  msg: txt
                                                                );
                                                              }
                                                            );

                                                          }else{

                                                          }
                                                        },
                                                      ),
                                                    );
                                                  }).toList(),
                                                );
                                            }
                                          },
                                        ),
                                      )
                                  );
                                },
                                child: Text(
                                  "Thêm Sinh Viên",
                                  style: TextStyle(color: Colors.white, fontSize: 18),
                                ),
                                color: Colors.redAccent,

                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(6))),
                              ),
                            ),
                          )
                        ],
                      );
                  }



                },
              );
            },
          ),

        ],
      ),
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
  Widget _Sturent({String id}){
    _fire.getStudentByID(StudentID: id).then((value) {
      return  ListTile(
        title: new Text(value.data['name']),
        subtitle: new Text(value.data['ID']),
      );

    });

  }
}
