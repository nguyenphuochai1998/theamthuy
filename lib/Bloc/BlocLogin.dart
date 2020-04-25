import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterwebacsfinal/Fire/Fire.dart';
import 'package:flutterwebacsfinal/UI/Check/Validato.dart';


class LoginBloc{
  StreamController _userController = new StreamController();
  StreamController _passController = new StreamController();

  Stream get userStream => _userController.stream;
  Stream get passStream => _passController.stream;
  Fire _fire = new Fire();
  bool isValOk(String user,String pass){
    if(!Validato.isPhoneNumber(user)){
      if(!Validato.isEmail(user)){
        _userController.sink.addError("Nhập Email!");
        return false;
      }
    }
    if(!Validato.isPass(pass)){
      _passController.sink.addError("Mật Khẩu Phải Có 6 Kí Tự Hoặc Hơn!");
      return false;
    }
    _passController.add("ok");
    _userController.add("ok");
    return true;
  }




  void dispose(){
    _userController.close();
    _passController.close();
  }
}