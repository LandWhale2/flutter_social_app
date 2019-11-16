import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:socialapp/page/ProfileEdit.dart';
import 'package:socialapp/page/contextpage.dart';
import 'package:socialapp/page/settingpage.dart';
import 'package:socialapp/page/userwrite.dart';
import 'package:socialapp/widgets/Bloc.dart';
import 'package:socialapp/base.dart';

import 'chatpage.dart';

class ProfileDetail extends StatefulWidget {
  final String usercurrentId, currentId;
  final int check;

  ProfileDetail(
      {Key key, @required this.usercurrentId, @required this.currentId, @required this.check})
      : super(key: key);

  @override
  _ProfileDetailState createState() =>
      _ProfileDetailState(usercurrentId: usercurrentId, currentId: currentId, check: check);
}

class _ProfileDetailState extends State<ProfileDetail> {
  final String usercurrentId, currentId;
  final int check;

  bool LikeState = false;
  bool back = false;
  final _today = TextEditingController();

  _ProfileDetailState(
      {Key key, @required this.usercurrentId, @required this.currentId, @required this.check});

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


  Blockuser(List profileuser, List user, String profileId, String userId) {
    if (user != null) {
      //저장된게있을때
      if(user.length == 0){
        //차단기능을 한번 사용했다가 전부 비운경우
        if(mounted){
          Firestore.instance
              .collection('users')
              .document(profileId)
              .updateData({
            'block': FieldValue.arrayUnion([userId]),
          });
          Firestore.instance
              .collection('users')
              .document(userId)
              .updateData({
            'block': FieldValue.arrayUnion([profileId]),
          });
          return print('sd');
        }

      }

      if (profileuser != null) {
        if(profileuser.length ==0){
          //차단기능을 한번 사용했다가 전부 비운경우
          if(mounted){

            Firestore.instance
                .collection('users')
                .document(profileId)
                .updateData({
              'block': FieldValue.arrayUnion([userId]),
            });
            Firestore.instance
                .collection('users')
                .document(userId)
                .updateData({
              'block': FieldValue.arrayUnion([profileId]),
            });
            return print('aa');
          }
        }

        //프로필유저 저장된게있을때
        if (user.length >= profileuser.length) {

          //길이큰쪽으로 검사하기위함
          for (int i = 0; i < user.length; i++) {

            //리스트중복검사
            if (user[i] == profileId) {
              //원래차단된유저
              return print('a');
            } else if (i == user.length) {
              if(mounted){
                Firestore.instance
                    .collection('users')
                    .document(profileId)
                    .updateData({
                  'block': FieldValue.arrayUnion([userId]),
                });
                Firestore.instance
                    .collection('users')
                    .document(userId)
                    .updateData({
                  'block': FieldValue.arrayUnion([profileId]),
                });
                //채팅방이동페이지
                return print('b');
              }
            }
          }
        } else {

          //길이큰쪽으로 검사하기위함
          for (int i = 0; i < profileuser.length; i++) {
            //리스트중복검사
            if (profileuser[i] == userId) {
              //차단된유저
              return print('f');
            } else if (i == profileuser.length) {
              //신규차단

              if(mounted){

                Firestore.instance
                    .collection('users')
                    .document(profileId)
                    .updateData({
                  'block': FieldValue.arrayUnion([userId]),
                });
                Firestore.instance
                    .collection('users')
                    .document(userId)
                    .updateData({
                  'block': FieldValue.arrayUnion([profileId]),
                });
                return print('c');
              }
              //채팅방 이동페이지
            }
          }
        }
      } else {
        if(mounted){

          Firestore.instance.collection('users').document(profileId).updateData({
            'block': FieldValue.arrayUnion([userId]),
          });
          Firestore.instance.collection('users').document(userId).updateData({
            'block': FieldValue.arrayUnion([profileId]),
          });
          return print('g');
        }
      }
    } else if (user == null || user.length == 0) {
      //아무것도없을때 최초저장
      if(mounted){

        Firestore.instance.collection('users').document(profileId).updateData({
          'block': FieldValue.arrayUnion([userId]),
        });
        Firestore.instance.collection('users').document(userId).updateData({
          'block': FieldValue.arrayUnion([profileId]),
        });
        return print('d');
      }
    }
  }




