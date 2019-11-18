import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  final String currentId;

  NotificationPage({Key key, @required this.currentId}):super(key:key);

  @override
  _NotificationPageState createState() => _NotificationPageState(currentId: currentId);
}

class _NotificationPageState extends State<NotificationPage> {
  final String currentId;
  _NotificationPageState({Key key, @required this.currentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            SizedBox(height: 50,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '알림',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: MediaQuery.of(context).textScaleFactor*25
                  ),
                ),
                InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.notifications,
                    size: 40,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
            Container(
              width: MediaQuery.of(context).size.width / 1.1,
              height: MediaQuery.of(context).size.height / 10,
              decoration: BoxDecoration(
                border: Border.all(width: 1)
              ),
              child: Row(
                children: <Widget>[

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
