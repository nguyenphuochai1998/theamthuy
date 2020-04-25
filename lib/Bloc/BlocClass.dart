import 'dart:async';

import 'package:flutterwebacsfinal/UI/Check/Validato.dart';

class ClassBloc {
  StreamController _nameClassController = new StreamController();
  StreamController _teacherController = new StreamController();
  StreamController _idClassController = new StreamController();

  Stream get nameClassStream => _nameClassController.stream;
  Stream get teacherStream => _teacherController.stream;
  Stream get idClassStream => _idClassController.stream;

  bool CheckNameClass(String name) {
    if (!Validato.isName(name)) {
      _nameClassController.sink
          .addError("Bạn chưa nhập tên lớp !");
      return false;
    }
    _nameClassController.add("ok");
    return true;
  }

  bool CheckTeacher(String name) {
    if (!Validato.isName(name)) {
      _teacherController.sink.addError("Bạn chưa nhập tên giáo viên của lớp!");
      return false;
    }
    _teacherController.add("ok");
    return true;
  }

  bool CheckID(String id) {
    if (!Validato.isID(id)) {
      _idClassController.sink.addError("Bạn chưa nhập id lớp!");
      return false;
    }
    _idClassController.add("ok");
    return true;
  }


}
