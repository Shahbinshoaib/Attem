
import 'dart:convert';
import 'dart:ffi';
import 'dart:ui';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:ned/game/dinoRun.dart';
import 'package:ned/models/leaves.dart';
import 'package:ned/models/user.dart';
import 'package:ned/pocket_library/home_screen.dart';
import 'package:ned/screens/home/addtuition.dart';
import 'package:ned/screens/home/calculator.dart';
import 'package:ned/screens/home/coures_panel.dart';
import 'package:ned/screens/home/new_course.dart';
import 'package:ned/screens/home/timetable.dart';
import 'package:ned/screens/home/tuition_post.dart';
import 'package:ned/services/cloudStorageDelete.dart';
import 'package:ned/services/database.dart';
import 'package:ned/services/loader.dart';
import 'package:provider/provider.dart';
import 'pieChart.dart';
import 'package:timezone/timezone.dart';
import 'package:intl/intl.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key key}) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {

  bool _isRewardedAdReady;
  //
  //
  // static final MobileAdTargetingInfo targetInfo = new MobileAdTargetingInfo(
  //   testDevices: <String> [],
  //   keywords: <String>['library'],
  //   birthday: new DateTime.now(),
  //   childDirected: true,
  // );

  // InterstitialAd _interstitialAd;
  // BannerAd _bannerAd;
  bool loader = false;

  // BannerAd createBannerAd() {
  //   return BannerAd(
  //       adUnitId: 'ca-app-pub-2022933174799210/1534743297',
  //       //Change BannerAd adUnitId with Admob ID
  //       size: AdSize.banner,
  //       targetingInfo: targetInfo,
  //       listener: (MobileAdEvent event) {
  //         print("BannerAd $event");
  //       });
  // }

  // InterstitialAd createInterstitialAd(){
  //   return new InterstitialAd(
  //       adUnitId: 'ca-app-pub-2022933174799210/5644560451',
  //       targetingInfo: targetInfo,
  //       listener: (MobileAdEvent event){
  //         print('Interstitial event : $event');
  //       }
  //   );
  // }


  // // TODO: Implement _loadRewardedAd()
  // void _loadRewardedAd() {
  //   RewardedVideoAd.instance.load(
  //     targetingInfo: targetInfo,
  //     adUnitId: 'ca-app-pub-2022933174799210/8437393062',
  //   );
  // }
  //
  // // TODO: Implement _onRewardedAdEvent()
  // void _onRewardedAdEvent(RewardedVideoAdEvent event,
  //     {String rewardType, int rewardAmount}) {
  //   switch (event) {
  //     case RewardedVideoAdEvent.loaded:
  //       setState(() {
  //         _isRewardedAdReady = true;
  //       });
  //       break;
  //     case RewardedVideoAdEvent.closed:
  //       setState(() {
  //         _isRewardedAdReady = false;
  //       });
  //       _loadRewardedAd();
  //       break;
  //     case RewardedVideoAdEvent.failedToLoad:
  //       setState(() {
  //         _isRewardedAdReady = false;
  //       });
  //       print('Failed to load a rewarded ad');
  //       break;
  //     case RewardedVideoAdEvent.rewarded:
  //       break;
  //     default:
  //     // do nothing
  //   }
  // }
  //

  //
  // @override
  // void initState() {
  //   // TODO: Initialize _isRewardedAdReady
  //   _isRewardedAdReady = false;
  //   // TODO: Set Rewarded Ad event listener
  //   RewardedVideoAd.instance.listener = _onRewardedAdEvent;
  //   // TODO: Load a Rewarded Ad
  //   _loadRewardedAd();
  //   FirebaseAdMob.instance.initialize(appId: 'ca-app-pub-2022933174799210~8534953885');
  //   //Change appId With Admob Id
  //   _bannerAd = createBannerAd()
  //     ..load()
  //     ..show();
  //   super.initState();
  // }


  // Chart configs.
  bool _agree = false;
  bool _animate = true;
  double _arcRatio = 0.2;
  charts.ArcLabelPosition _arcLabelPosition = charts.ArcLabelPosition.outside;
  charts.BehaviorPosition _legendPosition = charts.BehaviorPosition.top;

  final CloudStorageService _cloudStorageService = CloudStorageService();



  @override
  Widget build(BuildContext context) {
    final courses = Provider.of<List<Course>>(context) ?? [];
    final user = Provider.of<User>(context);
    final _colorPalettes =
    charts.MaterialPalette.getOrderedPalettes(courses.length);
    double newHeight = courses.length > 10 ? 200 : 250;

    double size = MediaQuery.of(context).size.height;
    double sizew = MediaQuery.of(context).size.width;

    return StreamBuilder<List<Course>>(
      stream: DatabaseService(email: user.email, uid: user.uid).courses,
      builder: (context, snapshot){

            return loader ? Loader() : ListView(
              padding: const EdgeInsets.all(8),
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(10.0, size*0.030, 10.0, 10.0),
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                              // ignore: prefer_const_literals_to_create_immutables
                              boxShadow: [
                                const BoxShadow(
                                    color: Colors.black12,
                                    offset: Offset(0.0,10.0),
                                    blurRadius: 5.0
                                ),
                                const BoxShadow(
                                  color: Colors.black12,
                                  offset: Offset(0.0, -10.0),
                                  blurRadius: 30.0,
                                )
                              ]
                          ),
                          height: size*0.24,
                          child: courses.length != 0  ? charts.PieChart(
                            // Pie chart can only render one series.
                            /*seriesList=*/ [
                            charts.Series<Course, String>(
                              id: 'Sales-1',
                              colorFn: (_, idx) => _colorPalettes[idx].shadeDefault,
                              domainFn: (Course sales, _) => sales.courseCode,
                              measureFn: (Course sales, _) => sales.leaves,
                              data: courses,
                              // Set a label accessor to control the text of the arc label.
                              labelAccessorFn: (Course row, _) =>
                              '${row.courseCode}: ${row.leaves}',
                            ),
                          ],
                            animate: this._animate,
                            defaultRenderer: charts.ArcRendererConfig(
                              arcRatio: this._arcRatio,
                              arcRendererDecorators: [
                                charts.ArcLabelDecorator(labelPosition: this._arcLabelPosition)
                              ],
                            ),
                            // ignore: prefer_const_literals_to_create_immutables
                            behaviors: [
                              // Add title.

                            ],
                          )
                              : Center(
                            child: Image.asset('assets/bot.gif', height: size*0.15, width: sizew*0.35,),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: sizew*0.02,vertical: size*0.006),
                          child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                            child: Container(width: sizew*0.4,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.0),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black12,
                                        offset: Offset(0.0,10.0),
                                        blurRadius: 5.0
                                    ),
                                    BoxShadow(
                                      color: Colors.black12,
                                      offset: Offset(0.0, -10.0),
                                      blurRadius: 30.0,
                                    )
                                  ]
                              ),
                              height: size*0.15,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Container(
                                    height: size*0.10,
                                    width: size*0.40,
                                    child: RaisedButton(
                                      color: Colors.white,
                                      elevation: 0.0,
                                      child: Image(
                                        image: AssetImage('assets/Atten.png'),
                                       // fit: BoxFit.fill,
                                      ),
                                      onPressed: (){
                                        setState(() {
                                        //  createInterstitialAd()..load()..show();
                                          Navigator.of(context).push(_NewPage9(user.uid,user.email));
                                        //  _bannerAd.dispose();
                                        });
                                      },
                                    ),
                                  ),
                                  Text('Attendance', style: TextStyle(fontSize: size*0.015),),
                                  SizedBox(height: 1.0,)
                                ],
                              )
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: sizew*0.02,vertical: size*0.006),
                          child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                            child: Container(width: sizew*0.425,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.0),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black12,
                                        offset: Offset(0.0,10.0),
                                        blurRadius: 5.0
                                    ),
                                    BoxShadow(
                                      color: Colors.black12,
                                      offset: Offset(0.0, -10.0),
                                      blurRadius: 30.0,
                                    )
                                  ]
                              ),
                              height: size*0.15,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      height: size*0.10,
                                      width: size*0.40,
                                      child: RaisedButton(
                                        color: Colors.white,
                                        elevation: 0.0,
                                        child: Image(
                                          image: AssetImage('assets/time.png'),
                                          // fit: BoxFit.fill,
                                        ),
                                        onPressed: ()async {
                                            //createInterstitialAd()..load()..show();
                                           // Navigator.pop(context);
                                            Loader();
                                            dynamic result = await _cloudStorageService.downloadImage(user.uid);
                                            setState(() {
                                              Navigator.of(context).push(_NewPage4(result,user.uid));
                                            });
                                          },
                                      ),
                                    ),
                                    Text('Timetable', style: TextStyle(fontSize: size*0.015),),
                                    SizedBox(height: 1.0,)
                                  ],
                                )
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: sizew*0.02,vertical: size*0.01),
                          child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                            child: Container(width: sizew*0.425,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.0),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black12,
                                        offset: Offset(0.0,10.0),
                                        blurRadius: 5.0
                                    ),
                                    BoxShadow(
                                      color: Colors.black12,
                                      offset: Offset(0.0, -10.0),
                                      blurRadius: 30.0,
                                    )
                                  ]
                              ),
                              height: size*0.15,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Container(
                                      height: size*0.10,
                                      width: size*0.40,
                                      child: RaisedButton(
                                        color: Colors.white,
                                        elevation: 0.0,

                                        child: Image(
                                          image: AssetImage('assets/librar.png'),
                                          // fit: BoxFit.fill,
                                        ),
                                        onPressed: (){
                                          //createInterstitialAd()..load()..show();
                                          Navigator.of(context).push(_NewPage5());
                                          //_bannerAd?.dispose();
                                        },
                                      ),
                                    ),
                                    Text('Pocket Library', style: TextStyle(fontSize: size*0.015),),
                                    SizedBox(height: 1.0,)
                                  ],
                                )
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: sizew*0.02,vertical: size*0.01),
                          child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                            child: Container(width: sizew*0.425,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.0),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black12,
                                        offset: Offset(0.0,10.0),
                                        blurRadius: 5.0
                                    ),
                                    BoxShadow(
                                      color: Colors.black12,
                                      offset: Offset(0.0, -10.0),
                                      blurRadius: 30.0,
                                    )
                                  ]
                              ),
                              height: size*0.15,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(height: 20.0,),
                                    Container(
                                      height: size*0.075,
                                      width: size*0.40,
                                      child: RaisedButton(
                                        color: Colors.white,
                                        elevation: 0.0,
                                        child: Image(
                                          image: AssetImage('assets/calcu.png'),
                                          // fit: BoxFit.fill,
                                        ),
                                        onPressed: (){
                                         //createInterstitialAd()..load()..show();
                                          Navigator.of(context).push(_NewPage6());
                                         //_bannerAd?.dispose();

                                        },
                                      ),
                                    ),
                                    SizedBox(height: 15.0,),
                                    Text('Calculator', style: TextStyle(fontSize: size*0.015),),
                                    SizedBox(height: 1.0,)
                                  ],
                                )
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: sizew*0.02,vertical: size*0.005),
                          child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                            child: Container(width: sizew*0.425,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.0),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black12,
                                          offset: Offset(0.0,10.0),
                                          blurRadius: 5.0
                                      ),
                                      BoxShadow(
                                        color: Colors.black12,
                                        offset: Offset(0.0, -10.0),
                                        blurRadius: 30.0,
                                      )
                                    ]
                                ),
                                height: size*0.15,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Container(
                                      height: size*0.10,
                                      width: size*0.40,
                                      child: RaisedButton(
                                        color: Colors.white,
                                        elevation: 0.0,
                                        child: Image(
                                          image: AssetImage('assets/dino.png'),
                                          // fit: BoxFit.fill,
                                        ),
                                        onPressed: (){
                                          //createInterstitialAd()..load()..show();
                                          Navigator.of(context).push(_NewPage7());
                                        },
                                      ),
                                    ),
                                    SizedBox(height: 3.0,),
                                    Text('Dino Run', style: TextStyle(fontSize: size*0.015),),
                                    SizedBox(height: 1.0,)
                                  ],
                                )
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: sizew*0.02,vertical: size*0.005),
                          child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                            child: Container(width: sizew*0.425,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.0),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black12,
                                          offset: Offset(0.0,10.0),
                                          blurRadius: 5.0
                                      ),
                                      BoxShadow(
                                        color: Colors.black12,
                                        offset: Offset(0.0, -10.0),
                                        blurRadius: 30.0,
                                      )
                                    ]
                                ),
                                height: size*0.15,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    const SizedBox(height: 5.0,),
                                    Container(
                                      height: size*0.09,
                                      width: size*0.40,
                                      child: RaisedButton(
                                        color: Colors.white,
                                        elevation: 0.0,
                                        child: const Image(
                                          image: AssetImage('assets/teach.png'),
                                          // fit: BoxFit.fill,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            loader = true;
                                           // createInterstitialAd()..load()..show();
                                          });
                                            Navigator.of(context).push(_NewPage8(user.uid,user.email));
                                            //RewardedVideoAd.instance.show();
                                          setState(() {
                                              loader = false;
                                            });
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 2.0,),
                                     Text('Teaching Portal', style: TextStyle(fontSize: size*0.015),),
                                    const SizedBox(height: 1.0,)
                                  ],
                                )
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            );
      },
    );
  }

}

