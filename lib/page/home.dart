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
                padding: EdgeInsets.only(top: 30),
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
                          child: Text(
                            '찾는 장소를 입력해주세요.',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.black38,
                                fontSize: 20,
                                fontFamily: 'NIX'),
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
                padding: EdgeInsets.only(top: 30),
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.5,
                  height: 1,
                  color: Colors.black26,
                ),
              ),
              Stack(
                children: <Widget>[
                  Padding(//큰 네모
                    padding: EdgeInsets.only(top: 30, bottom: 0, left: 15, right: 15),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 1.75,
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
                              backgroundColor: Color.fromRGBO(253, 36, 75, 1)
                            ),
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
                  Positioned(
                      top: 20,
                      bottom: 444,
                      right: 43,
                      child: Container(
                        width: MediaQuery.of(context).size.width/5,
                        height: MediaQuery.of(context).size.height / 27,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(253, 36, 75, 1),
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        child: Text(
                          '인기',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 23,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
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
    return Column(
      children: <Widget>[
        SizedBox(
          height: 30,
        ),
        Row(
          children: <Widget>[
            SizedBox(
              width: 30,
            ),
            ItemBox(imagename: 'assets/homeicon/Bmovie.png', place: '영화관', currentId: currentId,),
            ItemBox(imagename: 'assets/homeicon/Bcoffee.png', place: '카페',currentId: currentId,),
            ItemBox(imagename: 'assets/homeicon/Brest.png', place: '맛집',currentId: currentId,),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          children: <Widget>[
            SizedBox(
              width: 30,
            ),
            ItemBox(imagename: 'assets/homeicon/Bskis.png', place: '스키장',currentId: currentId,),
            ItemBox(imagename: 'assets/homeicon/Bpark.png', place: '놀이동산',currentId: currentId,),
            ItemBox(imagename: 'assets/homeicon/Bgame.png', place: '피시방',currentId: currentId,),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          children: <Widget>[
            SizedBox(
              width: 33,
            ),
            ItemBox(imagename: 'assets/homeicon/BBear.png', place: '술',currentId: currentId,),
            ItemBox(imagename: 'assets/homeicon/Btrip.png', place: '여행',currentId: currentId,),
            ItemBox(imagename: 'assets/homeicon/etc.png', place: '기타',currentId: currentId,),
          ],
        ),
      ],
    );
  }

  Widget areaspace(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Row(
            children: <Widget>[
//              SizedBox(
//                width: 30,
//              ),
              CityItem(),
              CityItem(),
              CityItem(),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: <Widget>[
//              SizedBox(
//                width: 30,
//              ),
              CityItem(),
              CityItem(),
              CityItem(),
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
              CityItem(),
              CityItem(),
              CityItem(),
            ],
          ),
        ],
      ),
    );
  }
}

class ItemBox extends StatelessWidget {
  String imagename, place;
  final String currentId;

  ItemBox({Key key, @required this.imagename, @required this.place, @required this.currentId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 20),
      child: InkWell(
        onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => Board(currentUserId: currentId,)));
        },
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width / 4.5,
              height: MediaQuery.of(context).size.height / 11,
//            decoration: BoxDecoration(
//              color: Colors.black12,
//              border: Border.all(color: Colors.black, width: 1),
//            ),
              child: Image.asset(
                imagename,
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              width: MediaQuery.of(context).size.width / 4.5,
              height: MediaQuery.of(context).size.height / 35,
//            decoration: BoxDecoration(
//              color: Colors.black12,
//              border: Border.all(color: Colors.black, width: 1),
//            ),
              child: Text(
                place,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 20, fontFamily: 'NIX'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CityItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width / 4.1,
        height: MediaQuery.of(context).size.height / 9,
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
            '서울',
            style: TextStyle(
                fontWeight: FontWeight.w600, fontSize: 30, fontFamily: 'NIX'),
          ),
        ),
      ),
    );
  }
}
