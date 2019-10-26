import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as prefix0;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socialapp/model/data.dart';
import 'package:socialapp/page/Rewriteprofile2.dart';
import 'package:socialapp/page/writeprofile.dart';
import 'package:socialapp/widgets/database_create.dart';
import 'dart:convert';
import 'Rewriteprofile.dart';

class ProfilePage extends StatefulWidget {
  final String currentId;
  ProfilePage({Key key, @required this.currentId}): super(key:key);
  @override
  _ProfilePageState createState() => _ProfilePageState(currentId: currentId);
}

class _ProfilePageState extends State<ProfilePage> {
  final String currentId;
  _ProfilePageState({Key key, @required this.currentId});

  String tmpimage;
  Uint8List TmpBytesImage;
  Uint8List BytesImage;
  File pimage;
  var userimage1;
  var tmpimage64;

  void initState() {
    super.initState();
    profileimage();
//    Future.delayed(Duration.zero, () async{
//      TmpBytesImage = await profileimage();
//    });
  }

  profileimage() async {
    userimage1 = await DBHelper().getuserIMAGE1('roro');
    print(userimage1);
    if (userimage1 == Null) {
      print('Empty');
    } else {
      setState(() {
        userimage1.map((e) {
          tmpimage = e['image0'];
        }).toList();
        print(tmpimage);
        return tmpimage;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    TmpBytesImage = Base64Decoder().convert(tmpimage);
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 50, bottom: 20),
                child: Container(
                  //맨위 프로필 전체컨테이너
                  width: MediaQuery.of(context).size.width / 1.3,
                  height: MediaQuery.of(context).size.height / 8,
                  decoration: BoxDecoration(
                      color: Colors.white,
//                      gradient: LinearGradient(
//                        colors: [
//                          Color.fromRGBO(255, 144, 128, 1),
//                          Color.fromRGBO(255, 144, 128, 1)
//                        ],
//                        begin: Alignment.topLeft,
//                        end: Alignment.bottomRight,
//                      ),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(4.0, 4.0),
                          blurRadius: 0,
                        ),
                      ],
                      border: Border.all(
                          color: Colors.black12,
                          width: 1.5,
                          style: BorderStyle.solid),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Row(
                    children: <Widget>[
                      InkWell(
                        //프로필사진
                        child: Padding(
                          padding: EdgeInsets.only(right: 0, left: 20),
                          child: Center(
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  child: Container(
                                    width:
                                    MediaQuery.of(context).size.width / 4.1,
                                    height:
                                    MediaQuery.of(context).size.height / 10,
                                    decoration: BoxDecoration(
//                                    shape: BoxShape.circle,
//                                      border: Border.all(
//                                          color: Colors.black87,
//                                          width: 2,),
                                    ),
                                    child: (TmpBytesImage == null)
                                        ? Icon(Icons.camera_alt,
                                        color: Colors.black26)
                                        : Image.memory(TmpBytesImage,
                                        fit: BoxFit.fill),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        onTap: (){
//                          asdasd() async{
//                            var getttt = await getTopuser();
//                            print(getttt[2]);
//                          }
//                          asdasd();
                        },
                      ),
                      Column(
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => REwriteprofile()));
                            },
                            //오른쪽위
                            child: Padding(
                              padding: EdgeInsets.only(left: 20, top: 20),
                              child: Container(
                                child: Center(
                                  child: Text(
                                    '+ 프로필 사진 수정',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: prefix0.FontStyle.normal,
                                    ),
                                  ),
                                ),
//                                width: MediaQuery.of(context).size.width / 3,
//                                height: MediaQuery.of(context).size.height / 25,
//                                decoration: BoxDecoration(
//                                    color: Colors.white,
//                                    border: Border.all(
//                                        color: Colors.black12,
//                                        width: 1.5,
//                                        style: BorderStyle.solid),
//                                    borderRadius:
//                                        BorderRadius.all(Radius.circular(15))),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Container(
                              height: 1,
                              width: MediaQuery.of(context).size.width / 3,
                              color: Colors.black26,
                            ),
                          ),
                          InkWell(
                            //오른쪽위
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Rewriteprofile2()));
                            },
                            child: Padding(
                              padding: EdgeInsets.only(left: 20, top: 13),
                              child: Container(
                                child: Center(
                                  child: Text(
                                    '+ 자기소개 수정',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: prefix0.FontStyle.normal,
                                    ),
                                  ),
                                ),
//                                width: MediaQuery.of(context).size.width / 3,
//                                height: MediaQuery.of(context).size.height / 25,
//                                decoration: BoxDecoration(
//                                    color: Colors.white,
//                                    border: Border.all(
//                                        color: Colors.black12,
//                                        width: 1.5,
//                                        style: BorderStyle.solid),
//                                    borderRadius:
//                                        BorderRadius.all(Radius.circular(15))),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 30, bottom: 20),
                child: Container(
                  height: 1,
                  width: MediaQuery.of(context).size.width / 1.4,
                  color: Colors.black26,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 30),
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.3,
                  height: MediaQuery.of(context).size.height / 14,
                  decoration: BoxDecoration(
                      color: Colors.white,
//                      gradient: LinearGradient(
//                        colors: [
//                          Color.fromRGBO(255, 144, 28, 1),
//                          Color.fromRGBO(255, 144, 1228, 1)
//                        ],
//                        begin: Alignment.topLeft,
//                        end: Alignment.bottomRight,
//                      ),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(2.0, 2.0),
                          blurRadius: 0,
                        ),
                      ],
                      border: Border.all(
                          color: Colors.black12,
                          width: 1.5,
                          style: BorderStyle.solid),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Icon(
                          Icons.info,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Text(
                          '공지사항',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 30),
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.3,
                  height: MediaQuery.of(context).size.height / 14,
                  decoration: BoxDecoration(
                      color: Colors.white,
//                      gradient: LinearGradient(
//                        colors: [
//                          Color.fromRGBO(255, 144, 28, 1),
//                          Color.fromRGBO(255, 144, 1228, 1)
//                        ],
//                        begin: Alignment.topLeft,
//                        end: Alignment.bottomRight,
//                      ),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(2.0, 2.0),
                          blurRadius: 0,
                        ),
                      ],
                      border: Border.all(
                          color: Colors.black12,
                          width: 1.5,
                          style: BorderStyle.solid),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Icon(
                          Icons.info,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Text(
                          '안내사항',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 30),
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.3,
                  height: MediaQuery.of(context).size.height / 14,
                  decoration: BoxDecoration(
                      color: Colors.white,
//                      gradient: LinearGradient(
//                        colors: [
//                          Color.fromRGBO(255, 144, 28, 1),
//                          Color.fromRGBO(255, 144, 1228, 1)
//                        ],
//                        begin: Alignment.topLeft,
//                        end: Alignment.bottomRight,
//                      ),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(2.0, 2.0),
                          blurRadius: 0,
                        ),
                      ],
                      border: Border.all(
                          color: Colors.black12,
                          width: 1.5,
                          style: BorderStyle.solid),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Icon(
                          Icons.info,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Text(
                          '공지사항',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
