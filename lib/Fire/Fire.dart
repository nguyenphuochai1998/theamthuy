
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';



class Fire{
  final Firestore _fireS = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // tạo giáo viên
  Future<void> AddTeacher({String Name,String SDT,String Email,String ID,Function(String) isCreateTecher,Function(String) isErr}) async {
      await _auth.createUserWithEmailAndPassword(email: Email, password: Random6Num().toString()).then((value) {
        UserUpdateInfo userUpdateInfo = new UserUpdateInfo();
        userUpdateInfo.displayName = Name;
        var user = value.user;
        print("đã thêm vào user");
        user.updateProfile(userUpdateInfo);
        _fireS.collection('Teacher').document().setData({
          'name': Name,
          'uid': ID,
          'email': user.email,
          'phone': SDT
        }).then((value) async {
          print("đã tạo");
          await _auth.sendPasswordResetEmail(email: Email);
          isCreateTecher("Đã Tạo Giáo Viên Trên Hệ Thống Thành Công,Một email xát nhận và ghi lại mật khẩu được gửi đến giáo viên");
        });
      }).catchError((Err) {
          if(Err.code == "auth/email-already-in-use"){
            isErr("Đã có giáo viên sử dụng tài khoản này trên hệ thống");
          }
      });
  }
  Future<void> SendPassTeacher({String Email,Function(String) isSendPassToTecher,Function(String) isError}) async {
    await _auth.sendPasswordResetEmail(email: Email).then((val){
      isSendPassToTecher("Đã gửi lại gmail cấp mật khẩu cho giáo viên này");
    }).catchError((err){
      if(err.code == "auth/user-not-found"){
        isError("Không Có Giáo Viên Nào Có Gmail Này");
      }else{
        isError("Có Lỗi Xãy Ra");
      }

    });
  }
  Future<void> getTeacherIDDoc({String ID,Function(String) isTeacherNull,Function(String) haveTeacher}) async {
     await _fireS.collection("Teacher").where("uid",isEqualTo: ID).getDocuments().then((value) {
       if(value.documents.length == 0) {
         isTeacherNull("Không có giáo viên này trong cơ sở dữ liệu");

       } else{
         value.documents.forEach((element) {
           haveTeacher(element.documentID);

         });
       }
     });
  }
  Future<void> logOut({Function() isLogOut,Function(String) isErr}) async {
    await _auth.signOut().then((value){
          isLogOut();
      }).catchError((err){
        isErr("Gặp Lỗi !!");
    });
  }
  Future<void> getClassIDDoc({String ID,Function(String) isClassNull,Function(String) haveClass}) async {
    await _fireS.collection("Class").where("IDClass",isEqualTo: ID).getDocuments().then((value) {
      if(value.documents.length == 0) {
        isClassNull("Không có lớp này trong cơ sở dữ liệu");

      } else{
        value.documents.forEach((element) {
          haveClass(element.documentID);

        });
      }
    });
  }
  void editTeacher({String name,String SDT,String idDoc,Function(String) isSuccess,Function(String) isError}){
    _fireS.collection("Teacher").document(idDoc).updateData({
      'phone':SDT,
      'name':name
    }).then((val) {

      isSuccess("Sửa đổi thành công!!");

      }
    );

  }
  Stream listTeacherStream(){
    return _fireS.collection("Teacher").orderBy("name",descending: true).snapshots();
  }
  Stream listStudentStream(){
    return _fireS.collection("SinhVien").orderBy("name",descending: true).snapshots();
  }
  Stream<QuerySnapshot> listClassStreamByIDTeacher({String id}){
    return _fireS.collection("Class").where("Teacher",isEqualTo: id).snapshots();
  }
  Stream<QuerySnapshot> listClassHistoryStreamByIDClass({String id}){
    return _fireS.collection("Class").document(id).collection("Period").orderBy("Start time",descending: true).snapshots();
  }
  Stream<QuerySnapshot> listClassHistoryStudentStream({String idClass,String idPeriod}){
    return _fireS.collection("Class").document(idClass).collection("Period").document(idPeriod).collection("Student").orderBy("TimeToClass",descending: true).snapshots();
  }
  Future<void> addStudentClass({String id,String docID,Function(String) isSuccess,Function(String) isError}) async {
    await _fireS.collection("Class").document(docID).collection("Student").document().setData({
      "ID" : id,
      "Period Missed": 0,
    });
    isSuccess("Đã thêm sinh viên vào lớp");
  }
  Future<void> addClass({String nameClass,String idTeacher,String idClass,Function(String) isSuccess,Function(String) isError}) async {

   await ktUUID(collection: "Class",fi:"uuidClass" ).then((value) {
      print("testUUUUUUUUID:$value");
      _fireS.collection("Class").document().setData({
        "IDClass":idClass,
        "Name":nameClass,
        "uuidClass": value.toString(),
        "Teacher" : idTeacher,
        "isOpen" : false

      }).then((val) {

        isSuccess("Tạo lớp thành công!!");

      }
      );

    });



  }
  Future<void> editClass({String name,String teacher,String idDoc,String idClass,Function(String) isSuccess,Function(String) isError}) async {
    await ktUUID(collection: "Class",fi:"uuidClass" ).then((value) {
      print("testUUUUUUUUID:$value");
      _fireS.collection("Class").document(idDoc).updateData({
        'IDClass':idClass,
        'Name':name,
        'Teacher':teacher,
        'uuidClass':value.toString()
      }).then((val) {

        isSuccess("Sửa đổi thành công!!");

      }
      );

    });


  }
  Future<void> createNewUuidClass({String idDocClass,Function isSuccess}) async {
    await ktUUID(collection: "Class",fi:"uuidClass" ).then((value) {
      print("testUUUUUUUUID:$value");
      _fireS.collection("Class").document(idDocClass).updateData({
        'uuidClass':value.toString()
      }).then((val) {

        isSuccess();

      }
      );

    });
  }
  Future<int> ktUUID({String collection,String fi}) async {
    int val = Random6Num();
    int kt=1;
      await _fireS.collection(collection).where(fi,isEqualTo: val.toString()).getDocuments().then((event)  async {
       print("số lượng là:${event.documents.length}");
       kt = event.documents.length;

      });
      if(kt ==0){
        return val;

      }else{
        return ktUUID(collection: collection,fi: fi);
      }
  }