  AddChat(List profileuser, List user, String profileId, String userId) {
    if (user != null) {
      //저장된게있을때
      if (profileuser != null) {
        //프로필유저 저장된게있을때
        if (user.length >= profileuser.length) {
          //길이큰쪽으로 검사하기위함
          for (int i = 0; i < profileuser.length; i++) {
            //리스트중복검사
            if (profileuser[i] == userId) {
              //원래채팅하던유저
              //채팅방이동페이지
              return print('a');
            } else if (i == profileuser.length) {
              Firestore.instance
                  .collection('users')
                  .document(profileId)
                  .updateData({
                'chattingWith': FieldValue.arrayUnion([userId]),
              });
              Firestore.instance
                  .collection('users')
                  .document(userId)
                  .updateData({
                'chattingWith': FieldValue.arrayUnion([profileId]),
              });
              //채팅방이동페이지
              return print('b');
            }
          }
        } else {
          //길이큰쪽으로 검사하기위함
          for (int i = 0; i < user.length; i++) {
            //리스트중복검사
            if (user[i] == profileId) {
              //원래채팅하던유저
              //채팅방이동페이지
              return print('f');
            } else if (i == user.length) {
              //신규채팅등록
              Firestore.instance
                  .collection('users')
                  .document(profileId)
                  .updateData({
                'chattingWith': FieldValue.arrayUnion([userId]),
              });
              Firestore.instance
                  .collection('users')
                  .document(userId)
                  .updateData({
                'chattingWith': FieldValue.arrayUnion([profileId]),
              });
              return print('c');
              //채팅방 이동페이지
            }
          }
        }
      } else {
        Firestore.instance.collection('users').document(profileId).updateData({
          'chattingWith': FieldValue.arrayUnion([userId]),
        });
        Firestore.instance.collection('users').document(userId).updateData({
          'chattingWith': FieldValue.arrayUnion([profileId]),
        });
        return print('g');
      }
    } else if (user == null) {
      //아무것도없을때 최초저장
      Firestore.instance.collection('users').document(profileId).updateData({
        'chattingWith': FieldValue.arrayUnion([userId]),
      });
      Firestore.instance.collection('users').document(userId).updateData({
        'chattingWith': FieldValue.arrayUnion([profileId]),
      });
      return print('d');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (this.mounted) {
      isLoading = false;
    } else {
      isLoading = true;
    }
    BlockBlock();
  }


  BlockBlock(){
    Firestore.instance.collection('users').document(usercurrentId).snapshots().listen((data){
      if(data['block'] != null){
        for(int i=0; i<data['block'].length; i++){
          if(data['block'][i] == currentId){
            Navigator.pop(context);
            Fluttertoast.showToast(msg: '찾을 수 없는 유저입니다.');
          }
        }

        return null;
      }else{
        return null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
          return StreamBuilder(
            stream: Firestore.instance
                .collection('users')
                .document(currentId)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }
              var ds2 = snapshot.data;
              return Scaffold(
                appBar: AppBar(
                  iconTheme: IconThemeData(
                    color:
                        (currentId == usercurrentId && check ==1) ?Colors.white  : Colors.black,
                  ),
                  title: Text(
                    ds['nickname'],
                    style: TextStyle(
                        fontFamily: 'NIX', fontSize: 25, color: Colors.black),
                  ),
                  centerTitle: true,
                  backgroundColor: Colors.white,
                  actions: <Widget>[
                    InkWell(
                      onTap: (){
                        showDialog(context: context,
                        builder: (_) => AlertDialog(
                          title: Text('차단/신고',style: TextStyle(color: Colors.red),),
                          content: Text('이 유저를 차단할 시 서로 글과 댓글을 볼 수 없게 되며 자동으로 신고처리가 됩니다. 차단하시겠습니까?'),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('취소'),
                              onPressed: (){Navigator.pop(context);},),
                            FlatButton(
                              child: Text(
                              '차단',
                                style: TextStyle(
                                color: Colors.red),),
                              onPressed: (){
                                Navigator.pop(context);
                                Future.delayed(Duration(seconds: 1), (){
                                  Blockuser(ds['block'], ds2['block'], ds['id'], ds2['id']);
                                });

                              },
                            ),

                          ],
                        ),);
                      },
                        child: Icon(Icons.block)
                    ),
                    SizedBox(width: 10,),
                  ],
                ),
                body: ListView(
                  children: <Widget>[
                          Container(
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
                                        width:
                                            MediaQuery.of(context).size.width / 5,
                                        height:
                                            MediaQuery.of(context).size.height / 10,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.all(Radius.circular(10)),
                                          child: CachedNetworkImage(
                                            imageUrl: ds['image'],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Container(
                                            child: FlatButton.icon(
                                                onPressed: () {},
                                                icon: Icon(
                                                  Icons.edit_location,
                                                ),
                                                label: Text(
                                                  ds['location'] ?? '',
                                                  style:
                                                      TextStyle(fontFamily: 'NIX'),
                                                )),
                                          ),
                                          Container(
                                            child: FlatButton.icon(
                                                onPressed: () {},
                                                icon: Icon(
                                                  Icons.person,
                                                ),
                                                label: Text(
                                                  '${ds['age']}세' ?? '',
                                                  style:
                                                  TextStyle(fontFamily: 'NIX'),
                                                )),
                                          ),
                                        ],
                                        mainAxisAlignment: MainAxisAlignment.center,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width / 2,
                                        height:
                                            MediaQuery.of(context).size.height / 10,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(width: 0.1),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  4,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  10,
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.spaceEvenly,
                                                  children: <Widget>[
                                                    Text(
                                                      '방문자',
                                                      style: TextStyle(
                                                          fontFamily: 'NIX',
                                                          color: Colors.black),
                                                    ),
                                                    Text(
                                                      '23',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          fontSize: 20),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  4.1,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  10,
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.spaceEvenly,
                                                  children: <Widget>[
                                                    Text(
                                                      '좋아요',
                                                      style: TextStyle(
                                                          fontFamily: 'NIX',
                                                          color: Colors.black),
                                                    ),
                                                    Text(
                                                      (ds['like'] != null)
                                                          ? ds['like'].toString()
                                                          : '0',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          fontSize: 20),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      (usercurrentId != currentId)
                                          ? Row(
                                              children: <Widget>[
                                                SizedBox(
                                                  width: 95,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    AddChat(
                                                        ds['chattingWith'],
                                                        ds2['chattingWith'],
                                                        ds['id'],
                                                        ds2['id']);
                                                  },
                                                  child: Container(
                                                    width: MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        4.5,
                                                    height: MediaQuery.of(context)
                                                            .size
                                                            .height /
                                                        25,
                                                    decoration: BoxDecoration(
                                                        border:
                                                            Border.all(width: 0.1),
                                                        color: Color.fromRGBO(
                                                            247, 64, 106, 1),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    20))),
                                                    child: Center(
                                                      child: Text(
                                                        'CHAT',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 20),
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
                                                    width: MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        4.5,
                                                    height: MediaQuery.of(context)
                                                            .size
                                                            .height /
                                                        25,
                                                    decoration: BoxDecoration(
                                                        border:
                                                            Border.all(width: 0.1),
                                                        color: (LikeCheck(ds[
                                                                    'likeperson']) ==
                                                                false)
                                                            ? Colors.black
                                                            : Color.fromRGBO(
                                                                247, 64, 106, 1),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    20))),
                                                    child: Center(
                                                      child: Text(
                                                        'LIKE',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 20),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Container(),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      (currentId == usercurrentId)
                                          ? InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ProfileEdit(
                                                              currentId: currentId,
                                                            )));
                                              },
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    4,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    25,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 0.4,
                                                      color: Colors.black),
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(7)),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    '프로필 수정',
                                                    style: TextStyle(
                                                        fontFamily: 'NIX'),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Container(),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            width:
                                                MediaQuery.of(context).size.width /
                                                    2,
                                            height:
                                                MediaQuery.of(context).size.height /
                                                    25,
                                            decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(width: 1)),
                                            ),
                                            child: Center(
                                              child: Text(
                                                (ds['today'] == null)
                                                    ? '오늘의 한마디'
                                                    : ds['today'],
                                                style: TextStyle(
                                                    color: (ds['today'] == null)
                                                        ? Colors.black54
                                                        : Colors.black,
                                                    fontSize: 15,
                                                    fontFamily: 'NIX'),
                                              ),
                                            ),
                                          ),
//                                      (currentId == usercurrentId)
//                                          ? InkWell(
//                                        onTap: () {
//                                          showDialog(
//                                              context: context,
//                                              builder:
//                                                  (BuildContext context) {
//                                                return AlertDialog(
//                                                  content: Container(
//                                                    child: TextFormField(
//                                                      maxLength: 12,
//                                                      controller: _today,
//                                                      decoration:
//                                                      InputDecoration(
//                                                        hintText:
//                                                        '오늘의한마디를 입력해주세요.',
//                                                      ),
//                                                      validator: (input) {
//                                                        if (input.isEmpty) {
//                                                          return '내용을입력해주세요';
//                                                        }
//                                                      },
//                                                    ),
//                                                  ),
//                                                  actions: <Widget>[
//                                                    FlatButton(
//                                                      child: Text('취소'),
//                                                      onPressed: () {
//                                                        Navigator.of(context)
//                                                            .pop();
//                                                      },
//                                                      textColor: maincolor,
////                                                        padding:
////                                                        EdgeInsets.only(
////                                                            left: 120),
//                                                    ),
//                                                    FlatButton(
//                                                      child: Text('확인'),
//                                                      onPressed: (){
//                                                        Firestore.instance.collection('users').document(usercurrentId).updateData({
//                                                          'today': _today.text,
//                                                        });
//                                                        Navigator.of(context)
//                                                            .pop(_today);
//                                                      },
//                                                      textColor: Colors.black,
////                                                        padding:
////                                                            EdgeInsets.only(
////                                                                right: 120),
//                                                    )
//                                                  ],
//                                                );
//                                              });
//                                        },
//                                        child: Icon(Icons.edit),
//                                      )
//                                          : Container(),
                                        ],
                                      ),
                                      SizedBox(height: 20,),
                                      Container(
                                        child: FlatButton.icon(
                                            onPressed: () {
                                            },
                                            icon: Icon(
                                              Icons.edit,
                                            ),
                                            label: Text(
                                              '작성글 보기',
                                              style:
                                              TextStyle(fontFamily: 'SIL', fontSize: MediaQuery.of(context).textScaleFactor*25),
                                            )),
                                      ),
                                      SizedBox(height: 10,),

