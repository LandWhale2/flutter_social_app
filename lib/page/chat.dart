import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp/model/fullPhoto.dart';
import 'package:socialapp/page/contextpage.dart';
import 'package:socialapp/page/loginscreen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:socialapp/widgets/adHelper.dart';



class Chat extends StatelessWidget {
  final String peerId;
  final String peerAvatar;
  final String currentId;

  Chat({Key key,@required this.peerId, @required this.peerAvatar , @required this.currentId}) : super(key:key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'CHAT',
        ),
        centerTitle: true,
      ),
      body:ChatScreen(peerId: peerId, peerAvatar: peerAvatar, currentId: currentId,),
    );
  }
}




class ChatScreen extends StatefulWidget {
  final String currentId;
  final String peerId;
  final String peerAvatar;

  ChatScreen({Key key,@required this.peerId, @required this.peerAvatar, @required this.currentId}) : super(key:key);


  @override
  _ChatScreenState createState() => _ChatScreenState(peerId: peerId, peerAvatar: peerAvatar, currentId: currentId);
}

class _ChatScreenState extends State<ChatScreen> {
  _ChatScreenState({Key key,@required this.peerId, @required this.peerAvatar, @required this.currentId});
  String peerId;
  String peerAvatar;
  String id;
  final String currentId;

  var listMessage;
  String groupChatId;
  SharedPreferences prefs;

  File imageFile;
  bool isLoading;
  bool isShowSticker;
  String imageUrl;

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    focusNode.addListener(onFocusChange);

    groupChatId = '';

