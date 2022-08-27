import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ned/screens/loading.dart';
import 'package:provider/provider.dart';
import 'package:ned/services/auth.dart';
import 'package:ned/models/user.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {


    // SystemChrome.setPreferredOrientations(
    //     [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp,DeviceOrientation.portraitUp,DeviceOrientation.portraitDown]);

    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        title: 'Attem',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),

        home: Loading(),
      ),
    );
  }
}
