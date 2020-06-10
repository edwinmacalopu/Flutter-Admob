import 'package:flutter/material.dart';
import 'package:firebase_admob/firebase_admob.dart';

const String testDevice = '63F47217AC8A3EF1F5155741437B614D';
class AdmobHome extends StatefulWidget {
  @override
  _AdmobHomeState createState() => _AdmobHomeState();
}

class _AdmobHomeState extends State<AdmobHome> {
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: testDevice != null ? <String>[testDevice] : null,
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    childDirected: true,
    nonPersonalizedAds: true,
  );
  
  BannerAd _bannerAd;
  NativeAd _nativeAd;
  InterstitialAd _interstitialAd;
  //int _coins = 0;
  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: BannerAd.testAdUnitId,
      size: AdSize.banner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event $event");
      },
    );
  }

  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
      adUnitId: InterstitialAd.testAdUnitId,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("InterstitialAd event $event");
      },
    );
  }

  NativeAd createNativeAd() {
    return NativeAd(
      adUnitId: NativeAd.testAdUnitId,
      factoryId: 'adFactoryExample',
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("$NativeAd event $event");
      },
    );
  }
  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance.initialize(appId: FirebaseAdMob.testAppId);
    _bannerAd = createBannerAd()..load();
    RewardedVideoAd.instance.listener =
        (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      print("RewardedVideoAd event $event");
      if (event == RewardedVideoAdEvent.rewarded) {
        _showMyDialog(context);
        setState(() {
        });
      }      
    };
  }
@override
  void dispose() {
    _bannerAd?.dispose();
    _nativeAd?.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return   Scaffold(
        appBar: AppBar(
          title: Text('Flutter Admob'),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
               Row(
                 crossAxisAlignment: CrossAxisAlignment.center,
                 mainAxisAlignment:MainAxisAlignment.center,
                 children: <Widget>[
                   RaisedButton(
                     color: Colors.blueAccent,
                    child: const Text('SHOW BANNER',style: TextStyle(color: Colors.white),),
                    onPressed: () {
                      _bannerAd ??= createBannerAd();
                      _bannerAd
                        ..load()
                        ..show(anchorOffset: 100.0);
                    }),
                    SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 60,
                      child: RaisedButton(
                       color: Colors.redAccent,
                       child: Icon(Icons.delete_outline,color: Colors.white,),
                      onPressed: () {
                        _bannerAd?.dispose();
                        _bannerAd = null;
                      }),
                    ),
                 ],
               ),
                SizedBox(height: 40),
                 
              RaisedButton(
                color: Colors.purple,
                  child: const Text('LOAD INTERSTITIAL',style: TextStyle(color: Colors.white),),
                  onPressed: () {
                    _interstitialAd?.dispose();
                    _interstitialAd = createInterstitialAd()..load()..show();
                  },
                ),
              SizedBox(height: 40),
                 RaisedButton(
                   color: Colors.green,
                  child: const Text('LOAD AND SHOW REWARDED VIDEO',style: TextStyle(color: Colors.white),),
                  onPressed: () async{
                    RewardedVideoAd.instance.load(
                        adUnitId: RewardedVideoAd.testAdUnitId,
                        targetingInfo: targetingInfo);
                        await Future.delayed(Duration(seconds: 2));                            
                        RewardedVideoAd.instance.show();
                  },
                ),
               
              
            ],
          )
        ),
    );
  }
}

Future<void> _showMyDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Congratulations 🎊 🎉'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[  
              Container(
                  height: 150,
                  width: 150,
                child: Image.asset('assets/image/money.png')
              ) 
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('OK',style: TextStyle(color: Colors.orangeAccent),),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}