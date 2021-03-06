import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as prefix0;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socialapp/base.dart';

class ProfileEdit extends StatefulWidget {
  final String currentId;
  bool first;



  ProfileEdit({Key key, @required this.currentId, @required this.first}) : super(key: key);

  @override
  _ProfileEditState createState() => _ProfileEditState(currentId: currentId,first: first);
}

class _ProfileEditState extends State<ProfileEdit> {
  final String currentId;
  bool first;

  _ProfileEditState({Key key, @required this.currentId, @required this.first});

  GlobalKey<FormState> _formKey = GlobalKey<FormState>(debugLabel: 'asd');
  File tmpimage;
  String _ImageUrl;
  int _selectage;
  TextEditingController _nicknamecontroll = TextEditingController();
  TextEditingController _locationcontroll = TextEditingController();
  TextEditingController _todaycontroll = TextEditingController();
  String _location;
  String _nickname;
  String _today;


  initprofile(){
    try {
      Firestore.instance.collection('users').document(currentId).updateData({
        'e' : 'e',
      });
    }catch(e){
      Firestore.instance.collection('users').document(currentId).setData({
        'a': 'a',
      });
    }

  }


  initSetting(){
    var form= _formKey.currentState;
    try{
      Firestore.instance
          .collection('users')
          .document(currentId)
          .snapshots()
          .listen((data) {
        setState(() {
          _nicknamecontroll.text = data['nickname'];
          _locationcontroll.text = data['location'];
          _todaycontroll.text = data['today'];
          _nickname = data['nickname'];
          _location = data['location'];
          _today = data['today'];
        });
      });
    }catch(e){
      print(e.message);
    }

  }


