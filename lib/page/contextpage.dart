import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';
import 'package:socialapp/base.dart';
import 'package:socialapp/main.dart';
import 'package:socialapp/page/Writing.dart';
import 'package:socialapp/page/home.dart';
import 'package:socialapp/widgets/Bloc.dart';
import 'board.dart';
import 'package:socialapp/widgets/Hero.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

var maincolor = Color.fromRGBO(255, 125, 128, 1);

class ContextPage extends StatefulWidget {
  String SelectSpace, title;
  final String currentId;
  final String contextId;

  ContextPage({
    Key key,
    @required this.title,
    @required this.currentId,
    @required this.contextId,
    @required this.SelectSpace,
  }) : super(key: key);

  @override
  _ContextPageState createState() => _ContextPageState(
      currentId: currentId,
      contextId: contextId,
      SelectSpace: SelectSpace,
      title: title);
}

class _ContextPageState extends State<ContextPage> {
  final String currentId;
  final String contextId;
  String SelectSpace, title;
  bool LikeState = false;
  int commentNum;
  String _comment;
  String reply;
  final _formKey = GlobalKey<FormState>();
  final replyKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  _ContextPageState(
      {Key key,
      @required this.currentId,
      @required this.contextId,
      @required this.title,
      @required this.SelectSpace});

  LikeManager(List tmp) {
    if (tmp == null) {
      return Firestore.instance
          .collection(SelectSpace)
          .document(contextId)
          .updateData({
        'likeperson': FieldValue.arrayUnion([currentId]),
        'like': FieldValue.increment(1),
      });
    }

    for (int i = 0; i < tmp.length; i++) {
      if (tmp[i] == currentId) {
        return Firestore.instance
            .collection(SelectSpace)
            .document(contextId)
            .updateData({
          'likeperson': FieldValue.arrayRemove([currentId]),
          'like': FieldValue.increment(-1),
        });
      } else {
        continue;
      }
    }

    return Firestore.instance
        .collection(SelectSpace)
        .document(contextId)
        .updateData({
      'likeperson': FieldValue.arrayUnion([currentId]),
      'like': FieldValue.increment(1),
    });
  }

  CommentSum() async {
    await Firestore.instance
        .collection(SelectSpace)
        .document(contextId)
        .collection('comment')
        .snapshots()
        .listen((data) {
      commentNum = data.documents.length;
      return commentNum;
    });
  }

  delete(String commentId) {
    Firestore.instance
        .collection(SelectSpace)
        .document(contextId)
        .collection('comment')
        .document(commentId)
        .delete();
  }
  deleteContext(String commentId) {
    Firestore.instance
        .collection(SelectSpace)
        .document(contextId)
        .delete();
  }

//  LikeControll(bool state) async {
//    if (state == false) {
//      return await Firestore.instance
//          .collection(SelectSpace)
//          .document(contextId)
//          .updateData({
//        'like': FieldValue.increment(1),
//      });
//    } else {
//      return await Firestore.instance
//          .collection(SelectSpace)
//          .document(contextId)
//          .updateData({
//        'like': FieldValue.increment(-1),
//      });
//    }
//  }

//  PostReply(String commentId) async {
//    var _form = replyKey.currentState;
//    if (_form.validate()) {
//      _form.save();
//      try {
//        var documentName =
//            'R' + DateTime.now().millisecondsSinceEpoch.toString();
//
//        await Firestore.instance
//            .collection('users')
//            .where('id', isEqualTo: currentId)
//            .snapshots()
//            .listen((data) async {
//          await Firestore.instance
//              .collection(SelectSpace)
//              .document(contextId)
//              .collection('comment')
//              .document(commentId)
//              .collection('reply')
//              .document(documentName)
//              .setData({
//            'commentID': commentId,
//            'contextID': contextId,
//            'replyID': documentName,
//            'context': reply,
//            'time': DateTime.now().millisecondsSinceEpoch,
//            'space': title,
//            'id': currentId,
//            'image': data.documents[0]['image'][0],
//            'nickname': data.documents[0]['nickname'],
//          });
//        });
//
//        setState(() {
//          _form.reset();
//        });
//      } catch (e) {
//        print(e.message);
//      }
//    }
//  }

