import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';
import 'package:socialapp/page/Writing.dart';
import 'package:socialapp/page/signup.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:socialapp/widgets/Bloc.dart';
import 'ProfileDetail.dart';
import 'contextpage.dart';
import 'test.dart';
import 'package:socialapp/widgets/tool.dart';

class Board extends StatefulWidget {
  final String currentUserId;
  String SelectSpace, title;

  Board(
      {Key key,
      @required this.currentUserId,
      @required this.SelectSpace,
      @required this.title})
      : super(key: key);

  @override
  _BoardState createState() => _BoardState(
      currentUserId: currentUserId, SelectSpace: SelectSpace, title: title);
}

class _BoardState extends State<Board> {
  final String currentUserId;
  String result;
  String SelectSpace, title;
  String commentNum;

  _BoardState(
      {Key key,
      @required this.currentUserId,
      @required this.SelectSpace,
      @required this.title});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getlatlong();
  }

  double latitude1;
  double longitude1;

  getlatlong() async {
    Firestore.instance
        .collection('users')
        .document(currentUserId)
        .snapshots()
        .listen((data) {
      setState(() {
        latitude1 = data['latitude'];
        longitude1 = data['longitude'];
      });
    });
  }

  LocationCalcul(double l1, double g1, double l2, double g2) {
    Distance distance = Distance();
    String text;

    double meter = distance(
      LatLng(l1, g1),
      LatLng(l2, g2),
    );

    text = '$meter' + 'm';

    if (meter >= 1000) {
      double km =
          distance.as(LengthUnit.Kilometer, LatLng(l1, g1), LatLng(l2, g2));

      text = '$km' + 'km';
      return text;
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    final BlocProvider blocProvider = Provider.of<BlocProvider>(context);
    getlatlong();
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          title,
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: 20,
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    InkWell(
                      onTap: () {
                        blocProvider.select1();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 3.5,
                        height: MediaQuery.of(context).size.height / 13,
                        decoration: BoxDecoration(
                            border: (blocProvider.MenuController == 1)
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
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  '최신순',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
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
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    InkWell(
                      onTap: () {
                        blocProvider.select2();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 3.5,
                        height: MediaQuery.of(context).size.height / 13,
                        decoration: BoxDecoration(
                            border: (blocProvider.MenuController == 2)
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
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
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
              child: PostList(context),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: maincolor,
        child: Icon(Icons.border_color,),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Writing(
                        currentId: currentUserId,
                        title: title,
                        SelectSpace: SelectSpace,
                      )));
        },
      ),
    );
  }

  Widget PostList(BuildContext context) {
    final BlocProvider blocProvider = Provider.of<BlocProvider>(context);
    return StreamBuilder<QuerySnapshot>(
        stream: (blocProvider.MenuController == 1)
            ? Firestore.instance
                .collection(SelectSpace)
                .orderBy('time', descending: true)
                .snapshots()
            : Firestore.instance
                .collection(SelectSpace)
                .orderBy('like', descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.documents.length,
              padding: EdgeInsets.only(top: 10, left: 8),
              itemBuilder: (BuildContext context, int index) {
                if (!snapshot.hasData) {
                  return Container();
                }
                DocumentSnapshot ds = snapshot.data.documents[index];
                var latitude2 = ds['latitude'];
                var longitude2 = ds['longitude'];

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
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProfileDetail(
                                              usercurrentId: ds['id'],
                                              currentId: currentId,
                                            )));
                              },
                              child: Container(
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
                          onTap: () {
                            if (snapshot.hasData) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ContextPage(
                                            currentId: currentUserId,
                                            contextId: ds['contextID'],
                                            SelectSpace: SelectSpace,
                                            title: title,
                                          )));
                            }
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
                            child: Column(
                              children: <Widget>[
                                Container(
                                  //맨위 row
                                  width:
                                      MediaQuery.of(context).size.width / 1.38,
                                  height:
                                      MediaQuery.of(context).size.height / 23,
                                  child: Row(
                                    //맨위 row
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        //댓글이랑좋아요
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.2,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                23,
                                        child: Row(
                                          //댓글이랑좋아요
                                          children: <Widget>[
                                            Container(
                                              //좋아요
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  4.5,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  23,
                                              child: Row(
                                                //좋아요
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.favorite,
                                                    color: maincolor,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    (ds['like'] != null)
                                                        ? ds['like'].toString()
                                                        : '0',
                                                    style: TextStyle(
                                                      color: Colors.black54,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              //댓글
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  5,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  23,
                                              child: Row(
                                                //댓글
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.comment,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    (ds['comment'] != null)
                                                        ? ds['comment']
                                                            .toString()
                                                        : '0',
                                                    style: TextStyle(
                                                      color: Colors.black54,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        //위치
                                        width:
                                            MediaQuery.of(context).size.width /
                                                5,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                23,
                                        child: Center(
                                          child: (LocationCalcul(
                                                      latitude1,
                                                      longitude1,
                                                      latitude2,
                                                      longitude2) !=
                                                  null)
                                              ? Text(
                                                  LocationCalcul(
                                                      latitude1,
                                                      longitude1,
                                                      latitude2,
                                                      longitude2),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          255, 125, 128, 99)),
                                                )
                                              : Text(
                                                  '???m',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          255, 125, 128, 99)),
                                                ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  //텍스트
                                  width:
                                      MediaQuery.of(context).size.width / 1.38,
                                  height:
                                      MediaQuery.of(context).size.height / 11,
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      ds['context'],
                                      maxLines: 3,
                                      style: TextStyle(fontFamily: 'NIX'),
                                    ),
                                  ),
                                ),
                                Container(
                                  //맨밑
                                  width:
                                      MediaQuery.of(context).size.width / 1.38,
                                  height:
                                      MediaQuery.of(context).size.height / 15.5,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        //이미지
                                        width:
                                            MediaQuery.of(context).size.width /
                                                7,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                16,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          child: (ds['contextImage'] != null)
                                              ? CachedNetworkImage(
                                                  imageUrl: ds['contextImage'],
                                                  fit: BoxFit.cover,
                                                )
                                              : null,
                                        ),
                                      ),
                                      Container(
                                        //시간
                                        width:
                                            MediaQuery.of(context).size.width /
                                                5,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                40,
                                        margin: EdgeInsets.only(top: 20),
                                        child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Text(
                                            TimeDuration(
                                                ds['time'], DateTime.now()),
                                            style: TextStyle(
                                                color: Colors.black54),
                                          ),
                                        ),
                                      ),
                                    ],
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
          } else {
            return Container();
          }
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