    isLoading = false;
    isShowSticker = false;
    imageUrl = '';
    Ads.hideBannerAd();
    readLocal();
  }


  void onFocusChange(){
    if(focusNode.hasFocus){
      //키보드가 나타날때 스티커 감추기
      setState(() {
        isShowSticker = false;
      });
    }
  }

  readLocal() async{
    id = currentId;
    if(id.hashCode <= peerId.hashCode){
      groupChatId = '$id-$peerId';
    }else{
      groupChatId = '$peerId-$id';
    }
//    Firestore.instance.collection('users').document(id).updateData({'chattingWith': peerId});

    setState(() {
    });
  }

  Future getImage() async{
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    if(imageFile != null){
      setState(() {
        isLoading = true;
      });
      print(isLoading);
      uploadFile();
    }
  }

  void getSticker(){
    //스티커가 나올때 키보드 감춤
      focusNode.unfocus();
      setState(() {
        isShowSticker = !isShowSticker;
      });
  }


  Future uploadFile() async{
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl){
      imageUrl = downloadUrl;
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl, 1);
      });
    }, onError: (err){
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: '이미지 파일이 아닙니다');
    });
  }


  void onSendMessage(String content, int type){
    //type 0 = 텍스트, 1 = 이미지 , 3= 스티커
    if(content.trim() != ''){
      textEditingController.clear();

      var documentReference = Firestore.instance
          .collection('messages')
          .document(groupChatId)
          .collection(groupChatId)
          .document(DateTime.now()
          .millisecondsSinceEpoch.toString());

      Firestore.instance.runTransaction((transtion) async{
        await transtion.set(
          documentReference,
          {
            'idFrom' : id,
            'idTo' : peerId,
            'timestamp' : DateTime.now().millisecondsSinceEpoch.toString(),
            'content' : content,
            'type' : type
          },
        );
      });
      listScrollController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    }else{
      Fluttertoast.showToast(msg: 'Nothing to send');
    }
  }

  Widget buildItem(int index, DocumentSnapshot document) {
    if (document['idFrom'] == id) {
      // Right (my message)
      return Container(
        child: Column(
          children: <Widget>[
            document['type'] == 0
            // Text
                ? Container(
              child: Text(
                document['content'],
                style: TextStyle(color: Colors.white),
              ),
              padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
              width: 200.0,
              decoration: BoxDecoration(color: Colors.lightBlueAccent, borderRadius: BorderRadius.circular(8.0)),
              margin: EdgeInsets.only(bottom: isLastMessageRight(index) ? 10.0 : 10.0, right: 10.0),
            )
                : document['type'] == 1
            // Image
                ? Container(
              child: FlatButton(
                child: Material(
                  child: CachedNetworkImage(
                    placeholder: (context, url) => Container(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black87),
                      ),
                      width: 200.0,
                      height: 200.0,
                      padding: EdgeInsets.all(70.0),
                      decoration: BoxDecoration(
                        color: Colors.pinkAccent,
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Material(
                      child: Image.asset(
                        'images/img_not_available.jpeg',
                        width: 200.0,
                        height: 200.0,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                      clipBehavior: Clip.hardEdge,
                    ),
                    imageUrl: document['content'],
                    width: 200.0,
                    height: 200.0,
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  clipBehavior: Clip.hardEdge,
                ),
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => FullPhoto(url: document['content'])));
                },
                padding: EdgeInsets.all(0),
              ),
              margin: EdgeInsets.only(bottom: isLastMessageRight(index) ? 20.0 : 10.0, right: 10.0),
            )
            // Sticker
                : Container(
              child: new Image.asset(
                'assets/${document['content']}.gif',
                width: 100.0,
                height: 100.0,
                fit: BoxFit.cover,
              ),
              margin: EdgeInsets.only(bottom: isLastMessageRight(index) ? 20.0 : 10.0, right: 10.0),
            ),
            Container(
              child: Text(
                DateFormat('dd MMM kk:mm')
                    .format(DateTime.fromMillisecondsSinceEpoch(int.parse(document['timestamp']))),
                style: TextStyle(color: Colors.black54, fontSize: 12.0),
              ),
              margin: EdgeInsets.only(right: 10),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
        ),
      );
    } else {
      // Left (peer message)
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                isLastMessageLeft(index)
                    ? Material(
                  child: CachedNetworkImage(
                    placeholder: (context, url) => Container(
                      child: CircularProgressIndicator(
                        strokeWidth: 1.0,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                      width: 35.0,
                      height: 35.0,
                      padding: EdgeInsets.all(10.0),
                    ),
                    imageUrl: peerAvatar,
                    width: 35.0,
                    height: 35.0,
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(18.0),
                  ),
                  clipBehavior: Clip.hardEdge,
                )
                    : Container(width: 35.0),
                document['type'] == 0
                    ? Container(
                  child: Text(
                    document['content'],
                    style: TextStyle(color: Colors.black),
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: 200.0,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(width: 0.3)),
                  margin: EdgeInsets.only(left: 10.0),
                )
                    : document['type'] == 1
                    ? Container(
                  child: FlatButton(
                    child: Material(
                      child: CachedNetworkImage(
                        placeholder: (context, url) => Container(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                          ),
                          width: 200.0,
                          height: 200.0,
                          padding: EdgeInsets.all(70.0),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Material(
                          child: Image.asset(
                            'images/img_not_available.jpeg',
                            width: 200.0,
                            height: 200.0,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                          clipBehavior: Clip.hardEdge,
                        ),
                        imageUrl: document['content'],
                        width: 200.0,
                        height: 200.0,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      clipBehavior: Clip.hardEdge,
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => FullPhoto(url: document['content'])));
                    },
                    padding: EdgeInsets.all(0),
                  ),
                  margin: EdgeInsets.only(left: 10.0),
                )
                    : Container(
                  child: new Image.asset(
                    'assets/${document['content']}.gif',
                    width: 100.0,
                    height: 100.0,
                    fit: BoxFit.cover,
                  ),
                  margin: EdgeInsets.only(bottom: isLastMessageRight(index) ? 20.0 : 10.0, right: 10.0),
                ),
              ],
            ),

            // Time
            isLastMessageLeft(index)
                ? Container(
              child: Text(
                DateFormat('dd MMM kk:mm')
                    .format(DateTime.fromMillisecondsSinceEpoch(int.parse(document['timestamp']))),
                style: TextStyle(color: Colors.black54, fontSize: 12.0),
              ),
              margin: EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
            )
                : Container()
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }


  bool isLastMessageLeft(int index) {
    if ((index > 0 && listMessage != null && listMessage[index - 1]['idFrom'] == id) || index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 && listMessage != null && listMessage[index - 1]['idFrom'] != id) || index == 0) {
      return true;
    } else {
      return false;
    }
  }