                                          Container(
                                            width:
                                            MediaQuery.of(context).size.width / 2,
                                            height:
                                            MediaQuery.of(context).size.height / 20,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(width: 0.3,color: Colors.black),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))),
                                            child: Row(
                                              children: <Widget>[
                                                InkWell(
                                                  child: Container(
                                                    width:
                                                    MediaQuery.of(context).size.width /4,
                                                    height:
                                                    MediaQuery.of(context).size.height / 20,
                                                    decoration: BoxDecoration(
                                                        border: Border(
                                                          right: BorderSide(
                                                            width: 0.2
                                                          )
                                                        )),
                                                    child: Center(
                                                      child: Text(
                                                        '구한다',
                                                        style: TextStyle(fontFamily: 'SIL', fontSize: MediaQuery.of(context).textScaleFactor*18),
                                                      ),
                                                    ),
                                                  ),
                                                  onTap: (){
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                UserWrite(
                                                                  currentId: currentId,
                                                                  username: ds['nickname'],
                                                                  userId: ds['id'],
                                                                  title: '구한다',
                                                                  Selectspace: 'find',
                                                                )));
                                                  },
                                                ),
                                                InkWell(
                                                  child: Container(
                                                    width:
                                                    MediaQuery.of(context).size.width /4.1,
                                                    height:
                                                    MediaQuery.of(context).size.height / 20,
                                                    child: Center(
                                                      child: Text(
                                                        '말한다',
                                                        style: TextStyle(fontFamily: 'SIL', fontSize: MediaQuery.of(context).textScaleFactor*18),
                                                      ),
                                                    ),
                                                  ),
                                                  onTap: (){
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                UserWrite(
                                                                  currentId: currentId,
                                                                  username: ds['nickname'],
                                                                  userId: ds['id'],
                                                                  title: '말한다',
                                                                  Selectspace: 'say',
                                                                )));
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                      SizedBox(height: 10,),

                                      Container(
                                        child: FlatButton.icon(
                                            onPressed: () {},
                                            icon: Icon(
                                              Icons.chat,
                                            ),
                                            label: Text(
                                              '공지사항',
                                              style:
                                              TextStyle(fontFamily: 'SIL', fontSize: MediaQuery.of(context).textScaleFactor*25),
                                            )),
                                      ),
                                      SizedBox(height: 20,),
                                      Container(
                                        child: FlatButton.icon(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          SettingPage(
                                                            currentId: currentId,
                                                          )));
                                            },
                                            icon: Icon(
                                              Icons.settings,
                                            ),
                                            label: Text(
                                              '환경설정',
                                              style:
                                              TextStyle(fontFamily: 'SIL', fontSize: MediaQuery.of(context).textScaleFactor*25),
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                                buildLoading(),
                              ],
                            ),
                          ),
                  ],
                ),
              );
            }
          );
        });
  }

  Widget buildLoading() {
    return Positioned(
      child: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.grey)),
              ),
              color: Colors.white.withOpacity(0.8),
            )
          : Container(),
    );
  }

  bool isLoading = false;
}

class CustomNavRoute<T> extends MaterialPageRoute<T> {
  CustomNavRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.isInitialRoute) return child;
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