  Stream getTeacherStream({String DocID}){
    return _fireS.collection("Teacher").document(DocID).get().asStream();
  }
  // da sua ngay 22/4
  Stream<DocumentSnapshot> getClassStream({String DocID}){
    return _fireS.collection("Class").document(DocID).get().asStream();
  }

  Stream<QuerySnapshot> getListStudentClassStream({String DocID}){
    return _fireS.collection("Class").document(DocID).collection("Student").snapshots();
  }
  Stream<QuerySnapshot> getStudentClassStream({String DocID,String StudentID}){
    return _fireS.collection("Class").document(DocID).collection("Student").where("ID",isEqualTo: StudentID).snapshots();
  }
  Stream<QuerySnapshot> getListStudentPeriodMissed2ClassStream({String DocID}){
    return _fireS.collection("Class").document(DocID).collection("Student").where("Period Missed",isEqualTo: 2).snapshots();
  }
  Stream<QuerySnapshot> getListStudentPeriodMissedBigClassStream({String DocID}){
    return _fireS.collection("Class").document(DocID).collection("Student").where("Period Missed",isGreaterThan:2 ).snapshots();
  }
  Stream<QuerySnapshot> getStudentByIdStream({String ID}){
    return _fireS.collection("SinhVien").where("ID",isEqualTo: ID).snapshots();
  }
  Stream<QuerySnapshot> getTeacherByIdStream({String ID}){
    return _fireS.collection("Teacher").where("uid",isEqualTo: ID).snapshots();
  }
  Stream<QuerySnapshot> getInfoStudentByIdStream({String IDStudent,String IDClass}){
    return _fireS.collection("Class").document(IDClass).collection("Student").where("ID",isEqualTo: IDStudent).snapshots();
  }
  Future<DocumentSnapshot> getStudentByID({String StudentID}) async {
    DocumentSnapshot val;
    await _fireS.collection("SinhVien").where("ID",isEqualTo: StudentID).getDocuments().then((value) {
      value.documents.forEach((element) {
        val = element;
      });
    });
    return val;
  }
  Future<DocumentSnapshot> getTeacherByID({String TeacherID}) async {
    DocumentSnapshot val;
    await _fireS.collection("Teacher").where("uid",isEqualTo: TeacherID).getDocuments().then((value) {
      value.documents.forEach((element) {
        val = element;
      });
    });
    return val;
  }
  Future<DocumentSnapshot> getTeacherByEmail({String Email}) async {
    DocumentSnapshot val;
    await _fireS.collection("Teacher").where("email",isEqualTo: Email).getDocuments().then((value) {
      value.documents.forEach((element) {
        val = element;
      });
    });
    return val;
  }
  int Random6Num(){

    var rng = new Random();
    print("Tự randommmmmmmmmmmmmmm ${rng.nextInt(900000) + 100000}");
    return rng.nextInt(900000) + 100000;

  }
  Future<void> Login({String user,String pass,Function onSuccsess,Function isAdmin,Function(String) onErr}) async {
    await _auth.signInWithEmailAndPassword(email: user, password: pass)
        .then((user){
          String email = user.user.email;
          _fireS.collection("Admin").where("Email",isEqualTo: email).getDocuments().then((value) {
            if(value.documents.length > 0){
              isAdmin();
            }else{

              onSuccsess();
            }
          });

    }).catchError((err){
      print(err.code);
      switch(err.code){
        case "auth/wrong-password":
          onErr("Mật Khẩu Không Đúng");
          break;
        case "auth/user-not-found":
          onErr("Không Có Tài Khoản Này Trong Hệ Thống");
          break;
      }


    });
  }
//  Future<void> logintest(Function run) async {
//    await _auth.signInWithEmailAndPassword(email: "nguyenphuochai98@gmail.com", password: "haitovai3").then((value){
//      run();
//    });
//  }
  Future<void> endAttendance({String docID}) async {
    await _fireS.collection("Class").document(docID).updateData({
      "isOpen" : false
    });
  }
  Future<void> updatePointStudentInClass({int pointNow,String idDocClass,String idDocStudent}) async {
    await _fireS.collection("Class").document(idDocClass).collection("Student").document(idDocStudent).updateData({"Period Missed" : pointNow+1});
  }
}