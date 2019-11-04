import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:socialapp/main.dart';
import 'package:socialapp/model/data.dart';
import 'package:socialapp/page/home.dart';
import 'package:socialapp/page/NewsFeed.dart';
import 'package:socialapp/page/Channel.dart';
import 'package:socialapp/page/profilepage.dart';
import 'package:socialapp/page/chat.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:geolocator/geolocator.dart';


final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
final SnackBar snackBar = const SnackBar(content: Text('Showing Snackbar'));
int _bottomSelectedIndex = 0;

class Base extends StatefulWidget {
  final String currentUserId;

  Base({Key key, @required this.currentUserId}) : super(key: key);

  @override
  _Base createState() => _Base(currentUserId: currentUserId);
}

class _Base extends State<Base> {
  _Base({Key key, @required this.currentUserId});

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

  Future<bool> onBackPress() {
    openDialog();
    return Future.value(false);
  }

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

  AddLocation()async{
    _getLocation().then((position) async{
      print('위치저장 시작');
      await Firestore.instance.collection('users').document(currentUserId)
          .updateData({
        'longitude' : position.longitude,
        'latitude':position.latitude,
      });
      print('사용자 위치저장');
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

  Widget chatpage(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        child: Stack(
          children: <Widget>[
            Container(
              child: StreamBuilder(
                stream: Firestore.instance.collection('users').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      itemBuilder: (context, index) =>
                          buildItem(context, snapshot.data.documents[index]),
                      padding: EdgeInsets.all(10),
                      itemCount: snapshot.data.documents.length,
                    );
                  }
                },
              ),
            ),
            Positioned(
              child: isLoading
                  ? Container(
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                      ),
                      color: Colors.white.withOpacity(0.8),
                    )
                  : Container(),
            ),
          ],
        ),
        onWillPop: onBackPress,
      ),
    );
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document) {
    if (document['id'] == currentUserId) {
      return Container();
    } else {
      return Container(
        child: FlatButton(
          child: Row(
            children: <Widget>[
              Material(
                child: document['photoUrl'] != null
                    ? CachedNetworkImage(
                        placeholder: (context, url) => Container(
                          child: CircularProgressIndicator(
                            strokeWidth: 1,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.black87),
                          ),
                          width: 50,
                          height: 50,
                          padding: EdgeInsets.all(15),
                        ),
                        imageUrl: document['photoUrl'],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                    : Icon(
                        Icons.account_circle,
                        size: 50,
                        color: Colors.grey,
                      ),
                borderRadius: BorderRadius.all(Radius.circular(25)),
                clipBehavior: Clip.hardEdge,
              ),
              Flexible(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          'Nickname: ${document['nickname']}',
                          style: TextStyle(color: Colors.black87),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10, 0, 0, 5),
                      ),
                      Container(
                        child: Text(
                          'About Me: ${document['aboutMe'] ?? 'Not availabe'}',
                          style: TextStyle(color: Colors.blue),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      ),
                    ],
                  ),
                  margin: EdgeInsets.only(left: 20),
                ),
              ),
            ],
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Chat(
                          peerId: document.documentID,
                          peerAvatar: document['photoUrl'],
                        )));
          },
          color: Colors.grey,
          padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        margin: EdgeInsets.only(bottom: 10, left: 5, right: 5),
      );
    }
  }


  @override
  void initState() {
    super.initState();
    AddLocation();
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
        chatpage(context),
        ProfilePage(
          currentId: currentUserId,
        ),
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
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
//          Color.fromRGBO(255, 125, 128, 1)
        backgroundColor: Color.fromRGBO(255, 125, 128, 1),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            tooltip: 'next page?',
            onPressed: () {
              openPage(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            tooltip: '',
            onPressed: () {
              handleSignOut();
            },
          ),
        ],
      ),
      body: buildPageView(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _bottomSelectedIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.apps),
            title: Text('Channel'),
          ),
//          BottomNavigationBarItem(
//            icon: Icon(Icons.assignment_ind),
//            title:Text('Feed'),
//          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.turned_in),
            title: Text('Card'),
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
        selectedItemColor: Colors.amber[800],
        onTap: (index) {
          bottomTapped(index);
        },
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
