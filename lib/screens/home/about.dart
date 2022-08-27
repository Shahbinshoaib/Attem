import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:share/share.dart';
import 'package:package_info/package_info.dart';


class About extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new AboutState();
  }
}

class AboutState extends State<About> {
  static const platform = const MethodChannel('com.eajy.flutterdemo/android');

  static const app_url =
      'https://play.google.com/store/apps/details?id=com.shah.ned';
  static const github_url = 'https://github.com/Eajy/flutter_demo';
  static const me_url = 'https://sites.google.com/view/eajy';
  TextEditingController _controller;



  @override
  void initState() {
    super.initState();
    this._controller = TextEditingController();
  }





  Future<Null> _openInWebview(String url) async {
    if (await url_launcher.canLaunch(url)) {
      Navigator.of(context).push(
        MaterialPageRoute(
          // **Note**: if got "ERR_CLEARTEXT_NOT_PERMITTED", modify
          // AndroidManifest.xml.
          // Cf. https://github.com/flutter/flutter/issues/30368#issuecomment-480300618
          builder: (ctx) => WebviewScaffold(
            initialChild: Center(child: CircularProgressIndicator()),
            url: url,
          ),
        ),
      );
    } else {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('URL $url can not be launched.'),
        ),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    _controller.text = 'www.google.com';
    return new Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  Color(0xFF000034),
                  Color(0xFF1a1aff),

                ])
        ),
        alignment: Alignment.bottomCenter,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 50.0, 20.0, 10.0),
          child: ListView(
            children: <Widget>[
              CircleAvatar(
                child: Image.asset('assets/official.png'),
                backgroundColor: Colors.transparent,
                radius: MediaQuery.of(context).size.height*0.080,
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.020,),
              Center(
                child: Text(
                  'Attem',
                  style: TextStyle(
                    fontFamily: 'Oxanium',
                    fontSize: MediaQuery.of(context).size.height*0.035,
                    color: Colors.grey[200],
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Text(
                      'Version',
                      style: TextStyle(
                        fontFamily: 'Oxanium',
                        fontSize:MediaQuery.of(context).size.height*0.015,
                        color: Colors.grey[200],
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 5.0,),
                  FutureBuilder(
                      future: getVersionNumber(), // The async function we wrote earlier that will be providing the data i.e vers. no
                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) =>	Text(snapshot.hasData ? snapshot.data : "", style: TextStyle(
                        fontFamily: 'Oxanium',
                        fontSize:MediaQuery.of(context).size.height*0.015,
                        color: Colors.grey[200],
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.bold,
                      ),) // The widget using the data
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.020,),
              Center(
                child: Text(
                  'Powered By ELECTROMATES',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height*0.020,
                    color: Colors.grey[300],
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.010,),
              new Divider(color: Colors.grey[700],),
              SizedBox(height: MediaQuery.of(context).size.height*0.005,),
              Text(
                  '   Attem stands for "Attendance Management", allowing students to keep track of their attendance.'
                'This app is unique as it updates attendance on the basis of leaves left in a semester, which makes it easy to maintain attendance and focus on our studies.'
             'Also equipped with tools to get you through the semester with ease that includes timetable, books, etc.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: Colors.grey[300],
                  letterSpacing: 0,
                  wordSpacing: 2.0,
                  fontSize: MediaQuery.of(context).size.height*0.012,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.005,),
              new Divider(color: Colors.grey[700],),
              SizedBox(height: MediaQuery.of(context).size.height*0.005,),
              new ListTile(
                leading: new Image.asset('assets/linkedin.png',height: MediaQuery.of(context).size.height*0.030,width: 30.0,),
                title: new Text('Developer Linkedin Profile', style: TextStyle(color: Colors.grey[200], fontWeight: FontWeight.bold, letterSpacing: 1.0),),
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  this._openInWebview('https://www.linkedin.com/in/shahrukh-shoaib-55724415b?lipi=urn%3Ali%3Apage%3Ad_flagship3_profile_view_base_contact_details%3BQSL3kerDRN6D3QKqiOg8sQ%3D%3D');
                },
              ),
              new ListTile(
                leading: new Image.asset('assets/playstore.png',height: MediaQuery.of(context).size.height*0.030,width: 30.0,),
                title: new Text('Rate on Google Play', style: TextStyle(color: Colors.grey[200],fontWeight: FontWeight.bold, letterSpacing: 1.0),),
                onTap: () {
                  launch(app_url);
                },
              ),
              new ListTile(
                leading: new Icon(Icons.feedback,color: Colors.white,size: MediaQuery.of(context).size.height*0.030,),
                title: new Text('Feedback', style: TextStyle(color: Colors.grey[200],fontWeight: FontWeight.bold, letterSpacing: 1.0),),
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  this._openInWebview('https://docs.google.com/forms/d/e/1FAIpQLSfIfSXdWM3tzxAkVkJfFTPPAAuqczTw_DOKr89yS9KgHnD5Hw/viewform');
                },
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.005,),
              new Divider(color: Colors.grey[700],),
              SizedBox(height: MediaQuery.of(context).size.height*0.005,),
              new ListTile(
                onTap: (){

                },
                title: Column(
                  children: <Widget>[
                    Text(
                      'Developed by MUHAMMAD SHAHRUKH',
                      style: new TextStyle(color: Colors.grey[200], fontSize: MediaQuery.of(context).size.height*0.020, fontWeight: FontWeight.bold, letterSpacing: 1.0),
                    ),
                    SizedBox(height: 5.0,),
                    Text(
                      'Student of Applied Physics, NEDUET',
                      style: new TextStyle(color: Colors.grey[200], fontSize: MediaQuery.of(context).size.height*0.017, fontWeight: FontWeight.bold, letterSpacing: 1.0),
                    ),
                    SizedBox(height: 5.0,),
                    Text(
                      'Co Founder of ELECTROMATES',
                      style: new TextStyle(color: Colors.grey[200], fontSize: MediaQuery.of(context).size.height*0.017, fontWeight: FontWeight.bold, letterSpacing: 1.0),
                    ),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.005,),
              new Divider(color: Colors.grey[700],),
              SizedBox(height: MediaQuery.of(context).size.height*0.005,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'ELECTROMATES ',
                    style: new TextStyle(color: Colors.white70, fontSize: MediaQuery.of(context).size.height*0.018, fontWeight: FontWeight.bold, letterSpacing: 1.0),
                  ),
                  Icon(Icons.copyright, color: Colors.white70,),
                  Text(
                    ' 2020',
                    style: new TextStyle(color: Colors.white70, fontSize: MediaQuery.of(context).size.height*0.018, fontWeight: FontWeight.bold, letterSpacing: 1.0),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        backgroundColor: Color(0xFF000034),
        onPressed: () {
          share(context);
        },
        child: Icon(Icons.share, color: Colors.white,),
      ),
    );
  }

  Future<String> getVersionNumber() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    return version;
  }

  void share(BuildContext context){
    final String text = 'Hey, try Attem for your attendance management: https://play.google.com/store/apps/details?id=com.electromates.attem';
    Share.share(text);
  }
}