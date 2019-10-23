import 'package:socialapp/base.dart';
import 'package:flutter/material.dart';


class CardList extends StatefulWidget{
  CardList({Key key}) : super(key: key);

  @override
  CardListState createState() => CardListState();
}

class CardListState extends State<CardList>{
  @override

  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body:Stack(
        children: <Widget>[
          Container(
//            height: 350,
//            decoration: BoxDecoration(
//                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50.0), bottomRight: Radius.circular(50.0)),
//                gradient: LinearGradient(
//                  colors: [Colors.pink,Colors.green],
//                  begin: Alignment.topLeft,
//                  end:Alignment.bottomRight,
//                )
//            ),
          ),
          Container(
            margin:const EdgeInsets.only(left: 20.0, right: 20.0, top: 0),
            child: Center(
                child: Card(
                  color:Colors.transparent,
                  elevation: 8.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  child: Container(
                    width: screenSize.width / 1.2,
                    height: screenSize.height /1.7,
                    decoration: BoxDecoration(
                      color:Colors.white,
                      borderRadius: BorderRadius.circular(60.0),
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(//윗 사진부분
                          width: screenSize.width / 1.2,
                          height: screenSize.height / 2.2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60.0),
                            image: DecorationImage(
                              image: AssetImage(
                                  'images/b.jpg'),
                              fit  : BoxFit.fill,
                            ),
                          ),
                        ),
                        Container(//아래 글자부분
                            width: screenSize.width / 1.2,
                            height: screenSize.height / 1.7- screenSize.height/2.2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                FlatButton.icon(
                                  color:Colors.white12,
                                  icon:Icon(Icons.thumb_down),
                                  label:Text('Nope'),
                                  onPressed: (){
                                    openPage(context);},),
                                FlatButton.icon(
                                  color:Colors.white,
                                  icon:Icon(Icons.thumb_up),
                                  label:Text('Like'),
                                  onPressed: (){
                                    openPage(context);},),
                              ],
                            ))
                      ],
                    ),
                  ),
                )
            ),
          ),
        ],
      ),
    );
  }
}