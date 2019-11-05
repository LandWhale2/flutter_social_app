import 'package:flutter/material.dart';


class BlocProvider extends ChangeNotifier{
  int _MenuController = 1;
  int get MenuController => _MenuController;

  set MenuController(int val){
    _MenuController = val;
    notifyListeners();
  }

  select1(){
    _MenuController = 1;
    notifyListeners();
  }

  select2(){
    _MenuController = 2;
    notifyListeners();
  }

}

class ProfileLikeState extends ChangeNotifier{
  bool _LikeState = false;
  bool get LikeState => _LikeState;

  set LikeState(bool val){
    _LikeState = val;
    notifyListeners();
  }

  on(){
    _LikeState = true;
    notifyListeners();
  }

  off(){
    _LikeState = false;
    notifyListeners();
  }
}

class ContextLikeState extends ChangeNotifier{
  bool _LikeState = false;
  bool get LikeState2 => _LikeState;

  set LikeState2(bool val){
    _LikeState = val;
    notifyListeners();
  }
  on2(){
    _LikeState = true;
    notifyListeners();
  }

  off2(){
    _LikeState = false;
    notifyListeners();
  }
}



