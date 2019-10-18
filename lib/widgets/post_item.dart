import 'package:flutter/material.dart';
import 'package:socialapp/base.dart';

class PostItem extends StatefulWidget{
  final String dp;
  final String name;
  final String time;
  final String img;
  final String address;

  PostItem({
    Key key,
    @required this.dp,
    @required this.name,
    @required this.time,
    @required this.img,
    @required this.address}) : super(key: key);
  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem>{
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical:8),
      child: InkWell(//버튼은 아니지만 버튼의 기능을 하게해줌
        child: Column(
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(
                  "${widget.dp}",
                ),
              ),
              contentPadding: EdgeInsets.all(0),
              title: Text(
                "${widget.name}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Text(
                "${widget.time}",
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 11,
                ),
              ),
            ),
            Container(
              child: Material(
                child: InkWell(
                  child: Image.asset(
                    "${widget.img}",
                    height: 170,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                  onTap: (){
                    openPage(context);
                  },
                ),
              ),
            ),
          ],
        ),
        onTap: (){},
      ),
    );
  }

}