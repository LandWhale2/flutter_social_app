import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as prefix0;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:socialapp/model/data.dart';
import 'package:socialapp/page/Rewriteprofile2.dart';
import 'package:socialapp/page/contextpage.dart';
import 'package:socialapp/page/writeprofile.dart';
import 'package:socialapp/widgets/database_create.dart';
import 'dart:convert';
import '../main.dart';
import 'Rewriteprofile.dart';

class ProfilePage extends StatefulWidget {
  final String currentId;

  ProfilePage({Key key, @required this.currentId}) : super(key: key);

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
//    profileimage();
//    Future.delayed(Duration.zero, () async{
//      TmpBytesImage = await profileimage();
//    });
  }

//  profileimage() async {
//    userimage1 = await DBHelper().getuserIMAGE1('roro');
//    print(userimage1);
//    if (userimage1 == Null) {
//      print('Empty');
//    } else {
//      setState(() {
//        userimage1.map((e) {
//          tmpimage = e['image0'];
//        }).toList();
//        print(tmpimage);
//        return tmpimage;
//      });
//    }
//  }
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<Null> handleSignOut() async {

    await FirebaseAuth.instance.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();


    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MyApp()),
            (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: StreamBuilder(
            stream: Firestore.instance
                .collection('users')
                .document(currentId)
                .snapshots(),
            builder: (context, snapshot) {
              DocumentSnapshot ds = snapshot.data;
              if(!snapshot.hasData){return Container();}
              return Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height /3.5,
                        color: maincolor,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height/4,
                        color: Color.fromRGBO(255, 125, 128, 250),
                      ),
//                      Container(
//                        height: MediaQuery.of(context).size.height/6,
//                        color: maincolor,
//                      ),
                    ],
                  ),
                  Center(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 30,
                        ),
                        ProfileCard(context, ds['image'][0]),
                        SizedBox(
                          height: 30,
                        ),
                        SettingContainer(context),
                      ],
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }


  Widget SettingContainer(BuildContext context){
    return Container(//설정네모칸 전체컨테이너
      width: MediaQuery.of(context).size.width /1.1,
      height: MediaQuery.of(context).size.height / 2,
      child: Column(//전체 column
        children: <Widget>[
          Container(//Row 컨테이너
            width: MediaQuery.of(context).size.width/1.1 ,
            height: MediaQuery.of(context).size.height / 4,
            child: Row(//위에 두개
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                InkWell(
                  onTap: handleSignOut,
                  child: Container(
                    width: MediaQuery.of(context).size.width/3 ,
                    height: MediaQuery.of(context).size.height / 6,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: Colors.black,
                          width: 0.1,
                          style: BorderStyle.solid),
                    ),
                    child: Center(
                      child: Text(
                          '설정',
                        style: TextStyle(
                          fontFamily: 'NIX',
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width/3 ,
                  height: MediaQuery.of(context).size.height / 6,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: Colors.black,
                        width: 0.1,
                        style: BorderStyle.solid),
                  ),
                  child: Center(
                    child: Text(
                      '공지사항',
                      style: TextStyle(
                        fontFamily: 'NIX',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(//아래 row 컨테이너
            width: MediaQuery.of(context).size.width/1.1 ,
            height: MediaQuery.of(context).size.height /4.1,
            child: Row(//아래 두개
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width/3 ,
                  height: MediaQuery.of(context).size.height / 6,
                  decoration: BoxDecoration(

                    color: Colors.white,
                    border: Border.all(
                        color: Colors.black,
                        width: 0.1,
                        style: BorderStyle.solid),
                  ),
                  child: Center(
                    child: Text(
                      '마이페이지',
                      style: TextStyle(
                        fontFamily: 'NIX',
                      ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width/3 ,
                  height: MediaQuery.of(context).size.height / 6,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: Colors.black,
                        width: 0.1,
                        style: BorderStyle.solid),
                  ),
                  child: Center(
                    child: Text(
                      '공지사항',
                      style: TextStyle(
                        fontFamily: 'NIX',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget ProfileCard(BuildContext context, String profileImage) {
    return Container(
//맨위 프로필 전체컨테이너
      width: MediaQuery.of(context).size.width / 1.3,
      height: MediaQuery.of(context).size.height / 6,
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black26,
              offset: Offset(4.0, 4.0),
              blurRadius: 0,
            ),
          ],
          border: Border.all(
              color: Colors.black12, width: 1.5, style: BorderStyle.solid),
          borderRadius: BorderRadius.all(Radius.circular(0))),
      child: Row(
        children: <Widget>[
          InkWell(
            //프로필 사진
            child: Padding(
              padding: EdgeInsets.only(right: 0, left: 20),
              child: Padding(
                padding: EdgeInsets.only(right: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    child: (profileImage != null)
                        ? CachedNetworkImage(
                      placeholder: (context, url) => Container(
                        child: CircularProgressIndicator(
                          strokeWidth: 1,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.black87),
                        ),
                        width: 80,
                        height: 80,
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      imageUrl: profileImage,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    )
                        : Icon(Icons.add),
                  ),
                ),
              ),
            ),
            onTap: () {},
          ),
          Container(
            width: MediaQuery.of(context).size.width / 2.2,
            height: MediaQuery.of(context).size.height / 6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('+ 프로필 사진 수정'),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 5,
                  height: 1,
                  color: Colors.black,
                ),
                SizedBox(
                  height: 10,
                ),
                Text('+ 자기 소개 수정'),
              ],
            ),
          )
        ],
      ),
    );
  }
}
