import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Spotlight extends StatefulWidget {
  final String currentId;
  final String title;
  Spotlight({Key key,@required this.currentId, @required this.title}):super(key:key);

  @override
  _SpotlightState createState() => _SpotlightState(currentId: currentId, title: title);
}

class _SpotlightState extends State<Spotlight> {
  final String currentId;
  final String title;
  _SpotlightState({Key key, @required this.currentId,@required this.title});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          title,
          style:
          TextStyle(fontFamily: 'NIX', fontSize: 25, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white, //Color.fromRGBO(188, 206, 255, 1)
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            if(!snapshot.hasData){
              return Container();
            }
            return GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                itemCount: snapshot.data.documents.length,
                padding: EdgeInsets.all(2),
                itemBuilder: (BuildContext context, int index){
              DocumentSnapshot ds = snapshot.data.documents[index];
              return Container(
                width: MediaQuery.of(context).size.width / 1.1,
                height: MediaQuery.of(context).size.height / 10,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                      Radius.circular(0)),
                  child: (ds['image'] != null)
                      ? CachedNetworkImage(
                    imageUrl: ds['image'],
                    fit: BoxFit.cover,
                  )
                      : null,
                ),
              );
                });
          }
        ),
      ),
    );
  }
}
