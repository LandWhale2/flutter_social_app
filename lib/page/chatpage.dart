import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialapp/base.dart';
import 'package:socialapp/page/contextpage.dart';

import 'chat.dart';

class Chatpage extends StatefulWidget {
  final String currentId;

  Chatpage({Key key, @required this.currentId}) : super(key: key);

  @override
  _ChatpageState createState() => _ChatpageState(currentId: currentId);
}

class _ChatpageState extends State<Chatpage> {
  final String currentId;

  _ChatpageState({Key key, @required this.currentId});

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            child: StreamBuilder(
              stream: Firestore.instance.collection('users').document(currentId).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                } else {
                  return ListView.builder(
                    itemBuilder: (context, index) =>
                        buildItem(context, snapshot.data['chattingWith'][index]),
                    padding: EdgeInsets.all(10),
                    itemCount:(snapshot.data['chattingWith'] != null)? snapshot.data['chattingWith'].length: 0,
                  );
                }
              },
            ),
          ),
          Positioned(
            child: isLoading
                ? Container(
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.redAccent),
                      ),
                    ),
                    color: Colors.white.withOpacity(0.8),
                  )
                : Container(),
          ),
        ],
      ),
    );
  }

  Widget buildItem(BuildContext context, String userId) {
      return StreamBuilder(
        stream: Firestore.instance.collection('users').document(userId).snapshots(),
        builder: (context, snapshot) {
          var document = snapshot.data;
          return Container(
            child: FlatButton(
              child: Row(
                children: <Widget>[
                  Material(
                    child: document['image'][0] != null
                        ? CachedNetworkImage(
                            placeholder: (context, url) => Container(
                              child: CircularProgressIndicator(
                                strokeWidth: 1,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.black87),
                              ),
                              width: 50,
                              height: 50,
                              padding: EdgeInsets.all(15),
                            ),
                            imageUrl: document['image'][0],
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                        : Icon(
                            Icons.account_circle,
                            size: 50,
                            color: Colors.grey,
                          ),
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    clipBehavior: Clip.hardEdge,
                  ),
                  Flexible(
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: Text(
                              '${document['nickname']}',
                              style: TextStyle(color: Colors.black87, fontFamily: 'NIX'),
                            ),
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.fromLTRB(10, 0, 0, 5),
                          ),
                          Container(
                            child: Text(
                              '${document['aboutMe'] ?? '냉무'}',
                              style: TextStyle(color: Colors.blue),
                            ),
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          ),
                        ],
                      ),
                      margin: EdgeInsets.only(left: 20),
                    ),
                  ),
                ],
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Chat(
                              peerId: document['id'],
                              peerAvatar: document['image'][0],
                            )));
              },
              color: Colors.white30,
              padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            margin: EdgeInsets.only(bottom: 10, left: 5, right: 5),

          );
        }
      );

  }
}
