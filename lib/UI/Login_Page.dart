import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterwebacsfinal/Bloc/BlocLogin.dart';
import 'package:flutterwebacsfinal/Fire/Fire.dart';
import 'package:flutterwebacsfinal/UI/Admin_Page.dart';
import 'package:flutterwebacsfinal/UI/Dialog/CustomInputDialog.dart';
import 'package:flutterwebacsfinal/UI/Dialog/ErrorDialog.dart';
import 'package:flutterwebacsfinal/UI/Dialog/LoadDialog.dart';
import 'package:flutterwebacsfinal/UI/Home_Page.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Fire _fire = new Fire();

  @override
  void initState()  {
//    _fire.logintest((){
//      Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
//    });


    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    final Size _size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.lightBlueAccent,
      body: Container(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: _size.height*0.3,left: _size.width*0.2),
              child: Container(
                width:  _size.width*0.6,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text("ASW Login",style:GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,

                      )),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Color(0x30ADD9D9),
                          borderRadius: BorderRadius.circular(20)
                      ),
                      height: _size.height*0.4,
                      width: _size.width*0.6,
                      alignment: Alignment.center,
                      child: _LoginForm(_size),
                    )
                  ],
                ),
              )
            )
          ],
        ),


      ),
    );
  }
  Widget _LoginForm(Size size){
    LoginBloc bloc = new LoginBloc();
    final TextEditingController _userController = TextEditingController();
    final TextEditingController _passController = TextEditingController();
    print(size.width*0.6);

    return Container(
      width: size.width*0.6 >= 400 ?400: size.width*0.6,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
            child: StreamBuilder(
              stream: bloc.userStream,
              builder: (context, snapshot) => TextField(

                controller: _userController,
                style: TextStyle(fontSize: 18, color: Colors.white),
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: Colors.white),

                    labelText: "Nhập Email",
                    errorText:
                    snapshot.hasError ? snapshot.error : null,
                    prefixIcon: Container(
                        padding: EdgeInsets.fromLTRB(6, 6, 6, 6),
                        width: 50,
                        child: Image.asset("ic_gmail.png")),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        borderSide: BorderSide(color: Colors.white)
                    ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      borderSide: BorderSide(color: Colors.white)
                  ),

                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
            child: StreamBuilder(
              stream: bloc.passStream,
              builder: (context, snapshot) => TextField(
                obscureText: true,
                controller: _passController,
                style: TextStyle(fontSize: 18, color: Colors.white),
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: Colors.white),

                  labelText: "Nhập Mật Khẩu",
                  errorText:
                  snapshot.hasError ? snapshot.error : null,
                  prefixIcon: Container(
                      padding: EdgeInsets.fromLTRB(6, 6, 6, 6),
                      width: 50,
                      child: Image.asset("ic_pass.png")),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      borderSide: BorderSide(color: Colors.white)
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      borderSide: BorderSide(color: Colors.white)
                  ),

                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
            child: SizedBox(
              width: size.width*0.6 >= 250 ?250: size.width*0.6,
              height: 52,
              child: RaisedButton(
                onPressed:(){
                  if(bloc.isValOk(_userController.text, _passController.text)){
                    LoadingDialog.showLoadingDialog(context, "Đăng Nhập...");
                    _fire.Login(
                      user: _userController.text,
                      pass: _passController.text,
                      onSuccsess: (){
                        LoadingDialog.hideLoadingDialog(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
                      },
                      isAdmin: (){
                        LoadingDialog.hideLoadingDialog(context);
                        CustomInputDialog.showMsgDialog(context:context,okButton: "",title: "Chọn Cách Đăng Nhập",
                            custom: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 30),
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 52,
                                    child: RaisedButton(
                                      onPressed:(){
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));

                                      }
                                      ,
                                      child: Text(
                                        "Đăng Nhập Với Tư Cách Giáo Viên",
                                        style: TextStyle(color: Colors.white, fontSize: 18),
                                      ),
                                      color: Colors.lightBlue,

                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(6))),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 30),
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 52,
                                    child: RaisedButton(
                                      onPressed:(){
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminPage()));

                                      }
                                      ,
                                      child: Text(
                                        "Đăng Nhập Với Tư Cách ADMIN",
                                        style: TextStyle(color: Colors.white, fontSize: 18),
                                      ),
                                      color: Colors.redAccent,

                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(6))),
                                    ),
                                  ),
                                ),
                              ],
                            )
                        );


                      },
                      onErr: (txt){
                        LoadingDialog.hideLoadingDialog(context);
                        ErrorDialog.showErrorDialog(
                          msg: txt,
                          context: context
                        );
                        print(txt);
                      }
                    );
                  }
                },
                child: Text(
                  "Đăng Nhập",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                color: Colors.lightBlue,

                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6))),
              ),
            ),
          ),

        ],
      ),
    );
  }

}