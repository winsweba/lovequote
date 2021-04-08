

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lovequotes/WallpaperApp/quote_fullscreen.dart';
import 'package:random_color/random_color.dart';

const String testDevice = '';

class QuoteScreen extends StatefulWidget {

  @override
  _QuoteScreenState createState() => new _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {

  BannerAd _bannerAd;
  InterstitialAd _interstitialAd;
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo();

  BannerAd createBannerAdd() {
    return BannerAd(
        targetingInfo: targetingInfo,
        adUnitId: BannerAd.testAdUnitId,
        size: AdSize.smartBanner,
        listener: (MobileAdEvent event) {
          print('Bnner Event: $event');
        });
  }

  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
        targetingInfo: targetingInfo,
        adUnitId: InterstitialAd.testAdUnitId,
        listener: (MobileAdEvent event) {
          print('interstitial event: $event');
        });
  }

  //  @override
  // void initState() {
  //   super.initState();
  //   FirebaseAdMob.instance.initialize(appId: 'YOUR_APP_ID');
  //   _bannerAd = createBannerAdd()..load();
  //   _interstitialAd = createInterstitialAd()..load();
  //   RewardedVideoAd.instance.load(
  //       adUnitId: RewardedVideoAd.testAdUnitId, targetingInfo: targetingInfo);
  //   RewardedVideoAd.instance.listener =
  //       (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
  //     print('Rewarded event: $event');
  //     if (event == RewardedVideoAdEvent.rewarded) {
  //       setState(() {
  //         _coins += rewardAmount;
  //       });
  //     }
  //   };
  // }

  final RandomColor _randomColor = RandomColor();

  StreamSubscription<QuerySnapshot> subscription;
  List<DocumentSnapshot> quoteList;
  final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection("quote");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    subscription = collectionReference.snapshots().listen((datasnapshot) {
      setState(() {
        quoteList = datasnapshot.docs;
      });
    });

    // _currentScreen();
    // 
    // ADS ADMOB
    
    FirebaseAdMob.instance.initialize(appId: 'ca-app-pub-2635835949649414~7580091406');
    _bannerAd = createBannerAdd()..load();

     _interstitialAd = createInterstitialAd()..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Timer(Duration(seconds: 10), () {
      _bannerAd?.show();
    });

    return new Scaffold(
        appBar: new AppBar(
          elevation: 0.0,
          backgroundColor: _randomColor.randomColor(
                        colorBrightness: ColorBrightness.veryDark
                    ),
                    centerTitle: true,
          title: new Text("Love Quote", style: TextStyle(fontSize: 20.0),),
        ),
        body: quoteList != null
            ? new StaggeredGridView.countBuilder(
                padding: const EdgeInsets.all(8.0),
                crossAxisCount: 4,
                itemCount: quoteList.length,
                itemBuilder: (context, i) {

                  String quote = quoteList[i].get("words");

                  return new Material(
                    color: _randomColor.randomColor(
                      colorBrightness: ColorBrightness.veryLight
                    ),
                    elevation: 8.0,
                    borderRadius:
                        new BorderRadius.all(new Radius.circular(8.0)),
                    child: new InkWell(
                      onTap: () {
                        _bannerAd?.dispose();
                        _bannerAd = null;
                        _interstitialAd?.show();
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                              builder: (context) => new FullScreenQuotePage(quote),
                            ),
                      );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30.0 ),
                        child: Text(quote, textAlign: TextAlign.center,
                        style: TextStyle( fontSize: 20.0, fontWeight: FontWeight.bold, 
                        color: _randomColor.randomColor(
                        colorBrightness: ColorBrightness.veryDark
                    ), ), ),
                      ),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       // Padding(padding: EdgeInsets.only(left: 20)),
                    //       Text(quote, style: TextStyle( fontSize: 18.0, color: _randomColor.randomColor(
                    //   colorBrightness: ColorBrightness.veryDark
                    // ), ),),
                    //     ],),
                    ),
                  );
                },
                staggeredTileBuilder: (i) =>
                    new StaggeredTile.count(2, i.isEven ? 2 : 3),
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
              )
            : new Center(
                child: new CircularProgressIndicator(),
              ));
  }
}
