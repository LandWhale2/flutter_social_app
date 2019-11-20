import 'package:flutter/material.dart';

class Notice extends StatefulWidget {
  @override
  _NoticeState createState() => _NoticeState();
}

class _NoticeState extends State<Notice> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          '공지사항',
          style:
          TextStyle(fontFamily: 'NIX', fontSize: 25, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white, //Color.fromRGBO(188, 206, 255, 1)
      ),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(height: 20,),
              Container(
                width: MediaQuery.of(context).size.width /1.3,
                height: MediaQuery.of(context).size.height /20,
                decoration: BoxDecoration(
                  border: Border.all(width: 0.5),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text('베타 테스트중 입니다', style: TextStyle(
                        fontFamily: 'NIX',
                        fontWeight: FontWeight.w800,
                      ),),
                    ),
                    Icon(
                      Icons.arrow_forward_ios
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