  Future UploadImage() async {
//    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference =
    FirebaseStorage.instance.ref().child('${currentId}/0.jpg');
    StorageUploadTask uploadTask = reference.putFile(tmpimage);
    StorageTaskSnapshot storageTaskSnapshot;
    uploadTask.onComplete.then((value) async {
      if (value.error == null) {
        storageTaskSnapshot = value;
        storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
          setState(() {
            _ImageUrl = downloadUrl;
            isLoading = false;
          });
        }, onError: (err) {
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(msg: '이미지파일이 아닙니다.');
        });
      } else{

        setState(() {
          isLoading = false;
          Fluttertoast.showToast(msg: '이미지파일이 아닙니다.');
          print(value.error);
        });
      }


    });
  }


  uploadtask()async{
    if(_nickname != null){
      if(_selectage ==null){
        return Fluttertoast.showToast(msg: '나이를 입력해주세요.');
      }
      if(_location ==null){
        return Fluttertoast.showToast(msg: '지역을 입력해주세요.');
      }
      try{

        if(this.mounted){

            if(first == true){
              if(this.mounted){
                print('111111');
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Base(currentUserId: currentId)));
              }
            }else{
              print('22222');
                Navigator.pop(context);
            }

        }

        if(this.mounted){
          if(_ImageUrl == null){
            Firestore.instance.collection('users').document(currentId).updateData({
              'nickname':_nickname,
              'age': _selectage,
              'location': _location,
              'today': _today,
            });
          }else{
            Firestore.instance.collection('users').document(currentId).updateData({
              'nickname':_nickname,
              'age': _selectage,
              'location': _location,
              'today': _today,
              'image': _ImageUrl,
            });
          }
        }
      }catch(e){
        print(e.message);
      }
    }else{
      return Fluttertoast.showToast(msg: '닉네임을 입력해주세요.');
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    initprofile();
    initSetting();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              child: Center(
                child: StreamBuilder(
                    stream: Firestore.instance
                        .collection('users')
                        .document(currentId)
                        .snapshots(),
                    builder: (context, snapshot) {
                      var ds = snapshot.data;
                      if (!snapshot.hasData) {
                        return Container();
                      }
                      return Stack(
                        children: <Widget>[
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    InkWell(
                                      onTap: (){
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        child: Text(
                                          '취소',
                                          style: TextStyle(
                                              fontFamily: 'NIX',
                                              fontWeight: FontWeight.w800,
                                              fontSize:
                                              MediaQuery.of(context).textScaleFactor * 20),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        '프로필 사진',
                                        style: TextStyle(
                                            fontFamily: 'NIX',
                                            fontWeight: FontWeight.w800,
                                            fontSize:
                                                MediaQuery.of(context).textScaleFactor * 25),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: (){

                                        if(_ImageUrl == null && ds['image'] != null){
                                          if(this.mounted){
                                            uploadtask();
                                          }
                                        }else if(ds['image'] ==null && _ImageUrl ==null){
                                          Fluttertoast.showToast(msg: '프로필 사진을 올려주세요.');
                                        }else if(ds['image'] == null && _ImageUrl != null){
                                          if(this.mounted){
                                            uploadtask();
                                          }
                                        }else{
                                          if(this.mounted){
                                            uploadtask();
                                          }
                                        }

                                      },
                                      child: Container(
                                        child: Text(
                                          '완료',
                                          style: TextStyle(
                                              fontFamily: 'NIX',
                                              fontWeight: FontWeight.w800,
                                              fontSize:
                                              MediaQuery.of(context).textScaleFactor * 20),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                InkWell(
                                  onTap: () async {
                                    var getimage = await ImagePicker.pickImage(
                                        source: ImageSource.gallery);
                                    if(getimage != null){
                                      tmpimage = getimage;
                                      setState(() {
                                        isLoading =true;
                                      });
                                      UploadImage();
                                    }
                                  },
                                  child: (_ImageUrl != null)
                                      ? Container(
                                          width: MediaQuery.of(context).size.width / 5,
                                          height: MediaQuery.of(context).size.height / 10,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(10),
                                            child: Image.network(_ImageUrl, fit: BoxFit.cover,)
                                          ),
                                        )
                                      : (ds['image'] != null)
                                          ? Container(
                                              width: MediaQuery.of(context).size.width / 5,
                                              height:
                                                  MediaQuery.of(context).size.height / 10,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.all(Radius.circular(10)),
                                                child: CachedNetworkImage(
                                                  imageUrl: ds['image'],
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            )
                                          : Container(
                                              width: MediaQuery.of(context).size.width / 5,
                                              height:
                                                  MediaQuery.of(context).size.height / 10,
                                              decoration: BoxDecoration(
                                                border: Border.all(width: 0.2),
                                                borderRadius:
                                                    BorderRadius.all(Radius.circular(10)),
                                                color: Colors.black12,
                                              ),
                                              child: Center(
                                                child: Icon(Icons.account_circle),
                                              ),
                                            ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Container(
                                  child: Text(
                                    '기본정보',
                                    style: TextStyle(
                                        fontFamily: 'NIX',
                                        fontWeight: FontWeight.w800,
                                        fontSize:
                                        MediaQuery.of(context).textScaleFactor * 25),
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Text('*', style: TextStyle(color: Colors.red, fontSize: 20),),
                                    ),
                                    Container(
                                      child: Text(
                                        '닉네임',
                                        style: TextStyle(
                                            fontFamily: 'NIX',
                                            fontWeight: FontWeight.w500,
                                            fontSize:
                                            MediaQuery.of(context).textScaleFactor * 20),
                                      ),
                                    ),
                                    SizedBox(width: 10,),
                                    Container(
                                      width: MediaQuery.of(context).size.width / 3,
                                      height:MediaQuery.of(context).size.height / 25,
                                      decoration: BoxDecoration(
                                        border: Border.all(width: 0.5),
                                        borderRadius: BorderRadius.all(Radius.circular(10))
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 5, left: 10),
                                        child: TextFormField(
                                          style: TextStyle(
                                              fontFamily: 'NIX'
                                          ),
                                          maxLength: 6,
                                          controller: _nicknamecontroll,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.zero,
                                            counterText: '',
                                            border: InputBorder.none,
                                          ),
                                          onChanged: (String value){
                                            setState(() {
                                              _nickname = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20,),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Text('*', style: TextStyle(color: Colors.red, fontSize: 20),),
                                    ),
                                    Container(
                                      child: Text(
                                        '나이',
                                        style: TextStyle(
                                            fontFamily: 'NIX',
                                            fontWeight: FontWeight.w500,
                                            fontSize:
                                            MediaQuery.of(context).textScaleFactor * 20),
                                      ),
                                    ),
                                    SizedBox(width: 10,),
                                    Container(
                                      child: FormField<int>(
                                        builder: (FormFieldState<int> state,){
                                          return Row(
                                            children: <Widget>[
                                              DropdownButton<int>(
                                                iconEnabledColor: Colors.red,
                                                value: _selectage,
                                                items: List<DropdownMenuItem<int>>.generate(
                                                  50,
                                                      (int index) => DropdownMenuItem<int>(
                                                    value: index,
                                                    child: Text(index.toString(), style: TextStyle(fontFamily: 'NIX'),),
                                                  ),
                                                ),
                                                onChanged: (int value){
                                                  setState(() {
                                                    _selectage = value;
                                                  });
                                                },
                                              ),
                                              SizedBox(width: 10,),
                                            ],
                                          );
                                        },

                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20,),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Text('*', style: TextStyle(color: Colors.red, fontSize: 20),),
                                    ),
                                    Container(
                                      child: Text(
                                        '선호지역',
                                        style: TextStyle(
                                            fontFamily: 'NIX',
                                            fontWeight: FontWeight.w500,
                                            fontSize:
                                            MediaQuery.of(context).textScaleFactor * 20),
                                      ),
                                    ),
                                    SizedBox(width: 10,),
                                    Container(
                                      width: MediaQuery.of(context).size.width / 3,
                                      height:MediaQuery.of(context).size.height / 25,
                                      decoration: BoxDecoration(
                                          border: Border.all(width: 0.5),
                                          borderRadius: BorderRadius.all(Radius.circular(10))
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 5, left: 10),
                                        child: TextFormField(
                                          style: TextStyle(
                                            fontFamily: 'NIX'
                                          ),
                                          maxLength: 6,
                                          controller: _locationcontroll,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.zero,
                                            counterText: '',
                                            border: InputBorder.none,
                                          ),
                                          onChanged: (String value){
                                            setState(() {
                                              _location = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 30,),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        '한마디',
                                        style: TextStyle(
                                            fontFamily: 'NIX',
                                            fontWeight: FontWeight.w500,
                                            fontSize:
                                            MediaQuery.of(context).textScaleFactor * 20),
                                      ),
                                    ),
                                    SizedBox(width: 10,),
                                    Container(
                                      width: MediaQuery.of(context).size.width / 3,
                                      height:MediaQuery.of(context).size.height / 25,
                                      decoration: BoxDecoration(
                                          border: Border.all(width: 0.5),
                                          borderRadius: BorderRadius.all(Radius.circular(10))
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 5, left: 10),
                                        child: TextFormField(

                                          style: TextStyle(
                                              fontFamily: 'NIX'
                                          ),
                                          maxLength: 8,
                                          controller: _todaycontroll,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.zero,
                                            counterText: '',
                                            border: InputBorder.none,
                                          ),
                                          onChanged: (String value){
                                            setState(() {
                                              _today = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          buildLoading(),
                        ],
                      );

                    }),
              ),
            ),
            buildLoading(),
          ],
        ),
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

  bool isLoading =false;
}
