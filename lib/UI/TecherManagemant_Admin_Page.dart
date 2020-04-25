import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterwebacsfinal/Bloc/BlocDialog.dart';
import 'package:flutterwebacsfinal/Fire/Fire.dart';
import 'package:flutterwebacsfinal/UI/Dialog/CustomInputDialog.dart';
import 'package:flutterwebacsfinal/UI/Dialog/LoadDialog.dart';
import 'Dialog/ErrorDialog.dart';
import 'Dialog/NotificationDialog.dart';


class TecherManagerAdminPage extends StatefulWidget {
  TecherManagerAdminPage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _TecherManagerAdminPageState createState() => _TecherManagerAdminPageState();
}

class _TecherManagerAdminPageState extends State<TecherManagerAdminPage> {
  Fire _fire = new Fire();

  @override
  Widget build(BuildContext context) {

    return _TeacherManagement();
  }

  Widget _TeacherManagement() {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          alignment: Alignment.center,
          child: Text("Quản Lý Giáo Viên"),
        ),
      ),
      body: _MenuTecherManagemant(),
    );
  }

  // ui cho menu giáo viên
  var _nameTagTM = ["Thêm Giáo Viên", "Sửa thông tin giáo viên"];
  var _iconTagTM = ["ic_add_user.png", "ic_edit_user.png"];
  Widget _MenuTecherManagemant() {
    return GridView.builder(
      itemCount: _iconTagTM.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 1, crossAxisSpacing: 1),
      itemBuilder: (BuildContext context, int index) {
        return Center(
          child: GestureDetector(
              onTap: () {
                ClickFuncTecher(context: context, index: index);
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

  void ClickFuncTecher({int index, BuildContext context}) {
    DialogBloc _bloc = new DialogBloc();
    switch (index) {
      case 0:
        {
          _FuncAddTecher(_bloc,context);
          //Thêm Giáo Viên
        }
        break;
      case 1:
        {
          _FuncEditTecher(_bloc,context);
        }
        break;
    }
  }
  void _FuncAddTecher(DialogBloc bloc, BuildContext context){
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _idController = TextEditingController();
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _phoneController = TextEditingController();

    CustomInputDialog.showMsgDialog(
        context: context,
        okButton: "ok",
        onClickOK: () {

          bool _isEmail,_isName,_isID,_isPhone;
          _isEmail = bloc.CheckEmail(_emailController.text);
          _isID =bloc.CheckID(_idController.text);
          _isPhone = bloc.CheckPhone(_phoneController.text);
          _isName = bloc.CheckName(_nameController.text);
          if(_isEmail && _isID && _isPhone &&_isName){
            LoadingDialog.showLoadingDialog(context,"Loading...");
            // tao tk giao vien
            _fire.AddTeacher(
                Email:_emailController.text,
                ID: _idController.text,
                Name:_nameController.text,
                SDT: _phoneController.text,
                isCreateTecher: (msg){
                  LoadingDialog.hideLoadingDialog(context);
                  CustomInputDialog.hideLoadingDialog(context);
                  NotificationDialog.showNotificationDialog(
                      context: context,
                      msg: msg,
                      onClickOkButton: (){

                      }
                  );

                },
                isErr: (err){
                  LoadingDialog.hideLoadingDialog(context);
                  ErrorDialog.showErrorDialog(
                      msg: err,
                      context: context
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
                  stream: bloc.emailStream,
                  builder: (context, snapshot) => TextField(
                    controller: _emailController,
                    style:
                    TextStyle(fontSize: 18, color: Colors.blue),

                    decoration: InputDecoration(
                        labelText: "Email Giáo Viên",
                        errorText:
                        snapshot.hasError ? snapshot.error : null,
                        prefixIcon: Container(
                            padding: EdgeInsets.fromLTRB(6, 6, 6, 6),
                            width: 50,
                            child: Image.asset("ic_gmail.png")),
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
                  stream: bloc.idStream,
                  builder: (context, snapshot) => TextField(
                    controller: _idController,
                    style:
                    TextStyle(fontSize: 18, color: Colors.blue),
                    decoration: InputDecoration(
                        labelText: "ID Giáo Viên",
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
                  stream: bloc.nameStream,
                  builder: (context, snapshot) => TextField(
                    controller: _nameController,
                    style:
                    TextStyle(fontSize: 18, color: Colors.blue),
                    decoration: InputDecoration(
                        labelText: "Tên Giáo Viên",
                        errorText:
                        snapshot.hasError ? snapshot.error : null,
                        prefixIcon: Container(
                            padding: EdgeInsets.fromLTRB(6, 6, 6, 6),
                            width: 50,
                            child: Image.asset("ic_name.png")),
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
                  stream: bloc.phoneStream,
                  builder: (context, snapshot) => TextField(
                    controller: _phoneController,
                    style:
                    TextStyle(fontSize: 18, color: Colors.blue),
                    decoration: InputDecoration(
                        labelText: "SĐT Giáo Viên",
                        errorText:
                        snapshot.hasError ? snapshot.error : null,
                        prefixIcon: Container(
                            padding: EdgeInsets.fromLTRB(6, 6, 6, 6),
                            width: 50,
                            child: Image.asset("ic_call.png")),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xFFA8DBA8), width: 1),
                            borderRadius:
                            BorderRadius.all(Radius.circular(6)))),
                  ),
                ),
              )
            ],
          ),
        ),
        title: "Thêm Giáo Viên");
  }
  void _FuncEditTecher(DialogBloc bloc, BuildContext context){
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _idController = TextEditingController();
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _phoneController = TextEditingController();
    final TextEditingController _docController = TextEditingController();
    CustomInputDialog.showMsgDialog(
        context: context,
        okButton: "Sửa",
        onClickOK: () {

          bool _isEmail,_isName,_isPhone;
          _isEmail = bloc.CheckEmail(_emailController.text);
          _isPhone = bloc.CheckPhone(_phoneController.text);
          _isName = bloc.CheckName(_nameController.text);
          if(_isEmail && _isPhone && _isPhone &&_isName){
            LoadingDialog.showLoadingDialog(context, "Loading...");
            _fire.editTeacher(
              idDoc: _docController.text,
              name: _nameController.text,
              SDT: _phoneController.text,
              isError: (err){
                LoadingDialog.hideLoadingDialog(context);
                ErrorDialog.showErrorDialog(context: context,msg: err);
              },
              isSuccess: (msg){
                LoadingDialog.hideLoadingDialog(context);
                CustomInputDialog.hideLoadingDialog(context);
                NotificationDialog.showNotificationDialog(
                  msg: msg,
                  context: context
                );
              });

          }


        },
        custom: _editT(
          bloc: bloc,
          emailController: _emailController,
          idController: _idController,
          nameController: _nameController,
          phoneController: _phoneController,
            docController:_docController
        ),
        title: "Sửa Giáo Viên");
  }
  Widget _editT({DialogBloc bloc,TextEditingController emailController,TextEditingController idController,TextEditingController phoneController,TextEditingController nameController,TextEditingController docController}){
    StreamController<String> _idController = new StreamController<String>.broadcast();
    StreamController<String> _teachDocController = new StreamController<String>.broadcast();
    _teachDocController.add(null);
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
                    stream: _idController.stream,
                    builder: (context, snapshot) => TextField(
                      controller: idController,
                      style:
                      TextStyle(fontSize: 18, color: Colors.blue),
                      decoration: InputDecoration(
                          labelText: "ID Giáo Viên",
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
                        _teachDocController.add(null);
                       await _fire.getTeacherIDDoc(
                          ID: idController.text,
                          isTeacherNull:  (txt){
                            docController.text = "";
                            nameController.text = "";
                            phoneController.text = "";
                            emailController.text = "";
                            _idController.sink.addError(txt);
                            _teachDocController.add(null);
                          },
                         haveTeacher: (txt){
                            idController.text = "";
                            print(txt);
                           _teachDocController.add(txt);
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
           stream: _teachDocController.stream,
           builder: (context, snapshot) {
             Stream _streamT = _fire.getTeacherStream(DocID: snapshot.data);
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
                         docController.text = ds.documentID;
                         emailController.text = ds['email'];
                         nameController.text = ds['name'];
                         phoneController.text = ds['phone'];
                         _streamT.distinct();
                         return Column(
                           children: [
                             Text("Thông Tin Giáo Viên Có ID ${ds['uid']}"),
                             Padding(
                               padding: EdgeInsets.all(10),
                               child: StreamBuilder(
                                 stream: bloc.emailStream,
                                 builder: (context, snapshot) => TextField(
                                   controller: emailController,
                                   style:
                                   TextStyle(fontSize: 18, color: Colors.blue),

                                   decoration: InputDecoration(
                                       labelText: "Email Giáo Viên",
                                       errorText:
                                       snapshot.hasError ? snapshot.error : null,
                                       prefixIcon: Container(
                                           padding: EdgeInsets.fromLTRB(6, 6, 6, 6),
                                           width: 50,
                                           child: Image.asset("ic_gmail.png")),
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
                                 stream: bloc.nameStream,
                                 builder: (context, snapshot) => TextField(
                                   controller: nameController,
                                   style:
                                   TextStyle(fontSize: 18, color: Colors.blue),
                                   decoration: InputDecoration(
                                       labelText: "Tên Giáo Viên",
                                       errorText:
                                       snapshot.hasError ? snapshot.error : null,
                                       prefixIcon: Container(
                                           padding: EdgeInsets.fromLTRB(6, 6, 6, 6),
                                           width: 50,
                                           child: Image.asset("ic_name.png")),
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
                                 stream: bloc.phoneStream,
                                 builder: (context, snapshot) => TextField(
                                   controller: phoneController,
                                   style:
                                   TextStyle(fontSize: 18, color: Colors.blue),
                                   decoration: InputDecoration(
                                       labelText: "SĐT Giáo Viên",
                                       errorText:
                                       snapshot.hasError ? snapshot.error : null,
                                       prefixIcon: Container(
                                           padding: EdgeInsets.fromLTRB(6, 6, 6, 6),
                                           width: 50,
                                           child: Image.asset("ic_call.png")),
                                       border: OutlineInputBorder(
                                           borderSide: BorderSide(
                                               color: Color(0xFFA8DBA8), width: 1),
                                           borderRadius:
                                           BorderRadius.all(Radius.circular(6)))),
                                 ),
                               ),
                             )

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
}