  PostComment() async {
    var form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      try {
        var documentName =
            'C' + DateTime.now().millisecondsSinceEpoch.toString();
        await Firestore.instance
            .collection('users')
            .where('id', isEqualTo: currentId)
            .snapshots()
            .listen((data) async {
          await Firestore.instance
              .collection(SelectSpace)
              .document(contextId)
              .collection('comment')
              .document(documentName)
              .setData({
            'context': _comment,
            'image': data.documents[0]['image'],
            'time': DateTime.now().millisecondsSinceEpoch,
            'space': title,
            'nickname': data.documents[0]['nickname'],
            'id': data.documents[0]['id'],
            'commentID': documentName,
            'contextID': contextId,
          });
        });

        Firestore.instance
            .collection(SelectSpace)
            .document(contextId)
            .updateData({
          'comment': FieldValue.increment(1),
        });

        setState(() {
          form.reset();
        });
      } catch (e) {
        print(e.message);
      }
    }
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

    return false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CommentSum();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance
            .collection(SelectSpace)
            .document(contextId)
            .snapshots(),
        builder: (context, snapshot) {
          var ds1 = snapshot.data;
          if (!snapshot.hasData) {
            return Container();
          }
          return Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
              title: Text(
                ds1['nickname'],
                style: TextStyle(
                    fontFamily: 'NIX', fontSize: 25, color: Colors.black),
              ),
              centerTitle: true,
              backgroundColor: Colors.white, //Color.fromRGBO(188, 206, 255, 1)
            ),
            body: Stack(
              children: <Widget>[
                ListView(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height / 12,
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    //작성자프로필사진
                                    width: MediaQuery.of(context).size.width / 6,
                                    height: MediaQuery.of(context).size.height / 12,
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      child: (ds1['image'] != null)
                                          ? CachedNetworkImage(
                                              imageUrl: ds1['image'],
                                              fit: BoxFit.cover,
                                            )
                                          : null,
                                    ),
                                  ),
                                  Positioned(
                                    //작성자닉네임
                                    left: 70,
                                    top: 3,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width / 4,
                                      height:
                                          MediaQuery.of(context).size.height / 30,
                                      child: Text(
                                        ds1['nickname'],
                                        textAlign: TextAlign.start,
                                        style: TextStyle(),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    //작성시간
                                    left: 70,
                                    bottom: 5,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width / 5,
                                      height:
                                          MediaQuery.of(context).size.height / 40,
                                      child: Text(
                                        TimeDuration(ds1['time'], DateTime.now()),
                                        style: TextStyle(color: Colors.black45,
                                        fontFamily: 'NIX'),
                                      ),
                                    ),
                                  ),
                                  (currentId == ds1['id'] || currentId == 'admin')?Positioned(
                                    right: 5,
                                    top: 5,
                                    child: InkWell(
                                      onTap: (){
                                          showDialog(context: context,
                                          builder: (BuildContext context) => CupertinoActionSheet(
                                            cancelButton: CupertinoActionSheetAction(
                                              child: Text('취소'),
                                              onPressed: (){
                                                Navigator.pop(context);
                                              },
                                            ),
                                            actions: <Widget>[
                                              CupertinoActionSheetAction(
                                                child: Text('글 삭제', style: TextStyle(color: Colors.red),),
                                                onPressed: (){
                                                  showDialog(context: context,
                                                  builder: (BuildContext context)=> CupertinoAlertDialog(
                                                    title: Text('정말 삭제하시겠습니까?'),
                                                    content: Text('삭제시 되돌릴수없습니다.'),
                                                    actions: <Widget>[
                                                      CupertinoDialogAction(
                                                        child: Text('취소'),
                                                        onPressed: (){
                                                          Navigator.pop(context);
                                                        },
                                                      ),
                                                      CupertinoDialogAction(
                                                        child: Text('삭제'),
                                                        onPressed: (){
                                                          Navigator.of(context).pushAndRemoveUntil(
                                                              MaterialPageRoute(builder: (context) => Base(currentUserId: currentId,)),
                                                                  (Route<dynamic> route) => false);
                                                          deleteContext(contextId);
                                                        },
                                                      ),
                                                    ],
                                                  ),);
                                                },
                                              ),
                                              CupertinoActionSheetAction(
                                                child: Text('글 수정'),
                                                onPressed: (){
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => Writing(
                                                            currentId: currentId,
                                                            SelectSpace: SelectSpace,
                                                            title: title,
                                                            contextId: contextId,
                                                          )));
                                                },
                                              ),
                                            ],
                                          ),);

                                      },
                                      child: Icon(
                                        Icons.view_headline,
                                      ),
                                    ),
                                  ):Container(),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              //텍스트
                              ds1['context'],
                              maxLines: null,
                              style: TextStyle(fontFamily: 'NIX'),
                            ),
