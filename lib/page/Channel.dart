import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:socialapp/main.dart';
import 'package:socialapp/model/data.dart';
import 'package:socialapp/page/ProfileDetail.dart';
import 'package:socialapp/page/loginscreen.dart';
import 'package:socialapp/page/signup.dart';
import 'package:socialapp/page/spotlight.dart';
import 'package:socialapp/widgets/adHelper.dart';
import 'package:socialapp/widgets/slide_item.dart';

class Home extends StatefulWidget {
  final String currentId;

  Home({Key key, @required this.currentId}) : super(key: key);

  @override
  _HomeState createState() => _HomeState(currentId: currentId);
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin<Home> {
  final String currentId;

  _HomeState({Key key, @required this.currentId});

  var getTop;

  checklogin()async{
    print(await FirebaseAuth.instance.currentUser());
  }

  void initState() {
    super.initState();
//    futureget();

  }

//  futureget() async {
//    getTop = await getTopuser();
//    return getTop;
//  }

  gettoplength() async {
    await Firestore.instance
        .collection('users')
        .snapshots()
        .listen((data) async {
      int leng = data.documents.length;
      return print(leng * 10 / 100);
    });
  }

  Uint8List smallImageByte;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return (FirebaseAuth.instance.currentUser() != null)?Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: ListView(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Row(
            //첫번째 위에 리스트 타이틀
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                //타이틀이름
                "스포트라이트",
                style: TextStyle(
                  fontSize: MediaQuery.of(context).textScaleFactor*30,
                  fontWeight: FontWeight.w800,
                ),
              ),
              FlatButton(
                //더보기
                child: Text(
                  "더보기",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w300,
                      color: Colors.pinkAccent),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Spotlight(
                            currentId: currentId,
                            title: '스포트라이트',
                          )));
                },
              ),
            ],
          ),
          SizedBox(height: 10),
          //위에 리스트의 끝

          //사진 리스트
          Container(
            height: MediaQuery.of(context).size.height / 2.4,
            width: MediaQuery.of(context).size.width,
            child: StreamBuilder(
                stream: Firestore.instance
                    .collection('users')
                    .orderBy('like', descending: true)
                .limit(30)
                    .snapshots(),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (!snapshot.hasData) {
                            return Text('없습니다');
                          }
                          DocumentSnapshot ds = snapshot.data.documents[index];
                          if(ds['block'] != null){
                            for(int i=0; i<ds['block'].length ; i++){
                              if(ds['block'][i] == currentId){
                                return Container();
                              }
                            }
                          }
                          return InkWell(
                            onTap: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProfileDetail(
                                        usercurrentId: ds['id'],
                                        currentId: currentId,
                                      )));
                            },
                            child: Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: SlideItem(
                                image: ds['image'],
                                nickname: ds['nickname'],
                                intro: ds['intro'],
                                age: ds['age'],
                              ),
                            ),
                          );
                        });
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
          ),
          SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "인기",
                style: TextStyle(
                  fontSize: MediaQuery.of(context).textScaleFactor*28,
                  fontWeight: FontWeight.w800,
                ),
              ),
              FlatButton(
                child: Text(
                  "더보기",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w300,
                      color: Colors.pinkAccent),
                ),
                onPressed: () {
                  checklogin();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Spotlight(
                            currentId: currentId,
                            title: '인기',
                          )));

                },
              ),
            ],
          ),
          SizedBox(height: 10),
          Container(
            height: MediaQuery.of(context).size.height / 6,
            child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection('users')
                    .orderBy('like', descending: true)
                .limit(20)
                    .snapshots(),
                builder: (context, snapshot) {
                  if(!snapshot.hasData){
                    return Container();
                  }
                  return ListView.builder(
                    primary: false,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot ds = snapshot.data.documents[index];
                      if(ds['block'] != null){
                        for(int i=0; i<ds['block'].length ; i++){
                          if(ds['block'][i] == currentId){
                            return Container();
                          }
                        }
                      }
                      return InkWell(
                        onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfileDetail(
                                    usercurrentId: ds['id'],
                                    currentId: currentId,
                                  )));
                        },
                        child: Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Stack(
                            children: <Widget>[
                              Container(
                                height: MediaQuery.of(context).size.height / 6,
                                width: MediaQuery.of(context).size.height / 6,
                                child: (ds['image'] != null)?ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  child: CachedNetworkImage(
                                    imageUrl: ds['image'],
                                    fit: BoxFit.cover,
                                  ),
                                ):Center(child: Icon(Icons.person),),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
          ),
          SizedBox(height: 20),
//          Row(
//            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//            children: <Widget>[
//              Text(
//                "Friends",
//                style: TextStyle(
//                  fontSize: 23,
//                  fontWeight: FontWeight.w800,
//                ),
//              ),
//
//              FlatButton(
//                child: Text(
//                  "See All",
//                  style: TextStyle(
//                    fontSize: 22,
//                    fontWeight:FontWeight.w300,
//                    color: Theme.of(context).accentColor,
//                  ),
//                ),
//                onPressed: (){},
//              ),
//            ],
//          ),
//          SizedBox(height: 10),
//          Container(
//            height: 50,
//            child: ListView.builder(
//              primary: false,
//              scrollDirection: Axis.horizontal,
//              shrinkWrap: true,
//              itemCount: posts == null? 0:posts.length,
//              itemBuilder: (BuildContext context, int index){
//                String img = posts[index];
//
//                return Padding(
//                  padding: EdgeInsets.only(right: 5),
//                  child: CircleAvatar(
//                    backgroundImage: AssetImage(
//                      img,
//                    ),
//                    radius: 25,
//                  ),
//                );
//              },
//            ),
//          ),
//          SizedBox(height: 30),
        ],
      ),
    ):Container();
  }

  @override
  bool get wantKeepAlive => true;
}
