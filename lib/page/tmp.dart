//import 'package:flutter/material.dart';
//import 'package:socialapp/page/Writing.dart';
//import 'package:socialapp/page/signup.dart';
//import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
//
//int menuIndexController = 0;
//
//class Board extends StatefulWidget {
//  final String currentUserId;
//
//  Board({Key key, @required this.currentUserId}) : super(key: key);
//
//  @override
//  _BoardState createState() => _BoardState(currentUserId: currentUserId);
//}
//
//class _BoardState extends State<Board> {
//  final String currentUserId;
//
//  _BoardState({Key key, @required this.currentUserId});
//
//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text(
//          '영화관',
//          style: TextStyle(fontFamily: 'NIX', fontSize: 25),
//        ),
//        centerTitle: true,
//        backgroundColor: Color.fromRGBO(255, 125, 128, 1),
//      ),
//      body: Container(
//        child: Column(
//          children: <Widget>[
//            Padding(
//              padding: EdgeInsets.only(top: 0),
//              child: Container(
//                width: MediaQuery.of(context).size.width,
//                height: MediaQuery.of(context).size.height / 13,
//                decoration: BoxDecoration(
//                  color: Colors.white,
//                ),
//                child: Row(
//                  children: <Widget>[
//                    SizedBox(
//                      width: 20,
//                    ),
//                    InkWell(
//                      onTap: () {
//                        setState(() {
//                          menuIndexController = 1;
//                        });
//                      },
//                      child: Container(
//                        width: MediaQuery.of(context).size.width / 3.5,
//                        height: MediaQuery.of(context).size.height / 13,
//                        decoration: BoxDecoration(
//                            border: (menuIndexController == 1)
//                                ? Border(
//                              bottom: BorderSide(
//                                color: Colors.black,
//                                width: 1,
//                              ),
//                            )
//                                : null),
//                        child: Padding(
//                          padding: const EdgeInsets.all(12.0),
//                          child: Container(
////                            width: MediaQuery.of(context).size.width/6,
////                            height: MediaQuery.of(context).size.height/2,
//                            decoration: BoxDecoration(
//                              color: Color.fromRGBO(123, 198, 250, 1),
//                              borderRadius:
//                              BorderRadius.all(Radius.circular(30)),
//                            ),
//                            child: Padding(
//                              padding: const EdgeInsets.only(top: 4),
//                              child: Text(
//                                '거리순',
//                                textAlign: TextAlign.center,
//                                style: TextStyle(
//                                  fontSize: 25,
//                                  color: Colors.white,
//                                  fontWeight: FontWeight.w500,
//                                  fontFamily: 'NIX',
//                                ),
//                              ),
//                            ),
//                          ),
//                        ),
//                      ),
//                    ),
//                    InkWell(
//                      onTap: () {
//                        setState(() {
//                          menuIndexController = 2;
//                        });
//                      },
//                      child: Container(
//                        width: MediaQuery.of(context).size.width / 3.5,
//                        height: MediaQuery.of(context).size.height / 13,
//                        decoration: BoxDecoration(
//                            border: (menuIndexController == 2)
//                                ? Border(
//                              bottom: BorderSide(
//                                color: Colors.black,
//                                width: 1,
//                              ),
//                            )
//                                : null),
//                        child: Padding(
//                          padding: const EdgeInsets.all(12.0),
//                          child: Container(
////                            width: MediaQuery.of(context).size.width/6,
////                            height: MediaQuery.of(context).size.height/2,
//                            decoration: BoxDecoration(
//                              color: Color.fromRGBO(123, 198, 250, 1),
//                              borderRadius:
//                              BorderRadius.all(Radius.circular(30)),
//                            ),
//                            child: Padding(
//                              padding: const EdgeInsets.only(top: 4),
//                              child: Text(
//                                '최신순',
//                                textAlign: TextAlign.center,
//                                style: TextStyle(
//                                  fontSize: 25,
//                                  color: Colors.white,
//                                  fontWeight: FontWeight.w500,
//                                  fontFamily: 'NIX',
//                                ),
//                              ),
//                            ),
//                          ),
//                        ),
//                      ),
//                    ),
//                    InkWell(
//                      onTap: () {
//                        setState(() {
//                          menuIndexController = 3;
//                        });
//                      },
//                      child: Container(
//                        width: MediaQuery.of(context).size.width / 3.5,
//                        height: MediaQuery.of(context).size.height / 13,
//                        decoration: BoxDecoration(
//                            border: (menuIndexController == 3)
//                                ? Border(
//                              bottom: BorderSide(
//                                color: Colors.black,
//                                width: 1,
//                              ),
//                            )
//                                : null),
//                        child: Padding(
//                          padding: const EdgeInsets.all(12.0),
//                          child: Container(
////                            width: MediaQuery.of(context).size.width/6,
////                            height: MediaQuery.of(context).size.height/2,
//                            decoration: BoxDecoration(
//                              color: Color.fromRGBO(123, 198, 250, 1),
//                              borderRadius:
//                              BorderRadius.all(Radius.circular(30)),
//                            ),
//                            child: Padding(
//                              padding: const EdgeInsets.only(top: 4),
//                              child: Text(
//                                '인기순',
//                                textAlign: TextAlign.center,
//                                style: TextStyle(
//                                  fontSize: 25,
//                                  color: Colors.white,
//                                  fontWeight: FontWeight.w500,
//                                  fontFamily: 'NIX',
//                                ),
//                              ),
//                            ),
//                          ),
//                        ),
//                      ),
//                    ),
//                  ],
//                ),
//              ),
//            ),
//            Padding(
//              padding: const EdgeInsets.all(0),
//              child: Container(
//                width: MediaQuery.of(context).size.width / 1.1,
//                height: 1,
//                color: Colors.black26,
//              ),
//            ),
//            SizedBox(
//              width: 10,
//            ),
//            Padding(
//              padding: const EdgeInsets.all(4.0),
//              child: StaggeredGridView.countBuilder(
//                crossAxisCount: 4,
//                staggeredTileBuilder: (int index) =>
//                    StaggeredTile.count(2, index.isEven ? 2 : 1),
//                mainAxisSpacing: 4,
//                crossAxisSpacing: 4,
//                itemCount: 8,
//                itemBuilder: (BuildContext context, int index) => Container(
//                  color: Colors.green,
//                  child: Center(
//                    child: CircleAvatar(
//                      backgroundColor: Colors.white,
//                      child: Text('$index'),
//                    ),
//                  ),
//                ),
//              ),
//            )
//          ],
//        ),
//      ),
//      floatingActionButton: FloatingActionButton(
//        child: Icon(Icons.border_color),
//        onPressed: () {
//          Navigator.push(
//              context,
//              MaterialPageRoute(
//                  builder: (context) => Writing(
//                    currentId: currentUserId,
//                  )));
//        },
//      ),
//    );
//  }
//}
