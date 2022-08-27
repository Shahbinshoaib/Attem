import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loader extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: SpinKitWanderingCubes(
          color:   Color(0xFF1a1aff),
          size: 90.0,
        ),
      ),
    );
  }
}
