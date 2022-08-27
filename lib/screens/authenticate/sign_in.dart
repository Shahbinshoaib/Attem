
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ned/services/auth.dart';
import 'package:flutter/widgets.dart';
import 'package:ned/services/loader.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

class SignIn extends StatefulWidget {

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  bool loader = false;


  //text field state
  String email = '';
  String password = '';
  String error = '';
  String gError = '';

  final kHintTextStyle = TextStyle(
    color: Colors.white54,
    fontFamily: 'OpenSans',
  );

  final kLabelStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontFamily: 'OpenSans',
  );

  final kBoxDecorationStyle = BoxDecoration(
    color: Color(0xFF6CA8F1),
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 6.0,
        offset: Offset(0, 2),
      ),
    ],
  );

  bool _showPassword = false;

  Widget horizontalLine() => Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    child: Container(
      height: 1.0,
      width: 60.0,
      color: Colors.white,
    ),
  );



  Widget _buildLoginBtn() {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(0, 15.0, 0, 0),
          width: MediaQuery.of(context).size.width*0.6,
          child: GoogleSignInButton(
            borderRadius: 50.0,
            splashColor: Color(0xFF0000E1),
            onPressed: () async {
              setState(() {
                loader = true;
              });
              dynamic result = await _auth.signInWithGoogle();
              if (result == null){
                setState(() {
                  gError = 'Could Not Sign In With Google';
                });
              } else{
                Navigator.pop(context);
              }
              setState(() {
                loader = false;
              });
            },
            // darkMode: true, // default: false
          ),
        ),
        SizedBox(height: 10.0,),
        Text(
          gError,
          style: TextStyle(color: Colors.red, fontSize: 14.0),
        ),
      ],
    );
  }

  Widget _buildLoginBtn2() {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(0, 15.0, 0, 0),
          width: MediaQuery.of(context).size.width*0.6,
          child: FacebookSignInButton(
            borderRadius: 50.0,
            splashColor: Color(0xFF0000E1),
            onPressed: () async {
              setState(() {
                loader = true;
              });
              dynamic result = await _auth.signInWithGoogle();
              if (result == null){
                setState(() {
                  gError = 'Could Not Sign In With Google';
                });
              } else{
                Navigator.of(context).pop();
              }
              setState(() {
                loader = false;
              });
            },
            // darkMode: true, // default: false
          ),
        ),
        SizedBox(height: 10.0,),
        Text(
          gError,
          style: TextStyle(color: Colors.red, fontSize: 14.0),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return loader ? Loader() : Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
           height: h,
            width: w,
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: h*0.1547,),
                  Text(
                    'Attem',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: h*0.10,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Oxanium'
                    ),
                  ),
                  SizedBox(height: h*0.004,),
                  Image.asset('assets/bot2.gif', height: h*0.295,),
                  SizedBox(height: h*0.01,),
                  _buildLoginBtn(),
                 // _buildLoginBtn2(),
                  Image.asset('assets/blue3.jpg',width: w,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

