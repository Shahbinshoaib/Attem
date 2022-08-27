import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ned/services/database.dart';
import 'package:provider/provider.dart';
import 'package:ned/models/user.dart';
import 'package:ned/screens/home/tuitionPosts.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';


class TuitionPost extends StatefulWidget {
  @override
  _TuitionPostState createState() => _TuitionPostState();
}

class _TuitionPostState extends State<TuitionPost> {




  @override
  Widget build(BuildContext context) {

    final tutorData = Provider.of<List<TuitionData>>(context) ?? [];

    return StreamBuilder<List<TuitionData>>(
        stream: DatabaseService().tutorData,
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height*0.92,
              child: ListView.builder(
                itemCount: tutorData.length,
                itemBuilder: (context, index){
                  final reversedTutorDat = tutorData.reversed;
                  return TuitionPostTile(user: reversedTutorDat.toList()[index],);
                },
              ),
            );
          }else{
            return Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height*0.9,
              width: MediaQuery.of(context).size.height,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Currently no tuition available',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
              ),
            );
          }
        }
    );
  }
}
