import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:socialapp/page/ProfileDetail.dart';
import 'package:socialapp/widgets/adHelper.dart';

class Spotlight extends StatefulWidget {
  final String currentId;
  final String title;
  int menu;
  Spotlight({Key key,@required this.currentId, @required this.title, @required this.menu}):super(key:key);

  @override
  _SpotlightState createState() => _SpotlightState(currentId: currentId, title: title, menu: menu);
}

class _SpotlightState extends State<Spotlight> {
  final String currentId;
  final String title;
  int menu;
  _SpotlightState({Key key, @required this.currentId,@required this.title, @required this.menu});

  int blockuser = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Ads.initialize();
    Ads.showBannerAd();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        Navigator.pop(context);
        return Future.value(false);
      },
      child: Scaffold(
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
            stream:(menu ==1)?Firestore.instance.collection('users').snapshots()
                : Firestore.instance.collection('users').orderBy('like', descending: true)
                .limit(20).snapshots(),
            builder: (context, snapshot) {
              if(!snapshot.hasData){
                return Container();
              }
              return GridView.builder(
                shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                  itemCount: snapshot.data.documents.length,
                  padding: EdgeInsets.all(2),
                  itemBuilder: (BuildContext context, int index){
                DocumentSnapshot ds = snapshot.data.documents[index];
                if(ds['block'] != null){
                  for(int i=0; i<ds['block'].length ; i++){
                    if(ds['block'][i] == currentId){
                      return Center(
                        child: Container(child: Text(
                          '알수없음',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).textScaleFactor*25,
                            fontFamily: 'NIX'
                          ),
                        ),),
                      );
                    }
                  }
                }
                return InkWell(
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ProfileDetail(
                                  usercurrentId: ds['id'],
                                  currentId: currentId,
                                )));
                  },
                  child: Container(
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
                  ),
                );
                  });
            }
          ),
        ),
      ),
    );
  }
}
