import 'dart:async';

import 'package:flutterwebacsfinal/UI/Check/Validato.dart';

class DialogBloc {
  StreamController _emailController = new StreamController();
  StreamController _phoneController = new StreamController();
  StreamController _nameController = new StreamController();
  StreamController _idController = new StreamController();

  Stream get emailStream => _emailController.stream;
  Stream get phoneStream => _phoneController.stream;
  Stream get idStream => _idController.stream;
  Stream get nameStream => _nameController.stream;

  bool CheckEmail(String email) {
    if (!Validato.isEmail(email)) {
      _emailController.sink
          .addError("Bạn chưa nhập email hoặc email sai định dạng!");
      return false;
    }
    _emailController.add("ok");
    return true;
  }

  bool CheckName(String name) {
    if (!Validato.isName(name)) {
      _nameController.sink.addError("Bạn chưa nhập tên!");
      return false;
    }
    _nameController.add("ok");
    return true;
  }

  bool CheckID(String id) {
    if (!Validato.isID(id)) {
      _idController.sink.addError("Bạn chưa nhập id !");
      return false;
    }
    _idController.add("ok");
    return true;
  }

  bool CheckPhone(String phone) {
    if (!Validato.isPhoneNumber(phone)) {
      _phoneController.sink
          .addError("Bạn chưa nhập SĐT hoặc SĐT sai định dạng!");
      return false;
    }
    _phoneController.add("ok");
    return true;
  }

  void dispose() {
    _emailController.close();
    _nameController.close();
    _idController.close();
    _phoneController.close();
  }
}
