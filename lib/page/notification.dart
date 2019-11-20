import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialapp/page/contextpage.dart';

import 'board.dart';

class NotificationPage extends StatefulWidget {
  final String currentId;

  NotificationPage({Key key, @required this.currentId}) : super(key: key);

  @override
  _NotificationPageState createState() =>
      _NotificationPageState(currentId: currentId);
}

class _NotificationPageState extends State<NotificationPage> {
  final String currentId;

  _NotificationPageState({Key key, @required this.currentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '알림',
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: MediaQuery.of(context).textScaleFactor * 25),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.notifications,
                    size: 40,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.18,
              child: StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance
                      .collection('find')
                      .where('id', isEqualTo: currentId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    }
                    return ListView.builder(
                        itemCount: snapshot.data.documents.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          DocumentSnapshot ds = snapshot.data.documents[index];
                          return StreamBuilder<QuerySnapshot>(
                              stream: Firestore.instance
                                  .collection('find')
                                  .document(ds['contextID'])
                                  .collection('comment')
                                  .snapshots(),
                              builder: (context, snapshot2) {
                                if (!snapshot2.hasData) {
                                  return Container();
                                }
                                return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: snapshot2.data.documents.length,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder:
                                        (BuildContext context, int index2) {
                                      DocumentSnapshot ds2 = snapshot2.data.documents[index2];
                                      if(ds2['id'] ==currentId){
                                        return Container();
                                      }
                                      return InkWell(
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
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width /
                                                  1.1,
                                          height:
                                              MediaQuery.of(context).size.height /
                                                  10,
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    6,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    12,
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(10)),
                                                  child: (ds2['image'] != null)
                                                      ? CachedNetworkImage(
                                                          imageUrl: ds2['image'],
                                                          fit: BoxFit.cover,
                                                        )
                                                      : null,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(10.0),
                                                child: Stack(
                                                  children: <Widget>[
                                                    Container(
                                                      width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                          1.5,
                                                      height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                          10,
                                                      child: Column(
                                                        children: <Widget>[
                                                          Text(
                                                            '${ds2['nickname']}님이 ${ds['context'].substring(0,6)}... 에 댓글을 남겼습니다',
                                                            style: TextStyle(
                                                                fontSize: MediaQuery.of(context).textScaleFactor*20,
                                                                fontWeight: FontWeight.w500,
                                                                fontFamily: 'NIX'
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Positioned(
                                                      bottom: 5,
                                                      right: 1,
                                                      child: Container(
                                                        child: Text(
                                                          TimeDuration(ds2['time'],
                                                              DateTime.now()),
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
                                      );
                                    });
                              });
                        });
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
