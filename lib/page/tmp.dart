

//2번째 최신순

//Firestore.instance.collection('movie').orderBy('time', descending: true).snapshots()

//3번째 인기순

//
//
//Column(
//crossAxisAlignment: CrossAxisAlignment.center,
//children: <Widget>[
//InkWell(
//onTap: () {
//Navigator.push(
//context,
//MaterialPageRoute(
//builder: (context) =>
//REwriteprofile()));
//},
////오른쪽위
//child: Padding(
//padding: EdgeInsets.only(left: 20, top: 0),
//child: Container(
//child: Center(
//child: Text(
//'+ 프로필 사진 수정',
//style: TextStyle(
//fontSize: 15,
//fontWeight: FontWeight.w500,
//fontStyle: prefix0.FontStyle.normal,
//),
//),
//),
////                                width: MediaQuery.of(context).size.width / 3,
////                                height: MediaQuery.of(context).size.height / 25,
////                                decoration: BoxDecoration(
////                                    color: Colors.white,
////                                    border: Border.all(
////                                        color: Colors.black12,
////                                        width: 1.5,
////                                        style: BorderStyle.solid),
////                                    borderRadius:
////                                        BorderRadius.all(Radius.circular(15))),
//),
//),
//),
//Padding(
//padding: EdgeInsets.only(top: 10),
//child: Container(
//height: 1,
//width: MediaQuery.of(context).size.width / 3,
//color: Colors.black26,
//),
//),
//InkWell(
////오른쪽위
//onTap: () {
//Navigator.push(
//context,
//MaterialPageRoute(
//builder: (context) =>
//Rewriteprofile2()));
//},
//child: Padding(
//padding: EdgeInsets.only(left: 20, top: 13),
//child: Container(
//child: Center(
//child: Text(
//'+ 자기소개 수정',
//style: TextStyle(
//fontSize: 15,
//fontWeight: FontWeight.w500,
//fontStyle: prefix0.FontStyle.normal,
//),
//),
//),
////                                width: MediaQuery.of(context).size.width / 3,
////                                height: MediaQuery.of(context).size.height / 25,
////                                decoration: BoxDecoration(
////                                    color: Colors.white,
////                                    border: Border.all(
////                                        color: Colors.black12,
////                                        width: 1.5,
////                                        style: BorderStyle.solid),
////                                    borderRadius:
////                                        BorderRadius.all(Radius.circular(15))),
//),
//),
//),
//],
//),