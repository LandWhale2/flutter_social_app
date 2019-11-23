import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latlong/latlong.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';
import 'package:socialapp/model/todo.dart';
import 'package:socialapp/page/contextpage.dart';
import 'package:socialapp/widgets/Bloc.dart';

class UserWrite extends StatefulWidget {
  final String currentId, username,userId;
  UserWrite({Key key, @required this.currentId, @required this.username, @required this.userId}):super(key:key);



  @override
  _UserWriteState createState() => _UserWriteState(currentId: currentId,userId: userId,username: username);
}

class _UserWriteState extends State<UserWrite> {
  final String currentId, username, userId;

  _UserWriteState({Key key, @required this.currentId, @required this.username, @required this.userId});
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getlatlong();
  }

  PageController _pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  double latitude1;
  double longitude1;

  int pageSelect = 0;

  getlatlong() async {
    Firestore.instance
        .collection('users')
        .document(currentId)
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

    text = '${meter.toInt()}' + 'm';

    if (meter >= 1000) {
      double km =
      distance.as(LengthUnit.Kilometer, LatLng(l1, g1), LatLng(l2, g2));

      text = '${km.toInt()}' + 'km';
      return text;
    }
    return text;
  }

  Location(double l1, double g1, double l2, double g2) {
    Distance distance = Distance();
    var value;

    double meter = distance(
      LatLng(l1, g1),
      LatLng(l2, g2),
    );

    value = meter.toInt();

    return value;
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
          username ?? '',
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        blocProvider.select(0);
                        Tapped(0);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 3.5,
                        height: MediaQuery.of(context).size.height / 13,
                        decoration: BoxDecoration(
                            border: (blocProvider.MenuController == 0)
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
                                  '구한다',
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
                    InkWell(
                      onTap: () {
                        blocProvider.select(1);
                        Tapped(1);
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
                                  '말한다',
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
              child: PageView(
                onPageChanged: (index) {
                  pageChanged(index);
                },
                controller: _pageController,
                children: <Widget>[
                  PostList(context),
                  PostList(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void pageChanged(int index) {
    final BlocProvider blocProvider = Provider.of<BlocProvider>(context);
    blocProvider.select(index);
  }

  void Tapped(int index) {
    final BlocProvider blocProvider = Provider.of<BlocProvider>(context);
    blocProvider.select(index);
    setState(() {
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    });
  }


  Widget PostList(BuildContext context) {
    final BlocProvider blocProvider = Provider.of<BlocProvider>(context);
    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: (blocProvider.MenuController == 0)?Firestore.instance.collection('find').where('id',isEqualTo: userId).orderBy('time', descending: true).snapshots()
              :Firestore.instance.collection('say').where('id',isEqualTo: userId).orderBy('time', descending: true).snapshots(),
          builder: (context, snapshot2) {
            if (snapshot2.hasData) {
              return LiquidPullToRefresh(
                onRefresh: ()async{
                  await refreshList();
                },
                color: maincolor,
                springAnimationDurationInMilliseconds: 100,
                child: ListView.builder(
                  itemCount: snapshot2.data.documents.length,
                  padding: EdgeInsets.only(top: 10, left: 8),
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot ds = snapshot2.data.documents[index];
                    var latitude2 = ds['latitude'];
                    var longitude2 = ds['longitude'];
                    if (!snapshot2.hasData) {
                      return Container(child: Text('sd'),);
                    }else{
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 5,
                          child: Row(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                    },
                                    child: Container(
                                      width:
                                      MediaQuery.of(context).size.width / 5,
                                      height:
                                      MediaQuery.of(context).size.height / 10,
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
                                  if (snapshot2.hasData) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ContextPage(
                                              currentId: currentId,
                                              contextId: ds['contextID'],
                                              SelectSpace: (blocProvider.MenuController == 0)?'find':'say',
                                              title: (blocProvider.MenuController == 0)?'구한다':'말한다',
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
                                        width: MediaQuery.of(context).size.width /
                                            1.38,
                                        height:
                                        MediaQuery.of(context).size.height /
                                            23,
                                        child: Row(
                                          //맨위 row
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Container(
                                              //댓글이랑좋아요
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                                  2.2,
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height /
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
                                                              ? ds['like']
                                                              .toString()
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
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                                  5,
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height /
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
                                                  textAlign:
                                                  TextAlign.center,
                                                  style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          255,
                                                          125,
                                                          128,
                                                          99)),
                                                )
                                                    : Text(
                                                  '???m',
                                                  textAlign:
                                                  TextAlign.center,
                                                  style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          255,
                                                          125,
                                                          128,
                                                          99)),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        //텍스트
                                        width: MediaQuery.of(context).size.width /
                                            1.38,
                                        height:
                                        MediaQuery.of(context).size.height /
                                            11,
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
                                        width: MediaQuery.of(context).size.width /
                                            1.38,
                                        height:
                                        MediaQuery.of(context).size.height /
                                            15.5,
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Container(
                                              //이미지
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                                  7,
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                                  16,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                              ),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                child: (ds['contextImage'] !=
                                                    null)
                                                    ? CachedNetworkImage(
                                                  imageUrl:
                                                  ds['contextImage'],
                                                  fit: BoxFit.cover,
                                                )
                                                    : null,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 20),
                                              child: Container(
                                                //시간
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                    5,
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                    40,
                                                child: Padding(
                                                  padding:
                                                  const EdgeInsets.all(0),
                                                  child: Text(
                                                    TimeDuration(ds['time'],
                                                        DateTime.now()),
                                                    style: TextStyle(
                                                        color: Colors.black54),
                                                  ),
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
                    }
                  },
                ),
              );
            } else {
              return Container(
              );
            }
          }),
    );
  }
  Future<Null> refreshList() async{
    await Future.delayed(Duration(milliseconds: 1));
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
