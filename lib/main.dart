import 'package:flutter/material.dart';
import 'package:socialapp/page/home.dart';
import 'package:socialapp/page/loginscreen.dart';
import 'package:socialapp/page/signup.dart' as prefix0;
import 'package:socialapp/page/writeprofile.dart';
import 'package:socialapp/page/Channel.dart';
import 'package:socialapp/page/writeprofile2.dart';
import 'package:socialapp/base.dart';
import 'package:provider/provider.dart';
import 'widgets/Bloc.dart';
import 'Routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{

  static const String _title = 'flutter code';
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BlocProvider>.value(value: BlocProvider()),
        ChangeNotifierProvider<IdProvider>.value(value: IdProvider()),
      ],
      child: MaterialApp(
        routes: <String, WidgetBuilder>{
          '/home' : (BuildContext context) => Mainhome(currentId: prefix0.currentId,),
      },
        debugShowCheckedModeBanner: false,
        title: _title,
        home: LoginScreen(),
      ),
    );
  }
}

