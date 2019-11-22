import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:socialapp/base.dart';
import 'package:socialapp/page/contextpage.dart';
import 'package:socialapp/widgets/adHelper.dart';

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

  String groupChatId;


  bool isLoading = false;

  deleteMessages(String peerId){
    var groupChat = readLocal(peerId);
    Firestore.instance.collection('messages').document(groupChatId).updateData({
      'delete' : 'ss',
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    groupChatId = '';
  }

  readLocal(String peerId) async{
    if(currentId.hashCode <= peerId.hashCode){
      groupChatId = '$currentId-$peerId';
      return groupChatId;
    }else{
      groupChatId = '$peerId-$currentId';
      return groupChatId;
    }
  }
  Future<Null> refreshList() async{
    await Future.delayed(Duration(milliseconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),

        title: Text(
          '채팅',
          style:
          TextStyle(fontFamily: 'NIX', fontSize: 25, color: Colors.black),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.ac_unit),
            onPressed: (){},
          ),
        ],
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.ac_unit),
          onPressed: (){},
        ),
        backgroundColor: Colors.white, //Color.fromRGBO(188, 206, 255, 1)
      ),
      body: (FirebaseAuth.instance.currentUser() != null)?Stack(
        children: <Widget>[
          Container(
            child: StreamBuilder(
              stream: Firestore.instance
                  .collection('users')
                  .document(currentId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                } else {
                  return LiquidPullToRefresh(
                    onRefresh: ()async{
                      await refreshList();
                    },
                    color: Colors.blue,
                    springAnimationDurationInMilliseconds: 500,
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        if (snapshot.data['chattingWith'][index] == null) {
                          return Container();
                        } else {
                          return Dismissible(
                            key: ObjectKey(snapshot.data['chattingWith'][index]),
                            onDismissed: (direction){
                              deleteMessages(snapshot.data['chattingWith'][index]);
                              setState(() {
                                snapshot.data['chattingWith'].removeAt(index);
                              });
                            },
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.only(right: 20),
                              color: Colors.red,
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            child: buildItem(
                                context, snapshot.data['chattingWith'][index]),
                          );
                        }
                      },
                      padding: EdgeInsets.all(10),
                      itemCount: (snapshot.data['chattingWith'] != null)
                          ? snapshot.data['chattingWith'].length
                          : 0,
                    ),
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
      ):Container(),
    );
  }

  Widget buildItem(BuildContext context, String userId) {
    if (userId == null) {
      return Container();
    }
    return StreamBuilder(
        stream:
            Firestore.instance.collection('users').document(userId).snapshots(),
        builder: (context, snapshot) {
          var document = snapshot.data;
          readLocal(userId);
          if(!snapshot.hasData){
            return Container();
          }
          if(document['block'] != null){
            for(int i=0; i<document['block'].length ; i++){
              if(document['block'][i] == currentId){
                return Container();
              }
            }
          }
          return Container(
            child: FlatButton(
              child: Row(
                children: <Widget>[
                  Material(
                    child: document['image'] != null
                        ? CachedNetworkImage(
                            placeholder: (context, url) => Container(
                              child: CircularProgressIndicator(
                                strokeWidth: 1,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.black87),
                              ),
                              width: 50,
                              height: 50,
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                            imageUrl: document['image'],
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                        : Icon(
                            Icons.account_circle,
                            size: 50,
                            color: Colors.grey,
                          ),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    clipBehavior: Clip.hardEdge,
                  ),
                  StreamBuilder(
                    stream: Firestore.instance.collection('messages')
                        .document(groupChatId).collection(groupChatId).orderBy('timestamp', descending: true).limit(1).snapshots(),
                    builder: (context, snapshot) {
                      if(!snapshot.hasData){
                        return Container();
                      }
                      var lasttext = snapshot.data.documents;
                      return Flexible(
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: Text(
                                  '${document['nickname']}',
                                  style: TextStyle(
                                      color: Colors.black87, fontFamily: 'NIX'),
                                ),
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.fromLTRB(10, 0, 0, 5),
                              ),
                              Container(
                                child: Text(
                                  '${document['today'] ?? '냉무'}',
                                  style: TextStyle(color: Colors.blue),
                                ),
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              ),
                            ],
                          ),
                          margin: EdgeInsets.only(left: 20),
                        ),
                      );
                    }
                  ),
                ],
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Chat(
                              currentId: currentId,
                              peerId: document['id'],
                              peerAvatar: document['image'],
                            ))).then((value){
                              Ads.showBannerAd();
                });
              },
              color: Colors.white30,
              padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            margin: EdgeInsets.only(bottom: 10, left: 5, right: 5),
          );
        });
  }
}
