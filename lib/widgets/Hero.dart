//import 'package:cached_network_image/cached_network_image.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter/material.dart';
//import 'package:socialapp/base.dart';
//import 'package:socialapp/main.dart';
//import 'board.dart';
//import 'package:socialapp/widgets/Hero.dart';
//
//var maincolor = Color.fromRGBO(255, 125, 128, 1);
//
//class ContextPage extends StatefulWidget {
//  final String currentId;
//  final String contextId;
//
//  ContextPage({Key key, @required this.currentId, @required this.contextId})
//      : super(key: key);
//
//  @override
//  _ContextPageState createState() =>
//      _ContextPageState(currentId: currentId, contextId: contextId);
//}
//
//class _ContextPageState extends State<ContextPage> {
//  final String currentId;
//  final String contextId;
//  String _comment;
//  String reply;
//  final _formKey = GlobalKey<FormState>();
//  final replyKey = GlobalKey<FormState>();
//
//  _ContextPageState(
//      {Key key, @required this.currentId, @required this.contextId});
//
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
//              .collection('movie')
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
//            'space': '영화관',
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
//
//  PostComment() async {
//    var form = _formKey.currentState;
//    if (form.validate()) {
//      form.save();
//      try {
//        var documentName =
//            'C' + DateTime.now().millisecondsSinceEpoch.toString();
//        await Firestore.instance
//            .collection('users')
//            .where('id', isEqualTo: currentId)
//            .snapshots()
//            .listen((data) async {
//          await Firestore.instance
//              .collection('movie')
//              .document(contextId)
//              .collection('comment')
//              .document(documentName)
//              .setData({
//            'context': _comment,
//            'image': data.documents[0]['image'][0],
//            'time': DateTime.now().millisecondsSinceEpoch,
//            'space': '영화관',
//            'nickname': data.documents[0]['nickname'],
//            'id': data.documents[0]['id'],
//            'commentID': documentName,
//            'contextID': contextId,
//          });
//        });
//
//        setState(() {
//          form.reset();
//        });
//      } catch (e) {
//        print(e.message);
//      }
//    }
//  }
//
//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return StreamBuilder(
//        stream: Firestore.instance
//            .collection('movie')
//            .document(contextId)
//            .snapshots(),
//        builder: (context, snapshot) {
//          var ds1 = snapshot.data;
//          return Scaffold(
//            appBar: AppBar(
//              title: Text(
//                ds1['nickname'],
//                style: TextStyle(
//                    fontFamily: 'NIX', fontSize: 25, color: Colors.black),
//              ),
//              centerTitle: true,
//              backgroundColor: Colors.white, //Color.fromRGBO(188, 206, 255, 1)
//            ),
//            body: SingleChildScrollView(
//              child: Padding(
//                padding: const EdgeInsets.all(8.0),
//                child: Column(
//                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  children: <Widget>[
//                    Container(
//                      width: MediaQuery.of(context).size.width,
//                      height: MediaQuery.of(context).size.height / 12,
////                      decoration: BoxDecoration(
////                        border: Border.all(width: 1),
////                        color: Colors.white,
////                      ),
//                      child: Stack(
//                        children: <Widget>[
//                          Container(
//                            //작성자프로필사진
//                            width: MediaQuery.of(context).size.width / 6,
//                            height: MediaQuery.of(context).size.height / 12,
////                          decoration: BoxDecoration(
////                            border: Border.all(width: 1),
////                            color: Colors.white,
////                          ),
//                            child: ClipRRect(
//                              borderRadius:
//                              BorderRadius.all(Radius.circular(10)),
//                              child: (ds1['image'] != null)
//                                  ? CachedNetworkImage(
//                                imageUrl: ds1['image'],
//                                fit: BoxFit.cover,
//                              )
//                                  : null,
//                            ),
//                          ),
//                          Positioned(
//                            //작성자닉네임
//                            left: 70,
//                            top: 3,
//                            child: Container(
//                              width: MediaQuery.of(context).size.width / 4,
//                              height: MediaQuery.of(context).size.height / 30,
////                              decoration: BoxDecoration(
////                                border: Border.all(width: 1),
////                                color: Colors.white,
////                              ),
//                              child: Text(
//                                ds1['nickname'],
//                                textAlign: TextAlign.start,
//                                style: TextStyle(),
//                              ),
//                            ),
//                          ),
//                          Positioned(
//                            //작성시간
//                            left: 70,
//                            bottom: 5,
//                            child: Container(
//                              width: MediaQuery.of(context).size.width / 5,
//                              height: MediaQuery.of(context).size.height / 40,
////                              decoration: BoxDecoration(
////                                border: Border.all(width: 1),
////                                color: Colors.white,
////                              ),
//                              child: Text(
//                                TimeDuration(ds1['time'], DateTime.now()),
//                                style: TextStyle(color: Colors.black45),
//                              ),
//                            ),
//                          ),
//                          Positioned(
//                            //위치
//                            right: 5,
//                            top: 5,
//                            child: Container(
//                              width: MediaQuery.of(context).size.width / 6,
//                              height: MediaQuery.of(context).size.height / 40,
////                              decoration: BoxDecoration(
////                                border: Border.all(width: 1),
////                                color: Colors.white,
////                              ),
//                              child: Text(
//                                '33m',
//                                textAlign: TextAlign.center,
//                                style: TextStyle(color: Colors.black45),
//                              ),
//                            ),
//                          ),
//                        ],
//                      ),
//                    ),
//                    Padding(
//                      //프로필아래 선
//                      padding: const EdgeInsets.only(
//                        top: 10,
//                      ),
//                      child: Container(
//                        width: MediaQuery.of(context).size.width,
//                        height: 1,
//                        color: Colors.black54,
//                      ),
//                    ),
//                    SizedBox(
//                      height: 10,
//                    ),
//                    Text(
//                      //텍스트
//                      ds1['context'],
//                      maxLines: null,
//                      style: TextStyle(fontFamily: 'NIX'),
//                    ),
////              CachedNetworkImage(
////                imageUrl: ,
////              )
//                    Padding(
//                      //좋아요 ,댓글
//                      padding: const EdgeInsets.only(top: 70, bottom: 10),
//                      child: Row(
//                        children: <Widget>[
//                          Container(
//                            //좋아요수
//                            width: MediaQuery.of(context).size.width / 8,
//                            height: MediaQuery.of(context).size.height / 40,
//                            decoration: BoxDecoration(
//                              color: Colors.white,
//                              //Color.fromRGBO(123, 198, 250, 1)
//                              border: Border.all(width: 0.5),
//                            ),
//                            child: Row(
//                              children: <Widget>[
//                                Icon(
//                                  Icons.favorite,
//                                  color: Colors.black54,
//                                  size: 20,
//                                ),
//                                SizedBox(
//                                  width: 5,
//                                ),
//                                Text(
//                                  '5',
//                                  style: TextStyle(
//                                    color: Colors.black54,
//                                  ),
//                                )
//                              ],
//                            ),
//                          ),
//                          SizedBox(
//                            width: 5,
//                          ),
//                          Container(
//                            //코멘트 수
//                            width: MediaQuery.of(context).size.width / 8,
//                            height: MediaQuery.of(context).size.height / 40,
//                            decoration: BoxDecoration(
//                              color: Colors.white,
//                              //Color.fromRGBO(123, 198, 250, 1)
//                              border: Border.all(width: 0.5),
//                            ),
//                            child: Row(
//                              children: <Widget>[
//                                Icon(
//                                  Icons.comment,
//                                  color: Colors.black54,
//                                  size: 20,
//                                ),
//                                SizedBox(
//                                  width: 5,
//                                ),
//                                Text(
//                                  '5',
//                                  style: TextStyle(
//                                    color: Colors.black54,
//                                  ),
//                                )
//                              ],
//                            ),
//                          ),
//                        ],
//                      ),
//                    ),
//                    Padding(
//                      //댓글창위에 선
//                      padding:
//                      const EdgeInsets.only(top: 0, left: 10, bottom: 10),
//                      child: Container(
//                        width: MediaQuery.of(context).size.width / 1.1,
//                        height: 1,
//                        color: Colors.black87,
//                      ),
//                    ),
//                    Center(
//                      //댓글창전체 컨테이너
//                      child: Padding(
//                        padding: const EdgeInsets.all(8.0),
//                        child: Container(
//                          width: MediaQuery.of(context).size.width / 1.2,
//
////                              decoration: BoxDecoration(
////                                border: Border.all(width: 1),
////                                color: Colors.white,
////                              ),
//                          child: Row(
//                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                            children: <Widget>[
//                              Form(
//                                key: _formKey,
//                                child: Container(
//                                  //댓글입력창
//                                  width:
//                                  MediaQuery.of(context).size.width / 1.45,
//
//                                  decoration: BoxDecoration(
//                                    borderRadius:
//                                    BorderRadius.all(Radius.circular(10)),
//                                    border: Border.all(width: 0.8),
//                                    color: Colors.white,
//                                  ),
//                                  child: Column(
//                                    children: <Widget>[
//                                      Padding(
//                                        padding: const EdgeInsets.only(left: 3),
//                                        child: TextFormField(
//                                          maxLength: 500,
//                                          maxLines: null,
//                                          decoration: InputDecoration(
//                                            hintStyle: TextStyle(
//                                              fontSize: 15,
//                                            ),
//                                            hintText: '내용을 입력해주세요.',
//                                            border: InputBorder.none,
//                                          ),
//                                          validator: (input) {
//                                            if (input.isEmpty) {
//                                              return '내용을입력해주세요';
//                                            }
//                                          },
//                                          onSaved: (value) => _comment = value,
//                                        ),
//                                      ),
//                                    ],
//                                  ),
//                                ),
//                              ),
//                              InkWell(
//                                onTap: PostComment,
//                                child: Padding(
//                                  padding: const EdgeInsets.only(
//                                      bottom: 40, right: 2),
//                                  child: Container(
//                                    //전송
//                                    width: MediaQuery.of(context).size.width /
//                                        7.33,
//                                    height:
//                                    MediaQuery.of(context).size.height / 30,
//                                    decoration: BoxDecoration(
//                                      borderRadius:
//                                      BorderRadius.all(Radius.circular(10)),
////                                        border: Border.all(width: 0.3),
//                                      color: Color.fromRGBO(255, 125, 128, 1),
//                                    ),
//                                    child: Text(
//                                      '전송',
//                                      textAlign: TextAlign.center,
//                                      style: TextStyle(
//                                          fontSize: 20, color: Colors.white),
//                                    ),
//                                  ),
//                                ),
//                              ),
//                            ],
//                          ),
//                        ),
//                      ),
//                    ),
//                    Padding(
//                      //댓글창아래에 선
//                      padding: const EdgeInsets.only(top: 10, left: 10),
//                      child: Container(
//                        width: MediaQuery.of(context).size.width / 1.1,
//                        height: 1,
//                        color: Colors.black54,
//                      ),
//                    ),
//                    CommentBox(context),
//                  ],
//                ),
//              ),
//            ),
//          );
//        });
//  }
//
//  Widget CommentBox(BuildContext context) {
//    return StreamBuilder<QuerySnapshot>(
//        stream: Firestore.instance
//            .collection('movie')
//            .document(contextId)
//            .collection('comment')
//            .orderBy('time', descending: true)
//            .snapshots(),
//        builder: (context, snapshot) {
//          if (!snapshot.hasData) {
//            return Text('끝');
//          }
//          return ListView.builder(
//              padding: EdgeInsets.only(top: 10),
//              shrinkWrap: true,
//              itemCount: snapshot.data.documents.length,
//              itemBuilder: (BuildContext context, int index) {
//                DocumentSnapshot ds2 = snapshot.data.documents[index];
//                var textlength = ds2['context'].length;
//                return Padding(
//                  padding: const EdgeInsets.only(top: 10),
//                  child: Container(
//                    width: MediaQuery.of(context).size.width / 1.38,
//                    height: MediaQuery.of(context).size.height / 10,
//                    decoration: BoxDecoration(
//                        color: Colors.white,
//                        boxShadow: <BoxShadow>[
//                          BoxShadow(
//                            color: Colors.black38,
//                            offset: Offset(3.0, 3.0),
//                            blurRadius: 1,
//                          ),
//                        ],
//                        borderRadius: BorderRadius.all(Radius.circular(10))),
//                    child: Stack(
//                      children: <Widget>[
//                        Positioned(
//                          top: 5,
//                          left: 5,
//                          child: Container(
//                            //작성자프로필사진
//                            width: MediaQuery.of(context).size.width / 6,
//                            height: MediaQuery.of(context).size.height / 12,
////                          decoration: BoxDecoration(
////                            border: Border.all(width: 1),
////                            color: Colors.white,
////                          ),
//                            child: ClipRRect(
//                              borderRadius:
//                              BorderRadius.all(Radius.circular(10)),
//                              child: (ds2['image'] != null)
//                                  ? CachedNetworkImage(
//                                imageUrl: ds2['image'],
//                                fit: BoxFit.cover,
//                              )
//                                  : null,
//                            ),
//                          ),
//                        ),
//                        Positioned(
//                          top: 5,
//                          left: 70,
//                          child: Container(
//                            //닉네임
//                            width: MediaQuery.of(context).size.width / 6,
//                            height: MediaQuery.of(context).size.height / 40,
//                            decoration: BoxDecoration(
//                              border: Border(
//                                  bottom: BorderSide(
//                                    width: 1,
//                                    color: Color.fromRGBO(255, 125, 128, 1),
//                                  )),
//                              color: Colors.white,
//                            ),
//                            child: Text(
//                              ds2['nickname'],
//                              textAlign: TextAlign.center,
//                              style: TextStyle(),
//                            ),
//                          ),
//                        ),
//                        Positioned(
//                          top: 5,
//                          right: 10,
//                          child: Container(
//                            //작성자프로필사진
//                            width: MediaQuery.of(context).size.width / 5,
//                            height: MediaQuery.of(context).size.height / 40,
////                          decoration: BoxDecoration(
////                            border: Border.all(width: 1),
////                            color: Colors.white,
////                          ),
//                            child: Text(
//                              TimeDuration(ds2['time'], DateTime.now()),
//                              textAlign: TextAlign.center,
//                              style: TextStyle(),
//                            ),
//                          ),
//                        ),
//                        Positioned(
//                          top: 30,
//                          left: 70,
//                          child: InkWell(
//                            onTap: () {
//                              showDialog(
//                                  context: context,
//                                  builder: (BuildContext context) {
//                                    return AlertDialog(
//                                      content: Text(
//                                        ds2['context'],
//                                        textAlign: TextAlign.center,
//                                      ),
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
//                                    );
//                                  });
//                            },
//                            child: Container(
//                              //텍스트
//                              width: MediaQuery.of(context).size.width / 1.5,
//                              height: MediaQuery.of(context).size.height / 22,
////                          decoration: BoxDecoration(
////                            border: Border.all(width: 1),
////                            color: Colors.white,
////                          ),
//                              child: (textlength < 41)
//                                  ? Text(
//                                ds2['context'],
//                                textAlign: TextAlign.start,
//                                style: TextStyle(),
//                              )
//                                  : Text(
//                                ds2['context'].substring(1, 38) + '...',
//                                textAlign: TextAlign.start,
//                              ),
//                            ),
//                          ),
//                        ),
////                        Positioned(
////                          right: 5,
////                          bottom: 15,
////                          child: InkWell(
////                            onTap: () {
////                              showDialog(
////                                  context: context,
////                                  builder: (BuildContext context) {
////                                    return AlertDialog(
////                                      content: Form(
////                                        key: replyKey,
////                                        child: TextFormField(
////                                          maxLength: 500,
////                                          maxLines: null,
////                                          decoration: InputDecoration(
////                                            hintStyle: TextStyle(
////                                              fontSize: 15,
////                                            ),
////                                            hintText: '내용을 입력해주세요.',
////                                            border: InputBorder.none,
////                                          ),
////                                          validator: (input) {
////                                            if (input.isEmpty) {
////                                              return '내용을입력해주세요';
////                                            }
////                                          },
////                                          onSaved: (value) => reply = value,
////                                        ),
////                                      ),
////                                      actions: <Widget>[
////                                        FlatButton(
////                                          child: Text('확인'),
////                                          onPressed: () {
////                                            PostReply(ds2['commentID']);
////                                            Navigator.of(context).pop();
////                                          },
////                                          textColor: maincolor,
////                                          padding: EdgeInsets.only(right: 120),
////                                        )
////                                      ],
////                                    );
////                                  });
////                            },
////                            child: Container(
////                              //작성자프로필사진
////                              width: MediaQuery.of(context).size.width / 12,
////                              height: MediaQuery.of(context).size.height / 22,
////                              color: Color.fromRGBO(255, 125, 128, 1),
//////                          decoration: BoxDecoration(
//////                            border: Border.all(width: 1),
//////                            color: Color.fromRGBO(255, 125, 128, 1),
//////                          ),
////                              child: Icon(
////                                Icons.add,
////                                color: Colors.white,
////                              ),
////                            ),
////                          ),
////                        ),
//                        Positioned(
//                          top: 2,
//                          left: 170,
//                          child: InkWell(
//                            child: Container(
//                              //답글
//                              width: MediaQuery.of(context).size.width / 6,
//                              height: MediaQuery.of(context).size.height / 40,
//                              decoration: BoxDecoration(
//                                borderRadius:
//                                BorderRadius.all(Radius.circular(10)),
//                                color: maincolor,
//                              ),
//                              child: Center(
//                                child: Text(
//                                  '답글',
//                                  style: TextStyle(color: Colors.white),
//                                ),
//                              ),
//                            ),
//                          ),
//                        ),
//                      ],
//                    ),
//                  ),
//                );
//              });
//        });
//  }
//}
