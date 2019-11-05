import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialapp/page/contextpage.dart';
import 'package:socialapp/widgets/Bloc.dart';

class ProfileDetail extends StatefulWidget {
  final String currentId;

  ProfileDetail({Key key, @required this.currentId}) : super(key: key);

  @override
  _ProfileDetailState createState() =>
      _ProfileDetailState(currentId: currentId);
}

class _ProfileDetailState extends State<ProfileDetail> {
  final String currentId;

  _ProfileDetailState({Key key, @required this.currentId});

  LikeControll(bool state, String userId) async {
    if (state == false) {
      return await Firestore.instance
          .collection('users')
          .document(userId)
          .updateData({
        'like': FieldValue.increment(1),
      });
    } else {
      return await Firestore.instance
          .collection('users')
          .document(userId)
          .updateData({
        'like': FieldValue.increment(-1),
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
            .document(currentId)
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
            body: Container(
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
                            Container(
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
                            SizedBox(
                              width: 20,
                            ),
                            InkWell(
                              onTap: () {
                                if (mounted) {
                                  if (profileLikeState.LikeState == false) {
                                    LikeControll(
                                        profileLikeState.LikeState, ds['id']);
                                    if (mounted) {
                                      profileLikeState.on();
                                    }
                                  } else {
                                    LikeControll(
                                        profileLikeState.LikeState, ds['id']);
                                    if (mounted) {
                                      profileLikeState.off();
                                    }
                                  }
                                }
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width / 4.5,
                                height: MediaQuery.of(context).size.height / 25,
                                decoration: BoxDecoration(
                                    border: Border.all(width: 0.1),
                                    color: (profileLikeState.LikeState == false)
                                        ? Colors.black45
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
            ),
          );
        });
  }
}
