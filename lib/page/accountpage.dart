import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/main.dart';
import 'package:socialapp/page/contextpage.dart';
import 'package:socialapp/page/loginscreen.dart';
import 'package:socialapp/widgets/adHelper.dart';

class AccountPage extends StatefulWidget {
  final String currentId;
  AccountPage({Key key, @required this.currentId});

  @override
  _AccountPageState createState() => _AccountPageState(currentId: currentId);
}

class _AccountPageState extends State<AccountPage> {
  final String currentId;
  _AccountPageState({Key key,@required this.currentId});

  GoogleSignIn googleSignIn = GoogleSignIn();

  bool isLoading =false;

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
        MaterialPageRoute(builder: (context) => LoginScreen()),
            (Route<dynamic> route) => false).then((value){
      Ads.showBannerAd();
    });
  }


  Future<void> deleteUser() async{

    SharedPreferences _pref = await SharedPreferences.getInstance();





    FirebaseUser user =await FirebaseAuth.instance.currentUser();
    print('asd');

    print(user);
    if(user != null){
      print('s');
    }

    user.delete().then((_)async{

      FirebaseStorage.instance.ref().child(currentId+'/0.jpg').delete().then((_){
        print('클라우드삭제완료');
      });

      print('계정삭제완료');

      _pref.clear();

      print('preference 삭제완료');

      Firestore.instance.collection('user').document(currentId).delete();
      print('사용자 데이터 삭제완료');

      await FirebaseAuth.instance.signOut();
      await googleSignIn.disconnect();
      await googleSignIn.signOut();


      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen()),
              (Route<dynamic> route) => false).then((value){
        Ads.showBannerAd();
      });

    }).catchError((error){
      print('삭제할수없습니다 : ' + error.toString());
      Fluttertoast.showToast(msg: '재 로그인이 필요합니다.');
    });





  }







  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Ads.initialize();
    Ads.showBannerAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          '계정정보',
          style: TextStyle(
              fontFamily: 'NIX', fontSize: 25, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white, //Color.fromRGBO(188, 206, 255, 1)
      ),
      body: Stack(
        children: <Widget>[
          StreamBuilder(
            stream: Firestore.instance.collection('users').document(currentId).snapshots(),
            builder: (context, snapshot) {

              if(!snapshot.hasData){
                return Container();
              }
              var ds = snapshot.data;
              return Center(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20,),
                      Container(
                        width: MediaQuery.of(context).size.width/2,
                        height: MediaQuery.of(context).size.height/20,

                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 0),
                          child: Center(
                            child: Text(
                                (ds['email'] != null)?ds['email']:'알수없는이메일',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: MediaQuery.of(context).textScaleFactor*20,
                                fontFamily: 'NIX'
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15,),
                      Container(
                        width: MediaQuery.of(context).size.width/2,
                        height: 1,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1)
                        ),
                      ),
                      SizedBox(height: 15,),
                      InkWell(
                        onTap: (){
                          handleSignOut();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(width: 15,),
                            Text('로그아웃',style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: MediaQuery.of(context).textScaleFactor*20,
                                fontFamily: 'NIX'
                            ),),
                            Icon(Icons.arrow_forward_ios),
                          ],
                        ),
                      ),
                      SizedBox(height: 20,),
                      InkWell(
                        onTap: (){
                          deleteUser();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(width: 15,),
                            Text('회원탈퇴',style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: MediaQuery.of(context).textScaleFactor*20,
                                fontFamily: 'NIX'
                            ),),
                            Icon(Icons.arrow_forward_ios),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          ),
          buildLoading(),
        ],
      ),
    );
  }

  Widget buildLoading(){
    return Positioned(
      child: isLoading
          ?Container(
        child: Center(
          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.grey)),
        ),
        color: Colors.white.withOpacity(0.8),
      )
          :Container(),
    );
  }
}
