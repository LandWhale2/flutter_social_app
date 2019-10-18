//import 'package:flushbar/flushbar.dart';
//import 'package:flutter/material.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:socialapp/base.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:google_sign_in/google_sign_in.dart';
//import 'package:socialapp/model/todo.dart';
//import 'package:socialapp/page/signup.dart';
//import 'package:socialapp/widgets/database_create.dart';
//
//FirebaseUser firebaseauth;
//
//
//DecorationImage tick = DecorationImage(
//  image: ExactAssetImage('assets/tick.png'),
//  fit: BoxFit.cover,
//);
//
//DecorationImage backgroundImage = DecorationImage(
//  image: ExactAssetImage('assets/lake.jpg'),
//  fit: BoxFit.cover,
//);
//
//class LoginScreen extends StatefulWidget {
//  const LoginScreen({Key key}) : super(key: key);
//
//  @override
//  LoginScreenState createState() => LoginScreenState();
//}
//
//class LoginScreenState extends State<LoginScreen>
//    with TickerProviderStateMixin {
//  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
//  String _email ,_password;
//
//  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
//  final GoogleSignIn googleSignIn = GoogleSignIn();
//
//  Future<FirebaseUser> _signIn(BuildContext context) async{
//
//    final GoogleSignInAccount googleUser = await googleSignIn.signIn();
//    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
//
//    final AuthCredential credential = GoogleAuthProvider.getCredential(
//        idToken: googleAuth.idToken,
//        accessToken: googleAuth.accessToken);
//
//    FirebaseUser firebaseUser = (await firebaseAuth.signInWithCredential(credential)).user;
//    ProviderDetails providerInfo = ProviderDetails(firebaseUser.providerId);
//
//    List<ProviderDetails> providerData = List<ProviderDetails>();
//    providerData.add(providerInfo);
//
//    UserDetails details = UserDetails(
//      firebaseUser.providerId,
//      firebaseUser.displayName,
//      firebaseUser.photoUrl,
//      firebaseUser.email,
//      providerData,
//    );
//
//    Navigator.push(context,
//        MaterialPageRoute(
//          builder: (context) => Base(),
//        ));
//    return firebaseUser;
//  }
//
//
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      body: Container(
//        decoration: BoxDecoration(
//          image: backgroundImage,
//        ),
//        child: Container(
//          decoration: BoxDecoration(
//              gradient: LinearGradient(
//                colors: <Color>[
//                  const Color.fromRGBO(162, 146, 199, 0.8),
//                  const Color.fromRGBO(51, 51, 63, 0.9),
//                ],
//                stops: [0.2, 1.0],
//                begin: const FractionalOffset(0, 0),
//                end: const FractionalOffset(0, 1),
//              )),
//          child: ListView(
//            padding: EdgeInsets.all(0),
//            children: <Widget>[
//              Stack(
//                alignment: AlignmentDirectional.bottomCenter,
//                children: <Widget>[
//                  Column(
//                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                    children: <Widget>[
//                      Tick(image: tick),
//                      Container(
//                        margin: EdgeInsets.symmetric(horizontal: 20),
//                        child: Column(
//                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                          children: <Widget>[
//                            Form(
//                              child: Column(
//                                mainAxisAlignment:
//                                MainAxisAlignment.spaceAround,
//                                children: <Widget>[
//                                  Container(
//                                    margin:
//                                    EdgeInsets.symmetric(horizontal: 20),
//                                    child: Column(
//                                      mainAxisAlignment:
//                                      MainAxisAlignment.spaceEvenly,
//                                      children: <Widget>[
//                                        Form(
//                                          key: _formkey,
//                                          child: Column(
//                                            mainAxisAlignment:
//                                            MainAxisAlignment.spaceAround,
//                                            children: <Widget>[
//                                              Container(
//                                                decoration: BoxDecoration(
//                                                  border: Border(
//                                                    bottom: BorderSide(
//                                                      width: 0.5,
//                                                      color: Colors.white24,
//                                                    ),
//                                                  ),
//                                                ),
//                                                child: TextFormField(
//                                                  validator: (input) {
//                                                    if (input.isEmpty) {
//                                                      return '이메일을 입력해주세요';
//                                                    }
//                                                  },
//                                                  onSaved: (input) =>
//                                                  _email = input,
//                                                  keyboardType:
//                                                  TextInputType.text,
//                                                  obscureText: false,
//                                                  style: const TextStyle(
//                                                    color: Colors.white,
//                                                  ),
//                                                  decoration: InputDecoration(
//                                                    icon: Icon(
//                                                      Icons.person_outline,
//                                                      color: Colors.white,
//                                                    ),
//                                                    border: InputBorder.none,
//                                                    hintText: 'Email',
//                                                    hintStyle: const TextStyle(
//                                                        color: Colors.white,
//                                                        fontSize: 15),
//                                                    contentPadding:
//                                                    const EdgeInsets.only(
//                                                        top: 30,
//                                                        right: 30,
//                                                        bottom: 30,
//                                                        left: 5),
//                                                  ),
//                                                ),
//                                              ),
//                                              Container(
//                                                decoration: BoxDecoration(
//                                                  border: Border(
//                                                    bottom: BorderSide(
//                                                      width: 0.5,
//                                                      color: Colors.white24,
//                                                    ),
//                                                  ),
//                                                ),
//                                                child: TextFormField(
//                                                  validator: (input) {
//                                                    if (input.isEmpty) {
//                                                      return '패스워드를 입력해주세요';
//                                                    }
//                                                  },
//                                                  onSaved: (input) =>
//                                                  _password = input,
//                                                  keyboardType:
//                                                  TextInputType.text,
//                                                  obscureText: true,
//                                                  style: const TextStyle(
//                                                    color: Colors.white,
//                                                  ),
//                                                  decoration: InputDecoration(
//                                                    icon: Icon(
//                                                      Icons.lock,
//                                                      color: Colors.white,
//                                                    ),
//                                                    border: InputBorder.none,
//                                                    hintText: 'Password',
//                                                    hintStyle: const TextStyle(
//                                                        color: Colors.white,
//                                                        fontSize: 15),
//                                                    contentPadding:
//                                                    const EdgeInsets.only(
//                                                        top: 30,
//                                                        right: 30,
//                                                        bottom: 30,
//                                                        left: 5),
//                                                  ),
//                                                ),
//                                              ),
//                                            ],
//                                          ),
//                                        ),
//                                      ],
//                                    ),
//                                  ),
//                                ],
//                              ),
//                            ),
//                          ],
//                        ),
//                      ),
//                      SignUp(),
//                    ],
//                  ),
//                  Padding(
//                    padding: EdgeInsets.only(bottom: 50),
//                    child: InkWell(
//                      onTap: _SignDB,
//                      child: Container(
//                        width: 330,
//                        height: 60,
//                        alignment: FractionalOffset.center,
//                        decoration: BoxDecoration(
//                          color: const Color.fromRGBO(247, 64, 106, 1),
//                          borderRadius:
//                          BorderRadius.all(const Radius.circular(30)),
//                        ),
//                        child: Text(
//                          "Sign In",
//                          style: TextStyle(
//                            color: Colors.white,
//                            fontSize: 20,
//                            fontWeight: FontWeight.w300,
//                            letterSpacing: 0.3,
//                          ),
//                        ),
//                      ),
//                    ),
//                  ),
//                ],
//              ),
//              Padding(
//                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 100),
//                child: InkWell(
//                  onTap: (){
//                    _signIn(context).then((FirebaseUser user)=>print(user)).catchError((e)=>print(e));
//                  },
//                  child: Container(
//                    width: 200,
//                    height: 30,
//                    alignment: FractionalOffset.center,
//                    decoration: BoxDecoration(
//                      gradient: LinearGradient(
//                        colors: [Colors.pinkAccent, Colors.lightBlueAccent],
//                        begin: Alignment.topLeft,
//                        end: Alignment.bottomRight,
//                      ),
//                      borderRadius: BorderRadius.all(const Radius.circular(30)),
//                    ),
//                    child: Row(children: <Widget>[
//                      Icon(FontAwesomeIcons.google, color: Colors.black12),
//                      Text(
//                        "Sign in with Google",
//                        style: TextStyle(
//                          color: Colors.white,
//                          fontSize: 15,
//                          fontWeight: FontWeight.w100,
//                          letterSpacing: 0.3,
//                        ),
//                      ),
//                    ],
//                    ),
//                  ),
//                ),
//              ),
//            ],
//          ),
//        ),
//      ),
//    );
//  }
//
//  Future<void> _SignIn() async {
//    final formState = _formkey.currentState;
//    if (formState.validate()) {
//      formState.save();
//      try {
//        AuthResult _user = await FirebaseAuth.instance
//            .signInWithEmailAndPassword(email: _email, password: _password);
//        Navigator.push(
//            context, MaterialPageRoute(builder: (context) => Base()));
//      } catch (e) {
//        print(e.message);
//      }
//    }
//  }
//
//  _SignDB() async{
//    final formState = _formkey.currentState;
//    if(formState.validate()){
//      print('asd');
//      formState.save();
//      try{
//        var useridpw = await DBHelper().getuserIDPW(_email);
//        var tmpEmail;
//        var tmpPassword;
//
//
//        if(useridpw == Null){
//          Flushbar(
//            margin:EdgeInsets.all(8),
//            message: "아이디 또는 비밀번호가 일치하지않습니다",
//            icon: Icon(
//              Icons.tablet_android,
//              size:28,
//              color: Colors.blue[300],
//            ),
//            duration: Duration(seconds: 3),
//            leftBarIndicatorColor: Colors.blue[300],
//          )..show(context);
//        }else{
//          useridpw.map((e) {
//            tmpEmail = e['email'];
//          }).toList();
//          useridpw.map((e) {
//            tmpPassword = e['password'];
//          }).toList();
//        }
//
//
//
//        if(_email == tmpEmail){
//          if(_password == tmpPassword){
//            Navigator.push(
//                context, MaterialPageRoute(builder: (context) => Base()));
//          }else{
//            Flushbar(
//              margin:EdgeInsets.all(8),
//              message: "아이디 또는 비밀번호가 일치하지않습니다",
//              icon: Icon(
//                Icons.tablet_android,
//                size:28,
//                color: Colors.blue[300],
//              ),
//              duration: Duration(seconds: 3),
//              leftBarIndicatorColor: Colors.blue[300],
//            )..show(context);
//          }
//        }else{
//          Flushbar(
//            margin:EdgeInsets.all(8),
//            message: "아이디 또는 비밀번호가 일치하지않습니다",
//            icon: Icon(
//              Icons.tablet_android,
//              size:28,
//              color: Colors.blue[300],
//            ),
//            duration: Duration(seconds: 3),
//            leftBarIndicatorColor: Colors.blue[300],
//          )..show(context);
//        }
//      }catch(e){
//        print(e.message);
//      }
//    }
//  }
//
//
//
//
//
//}
//
//class Tick extends StatelessWidget {
//  final DecorationImage image;
//
//  Tick({this.image});
//
//  @override
//  Widget build(BuildContext context) {
//    return (Container(
//      width: 250,
//      height: 250,
//      alignment: Alignment.center,
//      decoration: BoxDecoration(
//        image: image,
//      ),
//    ));
//  }
//}
//
//class SignUp extends StatelessWidget {
//  SignUp();
//
//  @override
//  Widget build(BuildContext context) {
//    return (FlatButton(
//      padding: const EdgeInsets.only(
//        top: 160,
//      ),
//      onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()));},
//      child: Text(
//        "Dont't have an account? Sign Up",
//        textAlign: TextAlign.center,
//        overflow: TextOverflow.ellipsis,
//        softWrap: true,
//        style: TextStyle(
//          fontWeight: FontWeight.w300,
//          letterSpacing: 0.5,
//          color: Colors.white,
//          fontSize: 12,
//        ),
//      ),
//    ));
//  }
//}
//
//class UserDetails{
//  final String providerDetails;
//  final String userName;
//  final String photoUrl;
//  final String userEmail;
//  final List<ProviderDetails> providerData;
//  UserDetails(this.providerDetails, this.userName, this.photoUrl, this.userEmail, this.providerData);
//
//
//}
//
//class ProviderDetails{
//  ProviderDetails(this.providerDetails);
//  final String providerDetails;
//}