import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:socialapp/page/Writing.dart';
import 'package:socialapp/page/signup.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'contextpage.dart';
import 'test.dart';

int menuIndexController = 2;

class Board extends StatefulWidget {
  final String currentUserId;

  Board({Key key, @required this.currentUserId}) : super(key: key);

  @override
  _BoardState createState() => _BoardState(currentUserId: currentUserId);
}

class _BoardState extends State<Board> {
  final String currentUserId;

  _BoardState({Key key, @required this.currentUserId});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '영화관',
          style:
              TextStyle(fontFamily: 'NIX', fontSize: 25, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white, //Color.fromRGBO(188, 206, 255, 1)
      ),
      body: Container(
//        color: Color.fromRGBO(255, 125, 128, 99),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 13,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 20,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          menuIndexController = 1;
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 3.5,
                        height: MediaQuery.of(context).size.height / 13,
                        decoration: BoxDecoration(
                            border: (menuIndexController == 1)
                                ? Border(
                                    bottom: BorderSide(
                                      color: Colors.redAccent,
                                      width: 1,
                                    ),
                                  )
                                : null),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Container(
//                            width: MediaQuery.of(context).size.width/6,
//                            height: MediaQuery.of(context).size.height/2,
                            decoration: BoxDecoration(
//                              color: Color.fromRGBO(123, 198, 250, 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                '거리순',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'NIX',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          menuIndexController = 2;
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 3.5,
                        height: MediaQuery.of(context).size.height / 13,
                        decoration: BoxDecoration(
                            border: (menuIndexController == 2)
                                ? Border(
                                    bottom: BorderSide(
                                      color: Colors.redAccent,
                                      width: 1,
                                    ),
                                  )
                                : null),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Container(
//                            width: MediaQuery.of(context).size.width/6,
//                            height: MediaQuery.of(context).size.height/2,
                            decoration: BoxDecoration(
//                              color: Color.fromRGBO(123, 198, 250, 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                '최신순',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'NIX',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          menuIndexController = 3;
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 3.5,
                        height: MediaQuery.of(context).size.height / 13,
                        decoration: BoxDecoration(
                            border: (menuIndexController == 3)
                                ? Border(
                                    bottom: BorderSide(
                                      color: Colors.redAccent,
                                      width: 1,
                                    ),
                                  )
                                : null),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Container(
//                            width: MediaQuery.of(context).size.width/6,
//                            height: MediaQuery.of(context).size.height/2,
                            decoration: BoxDecoration(
//                              color: Color.fromRGBO(123, 198, 250, 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                '인기순',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'NIX',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(0),
              child: Container(
                width: MediaQuery.of(context).size.width / 1.1,
                height: 1,
                color: Colors.black26,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Stagger(context),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.border_color),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Writing(
                        currentId: currentUserId,
                      )));
        },
      ),
    );
  }

  Widget Stagger(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('movie').orderBy('time', descending: true).snapshots(),
        builder: (context, snapshot) {
          int count = snapshot.data.documents.length;
          return ListView.builder(
            itemCount: count,
            padding: EdgeInsets.only(top: 10, left: 8),
            itemBuilder: (BuildContext context, int index) {
              DocumentSnapshot ds = snapshot.data.documents[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 5,
//                  decoration: BoxDecoration(
//                      color: Colors.white, //Color.fromRGBO(123, 198, 250, 1)
//                      border: Border.all(width: 0.5),
//                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Row(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width / 5,
                            height: MediaQuery.of(context).size.height / 10,
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              child: CachedNetworkImage(
                                imageUrl: ds['image'],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            //이름
                            padding: EdgeInsets.only(top: 5),

                            child: Text(
                              ds['nickname'],
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'SIL'),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ContextPage(
                                    currentId: currentUserId,contextId: ds['contextID'],
                                  )));
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 1.38,
                          height: MediaQuery.of(context).size.height / 5,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              //Color.fromRGBO(123, 198, 250, 1)
//                            border: Border.all(width: 0.5),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: Colors.black38,
                                  offset: Offset(3.0, 3.0),
                                  blurRadius: 1,
                                ),
                              ],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Stack(
                            children: <Widget>[
                              Positioned(
                                //텍스트
                                right: 20,
                                bottom: 60,
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 1.6,
                                  height: MediaQuery.of(context).size.height / 12,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    //Color.fromRGBO(123, 198, 250, 1)
//                                  border: Border.all(width: 0.5),
                                  ),
                                  child: Text(
                                    ds['context'],
                                    style: TextStyle(fontFamily: 'NIX'),
                                  ),
                                ),
                              ),
                              Positioned(
                                //사진1
                                left: 10,
                                bottom: 5,
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 7,
                                  height: MediaQuery.of(context).size.height / 16,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    //Color.fromRGBO(123, 198, 250, 1)
                                  ),
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    child: (ds['contextImage'] != null)?CachedNetworkImage(
                                      imageUrl: ds['contextImage'],
                                      fit: BoxFit.cover,
                                    ):null,
                                  ),
                                ),
                              ),
                              Positioned(
                                //거리
                                top: 5,
                                right: 5,
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 8,
                                  height: MediaQuery.of(context).size.height / 40,
//                                decoration: BoxDecoration(
//                                  color: Colors.white,
//                                  //Color.fromRGBO(123, 198, 250, 1)
//                                  border: Border.all(width: 0.5),
//                                ),
                                  child: Text(
                                    '22m',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Color.fromRGBO(255, 125, 128, 99)),
                                  ),
                                ),
                              ),
                              Positioned(
                                //댓글
                                left: 5,
                                top: 5,
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 8,
                                  height: MediaQuery.of(context).size.height / 40,
//                                decoration: BoxDecoration(
//                                  color: Colors.white,
//                                  //Color.fromRGBO(123, 198, 250, 1)
//                                  border: Border.all(width: 0.5),
//                                ),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.favorite,
                                        color: Colors.black54,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        '5',
                                        style: TextStyle(
                                          color: Colors.black54,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                //좋아요
                                left: 55,
                                top: 5,
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 8,
                                  height: MediaQuery.of(context).size.height / 40,
//                                decoration: BoxDecoration(
//                                  color: Colors.white,
//                                  //Color.fromRGBO(123, 198, 250, 1)
//                                  border: Border.all(width: 0.5),
//                                ),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.sms,
                                        color: Colors.black54,
                                        size: 22,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        '2',
                                        style: TextStyle(
                                          color: Colors.black54,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                //좋아요
                                right: 5,
                                bottom: 5,
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 5,
                                  height: MediaQuery.of(context).size.height / 40,
//                                decoration: BoxDecoration(
//                                  color: Colors.white,
//                                  //Color.fromRGBO(123, 198, 250, 1)
//                                  border: Border.all(width: 0.5),
//                                ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Text(
                                      TimeDuration(ds['time'], DateTime.now()),
                                      style: TextStyle(color: Colors.black54),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        });
  }
}
String TimeDuration(int timestamp, var now) {
  var format = DateFormat('HH:mm a');
  var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  var diff = now.difference(date);
  var time = '';
  if (diff.inSeconds <= 0 ||
      diff.inSeconds > 0 && diff.inMinutes == 0 ||
      diff.inMinutes > 0 && diff.inHours == 0 ||
      diff.inHours > 0 && diff.inDays == 0) {
    time = format.format(date);
  } else if (diff.inDays > 0 && diff.inDays < 7) {
    if (diff.inDays == 1) {
      time = diff.inDays.toString() + 'DAY';
    } else {
      time = diff.inDays.toString() + 'DAYS';
    }
  } else {
    if (diff.inDays == 7) {
      time = (diff.inDays / 7).floor().toString() + 'WEEK';
    } else {
      time = (diff.inDays / 7).floor().toString() + 'WEEKS';
    }
  }
  return time;
}
