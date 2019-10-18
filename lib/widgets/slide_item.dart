import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:convert';

class SlideItem extends StatefulWidget {
  final String image0;
  final String name;
  final String location;
  final String age;
  int vote;

  SlideItem({
    Key key,
    @required this.image0,
    @required this.name,
    @required this.location,
    @required this.age,
    @required this.vote,
  }) : super(key: key);

  @override
  _SlideItemState createState() => _SlideItemState();
}

class _SlideItemState extends State<SlideItem> {
  Uint8List bigImageByte;

  @override
  Widget build(BuildContext context) {
    bigImageByte = Base64Decoder().convert(widget.image0);

    return Padding(
      padding: EdgeInsets.only(top: 5, bottom: 5),
      child: Container(
        height: MediaQuery.of(context).size.height / 2.9,
        width: MediaQuery.of(context).size.width / 1.2,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 4,
          child: Stack(
            children: <Widget>[
              Container(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    child: Image.memory(
                      bigImageByte,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 50,
                left: 10,
                child: Text(
                  '${widget.name}, ${widget.age}''세',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Positioned(
                bottom: 30,
                left: 10,
                child: Text(
                  '${widget.location}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
//              Positioned(
//                top: 6,
//                right: 6,
//                child: Card(
//                  shape: RoundedRectangleBorder(
//                      borderRadius: BorderRadius.circular(4)),
//                  child: Padding(
//                    padding: EdgeInsets.all(2),
//                    child: Row(
//                      children: <Widget>[
//                        Icon(
//                          Icons.star,
//                          color: Colors.yellow,
//                          size: 10,
//                        ),
//                        Text(
//                          "${widget.vote}",
//                          style: TextStyle(
//                            fontSize: 10,
//                          ),
//                        ),
//                      ],
//                    ),
//                  ),
//                ),
//              ),
//              Positioned(
//                top: 6.0,
//                left: 6.0,
//                child: Padding(
//                  padding: EdgeInsets.all(4),
//                  child: Text(
//                    "${widget.age}",
//                    style: TextStyle(
//                      fontSize: 10,
//                      color: Colors.green,
//                      fontWeight: FontWeight.bold,
//                    ),
//                  ),
//                ),
//              ),
            ],
          ),
        ),
      ),
    );
  }
}
