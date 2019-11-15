import 'package:flutter/material.dart';
import 'package:socialapp/page/blockuser.dart';

class SettingPage extends StatefulWidget {
  final String currentId;
  SettingPage({Key key, @required this.currentId}): super(key:key);

  @override
  _SettingPageState createState() => _SettingPageState(currentId: currentId);
}

class _SettingPageState extends State<SettingPage> {
  final String currentId;

  _SettingPageState({Key key, @required this.currentId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          '환경설정',
          style: TextStyle(
              fontFamily: 'NIX', fontSize: 25, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white, //Color.fromRGBO(188, 206, 255, 1)
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 20,),
          Row(
            children: <Widget>[
              SizedBox(width: 10,),
              Container(
                child: Text(
                  '계정',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).textScaleFactor*25,
                    fontFamily: 'NIX',
                    fontWeight: FontWeight.w300,
                    color: Colors.blue
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20,),
          Row(//계정정보
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(Icons.account_circle),
                  SizedBox(width: 10,),
                  Container(
                    child: Text(
                      '계정정보',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).textScaleFactor*20,
                        fontFamily: 'NIX',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ],
              ),

              Icon(Icons.arrow_forward_ios),
            ],
          ),
          SizedBox(height: 20,),
          InkWell(
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BlockUser(
                        currentId: currentId,
                      )));
            },
            child: Row(//차단유저
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(Icons.block),
                    SizedBox(width: 10,),
                    Container(
                      child: Text(
                        '차단유저',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).textScaleFactor*20,
                          fontFamily: 'NIX',
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ],
                ),

                Icon(Icons.arrow_forward_ios),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
