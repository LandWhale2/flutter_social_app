import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialapp/page/contextpage.dart';
import 'package:socialapp/widgets/Bloc.dart';
import 'package:socialapp/base.dart';

class ProfileDetail extends StatefulWidget {
  final String usercurrentId, currentId;

  ProfileDetail({Key key, @required this.usercurrentId, @required this.currentId}) : super(key: key);

  @override
  _ProfileDetailState createState() =>
      _ProfileDetailState(usercurrentId: usercurrentId, currentId: currentId);
}

class _ProfileDetailState extends State<ProfileDetail> {
  final String usercurrentId, currentId;

  bool LikeState = false;

  _ProfileDetailState({Key key, @required this.usercurrentId, @required this.currentId});

//  LikeControll(bool state, String userId) async {
//    if (state == false) {
//      return await Firestore.instance
//          .collection('users')
//          .document(usercurrentId)
//          .updateData({
//        'like': FieldValue.increment(1),
//      });
//    } else {
//      return await Firestore.instance
//          .collection('users')
//          .document(usercurrentId)
//          .updateData({
//        'like': FieldValue.increment(-1),
//      });
//    }
//  }

  LikeManager(List tmp) {
    if (tmp == null) {
      return Firestore.instance
          .collection('users')
          .document(usercurrentId)
          .updateData({
        'likeperson': FieldValue.arrayUnion([currentId]),
        'like': FieldValue.increment(1),
      });
    }

    for (int i = 0; i < tmp.length; i++) {
      if (tmp[i] == currentId) {
        return Firestore.instance
            .collection('users')
            .document(usercurrentId)
            .updateData({
          'likeperson': FieldValue.arrayRemove([currentId]),
          'like': FieldValue.increment(-1),
        });
      } else {
        continue;
      }
    }

    return Firestore.instance
        .collection('users')
        .document(usercurrentId)
        .updateData({
      'likeperson': FieldValue.arrayUnion([currentId]),
      'like': FieldValue.increment(1),
    });
  }

  LikeCheck(List person) {
    if (person != null) {
      for (int i = 0; i < person.length; i++) {
        if (person[i] == currentId) {
          LikeState = true;
          return LikeState;
        }
      }
      LikeState = false;
      return LikeState;
    }
    LikeState = false;
    return LikeState;
  }

  AddChat(List profileuser, List user, String profileId, String userId){
    if(user != null){
      if(user.length > profileuser.length){
        for(int i = 0 ; i<profileuser.length ; i++){
          if(user[i] == profileuser[i]){
            //채팅방이동페이지
          }else{
            Firestore.instance.collection('users').document(profileId).updateData({
              'chattingWith' : FieldValue.arrayUnion([userId]),
            });
            Firestore.instance.collection('users').document(userId).updateData({
              'chattingWith' : FieldValue.arrayUnion([profileId]),
            });

            //채팅방이동페이지
          }
        }
      }else{
        for(int i = 0 ; i<user.length ; i++){
          if(user[i] == profileuser[i]){
            //채팅방이동페이지
          }else{
            Firestore.instance.collection('users').document(profileId).updateData({
              'chattingWith' : FieldValue.arrayUnion([userId]),
            });
            Firestore.instance.collection('users').document(userId).updateData({
              'chattingWith' : FieldValue.arrayUnion([profileId]),
            });
//            Navigator.push(
//                context,
//                MaterialPageRoute(
//                    builder: (context) => ()));
            //채팅방 이동페이지
          }
        }
      }
    }else{
      Firestore.instance.collection('users').document(profileId).updateData({
        'chattingWith' : FieldValue.arrayUnion([userId]),
      });
      Firestore.instance.collection('users').document(userId).updateData({
        'chattingWith' : FieldValue.arrayUnion([profileId]),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ProfileLikeState profileLikeState =
        Provider.of<ProfileLikeState>(context);
    return StreamBuilder(
        stream: Firestore.instance
            .collection('users')
            .document(usercurrentId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          var ds = snapshot.data;
          return Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
              title: Text(
                ds['nickname'],
                style: TextStyle(
                    fontFamily: 'NIX', fontSize: 25, color: Colors.black),
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
                var ds2 = snapshot.data;
                return Container(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height / 4,
                        color: Color.fromRGBO(255, 125, 128, 100),
                      ),
                      Center(
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 5,
                              height: MediaQuery.of(context).size.height / 10,
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                child: CachedNetworkImage(
                                  imageUrl: ds['image'][0],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              child: FlatButton.icon(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.edit_location,
                                  ),
                                  label: Text(
                                    '대전',
                                    style: TextStyle(fontFamily: 'NIX'),
                                  )),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 2,
                              height: MediaQuery.of(context).size.height / 10,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(width: 0.1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    width: MediaQuery.of(context).size.width / 4,
                                    height: MediaQuery.of(context).size.height / 10,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Text(
                                            '방문자',
                                            style: TextStyle(
                                                fontFamily: 'NIX',
                                                color: Colors.black45),
                                          ),
                                          Text(
                                            '23',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w900,
                                                fontSize: 20),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 4.1,
                                    height: MediaQuery.of(context).size.height / 10,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Text(
                                            '좋아요',
                                            style: TextStyle(
                                                fontFamily: 'NIX',
                                                color: Colors.black45),
                                          ),
                                          Text(
                                            (ds['like'] != null)
                                                ? ds['like'].toString()
                                                : '0',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w900,
                                                fontSize: 20),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 95,
                                ),
                                InkWell(
                                  onTap: (){
                                    AddChat(ds['chattingWith'],ds2['chattingWith'], ds['id'], ds2['id']);
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width / 4.5,
                                    height: MediaQuery.of(context).size.height / 25,
                                    decoration: BoxDecoration(
                                        border: Border.all(width: 0.1),
                                        color: Color.fromRGBO(247, 64, 106, 1),
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(20))),
                                    child: Center(
                                      child: Text(
                                        'CHAT',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                InkWell(
                                  onTap: () {
                                    LikeManager(ds['likeperson']);
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width / 4.5,
                                    height: MediaQuery.of(context).size.height / 25,
                                    decoration: BoxDecoration(
                                        border: Border.all(width: 0.1),
                                        color: (LikeCheck(ds['likeperson']) == false)
                                            ? Colors.black
                                            : Color.fromRGBO(247, 64, 106, 1),
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(20))),
                                    child: Center(
                                      child: Text(
                                        'LIKE',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
            ),
          );
        });
  }
}