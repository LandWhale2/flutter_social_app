import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';

String getAppId(){
  if(Platform.isIOS){
    return 'ca-app-pub-7292179240636476~1459170107';
  }else if(Platform.isAndroid){
    return 'ca-app-pub-7292179240636476~1838799271';
  }
  return null;
}

String getBannerAdUnitId(){
  if(Platform.isIOS){
    return 'ca-app-pub-3940256099942544/2934735716';
  }else if(Platform.isAndroid){
    return 'ca-app-pub-3940256099942544/6300978111';
  }
  return null;
}

//진짜
//ca-app-pub-7292179240636476/5638088260
//테스트
//ca-app-pub-3940256099942544/2934735716



//android
//진짜
//ca-app-pub-7292179240636476/4489013343
//테스트
//	ca-app-pub-3940256099942544/6300978111


class Ads{
  static BannerAd _bannerAd;

  static void initialize(){
    FirebaseAdMob.instance.initialize(appId: getAppId());
  }



  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>['flutterio', 'beautiful apps'],
    contentUrl: 'https://flutter.io',
    childDirected: true,
    nonPersonalizedAds: true,
    designedForFamilies: false,
    gender: MobileAdGender.unknown, // or MobileAdGender.female, MobileAdGender.unknown
    testDevices: <String>[], // Android emulators are considered test devices
  );


  static BannerAd _createBannerAd(){
    return BannerAd(
      adUnitId: getBannerAdUnitId(),
      size: AdSize.banner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event){
        print('BannerAd event $event');
      }
    );
  }

  static void showBannerAd(){
    if(_bannerAd ==null) _bannerAd = _createBannerAd();
    _bannerAd..load()..show(
      anchorOffset: 60,
      anchorType: AnchorType.bottom
    );
  }


  static void hideBannerAd()async{
    await _bannerAd.dispose();
    _bannerAd =null;
  }


//  InterstitialAd myInterstitial = InterstitialAd(
//    // Replace the testAdUnitId with an ad unit id from the AdMob dash.
//    // https://developers.google.com/admob/android/test-ads
//    // https://developers.google.com/admob/ios/test-ads
//    adUnitId: getBannerAdUnitId(),
//    targetingInfo: targetingInfo,
//    listener: (MobileAdEvent event) {
//      print("InterstitialAd event is $event");
//    },
//  );


}