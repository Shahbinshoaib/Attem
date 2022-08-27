import 'package:flutter/material.dart';
import 'package:ned/screens/authenticate/sign_in.dart';
import 'package:ned/models/user.dart';
import 'package:flutter/services.dart';
import 'package:introduction_screen/introduction_screen.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {


  @override
  Widget build(BuildContext context) {
      return SignIn();
  }
}