//              CachedNetworkImage(
//                imageUrl: ,
//              )
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 50, left: 90, bottom: 10),
                              child: Container(
                                width: MediaQuery.of(context).size.width/2,
                                height: MediaQuery.of(context).size.height/15,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                  border: Border.all(width: 0.3),
                                  color: Colors.white
                                ),
                                child: Padding(
                                  //좋아요 ,댓글
                                  padding: const EdgeInsets.only(left:20),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        //좋아요수
                                        width: MediaQuery.of(context).size.width / 5,
                                        height: MediaQuery.of(context).size.height / 40,
                                        child: Row(
                                          children: <Widget>[
                                            InkWell(
                                              onTap: () {
                                                LikeManager(ds1['likeperson']);
                                              },
                                              child: (LikeCheck(ds1['likeperson']) ==
                                                  false)
                                                  ? Icon(
                                                Icons.favorite_border,
                                                color: Colors.red,
                                                size: 20,
                                              )
                                                  : Icon(
                                                Icons.favorite,
                                                color: Colors.red,
                                                size: 20,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              (ds1['like'] != null)
                                                  ? ds1['like'].toString()
                                                  : '0',
                                              maxLines: null,
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: Colors.black54,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        //코멘트 수
                                        width: MediaQuery.of(context).size.width / 5,
                                        height: MediaQuery.of(context).size.height / 40,
                                        child: Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.comment,
                                              color: Colors.red,
                                              size: 20,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              (commentNum != null)
                                                  ? commentNum.toString()
                                                  : '0',
                                              textAlign: TextAlign.start,
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
                              ),
                            ),
                            CommentBox(context),
                            SizedBox(
                              height: 50,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(
                                  width: 0.1
                              )
                          ),
                          color: Colors.black12
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 5, left: 10),
                            child: Container(
                              width: MediaQuery.of(context).size.width/1.2,
                              decoration: BoxDecoration(
                                border: Border.all(width: 0.1),
                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                  color: Colors.white

                              ),
                              child: Form(
                                key: _formKey,
                                child: Padding(
                                  padding:
                                  const EdgeInsets.only(left: 8),
                                  child: TextFormField(
                                    controller: _controller,
                                    maxLength: 500,
                                    maxLines: null,
                                    decoration: InputDecoration(
                                      counterText: '',
                                      hintStyle: TextStyle(
                                          fontSize: MediaQuery.of(context).textScaleFactor*20,
                                          fontFamily: 'NIX'
                                      ),
                                      hintText: '댓글을 입력해주세요.',
                                      border: InputBorder.none,
                                    ),
                                    validator: (input) {
                                      if (input.isEmpty) {
                                        return '내용을입력해주세요';
                                      }
                                    },
                                    onSaved: (value) =>
                                    _comment = value,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: PostComment,
                            child: Icon(
                              Icons.send,
                              size: MediaQuery.of(context).textScaleFactor*50,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  Widget CommentBox(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection(SelectSpace)
            .document(contextId)
            .collection('comment')
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          return ListView.builder(
              padding: EdgeInsets.only(top: 10),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: snapshot.data.documents.length,
              itemBuilder: (BuildContext context, int index) {
                DocumentSnapshot ds2 = snapshot.data.documents[index];
                var textlength = ds2['context'].length;
                return Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.38,
                    height: MediaQuery.of(context).size.height / 9,
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.3),
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          top: 5,
                          left: 5,
                          child: Container(
                            //작성자프로필사진
                            width: MediaQuery.of(context).size.width / 6,
                            height: MediaQuery.of(context).size.height / 12,
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              child: (ds2['image'] != null)
                                  ? CachedNetworkImage(
                                      imageUrl: ds2['image'],
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 5,
                          left: 70,
                          child: Container(
                            //닉네임
                            width: MediaQuery.of(context).size.width / 6,
                            height: MediaQuery.of(context).size.height / 40,
                            decoration: BoxDecoration(
//                              border: Border(
//                                  bottom: BorderSide(
//                                width: 1,
//                                color: Color.fromRGBO(255, 125, 128, 1),
//                              )),
                              color: Colors.white,
                            ),
                            child: Text(
                              ds2['nickname'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontFamily: 'NIX'),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 5,
                          right: 10,
                          child: Container(
                            //작성자프로필사진
                            width: MediaQuery.of(context).size.width / 5,
                            height: MediaQuery.of(context).size.height / 40,
//                          decoration: BoxDecoration(
//                            border: Border.all(width: 1),
//                            color: Colors.white,
//                          ),
                            child: Text(
                              TimeDuration(ds2['time'], DateTime.now()),
                              textAlign: TextAlign.center,
                              style: TextStyle(),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 30,
                          left: 70,
                          child: InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Text(
                                        ds2['context'],
                                        textAlign: TextAlign.center,
                                      ),
//                                      actions: <Widget>[
//                                        FlatButton(
//                                          child: Text('확인'),
//                                          onPressed: () {
//                                            Navigator.of(context).pop();
//                                          },
//                                          textColor: maincolor,
//                                          padding: EdgeInsets.only(right: 120),
//                                        )
//                                      ],
                                    );
                                  });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Container(
                                //텍스트
                                width: MediaQuery.of(context).size.width / 1.5,
                                height: MediaQuery.of(context).size.height / 20,
                                child: (textlength < 41)
                                    ? Text(
                                        ds2['context'],
                                        textAlign: TextAlign.start,
                                        style: TextStyle(),
                                      )
                                    : Text(
                                        ds2['context'].substring(1, 45) + '...',
                                        textAlign: TextAlign.start,
                                      ),
                              ),
                            ),
                          ),
                        ),
                        (currentId == ds2['id'] || currentId == 'admin')?Positioned(
                          right: 5,
                          bottom: 5,
                          child: InkWell(
                            onTap: (){
                              showDialog(context: context,
                                builder: (BuildContext context) => CupertinoActionSheet(
                                  cancelButton: CupertinoActionSheetAction(
                                    child: Text('취소'),
                                    onPressed: (){
                                      Navigator.pop(context);
                                    },
                                  ),
                                  actions: <Widget>[
                                    CupertinoActionSheetAction(
                                      child: Text('댓글 삭제', style: TextStyle(color: Colors.red),),
                                      onPressed: (){
                                        showDialog(context: context,
                                          builder: (BuildContext context)=> CupertinoAlertDialog(
                                            title: Text('정말 삭제하시겠습니까?'),
                                            content: Text('삭제시 되돌릴수없습니다.'),
                                            actions: <Widget>[
                                              CupertinoDialogAction(
                                                child: Text('취소'),
                                                onPressed: (){
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              CupertinoDialogAction(
                                                child: Text('삭제'),
                                                onPressed: (){
                                                  delete(ds2['commentID']);
                                                  Navigator.pop(context, true);
                                                },
                                              ),
                                            ],
                                          ),);
                                      },
                                    ),
                                  ],
                                ),);
                            },
                            child: Icon(
                              Icons.view_headline
                            ),
                          ),
                        ):Container(),
                      ],
                    ),
                  ),
                );
              });
        });
  }
}
