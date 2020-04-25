
import 'package:flutter/material.dart';
import 'package:flutterwebacsfinal/UI/Admin_Page.dart';
import 'package:flutterwebacsfinal/UI/Home_Page.dart';

import 'UI/Login_Page.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {





  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: LoginPage(),
    );
  }
}
