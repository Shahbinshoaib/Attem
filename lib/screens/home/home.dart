import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:ned/screens/home/about.dart';
import 'package:ned/screens/home/home_widgets.dart';
import 'package:ned/screens/home/settings.dart';
import 'package:ned/screens/profile.dart';
import 'package:ned/services/auth.dart';
import 'package:ned/services/cloudStorageDelete.dart';
import 'package:ned/services/database.dart';
import 'package:provider/provider.dart';
import 'package:ned/models/leaves.dart';
import 'package:ned/models/user.dart';
import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:ned/screens/home/adminPanel.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:url_launcher/url_launcher.dart';


const String testDevice = '';

class NavDrawerExample extends StatefulWidget {

  @override
  _NavDrawerExampleState createState() => _NavDrawerExampleState();
}

class _NavDrawerExampleState extends State<NavDrawerExample> {

  RateMyApp _rateMyApp = RateMyApp (
      preferencesPrefix: 'rateMyApp_pro',
      minDays: 3,
      minLaunches: 7,
      remindDays: 2,
      remindLaunches: 5
  );
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
    else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState(){
    super.initState();
    _rateMyApp.init().then((_){
      if(_rateMyApp.shouldOpenDialog){ //conditions check if user already rated the app
        _rateMyApp.showStarRateDialog(
          context,
          title: 'What do you think about Our App?',
          message: 'Please leave a rating',
          actionsBuilder: (_, stars){
            return [ // Returns a list of actions (that will be shown at the bottom of the dialog).
              FlatButton(
                child: Text('OK'),
                onPressed: () async {
                  print('Thanks for the ' + (stars == null ? '0' : stars.round().toString()) + ' star(s) !');
                  if(stars != null && (stars == 4 || stars == 5)){
                    //if the user stars is equal to 4 or five
                    // you can redirect the use to playstore or                         appstore to enter their reviews
                    _launchURL('https://play.google.com/store/apps/details?id=com.shah.ned');
                  } else {
// else you can redirect the user to a page in your app to tell you how you can make the app better
                  _launchURL('https://forms.gle/p6yXTC8PBknPiJDq7');
                  }
                  // You can handle the result as you want (for instance if the user puts 1 star then open your contact page, if he puts more then open the store page, etc...).
                  // This allows to mimic the behavior of the default "Rate" button. See "Advanced > Broadcasting events" for more information :
                  await _rateMyApp.callEvent(RateMyAppEventType.rateButtonPressed);
                  Navigator.pop<RateMyAppDialogButton>(context, RateMyAppDialogButton.rate);
                },
              ),
            ];
          },
          dialogStyle: DialogStyle(
            titleAlign: TextAlign.center,
            messageAlign: TextAlign.center,
            messagePadding: EdgeInsets.only(bottom: 20.0),
          ),
          starRatingOptions: StarRatingOptions(),
          onDismissed: () => _rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed),
        );
      }
    });
  }


  final AuthService _auth = AuthService();
  final CloudStorageService _cloudStorageService = CloudStorageService();

  final _formkey = GlobalKey<FormState>();
  bool loader = false;

  String _downloadUrl;
  String _adminPassword;
  bool _showPassword = false;

  String _validateName(String value) {
    if (value != 'Myaccount') return 'Access Denied';
  }
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    //
    // SystemChrome.setPreferredOrientations(
    //     [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

    final user = Provider.of<User>(context);
    final adminData = Provider.of<List<UserBioData>>(context) ?? [];

    Future<void> _showlogoutDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Logout'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Are you sure you want to logout?'),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('LOGOUT', style: TextStyle(color: Colors.red),),
                onPressed: () async {
                  await _auth.signOut();
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
    Future<void> _showMyDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Password'),
            content: Form(
              key: _formkey,
              child: TextFormField(
                onChanged: (val){
                    setState(() {
                      _adminPassword = val;
                    });
                },
                validator: (val) => _validateName(val),
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Enter Password',
                  prefixIcon: Icon(Icons.security),
                ),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('SUBMIT'),
                onPressed: () {
                  if(_formkey.currentState.validate()){
                    Navigator.pushReplacement(context, AdminPanel1());
                  }
                },
              ),
            ],
          );
        },
      );
    }


    final drawerHeader = UserAccountsDrawerHeader(
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Color(0xFF000034),
                Color(0xFF1a1aff),
              ])
      ),

      accountName: Text(user.username ?? ' '),
      accountEmail: null,
      currentAccountPicture: CircleAvatar(
        child: Image.asset('assets/bot.gif'),
        backgroundColor: Colors.transparent,
        ),
    );

    return StreamProvider<List<Course>>.value(
    value: DatabaseService(uid: user.uid,email: user.email).courses,
      child: Scaffold(
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
          actions: [
            user.email == 'shahbinshoaib@gmail.com' ? Stack(
              children: [
                IconButton(
                  icon: Icon(Icons.people,color: Colors.white,size: 40.0,),
                  onPressed: (){},
                ),
                adminData.length != 0 ? new Positioned(
                  right: 0,
                  top: 0,
                  child: new Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    constraints: BoxConstraints(
                      minHeight: 14,
                      minWidth: 14,
                    ),
                    child: Text('${adminData.length}',style: TextStyle(color: Colors.white),textAlign: TextAlign.center,),
                  ),
                ) : Container(),
                SizedBox(width: 10.0),
              ],
            ) : Container(),
            SizedBox(width: 20.0,)
          ],
          elevation: 10.0,
          title: Text('Home'),
        ),
           body: HomeWidget(),
            drawer: Container(
              child: Drawer(
                child: Container(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      drawerHeader,
                      ListTile(
                        leading: Icon(Icons.account_circle),
                        title: Text('Profile'),
                        onTap: () {
                          //createInterstitialAd()..load()..show();
                          Navigator.of(context).push(_NewPage1(1));
                          },
                      ),
                      ListTile(
                        leading: Icon(Icons.settings),
                        title: Text('Settings'),
                        onTap: () => Navigator.of(context).push(_NewPage2(2)),
                      ),
                      ListTile(
                        leading: Icon(Icons.exit_to_app),
                        title: Text('Logout'),
                        onTap: () {
                          setState(() {
                            Navigator.pop(context);
                            _showlogoutDialog();
                          });
                        },
                      ),
                      Divider(
                        thickness: 1.0,
                      ),
                      ListTile(
                        leading: Icon(Icons.info),
                        title: Text('About'),
                        onTap: () => Navigator.of(context).push(_NewPage3(3)),
                      ),
                      user.email == 'shahbinshoaib@gmail.com' ?
                      ListTile(
                        leading: Icon(Icons.devices),
                        title: Text('Admin Panel'),
                        onTap: () {
                          setState(() {
                            Navigator.pop(context);
                            _showMyDialog();
                          });
                        },
                      ) : ListTile(),
                    ],
                  ),
                ),
              ),
            ),
    )
    );
  }
}

// <Null> means this route returns nothing.
class _NewPage1 extends MaterialPageRoute<Null> {

  _NewPage1(int id)
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
        elevation: 5.0,
        title: Row(
          children: <Widget>[
            Text('Profile'),
          ],
        ),
      ),
      body: Profile1(),
    );
  });
}

class _NewPage2 extends MaterialPageRoute<Null> {
  _NewPage2(int id)
      : super(builder: (BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamProvider<List<Course>>.value(
    value: DatabaseService(uid: user.uid,email: user.email).courses,
      child: Scaffold(
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
        title: Text('Settings'),
        elevation: 1.0,
      ),
      body: Settings(),
    )
    );
  });
}

class _NewPage3 extends MaterialPageRoute<Null> {
  _NewPage3(int id)
      : super(builder: (BuildContext context) {
    return Scaffold(
      body: About(),
    );
  });
}




class AdminPanel1 extends MaterialPageRoute<Null> {
  AdminPanel1()
      : super(builder: (BuildContext context) {
    return StreamProvider<List<UserBioData>>.value(
      value: DatabaseService().userDataForAdmin,
      child: Scaffold(
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
          title: Text('Admin Panel',),
        ),
        body: AdminPanel(),
      ),
    );
  });
}

