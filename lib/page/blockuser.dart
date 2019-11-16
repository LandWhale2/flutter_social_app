import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialapp/page/contextpage.dart';

class BlockUser extends StatefulWidget {
  final String currentId;

  BlockUser({Key key, @required this.currentId}) : super(key: key);

  @override
  _BlockUserState createState() => _BlockUserState(currentId: currentId);
}

class _BlockUserState extends State<BlockUser> {
  final String currentId;

  _BlockUserState({Key key, @required this.currentId});

  BlockClear(String peerId) {
    try {
      if(mounted){
        Firestore.instance.collection('users').document(peerId).updateData({
          'block': FieldValue.arrayRemove([currentId]),
        });

        Firestore.instance.collection('users').document(currentId).updateData({
          'block': FieldValue.arrayRemove([peerId]),
        });
        return print('차단해제완료');
      }
    } catch (e) {
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          '차단유저관리',
          style:
              TextStyle(fontFamily: 'NIX', fontSize: 25, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white, //Color.fromRGBO(188, 206, 255, 1)
      ),
      body: StreamBuilder(
          stream: Firestore.instance
              .collection('users')
              .document(currentId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }
            var ds0 = snapshot.data;
            return ListView.builder(
                itemCount: ds0['block'].length,
                itemBuilder: (BuildContext context, int index) {
                  if (ds0['block'][index] == null) {
                    return Container();
                  }
                  var id = ds0['block'][index];
                  return StreamBuilder(
                      stream: Firestore.instance
                          .collection('users')
                          .document(id)
                          .snapshots(),
                      builder: (context, snapshot) {
                        var ds = snapshot.data;
                        if (snapshot.hasData) {
                          return Column(
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width / 1,
                                height: MediaQuery.of(context).size.height / 10,
                                child: Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      width:
                                      MediaQuery.of(context).size.width / 8,
                                      height:
                                      MediaQuery.of(context).size.height / 15,
                                      child: ClipRRect(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                        child: CachedNetworkImage(
                                          imageUrl: ds['image'],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      width:
                                      MediaQuery.of(context).size.width / 4,
                                      height:
                                      MediaQuery.of(context).size.height / 15,
                                      child: Column(
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                child: Text(
                                                  (ds['nickname'] != null)
                                                      ? ds['nickname']
                                                      : '',
                                                  style: TextStyle(
                                                      fontFamily: 'NIX',
                                                      fontWeight:
                                                      FontWeight.w800),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                child: Text(
                                                  (ds['age'] != null)
                                                      ? '${ds['age']}세'
                                                      : '',
                                                  style: TextStyle(
                                                      fontFamily: 'NIX'),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width:
                                      MediaQuery.of(context).size.width / 3,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        BlockClear(ds['id']);
                                      },
                                      child: Container(
                                        width:
                                        MediaQuery.of(context).size.width / 6,
                                        height:
                                        MediaQuery.of(context).size.height /
                                            25,
                                        decoration: BoxDecoration(
                                          border: Border.all(width: 0.3),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                        ),
                                        child: Center(
                                          child: Text(
                                            '해제',
                                            style: TextStyle(fontFamily: 'NIX'),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }else if(snapshot.hasError){
                          return CircularProgressIndicator();
                        }else{
                          return CircularProgressIndicator();
                        }
                      });
                });
          }),
    );
  }
}
