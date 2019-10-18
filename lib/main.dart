import 'package:flutter/material.dart';
import 'package:socialapp/page/loginscreen.dart';
import 'package:socialapp/page/writeprofile.dart';
import 'package:socialapp/page/Channel.dart';
import 'package:socialapp/page/writeprofile2.dart';
import 'package:socialapp/base.dart';

import 'Routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{

  static const String _title = 'flutter code';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      home: LoginScreen(),
    );
  }
}

