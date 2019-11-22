import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/base.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:socialapp/main.dart';
import 'package:socialapp/model/todo.dart';
import 'package:socialapp/page/ProfileEdit.dart';
import 'package:socialapp/page/contextpage.dart';
import 'package:socialapp/page/signup.dart';
import 'package:socialapp/page/userwrite.dart';
import 'package:socialapp/page/writeprofile2.dart';
import 'package:socialapp/widgets/adHelper.dart';
import 'package:socialapp/widgets/database_create.dart';

import 'writeprofile.dart';

FirebaseUser firebaseauth;

DecorationImage tick = DecorationImage(
  image: ExactAssetImage('assets/tick.png'),
  fit: BoxFit.cover,
);

DecorationImage backgroundImage = DecorationImage(
  image: ExactAssetImage('assets/lake.jpg'),
  fit: BoxFit.cover,
);

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  bool isLoading = false;
  bool isLoggedIn = false;


  FirebaseUser currentUser;



  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    isSignedIn();
    Ads.initialize();
    Ads.hideBannerAd();

  }

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>(debugLabel: 'LoginScreenState');
  String _email, _password;
  var tmpemail, tmppassword;

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  SharedPreferences prefs;




  void isSignedIn() async {
    this.setState(() {
      isLoading = true;
    });


    isLoggedIn = await googleSignIn.isSignedIn();
    prefs = await SharedPreferences.getInstance();

    if (isLoggedIn) {
      Firestore.instance.collection('users').document(prefs.getString('id')).snapshots().listen((data){
        if(data['nickname'] != null){
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      Base(currentUserId: prefs.getString('id'))));
        }else{
          print('로그인되어있지않은유저');
        }
      });

    }

    this.setState(() {
      isLoading = false;
    });
  }

  Future<Null> handleSignIn() async {
    prefs = await SharedPreferences.getInstance();

    this.setState(() {
      isLoading = true;
    });

    //로그인은 되어있는데 프로필을 작성하지않은 신규유저를 위한처리
    if(FirebaseAuth.instance.currentUser() != null){
      print('sssss');
      FirebaseUser user = await FirebaseAuth.instance.currentUser();

      final snapshot = await Firestore.instance.collection('users').document(user.uid).get();

      if(snapshot.exists == false){
        Firestore.instance
            .collection('users')
            .document(user.uid)
            .setData({
          'nickname': null,
          'id': user.uid,
          'createAt': DateTime.now().millisecondsSinceEpoch.toString(),
          'chattingWith': null,
          'image': null,
          'age': null,
          'like': 0,
          'likeperson': null,
          'block': null,
          'visit': 0,
          'email': null,
        });

        return Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ProfileEdit(currentId: user.uid)));
      }else{
        return Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ProfileEdit(currentId: user.uid)));
      }


    }

    print('asd');

    //프로필을 따로 작성하지않은유저
    if(prefs.getString('id') != null){
      Firestore.instance.collection('users').document(prefs.getString('id')).snapshots().listen((data){
        if(data['nickname'] == null){
          return Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ProfileEdit(currentId: prefs.getString('id'))));
        }else{
          return null;
        }
      });
    }
    print('222');

    GoogleSignInAccount googleUser = await googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken, accessToken: googleAuth.idToken);

    FirebaseUser firebaseUser =
        (await firebaseAuth.signInWithCredential(credential)).user;

    print('dddd');

    if (firebaseUser != null) {
      //check already signup
      print('onononon');



      Firestore.instance.collection('users').document(firebaseUser.uid).snapshots().listen((data){
        if(data['nickname'] == null){
          return Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ProfileEdit(currentId: firebaseUser.uid)));
        }else{
          return null;
        }
      });

      final QuerySnapshot result = await Firestore.instance
          .collection('users')
          .where('id', isEqualTo: firebaseUser.uid)
          .getDocuments();
      final List<DocumentSnapshot> documents = result.documents;
      print('gogogogo');




      if (documents.length == 0) {
        print('nonononoo');
        //Update data new user
        currentUser = firebaseUser;
        await prefs.setString('id', currentUser.uid);
        await prefs.setString('nickname', currentUser.displayName);
        await prefs.setString('photoUrl', currentUser.photoUrl);

        Firestore.instance
            .collection('users')
            .document(firebaseUser.uid)
            .setData({
          'nickname': null,
          'id': firebaseUser.uid,
          'createAt': DateTime.now().millisecondsSinceEpoch.toString(),
          'chattingWith': null,
          'image': null,
          'age': null,
          'like': 0,
          'likeperson': null,
          'block': null,
          'visit': 0,
          'email': (currentUser.displayName == null)?null:currentUser.displayName,
        });


        //write data local


        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ProfileEdit(currentId: firebaseUser.uid)));
        return null;
      } else {
        //기존유저

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Base(currentUserId: firebaseUser.uid)));

        await prefs.setString('id', documents[0]['id']);
        await prefs.setString('nickname', documents[0]['nickname']);
        await prefs.setString('photoUrl', documents[0]['photoUrl']);
        await prefs.setString('aboutMe', documents[0]['aboutMe']);
      }



    } else {
      Fluttertoast.showToast(msg: "sign in fail");
      this.setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
//          image: backgroundImage,
        color: Colors.grey
        ),
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: <Color>[
//              const Color.fromRGBO(162, 146, 199, 0.8),
//              const Color.fromRGBO(51, 51, 63, 0.9),
            maincolor,
              Colors.blue,
            ],
            stops: [0.2, 1.0],
            begin: const FractionalOffset(0, 0),
            end: const FractionalOffset(0, 1),
          )),
          child: ListView(
            padding: EdgeInsets.all(0),
            children: <Widget>[
              Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
//                      Tick(image: tick),
                    SizedBox(height: MediaQuery.of(context).size.height/6,),
                      Container(
                        child: Text(
                          '데이트메이트',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).textScaleFactor*40,
                            fontFamily: 'NIX',
                            fontWeight: FontWeight.w900,
                            color: Colors.white
                          ),
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height/10,),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Form(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Form(
                                          key: _formkey,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              Container(
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    bottom: BorderSide(
                                                      width: 0.5,
                                                      color: Colors.white24,
                                                    ),
                                                  ),
                                                ),
                                                child: TextFormField(
                                                  validator: (input) {
                                                    if (input.isEmpty) {
                                                      return '이메일을 입력해주세요';
                                                    }
                                                  },
                                                  onSaved: (input) =>
                                                      _email = input,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  obscureText: false,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                  decoration: InputDecoration(
                                                    icon: Icon(
                                                      Icons.person_outline,
                                                      color: Colors.white,
                                                    ),
                                                    border: InputBorder.none,
                                                    hintText: 'Email',
                                                    hintStyle: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15),
                                                    contentPadding:
                                                        const EdgeInsets.only(
                                                            top: 30,
                                                            right: 30,
                                                            bottom: 30,
                                                            left: 5),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    bottom: BorderSide(
                                                      width: 0.5,
                                                      color: Colors.white24,
                                                    ),
                                                  ),
                                                ),
                                                child: TextFormField(
                                                  validator: (input) {
                                                    if (input.isEmpty) {
                                                      return '패스워드를 입력해주세요';
                                                    }
                                                  },
                                                  onSaved: (input) =>
                                                      _password = input,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  obscureText: true,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                  decoration: InputDecoration(
                                                    icon: Icon(
                                                      Icons.lock,
                                                      color: Colors.white,
                                                    ),
                                                    border: InputBorder.none,
                                                    hintText: 'Password',
                                                    hintStyle: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15),
                                                    contentPadding:
                                                        const EdgeInsets.only(
                                                            top: 30,
                                                            right: 30,
                                                            bottom: 30,
                                                            left: 5),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SignUp(),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 50),
                    child: InkWell(
                      onTap: _SignDB,
                      child: Container(
                        width: 330,
                        height: 60,
                        alignment: FractionalOffset.center,
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius:
                              BorderRadius.all(const Radius.circular(30)),
                        ),
                        child: Text(
                          "Sign In",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 100),
                child: InkWell(
                  onTap: handleSignIn,
                  child: Container(
                    width: 200,
                    height: 30,
                    alignment: FractionalOffset.center,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.pinkAccent, Colors.lightBlueAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.all(const Radius.circular(30)),
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(FontAwesomeIcons.google, color: Colors.black12),
                        Text(
                          "Sign in with Google",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w100,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

//  Future<void> _SignIn() async {
//    final formState = _formkey.currentState;
//    if (formState.validate()) {
//      formState.save();
//      try {
//        AuthResult _user = await FirebaseAuth.instance
//            .signInWithEmailAndPassword(email: _email, password: _password);
//        Navigator.push(
//            context, MaterialPageRoute(builder: (context) => Base(currentUserId: currentUser,)));
//      } catch (e) {
//        print(e.message);
//      }
//    }
//  }

  _SignDB() async {
    final formState = _formkey.currentState;
    if (formState.validate()) {

      formState.save();
      try {
        await Firestore.instance
            .collection('users')
            .where('email', isEqualTo: _email)
            .where('password', isEqualTo: _password)
            .snapshots()
            .listen((data) async {
          try {
            tmpemail = await data.documents[0]['email'];
            tmppassword = await data.documents[0]['password'];
            if (tmpemail == Null) {
              Flushbar(
                margin: EdgeInsets.all(8),
                message: "아이디 또는 비밀번호가 일치하지않습니다",
                icon: Icon(
                  Icons.tablet_android,
                  size: 28,
                  color: Colors.blue[300],
                ),
                duration: Duration(seconds: 3),
                leftBarIndicatorColor: Colors.blue[300],
              )..show(context);
            } else {
              print('Id 일치');
            }

            if (_email == tmpemail) {
              if (_password == tmppassword) {
                await Firestore.instance
                    .collection('users')
                    .where('email', isEqualTo: _email)
                    .snapshots()
                    .listen((data) async {
                  var currentId = data.documents[0]['id'];
                  print(currentId);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Base(
                                currentUserId: currentId,
                              )));
                });
              } else {
                Flushbar(
                  margin: EdgeInsets.all(8),
                  message: "아이디 또는 비밀번호가 일치하지않습니다",
                  icon: Icon(
                    Icons.tablet_android,
                    size: 28,
                    color: Colors.blue[300],
                  ),
                  duration: Duration(seconds: 3),
                  leftBarIndicatorColor: Colors.blue[300],
                )..show(context);
              }
            } else {
              Flushbar(
                margin: EdgeInsets.all(8),
                message: "아이디 또는 비밀번호가 일치하지않습니다",
                icon: Icon(
                  Icons.tablet_android,
                  size: 28,
                  color: Colors.blue[300],
                ),
                duration: Duration(seconds: 3),
                leftBarIndicatorColor: Colors.blue[300],
              )..show(context);
            }
          } catch (e) {
            Flushbar(
              margin: EdgeInsets.all(8),
              message: "아이디 또는 비밀번호가 일치하지않습니다",
              icon: Icon(
                Icons.tablet_android,
                size: 28,
                color: Colors.blue[300],
              ),
              duration: Duration(seconds: 3),
              leftBarIndicatorColor: Colors.blue[300],
            )..show(context);
            print(e.message);
          }

          return print(' ');
        });
      } catch (e) {
        print(e.message);
      }
    }
  }
}

class Tick extends StatelessWidget {
  final DecorationImage image;

  Tick({this.image});

  @override
  Widget build(BuildContext context) {
    return (Container(
      width: 250,
      height: 250,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        image: image,
      ),
    ));
  }
}

class SignUp extends StatelessWidget {
  SignUp();

  @override
  Widget build(BuildContext context) {
    return (FlatButton(
      padding: const EdgeInsets.only(
        top: 160,
      ),
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignUpPage()));
      },
      child: Text(
        "Dont't have an account? Sign Up",
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        softWrap: true,
        style: TextStyle(
          fontWeight: FontWeight.w300,
          letterSpacing: 0.5,
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    ));
  }
}

class UserDetails {
  final String providerDetails;
  final String userName;
  final String photoUrl;
  final String userEmail;
  final List<ProviderDetails> providerData;

  UserDetails(this.providerDetails, this.userName, this.photoUrl,
      this.userEmail, this.providerData);
}

class ProviderDetails {
  ProviderDetails(this.providerDetails);

  final String providerDetails;
}
