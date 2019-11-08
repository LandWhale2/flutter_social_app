import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:socialapp/base.dart';
import 'package:flutter/material.dart';
import 'package:socialapp/page/signup.dart';
import 'package:socialapp/page/signup.dart' as prefix0;

import 'board.dart';

class Mainhome extends StatefulWidget {
  final String currentId;

  Mainhome({Key key, @required this.currentId}) : super(key: key);

  @override
  MainhomeState createState() => MainhomeState(currentId: currentId);
}

class MainhomeState extends State<Mainhome> {
  final String currentId;

  MainhomeState({Key key, @required this.currentId});

  int _bottomSelectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.3,
                  height: MediaQuery.of(context).size.height / 19,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black38,
                        offset: Offset(4.0, 4.0),
                        blurRadius: 1,
                      ),
                    ],
                    border: Border.all(
                        color: Colors.black87,
                        width: 1,
                        style: BorderStyle.solid),
//                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width / 1.5,
                        height: MediaQuery.of(context).size.height / 19,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              '찾는 장소를 입력해주세요.',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.black54,
//                                fontSize: MediaQuery.of(context).textScaleFactor *15,
                                  fontFamily: 'NIX'),
                            ),
                          ),
                        ),
                      ),
                      Icon(
                        Icons.search,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.5,
                  height: 1,
                  color: Colors.black26,
                ),
              ),
              Stack(
                children: <Widget>[
                  Padding(
                    //큰 네모
                    padding: EdgeInsets.all(15),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 1.65,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black38,
                            offset: Offset(4.0, 4.0),
                            blurRadius: 1,
                          ),
                        ],
                        border: Border.all(
                            color: Colors.black87,
                            width: 1,
                            style: BorderStyle.solid),
//                  borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Scaffold(
                        body: myPageview(),
                        bottomNavigationBar: BottomNavigationBar(
                          type: BottomNavigationBarType.fixed,
                          currentIndex: _bottomSelectedIndex,
                          items: <BottomNavigationBarItem>[
                            BottomNavigationBarItem(
                                icon: Icon(Icons.arrow_back_ios),
                                title: Text(' '),
                                backgroundColor:
                                    Color.fromRGBO(253, 36, 75, 1)),
                            BottomNavigationBarItem(
                              icon: Icon(Icons.arrow_forward_ios),
                              title: Text(' '),
                            ),
                          ],
                          onTap: (index) {
                            _bottomtapped(index);
                          },
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
    );
  }

  PageController _pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  void _bottomtapped(int index) {
    setState(() {
      _bottomSelectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    });
  }

  Widget myPageview() {
    return PageView(
      controller: _pageController,
      onPageChanged: (index) {
        _pageChanged(index);
      },
      children: <Widget>[
        datespace(context),
        areaspace(context),
      ],
    );
  }

  void _pageChanged(int index) {
    setState(() {
      _bottomSelectedIndex = index;
    });
  }

  Widget datespace(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width /25,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height/30,
                ),
                Row(
                  children: <Widget>[
                    ItemBox(
                      imagename: 'assets/homeicon/Bmovie.png',
                      place: '영화관',
                      currentId: currentId,
                      title: '영화관',
                      SelectSpace: 'movie',
                    ),
                    ItemBox(
                      imagename: 'assets/homeicon/Bcoffee.png',
                      place: '카페',
                      currentId: currentId,
                      title: '카페',
                      SelectSpace: 'cafe',
                    ),
                    ItemBox(
                      imagename: 'assets/homeicon/Brest.png',
                      place: '맛집',
                      currentId: currentId,
                      title: '맛집',
                      SelectSpace: 'food',
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: <Widget>[

                    ItemBox(
                      imagename: 'assets/homeicon/Bskis.png',
                      place: '스키장',
                      currentId: currentId,
                      title: '스키장',
                      SelectSpace: 'skis',
                    ),
                    ItemBox(
                      imagename: 'assets/homeicon/Bpark.png',
                      place: '놀이동산',
                      currentId: currentId,
                      title: '놀이동산',
                      SelectSpace: 'park',
                    ),
                    ItemBox(
                      imagename: 'assets/homeicon/Bgame.png',
                      place: '피시방',
                      currentId: currentId,
                      title: '피시방',
                      SelectSpace: 'pcroom',
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: <Widget>[
                    ItemBox(
                      imagename: 'assets/homeicon/BBear.png',
                      place: '술',
                      currentId: currentId,
                      title: '술',
                      SelectSpace: 'liquor',
                    ),
                    ItemBox(
                      imagename: 'assets/homeicon/Btrip.png',
                      place: '여행',
                      currentId: currentId,
                      title: '여행',
                      SelectSpace: 'trip',
                    ),
                    ItemBox(
                      imagename: 'assets/homeicon/etc.png',
                      place: '기타',
                      currentId: currentId,
                      title: '기타',
                      SelectSpace: 'etc',
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget areaspace(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width/15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height/ 40,
                ),
                Row(
                  children: <Widget>[
                    CityItem(currentId: currentId,title: '서울', SelectSpace: 'seoul'),
                    CityItem(currentId: currentId,title: '경기도', SelectSpace: 'gyeonggi'),
                    CityItem(currentId: currentId,title: '부산', SelectSpace: 'busan'),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: <Widget>[
                    CityItem(currentId: currentId,title: '광주', SelectSpace: 'gwangju'),
                    CityItem(currentId: currentId,title: '대전', SelectSpace: 'daejeon'),
                    CityItem(currentId: currentId,title: '경상도', SelectSpace: 'geongsang'),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: <Widget>[
//              SizedBox(
//                width: 33,
//              ),
                    CityItem(currentId: currentId,title: '강원도', SelectSpace: 'gangwon'),
                    CityItem(currentId: currentId,title: '전라도', SelectSpace: 'jeonra'),
                    CityItem(currentId: currentId,title: '제주도', SelectSpace: 'jeju'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ItemBox extends StatelessWidget {
  String imagename, place;
  final String currentId;
  String SelectSpace, title;
  String ww;

  ItemBox(
      {Key key,
      @required this.imagename,
      @required this.place,
      @required this.SelectSpace,
      @required this.currentId,
      @required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 20),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Board(
                        currentUserId: currentId,
                        SelectSpace: SelectSpace,
                        title: title,
                      )));
        },
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width / 5,
              height: MediaQuery.of(context).size.height / 12,
//            decoration: BoxDecoration(
//              color: Colors.black12,
//              border: Border.all(color: Colors.black, width: 1),
//            ),
              child: Image.asset(
                imagename,
                fit: BoxFit.fill,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 4.5,
              height: MediaQuery.of(context).size.height / 30,
//            decoration: BoxDecoration(
//              color: Colors.black12,
//              border: Border.all(color: Colors.black, width: 1),
//            ),

                child: Text(
                  place,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: MediaQuery.of(context).textScaleFactor*18,
                      fontFamily: 'NIX'),
                ),

            ),
          ],
        ),
      ),
    );
  }
}

class CityItem extends StatelessWidget {
  String title, currentId, SelectSpace;

  CityItem(
      {Key key,

      @required this.SelectSpace,
      @required this.currentId,
      @required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: (){
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Board(
                    currentUserId: currentId,
                    SelectSpace: SelectSpace,
                    title: title,
                  )));
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 5,
          height: MediaQuery.of(context).size.height / 10,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black87,
                offset: Offset(4.0, 4.0),
                blurRadius: 1,
              ),
            ],
            border: Border.all(
                color: Colors.black87, width: 3, style: BorderStyle.solid),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.w600, fontSize: MediaQuery.of(context).textScaleFactor*18,
                  fontFamily: 'NIX'),
            ),
          ),
        ),
      ),
    );
  }
}
