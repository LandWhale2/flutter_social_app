import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:socialapp/base.dart';
import 'package:socialapp/widgets/database_create.dart';
import 'dart:async';
import 'writeprofile.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flushbar/flushbar.dart';
import 'package:socialapp/model/todo.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
String currentId;

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String email, password, _password2, phoneNo, _authnumber;

  int check = 0;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _smsController = TextEditingController();

  String _message = '';

  String smsCode, _verificationId;

  Future<void> verifyPhone() async {
    setState(() {
      _message = '';
    });

    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verificationId) {
      _verificationId = verificationId;
    };

    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      _auth.signInWithCredential(phoneAuthCredential);
      setState(() {
        _message = 'received phone auth credential : $phoneAuthCredential';
      });
    };

    final PhoneVerificationFailed verfiFailed = (AuthException authException) {
      setState(() {
        _message =
            '폰인증 실패 Code : ${authException.code}. Message: ${authException.message}';
        Flushbar(
          margin: EdgeInsets.all(8),
          message: "전송에 실패했습니다 번호를 입력해주세요",
          icon: Icon(
            Icons.tablet_android,
            size: 28,
            color: Colors.blue[300],
          ),
          duration: Duration(seconds: 3),
          leftBarIndicatorColor: Colors.blue[300],
        )..show(context);
      });
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      Flushbar(
        margin: EdgeInsets.all(8),
        message: "휴대폰에서 인증번호를 확인 후 입력해주세요",
        icon: Icon(
          Icons.tablet_android,
          size: 28,
          color: Colors.blue[300],
        ),
        duration: Duration(seconds: 3),
        leftBarIndicatorColor: Colors.blue[300],
      )..show(context);
      _verificationId = verificationId;
    };

    await _auth.verifyPhoneNumber(
      phoneNumber: _phoneNumberController.text,
      timeout: const Duration(seconds: 5),
      verificationCompleted: verificationCompleted,
      verificationFailed: verfiFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: autoRetrieve,
    );
  }

  Future<String> signInwithPhoneNumber() async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: _verificationId,
      smsCode: _smsController.text,
    );

    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    final FirebaseUser currentUser = await _auth.currentUser();

    assert(user.uid == currentUser.uid);

    setState(() {
      if (user != null) {
        print('success!');
        check = 1;
        Flushbar(
          margin: EdgeInsets.all(8),
          message: "인증이 완료되었습니다",
          icon: Icon(
            Icons.tablet_android,
            size: 28,
            color: Colors.blue[300],
          ),
          duration: Duration(seconds: 3),
          leftBarIndicatorColor: Colors.blue[300],
        )..show(context);
        print(currentUser.uid);

        currentId = currentUser.uid;

        return currentId;
      } else {
        print('sign in failed');
        Flushbar(
          margin: EdgeInsets.all(8),
          message: "인증에 실패했습니다 다시한번 확인해주세요",
          icon: Icon(
            Icons.tablet_android,
            size: 28,
            color: Colors.blue[300],
          ),
          duration: Duration(seconds: 3),
          leftBarIndicatorColor: Colors.blue[300],
        )..show(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) => Center(
          child: Container(
            child: SingleChildScrollView(
              child: Container(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 1),
                        child: Text(
                          '회원가입',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 50),
                        child: Container(
                          height: 1,
                          width: MediaQuery.of(context).size.width / 1.4,
                          color: Colors.black26,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Container(
                          //이메일
                          width: MediaQuery.of(context).size.width / 1.7,
                          height: MediaQuery.of(context).size.height / 20,
                          alignment: FractionalOffset.center,
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius:
                                BorderRadius.all(const Radius.circular(20)),
                          ),
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: 20,
                              ),
                              border: InputBorder.none,
                              hintText: '이메일',
                              prefixIcon: Icon(
                                Icons.account_circle,
                                color: Colors.black,
                              ),
                              contentPadding: const EdgeInsets.only(
                                  top: 100, right: 30, bottom: 0, left: 5),
                            ),
                            validator: (input) {
                              if (input.isEmpty) {
                                return '이메일을 입력해주세요';
                              }
                            },
                            onSaved: (value) => email = value,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2,
                          height: MediaQuery.of(context).size.height / 20,
                          alignment: FractionalOffset.center,
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius:
                                BorderRadius.all(const Radius.circular(20)),
                          ),
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: 20,
                              ),
                              border: InputBorder.none,
                              hintText: '비밀번호',
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.black,
                              ),
                              contentPadding: const EdgeInsets.only(
                                  top: 100, right: 30, bottom: 0, left: 5),
                            ),
                            validator: (input) {
                              if (input.isEmpty) {
                                return '비밀번호를 입력해주세요';
                              }
                            },
                            onSaved: (value) => password = value,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Container(
                          //비번확인
                          width: MediaQuery.of(context).size.width / 2,
                          height: MediaQuery.of(context).size.height / 20,
                          alignment: FractionalOffset.center,
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius:
                                BorderRadius.all(const Radius.circular(20)),
                          ),
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: 20,
                              ),
                              border: InputBorder.none,
                              hintText: '비밀번호 재입력',
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                color: Colors.black,
                              ),
                              contentPadding: const EdgeInsets.only(
                                  top: 100, right: 30, bottom: 0, left: 5),
                            ),
                            validator: (input) {
                              if (input.isEmpty) {
                                return '비밀번호 재입력 해주세요';
                              }
                            },
                            onSaved: (value) => _password2 = value,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 50, bottom: 50),
                        child: Container(
                          height: 1,
                          width: MediaQuery.of(context).size.width / 2,
                          color: Colors.black26,
                        ),
                      ),
                      Container(
                        child: Row(
                          children: <Widget>[
                            Center(
                              child: Padding(
                                padding: EdgeInsets.only(left: 90),
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 2,
                                  height:
                                      MediaQuery.of(context).size.height / 20,
                                  alignment: FractionalOffset.center,
                                  decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.all(
                                        const Radius.circular(20)),
                                  ),
                                  child: TextFormField(
                                    controller: _phoneNumberController,
                                    decoration: InputDecoration(
                                      hintStyle: TextStyle(
                                        fontSize: 20,
                                      ),
                                      border: InputBorder.none,
                                      hintText: '휴대폰 번호',
                                      prefixIcon: Icon(
                                        Icons.phone,
                                        color: Colors.black,
                                      ),
                                      contentPadding: const EdgeInsets.only(
                                          top: 100,
                                          right: 30,
                                          bottom: 0,
                                          left: 5),
                                    ),
                                    validator: (input) {
                                      if (input.isEmpty) {
                                        return "휴대폰 번호를 입력해주세요";
                                      }
                                      ;
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: InkWell(
                                onTap: verifyPhone,
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 5,
                                  height:
                                      MediaQuery.of(context).size.height / 20,
                                  alignment: FractionalOffset.center,
                                  decoration: BoxDecoration(
                                    color: Colors.black87,
                                    borderRadius: BorderRadius.all(
                                        const Radius.circular(30)),
                                  ),
                                  child: Text(
                                    "전송",
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
                      ),
                      Container(
                        child: Row(
                          children: <Widget>[
                            Center(
                              child: Padding(
                                padding: EdgeInsets.only(left: 90, top: 20),
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 2,
                                  height:
                                      MediaQuery.of(context).size.height / 20,
                                  alignment: FractionalOffset.center,
                                  decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.all(
                                        const Radius.circular(20)),
                                  ),
                                  child: TextFormField(
                                    controller: _smsController,
                                    decoration: InputDecoration(
                                      hintStyle: TextStyle(
                                        fontSize: 20,
                                      ),
                                      border: InputBorder.none,
                                      hintText: '인증번호',
                                      prefixIcon: Icon(
                                        Icons.phone,
                                        color: Colors.black,
                                      ),
                                      contentPadding: const EdgeInsets.only(
                                          top: 100,
                                          right: 30,
                                          bottom: 0,
                                          left: 5),
                                    ),
                                    validator: (val) {
                                      if (!isNumber(val)) {
                                        return "인증번호를 입력해주세요";
                                      }
                                      ;
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10, top: 15),
                              child: InkWell(
                                onTap: () async {
                                  await signInwithPhoneNumber();
                                  print('123');
                                  print(currentId);
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 5,
                                  height:
                                      MediaQuery.of(context).size.height / 20,
                                  alignment: FractionalOffset.center,
                                  decoration: BoxDecoration(
                                    color: Colors.black87,
                                    borderRadius: BorderRadius.all(
                                        const Radius.circular(30)),
                                  ),
                                  child: Text(
                                    "인증",
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
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Text(
                          _message,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      InkWell(
                        onTap: _next,
                        child: Padding(
                          padding: EdgeInsets.only(top: 50),
                          child: Container(
                            width: MediaQuery.of(context).size.width / 3,
                            height: MediaQuery.of(context).size.height / 20,
                            alignment: FractionalOffset.center,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(250, 80, 100, 1),
                              borderRadius:
                                  BorderRadius.all(const Radius.circular(30)),
                            ),
                            child: Text(
                              "가입완료",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _next() async {
    var formstate = _formKey.currentState;
    if (formstate.validate()) {
      if (check == 1) {
        formstate.save();
        try {
          print(currentId);
          print('222');
          var firebaseUser;
          final QuerySnapshot result = await Firestore.instance
              .collection('users')
              .where('id', isEqualTo: currentId)
              .getDocuments();
          final List<DocumentSnapshot> documents = result.documents;
          if (documents.length == 0) {
            Firestore.instance.collection('users').document(currentId).setData({
              'nickname': null,
              'photoUrl': null,
              'email': email,
              'password': password,
              'id': currentId,
              'createAt': DateTime.now().millisecondsSinceEpoch.toString(),
              'chattingWith': null,
              'favorite': null,
              'image': [],
              'age': null,
              'intro': null,
            });
          }
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => writeprofile(
                        currentUserId: currentId,
                      )));
        } catch (e) {
          print(e.message);
        }
      }
    }
  }

  int PasswordCheck() {
    int _pscheck = 0;
    if (password == _password2) {
      _pscheck = 1;
      print('비밀번호같습니다');
      return _pscheck;
    } else {
      return _pscheck;
    }
  }
}

bool isNumber(String valueNumber) {
  if (valueNumber == null) {
    return true;
  }
  final n = num.tryParse(valueNumber);
  return n != null;
}
