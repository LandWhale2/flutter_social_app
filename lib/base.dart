import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:socialapp/main.dart';
import 'package:socialapp/model/data.dart';
import 'package:socialapp/page/ProfileDetail.dart';
import 'package:socialapp/page/chatpage.dart';
import 'package:socialapp/page/contextpage.dart';
import 'package:socialapp/page/home.dart';
import 'package:socialapp/page/NewsFeed.dart';
import 'package:socialapp/page/Channel.dart';
import 'package:socialapp/page/profilepage.dart';
import 'package:socialapp/page/chat.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:geolocator/geolocator.dart';
import 'package:socialapp/widgets/Bloc.dart';
import 'package:socialapp/widgets/adHelper.dart';





class Base extends StatefulWidget {
  final String currentUserId;

  Base({Key key, @required this.currentUserId}) : super(key: key);

  @override
  _Base createState() => _Base(currentUserId: currentUserId);
}

class _Base extends State<Base> {
  _Base({Key key, @required this.currentUserId});
  int _bottomSelectedIndex = 0;
  final SnackBar snackBar = const SnackBar(content: Text('Showing Snackbar'));
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(debugLabel: 'scaffoldKey');

  Geolocator geolocator = Geolocator();

  Position userLocation;

  final String currentUserId;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final GoogleSignIn googleSignIn = GoogleSignIn();

  bool isLoading = false;

  List<Choice> choices = const <Choice>[
    const Choice(title: 'Setting', icon: Icons.settings),
    const Choice(title: 'Log out', icon: Icons.exit_to_app),
  ];

//  void registerNotification(){
//    firebaseMessaging.requestNotificationPermissions();
//
//    firebaseMessaging.configure(onMessage: (Map<String, dynamic> message){
//      print('onMessage : $message');
//      showNotification(message['notification']);
//      return;
//    },onResume: (Map<String, dynamic> message){
//      print('onResume: $message');
//    },onLaunch: (Map<String, dynamic> message){
//      print('onLaunch: $message');
//    });
//
//    firebaseMessaging.getToken().then((token) {
//      print('token : $token');
//      Firestore.instance.collection('users').document(currentUserId).updateData({'pushToken':token});
//    }).catchError((err) {
//      Fluttertoast.showToast(msg: err.message.toString());
//    });
//  }

//  void configLocalNotification(){
//    var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
//    var initializationSettingsIOS = IOSInitializationSettings();
//    var initializationSettings = InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
//    flutterLocalNotificationsPlugin.initialize(initializationSettings);
//  }

  void onItemMenuPress(Choice choice) {
    if (choice.title == 'Log out') {
      handleSignOut();
    } else {
//      Navigator.push(context, MaterialPageRoute(builder: (context) => Settings()));
    }
  }

//  void showNotification(message) async{
//    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//      Platform.isAndroid ? 'com.dfa.socialapp' : 'com.duytq.socialapp',
//      'Flutter chat',
//      'your channel des',
//      playSound: true,
//      enableVibration: true,
//      importance: Importance.Max,
//      priority: Priority.High,
//    );
//    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
//    var platformChannelSpecifics =
//        NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
//    await flutterLocalNotificationsPlugin.show(0, message['title'].toString(),
//        message['body'].toString(), platformChannelSpecifics, payload: json.encode(message));
//  }

//  Future<bool> onBackPress() {
//    openDialog();
//    return Future.value(false);
//  }

  Future<Position> _getLocation() async {
    var currentLocation;
    try {
      currentLocation = await geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }

  Future<Null> openDialog() async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            contentPadding:
                EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0, bottom: 0.0),
            children: <Widget>[
              Container(
                color: Colors.pinkAccent,
                margin: EdgeInsets.all(0.0),
                padding: EdgeInsets.only(bottom: 10.0, top: 10.0),
                height: 100.0,
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.exit_to_app,
                        size: 30.0,
                        color: Colors.white,
                      ),
                      margin: EdgeInsets.only(bottom: 10.0),
                    ),
                    Text(
                      'Exit app',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Are you sure to exit app?',
                      style: TextStyle(color: Colors.white70, fontSize: 14.0),
                    ),
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 0);
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.cancel,
                        color: Colors.pinkAccent,
                      ),
                      margin: EdgeInsets.only(right: 10.0),
                    ),
                    Text(
                      'CANCEL',
                      style: TextStyle(
                          color: Colors.pinkAccent,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 1);
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.pinkAccent,
                      ),
                      margin: EdgeInsets.only(right: 10.0),
                    ),
                    Text(
                      'YES',
                      style: TextStyle(
                          color: Colors.pinkAccent,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ],
          );
        })) {
      case 0:
        break;
      case 1:
        exit(0);
        break;
    }
  }

  AddLocation() async {
    _getLocation().then((position) {
      Firestore.instance
          .collection('users')
          .document(currentUserId)
          .updateData({
        'longitude': position.longitude,
        'latitude': position.latitude,
      });
    });
  }

  Future<Null> handleSignOut() async {
    this.setState(() {
      isLoading = true;
    });

    await FirebaseAuth.instance.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();

    this.setState(() {
      isLoading = false;
    });

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MyApp()),
        (Route<dynamic> route) => false);
  }





  BannerAd myBanner;
  static bool isShown = false;
  static bool _isGoingToBeShown = false;


  @override
  void initState() {
    super.initState();
  }





  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void pageChanged(int index) {
    setState(() {
      _bottomSelectedIndex = index;
    });
  }

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  Widget buildPageView() {
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: <Widget>[
        Home(
          currentId: currentUserId,
        ),
//        NewsFeed(),
        Mainhome(currentId: currentUserId),
        Chatpage(currentId: currentUserId,),
        ProfileDetail(currentId: currentUserId, usercurrentId: currentUserId, check: 1,),
      ],
    );
  }

  void bottomTapped(int index) {
    setState(() {
      _bottomSelectedIndex = index;
      pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        body: buildPageView(),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _bottomSelectedIndex,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.apps),
              title: Text('Channel'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.send),
              title: Text('Chat'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              title: Text('Profile'),
            ),
          ],
          selectedItemColor: maincolor,
          onTap: (index) {
            bottomTapped(index);
          },
        ),
      ),
    );
  }
}

//오픈페이지?
void openPage(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(
    builder: (BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(252, 165, 3, 1),
          title: const Text('Shop'),
        ),
        body: const Center(
          child: Text(
            'This is next page',
            style: TextStyle(fontSize: 24),
          ),
        ),
      );
    },
  ));
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

