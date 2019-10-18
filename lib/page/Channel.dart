import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:socialapp/model/data.dart';
import 'package:socialapp/widgets/slide_item.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin<Home> {

  var getTop;

  void initState(){
    super.initState();
    futureget();
  }

  futureget() async{
    getTop = await getTopuser();
    return getTop;
  }

  Uint8List smallImageByte;

  @override
  Widget build(BuildContext context) {
    futureget();
    super.build(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: ListView(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Row(
            //첫번째 위에 리스트 타이틀
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                //타이틀이름
                "화제의 인물",
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w500,
                ),
              ),
              FlatButton(
                //더보기
                child: Text(
                  "더보기",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w300,
                    color: Colors.pinkAccent
                  ),
                ),
                onPressed: () {
                  print(getTop[2]);
                  print(getTop.length);
                },
              ),
            ],
          ),
          SizedBox(height: 10),
          //위에 리스트의 끝

          //사진 리스트
          Container(
            height: MediaQuery.of(context).size.height/2.4,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
                primary: false,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: getTop == null? 0: getTop.length,
                itemBuilder: (BuildContext context, int index){
                  Map post = getTop[index];

                  return Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: SlideItem(
                      image0: post["image0"],
                      name: post["name"],
                      location: post["location"],
                      vote: post["vote"],
                      age: post["age"],
                    ),
                  );
                }
            ),
          ),
          SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "내 주변",
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w500,
                ),
              ),
              FlatButton(
                child: Text(
                  "더보기",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w300,
                    color: Colors.pinkAccent
                  ),
                ),
                onPressed: (){},
              ),
            ],
          ),
          SizedBox(height: 10),
          Container(
            height: MediaQuery.of(context).size.height/6,
            child: ListView.builder(
              primary: false,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: getTop == null? 0: getTop.length,
              itemBuilder: (BuildContext context, int index){
                Map post = getTop[index];
                smallImageByte = Base64Decoder().convert(post["image0"]);
                return Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.height/6,
                          width: MediaQuery.of(context).size.height/6,
                          child: Image.memory(
                            smallImageByte,
                            fit: BoxFit.cover,
                          ),
                        ),



//                        Center(
//                          child: Container(
//                            height: MediaQuery.of(context).size.height/6,
//                            width: MediaQuery.of(context).size.height/6,
//                            padding: EdgeInsets.all(1),
//                            constraints: BoxConstraints(
//                              minWidth: 20,
//                              minHeight: 20,
//                            ),
//                            child: Center(
//                              child: Text(
//                                post["name"],
//                                style: TextStyle(
//                                  color: Colors.white,
//                                  fontSize: 20,
//                                  fontWeight: FontWeight.bold,
//                                ),
//                                textAlign: TextAlign.center,
//                              ),
//                            ),
//                          ),
//                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20),
//          Row(
//            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//            children: <Widget>[
//              Text(
//                "Friends",
//                style: TextStyle(
//                  fontSize: 23,
//                  fontWeight: FontWeight.w800,
//                ),
//              ),
//
//              FlatButton(
//                child: Text(
//                  "See All",
//                  style: TextStyle(
//                    fontSize: 22,
//                    fontWeight:FontWeight.w300,
//                    color: Theme.of(context).accentColor,
//                  ),
//                ),
//                onPressed: (){},
//              ),
//            ],
//          ),
//          SizedBox(height: 10),
//          Container(
//            height: 50,
//            child: ListView.builder(
//              primary: false,
//              scrollDirection: Axis.horizontal,
//              shrinkWrap: true,
//              itemCount: posts == null? 0:posts.length,
//              itemBuilder: (BuildContext context, int index){
//                String img = posts[index];
//
//                return Padding(
//                  padding: EdgeInsets.only(right: 5),
//                  child: CircleAvatar(
//                    backgroundImage: AssetImage(
//                      img,
//                    ),
//                    radius: 25,
//                  ),
//                );
//              },
//            ),
//          ),
//          SizedBox(height: 30),

        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