class _NewPage4 extends MaterialPageRoute<Null> {
  _NewPage4(String value, String uid)
      : super(builder: (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                      Color(0xFF000034),
                      Color(0xFF1a1aff)
                  ])
          ),
        ),
        title: Row(
          children: <Widget>[
            Text('Timetable'),
          ],
        ),
      ),
      body:ImagePickerExample(value: value, uid: uid),
    );
  });
}

class _NewPage5 extends MaterialPageRoute<Null> {
  _NewPage5()
      : super(builder: (BuildContext context) {
    return Scaffold(
      body: HomeScreen(),
      //body: Books(),
    );
  });
}
class _NewPage6 extends MaterialPageRoute<Null> {
  _NewPage6()
      : super(builder: (BuildContext context) {
    return Scaffold(
      body: Calculator(),
    );
  });
}
class _NewPage7 extends MaterialPageRoute<Null> {
  _NewPage7()
      : super(builder: (BuildContext context) {
    return Scaffold(
      body: TRexGameWrapper(),
    );
  });
}


class _NewPage8 extends MaterialPageRoute<Null> {
  _NewPage8(String uid, String email)
      : super(builder: (BuildContext context) {

    void _showAddCoursePanel(){
      showDialog(context: context, builder: (BuildContext context) {
        return Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 15.0),
                child: AddTuitions(),
            );
      });
    }
    final users = Provider.of<User>(context);


