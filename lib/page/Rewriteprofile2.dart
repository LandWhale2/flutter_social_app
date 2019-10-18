import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:socialapp/model/todo.dart';
import 'package:socialapp/widgets/database_create.dart';

class Rewriteprofile2 extends StatefulWidget {
  Rewriteprofile2({Key key}) : super(key: key);

  @override
  _Rewriteprofile2State createState() => _Rewriteprofile2State();
}

class _Rewriteprofile2State extends State<Rewriteprofile2> {
  final _formKey = GlobalKey<FormState>();
  String _name, _age, _intro;
  final _nameText = TextEditingController();
  final _ageText = TextEditingController();
  final _introText = TextEditingController();
  bool _validate = false;

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
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 70),
                        child: Text(
                          '프로필 수정',
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
                        padding: EdgeInsets.only(top: 10, bottom: 20),
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(bottom: 0),
                              child: Container(
                                width: MediaQuery.of(context).size.width / 2,
                                height: MediaQuery.of(context).size.height / 15,
                                decoration: BoxDecoration(
                                  color: Colors.black12,
                                  borderRadius:
                                  BorderRadius.all(const Radius.circular(20)),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 100, top: 0),
                              //이름입력
                              child: Center(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(
                                      fontSize: 15,
                                    ),
                                    hintText: '이름',
                                    border: InputBorder.none,
                                    prefixIcon: Icon(
                                      Icons.person_outline,
                                      color: Colors.black,
                                    ),
                                  ),
                                  validator: (input) {
                                    if (input.isEmpty) {
                                      return '이름을 입력해주세요';
                                    }
                                  },
                                  onSaved: (value) => _name = value,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 0, bottom: 20),
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width / 2,
                              height: MediaQuery.of(context).size.height / 15,
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius:
                                BorderRadius.all(const Radius.circular(20)),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 100, top: 0),
                              //이름입력
                              child: Center(
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    WhitelistingTextInputFormatter.digitsOnly
                                  ],
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(
                                      fontSize: 15,
                                    ),
                                    hintText: '나이',
                                    border: InputBorder.none,
                                    prefixIcon: Icon(
                                      Icons.border_color,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  validator: (input) {
                                    if (input.isEmpty) {
                                      return '나이를 입력해주세요';
                                    }
                                  },
                                  onSaved: (value) => _age = value,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 0, bottom: 0),
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width / 2,
                              height: MediaQuery.of(context).size.height / 15,
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius:
                                BorderRadius.all(const Radius.circular(20)),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 100, top: 0),
                              //이름입력
                              child: Center(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(
                                      fontSize: 15,
                                    ),
                                    hintText: '자기소개',
                                    border: InputBorder.none,
                                    prefixIcon: Icon(
                                      Icons.textsms,
                                      color: Colors.black,
                                    ),
                                  ),
                                  validator: (input) {
                                    if (input.isEmpty) {
                                      return '자기소개를 입력해주세요';
                                    }
                                  },
                                  onSaved: (value) => _intro = value,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          InkWell(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: EdgeInsets.only(top: 50,left: 50),
                              child: Container(
                                width: MediaQuery.of(context).size.width / 3,
                                height: MediaQuery.of(context).size.height / 20,
                                alignment: FractionalOffset.center,
                                decoration: BoxDecoration(
                                  color: Colors.black87,
                                  borderRadius:
                                  BorderRadius.all(const Radius.circular(30)),
                                ),
                                child: Text(
                                  "뒤로가기",
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
                          InkWell(
                            onTap: onPressed,
                            child: Padding(
                              padding: EdgeInsets.only(top: 50,left: 30),
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
                                  "완료",
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

  String validage(String value) {
    if (value.isNotEmpty) {
      return "나이를 입력해주세요";
    }
    return null;
  }

  void onPressed() {
    var form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      try {
        String _email = 'kmail';
        Todo newtodo = Todo(name: _name ,age: _age,intro: _intro,email: _email);
        DBHelper().profileUpdate(newtodo);
//        Navigator.push(
//            context, MaterialPageRoute(builder: (context) => Base()));
      Navigator.pop(context);
      } catch (e) {
        print(e.message);
      }
    }
  }

  String randomTodo() {
    final randomNumber = Random().nextInt(4);
    String todo;
    switch (randomNumber) {
      case 1:
        todo = 'hello1';
        break;
      case 1:
        todo = 'hello2';
        break;
      case 1:
        todo = 'hello3';
        break;
      default:
        todo = 'default';
        break;
    }
    return todo;
  }
}

bool isNumber(String valueNumber) {
  if (valueNumber == null) {
    return true;
  }
  final n = num.tryParse(valueNumber);
  return n != null;
}
