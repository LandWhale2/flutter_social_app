import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:socialapp/base.dart';
import 'package:flutter/material.dart';
import 'package:socialapp/main.dart';
import 'package:socialapp/page/contextpage.dart';
import 'package:socialapp/page/loginscreen.dart';
import 'package:socialapp/page/notification.dart';
import 'package:socialapp/page/signup.dart';
import 'package:socialapp/page/signup.dart' as prefix0;
import 'package:socialapp/widgets/Bloc.dart';
import 'package:socialapp/widgets/adHelper.dart';

import 'ProfileDetail.dart';
import 'board.dart';

class Mainhome extends StatefulWidget {
  final String currentId;

  Mainhome({Key key, @required this.currentId}) : super(key: key);

  @override
  MainhomeState createState() => MainhomeState(currentId: currentId);
}

class MainhomeState extends State<Mainhome> {
  final String currentId;

  MainhomeState({Key key, @required this.currentId});

  final RefreshController _refreshController = RefreshController();

  int _bottomSelectedIndex = 0;
  GoogleSignIn googleSignIn =GoogleSignIn();


  Future<Null> handleSignOut() async {


    await FirebaseAuth.instance.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();




    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()),
            (Route<dynamic> route) => false).then((value){
      Ads.showBannerAd();
    });
  }


  @override
  Widget build(BuildContext context) {
    final AlertProvider alertProvider = Provider.of<AlertProvider>(context);
    return FutureBuilder<FirebaseUser>(
      future: FirebaseAuth.instance.currentUser(),
      builder: (BuildContext context,AsyncSnapshot<FirebaseUser> snapshot) {
        if(!snapshot.hasData){
          return Scaffold(
            body: Container(),
          );
        }
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Text(
                        '커뮤니티',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).textScaleFactor * 30,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        Navigator.of(context).push(notifiRoute(currentId));
                      },
                      child: Stack(
                        children: <Widget>[
                          Container(
                            child: Icon(
                              Icons.notifications,
                              size: 40,
                            ),
                          ),
                          (alertProvider.AlertController != 0)?Positioned(
                            top: 1,
                            right: 1,
                            child: Container(
                              width: 23,
                              height:23,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(100)),
                                color: Colors.red
                              ),
                              child: Center(
                                child: Text(
                                  alertProvider.AlertController.toString(),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ):Container(),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 20,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Board(
                                      currentUserId: currentId,
                                      title: '구한다',
                                      SelectSpace: 'find',
                                    ))).then((value){
                                      Ads.showBannerAd();
                        });
//                  handleSignOut();
                      },
                      child: Column(
                        //구한다
                        children: <Widget>[
                          Container(
                            //아이콘
                            width: MediaQuery.of(context).size.width / 6,
                            height: MediaQuery.of(context).size.height / 13,
                            child: Image.asset(
                              'assets/play.png',
                              fit: BoxFit.fill,
                            ),
                          ),
                          Container(
                            //텍슽
                            width: MediaQuery.of(context).size.width / 6,
                            height: MediaQuery.of(context).size.height / 30,
                            decoration: BoxDecoration(border: Border.all(width: 1)),
                            child: Center(
                              child: Text(
                                '구한다',
                                style: TextStyle(fontFamily: 'NIX'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Board(
                                      currentUserId: currentId,
                                      title: '말한다',
                                      SelectSpace: 'say',
                                    ))).then((value){
                                      Ads.showBannerAd();
                        });
                      },
                      child: Column(
                        //말한다
                        children: <Widget>[
                          Container(
                            //아이콘
                            width: MediaQuery.of(context).size.width / 6,
                            height: MediaQuery.of(context).size.height / 13,
                            child: Image.asset(
                              'assets/talk2.png',
                              fit: BoxFit.fill,
                            ),
                          ),
                          Container(
                            //아이콘텏트
                            width: MediaQuery.of(context).size.width / 6,
                            height: MediaQuery.of(context).size.height / 30,
                            decoration: BoxDecoration(border: Border.all(width: 1)),
                            child: Center(
                              child: Text(
                                '말한다',
                                style: TextStyle(fontFamily: 'NIX'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      child: Text(
                        '스포트라이트',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).textScaleFactor * 30,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 5,
                  child: StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance.collection('find').limit(10).snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container();
                        }
                        return ListView.builder(
                            primary: false,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (BuildContext context, int index) {
                              DocumentSnapshot ds = snapshot.data.documents[index];
                              return StreamBuilder(
                                stream: Firestore.instance.collection('users').document(ds['id']).snapshots(),
                                builder: (context, snapshot) {
                                  if(!snapshot.hasData){
                                    return Container();
                                  }
                                  var ds2 = snapshot.data;
                                  if(ds2['block'] != null){
                                    for(int i=0; i<ds2['block'].length ; i++){
                                      if(ds2['block'][i] == currentId){
                                        return Container();
                                      }
                                    }
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width / 2,
                                      height: MediaQuery.of(context).size.height / 6,
                                      decoration: BoxDecoration(
                                          border: Border.all(width: 0.1),
                                          color: Colors.black54,
                                          borderRadius:
                                              BorderRadius.all(Radius.circular(15))),
                                      child: Row(
                                        children: <Widget>[
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Column(
                                            children: <Widget>[
                                              SizedBox(
                                                height: 10,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ProfileDetail(
                                                                usercurrentId: ds['id'],
                                                                currentId: currentId,
                                                              ))).then((value){
                                                                Ads.showBannerAd();
                                                  });
                                                },
                                                child: Container(
                                                  width:
                                                      MediaQuery.of(context).size.width /
                                                          7,
                                                  height:
                                                      MediaQuery.of(context).size.height /
                                                          14,
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(15)),
                                                    child: CachedNetworkImage(
                                                      imageUrl: ds['image'],
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: 5,),
                                          InkWell(
                                            onTap: (){
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => ContextPage(
                                                        currentId: currentId,
                                                        contextId: ds['contextID'],
                                                        SelectSpace: ds['space'],
                                                        title: ds['title'],
                                                      ))).then((value){
                                                        Ads.showBannerAd();
                                              });
                                            },
                                            child: Column(
                                              children: <Widget>[
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                  //아이콘텏트
                                                  width:
                                                      MediaQuery.of(context).size.width / 3.5,
                                                  height:
                                                      MediaQuery.of(context).size.height / 40,
                                                  child: Text(
                                                    ds['nickname'],
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        fontFamily: 'SIL',
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w800),
                                                  ),
                                                ),
                                                Container(
                                                  width:
                                                  MediaQuery.of(context).size.width / 3.5,
                                                  height:
                                                  MediaQuery.of(context).size.height / 7,

                                                  child: Text(
                                                    (ds['context'] != null)?ds['context']: ' ',
                                                    textAlign: TextAlign.start,
                                                    maxLines: 6,
                                                    style: TextStyle(
                                                        fontFamily: 'NIX',
                                                        fontSize: MediaQuery.of(context).textScaleFactor*18,
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w500),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              );
                            });
                      }),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      child: Text(
                        '인기글',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).textScaleFactor * 30,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 5,
                  child: StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance.collection('say').where('like', isGreaterThan:9 ).orderBy('like', descending: true).limit(10).snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container();
                        }
                        return ListView.builder(
                            primary: false,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (BuildContext context, int index) {
                              DocumentSnapshot ds = snapshot.data.documents[index];
                              return StreamBuilder(
                                stream: Firestore.instance.collection('users').document(ds['id']).snapshots(),
                                builder: (context, snapshot) {
                                  if(!snapshot.hasData){
                                    return Container();
                                  }
                                  var ds2 = snapshot.data;
                                  if(ds2['block'] != null){
                                    for(int i=0; i<ds2['block'].length ; i++){
                                      if(ds2['block'][i] == currentId){
                                        return Container();
                                      }
                                    }
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width / 2,
                                      height: MediaQuery.of(context).size.height / 6,
                                      decoration: BoxDecoration(
                                          border: Border.all(width: 0.1),
                                          color: Colors.black87,
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(15))),
                                      child: Row(
                                        children: <Widget>[
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Column(
                                            children: <Widget>[
                                              SizedBox(
                                                height: 10,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ProfileDetail(
                                                                usercurrentId: ds['id'],
                                                                currentId: currentId,
                                                              )));
                                                },
                                                child: Container(
                                                  width:
                                                  MediaQuery.of(context).size.width /
                                                      7,
                                                  height:
                                                  MediaQuery.of(context).size.height /
                                                      14,
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(15)),
                                                    child: CachedNetworkImage(
                                                      imageUrl: ds['image'],
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: 5,),
                                          InkWell(
                                            onTap: (){
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => ContextPage(
                                                        currentId: currentId,
                                                        contextId: ds['contextID'],
                                                        SelectSpace: ds['space'],
                                                        title: ds['title'],
                                                      )));
                                            },
                                            child: Column(
                                              children: <Widget>[
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                  //아이콘텏트
                                                  width:
                                                  MediaQuery.of(context).size.width / 3.5,
                                                  height:
                                                  MediaQuery.of(context).size.height / 40,
                                                  child: Text(
                                                    ds['nickname'],
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        fontFamily: 'SIL',
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w800),
                                                  ),
                                                ),
                                                Container(
                                                  width:
                                                  MediaQuery.of(context).size.width / 3.5,
                                                  height:
                                                  MediaQuery.of(context).size.height / 7,

                                                  child: Text(
                                                    (ds['context'] != null)?ds['context']: ' ',
                                                    textAlign: TextAlign.start,
                                                    maxLines: 6,
                                                    style: TextStyle(
                                                        fontFamily: 'NIX',
                                                        fontSize: MediaQuery.of(context).textScaleFactor*18,
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w500),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              );
                            });
                      }),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
  List<Widget> buildList(){
    return List.generate(15, (index) => Container(
      height: 100,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
    ));
  }
}

class ItemBox extends StatelessWidget {
  String imagename, place;
  final String currentId;
  String SelectSpace, title;
  String ww;

  ItemBox(
      {Key key,
      @required this.imagename,
      @required this.place,
      @required this.SelectSpace,
      @required this.currentId,
      @required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 10, left: 8, top: 5),
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(notifiRoute(currentId));
            },
            child: Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 5,
                  height: MediaQuery.of(context).size.height / 12,
                  child: Image.asset(
                    imagename,
                    fit: BoxFit.fill,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 4.5,
                  height: MediaQuery.of(context).size.height / 30,
                  child: Text(
                    place,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: MediaQuery.of(context).textScaleFactor * 18,
                        fontFamily: 'NIX'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CityItem extends StatelessWidget {
  String title, currentId, SelectSpace;

  CityItem(
      {Key key,
      @required this.SelectSpace,
      @required this.currentId,
      @required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Board(
                        currentUserId: currentId,
                        SelectSpace: SelectSpace,
                        title: title,
                      )));
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 5,
          height: MediaQuery.of(context).size.height / 10,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black87,
                offset: Offset(4.0, 4.0),
                blurRadius: 1,
              ),
            ],
            border: Border.all(
                color: Colors.black87, width: 3, style: BorderStyle.solid),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: MediaQuery.of(context).textScaleFactor * 18,
                  fontFamily: 'NIX'),
            ),
          ),
        ),
      ),
    );
  }
}


Route notifiRoute(String currentId){
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => NotificationPage(currentId: currentId,),
    transitionsBuilder: (context, animation, secondaryAnimation, child){
      var begin = Offset(0, 1);
      var end = Offset.zero;
      var curve = Curves.ease;
      
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    }
  );
}