    return StreamProvider<List<TuitionData>>.value(
      value: DatabaseService().tutorData,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: Text('Teaching Portal'),
          actions: <Widget>[
            FlatButton.icon(
              onPressed: (){
                _showAddCoursePanel();
              },
              icon: Icon(Icons.add, color: Colors.white ,),
              label: Text(''),
            ),
          ],
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              // color: Colors.white,
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                          Color(0xFF000034),
                          Color(0xFF1a1aff)
                    ])
            ),
          ),
        ),
        body: TuitionPost(),
      ),
    );
  });
}


class _NewPage9 extends MaterialPageRoute<Null> {
  _NewPage9(String uid, String email)
      : super(builder: (BuildContext context) {


    void _newCoursePanel(){
      showModalBottomSheet(context: context, builder: (context){
        return StreamProvider<List<Course>>.value(value: DatabaseService(uid: uid, email: email).courses,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
            child: NewCourse(),
          ),
        );

      });
    }

    void _showAddCoursePanel(){
      showDialog(context: context, builder: (BuildContext context) {
        return StreamProvider<List<Course>>.value(
            value: DatabaseService(uid: uid,email: email).courses,
            child: Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 15.0),
                child: CoursePanel()
            )
        );
      });
    }


    return StreamProvider<List<Course>>.value(
      value: DatabaseService(uid: uid, email: email).courses,
      child: Scaffold(
        appBar: AppBar(
          //backgroundColor: Colors.white,
          elevation: 10.0,
          title: Text('Attendance Manager'),
          actions: <Widget>[
            FlatButton.icon(
              onPressed: (){
                _newCoursePanel();
              },
              icon: Icon(Icons.add, color: Colors.white,),
              label: Text(''),
            )
          ],
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              // color: Colors.white,
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                          Color(0xFF000034),
                          Color(0xFF1a1aff)
                    ])
            ),
          ),
        ),
        body: PieChartExample(),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          elevation: 0.0,
          notchMargin: 3.0,
          clipBehavior: Clip.antiAlias,
          child: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                          Color(0xFF000034),
                          Color(0xFF1a1aff)
                    ])
            ),
            height: 50.0,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 10.0,
          backgroundColor: Color(0xFF000034),
          onPressed: ()  {
            _showAddCoursePanel();
          },
              child: const Icon(
                Icons.update,
                color: Colors.white,
                size: 35.0,
              ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  });
}

