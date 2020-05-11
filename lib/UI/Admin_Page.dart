import 'package:flutter/material.dart';
import 'package:flutterwebacsfinal/Fire/Fire.dart';
import 'package:flutterwebacsfinal/UI/ClassManagemant_Admin_Page.dart';
import 'package:flutterwebacsfinal/UI/TecherManagemant_Admin_Page.dart';

import 'Dialog/ErrorDialog.dart';
import 'Dialog/LoadDialog.dart';
import 'Login_Page.dart';


class AdminPage extends StatefulWidget {
  AdminPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  Fire _fire = new Fire();
  Widget _func = new Container();
  @override
  Widget build(BuildContext context) {
    Size _sizeScreen = MediaQuery.of(context).size;
    Size _sizeMenu = new Size(_sizeScreen.width * 0.3, _sizeScreen.height);
    Size _sizeFunc =
        new Size(_sizeScreen.width - _sizeMenu.width, _sizeScreen.height);
    return WillPopScope(
      child:Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                width: 150,
                height: 52,
                child: RaisedButton(
                  onPressed:(){
                    _fire.logOut(
                        isLogOut: (){
                          LoadingDialog.showLoadingDialog(context, "Đăng xuất");
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
                        },
                        isErr: (err){
                          ErrorDialog.showErrorDialog(context: context,msg: err);
                        }
                    );
                  }
                  ,
                  child: Text(
                    "Đăng xuất",
                    style: TextStyle(color: Colors.blue, fontSize: 18),
                  ),
                  color: Colors.white,

                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6))),
                ),
              ),
            ),
          ],
          title: Text(
            "ADMIN",
          ),
        ),
        body: Container(
          child: Stack(
            children: <Widget>[
              //giao dien chuc nang
              Container(
                margin: EdgeInsets.only(left: _sizeMenu.width),
                width: _sizeFunc.width,
                height: _sizeFunc.height,
                child: _func,
              ),
              Container(
                child: _Menu(),
                height: _sizeMenu.height,
                width: _sizeMenu.width,
              ),
            ],
          ),
        ),
      ) ,
    );

  }

  Widget _Menu() {

    Color _colorTextMenu = Color(0xffE64C4E);
    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        ListTile(
          title: Text("Quản Lý Giáo Viên"),
          onTap: () {
            setState(() {
              _func = TecherManagerAdminPage();
            });
          },
        ),
        ListTile(
          title: Text("Quản Lý Lớp Học"),
          onTap: () {
            setState(() {
              _func = ClassManagerAdminPage();
            });
          },
        ),
      ],
    );
  }
  // khu vực quản lý chức năng cho giáo viên----------------------------------------------------------------------------------
  // quản lý ui chức năng cho giáo viên

}