//  Future<bool> onBackPress(){
//    if(isShowSticker){
//      setState(() {
//        isShowSticker= false;
//      });
//    }else{
//      Firestore.instance.collection('users').document(id).updateData({'chattingWith': null});
//      Navigator.pop(context);
//    }
//
//    return Future.value(false);
//  }





  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              //메세지 리스트
              buildListMessage(),

              //스티커
              (isShowSticker ? buildSticker() : Container()),

              //내용입력칸
              buildInput(),
            ],
          ),

          //로딩
          buildLoading()
        ],
      ),
//      onWillPop: onBackPress,
    );
  }

  Widget buildSticker(){
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => onSendMessage('mimi1', 2),
                child: Image.asset(
                  'assets/mimi1.gif',
                  width: 50,
                  height: 50,
                  fit:BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi2', 2),
                child: Image.asset(
                  'assets/mimi2.gif',
                  width: 50,
                  height: 50,
                  fit:BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi3', 2),
                child: Image.asset(
                  'assets/mimi3.gif',
                  width: 50,
                  height: 50,
                  fit:BoxFit.cover,
                ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => onSendMessage('mimi4', 2),
                child: Image.asset(
                  'assets/mimi4.gif',
                  width: 50,
                  height: 50,
                  fit:BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi5', 2),
                child: Image.asset(
                  'assets/mimi5.gif',
                  width: 50,
                  height: 50,
                  fit:BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi6', 2),
                child: Image.asset(
                  'assets/mimi6.gif',
                  width: 50,
                  height: 50,
                  fit:BoxFit.cover,
                ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => onSendMessage('mimi7', 2),
                child: Image.asset(
                  'assets/mimi7.gif',
                  width: 50,
                  height: 50,
                  fit:BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi8', 2),
                child: Image.asset(
                  'assets/mimi8.gif',
                  width: 50,
                  height: 50,
                  fit:BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi9', 2),
                child: Image.asset(
                  'assets/mimi9.gif',
                  width: 50,
                  height: 50,
                  fit:BoxFit.cover,
                ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey, width: 0.5)), color: Colors.white),
      padding: EdgeInsets.all(5),
      height: 180,
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

  Widget buildInput(){
    return Container(
      child: Row(
        children: <Widget>[
          //이미지 전송버튼
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1),
              child: IconButton(
                icon: Icon(Icons.image),
                onPressed: getImage,
                color: Colors.black87,
              ),
            ),
            color: Colors.white,
          ),
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1),
              child: IconButton(
                icon: Icon(Icons.face),
                onPressed: getSticker,
                color: Colors.black87
              ),
            ),
            color: Colors.white,
          ),
          Flexible(
            child: Container(
              child: TextField(
                style: TextStyle(color: Colors.black87, fontSize: 15),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(hintText: 'Type your message', hintStyle: TextStyle(color: Colors.grey)),
                focusNode: focusNode,
              ),
            ),
          ),

          //전송버튼
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: ()=> onSendMessage(textEditingController.text, 0),
                color: Colors.black87,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        border: Border(top:BorderSide(color: Colors.grey, width: 0.5)), color: Colors.white),
    );
  }

  Widget buildListMessage(){
    return Flexible(
      child: groupChatId== ''
          ?Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.pinkAccent)))
          :StreamBuilder(
        stream: Firestore.instance
            .collection('messages')
            .document(groupChatId)
            .collection(groupChatId)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.black87)));
          }else{
            listMessage = snapshot.data.documents;
            return ListView.builder(
              padding: EdgeInsets.all(10),
                itemCount: snapshot.data.documents.length,
                reverse: true,
                controller: listScrollController,
                itemBuilder:(context, index) => buildItem(index, snapshot.data.documents[index]),
            );
          }
        },
      )
    );
  }


}
