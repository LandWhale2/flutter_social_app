import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class SlideItem extends StatefulWidget {
  String image;
  final String nickname;
  final int age;
  String intro;

  SlideItem({
    Key key,
    @required this.image,
    @required this.nickname,
    @required this.age,
    @required this.intro,
  }) : super(key: key);

  @override
  _SlideItemState createState() => _SlideItemState();
}

class _SlideItemState extends State<SlideItem> {
//  Uint8List bigImageByte;


  @override
  Widget build(BuildContext context) {
//    bigImageByte = Base64Decoder().convert(widget.image0);
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
                  child: (widget.image != null)?ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    child: CachedNetworkImage(
                      imageUrl: widget.image,
                      fit: BoxFit.cover,
                    )
                  ):Center(child: Icon(Icons.person),),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 10,
                child: Text(
                  (widget.nickname != null)?'${widget.nickname}, ${widget.age}''세':'',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
//              Positioned(
//                bottom: 20,
//                left: 10,
//                child: Text(
//                  '${widget.intro}',
//                  style: TextStyle(
//                    color: Colors.white,
//                    fontSize: 25,
//                    fontWeight: FontWeight.w500,
//                  ),
//                ),
//              ),
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
