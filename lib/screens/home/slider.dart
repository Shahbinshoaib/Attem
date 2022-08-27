import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ned/services/database.dart';
import 'package:ned/services/loader.dart';
import 'package:provider/provider.dart';
import 'package:ned/models/user.dart';

class SliderBar extends StatefulWidget {
  final String courseName;

  const SliderBar({Key key, this.courseName}) : super(key: key);

  @override
  _SliderBarState createState() => _SliderBarState();
}

class _SliderBarState extends State<SliderBar> {

  String _courseType;
  String _coursecode;
  int _leaves;

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    return StreamBuilder<CourseData>(
        stream: DatabaseService(uid: user.uid, course: widget.courseName, email: user.email).courseData,
        builder: (context, snapshot){
        if(snapshot.hasData){
        CourseData courseData = snapshot.data;
        _coursecode = courseData.code;
        _courseType = courseData.type;
        return Column(
          children: <Widget>[
            Text('Update Leaves',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),),
            SizedBox(height: 20.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(courseData.courseName),
                SizedBox(width: 10.0,),
                Text(courseData.code),
                SizedBox(width: 10.0,),
                Text('Remaing Leaves: ${courseData.leaves}'),
              ],
            ),
            SizedBox(height: 55.0,),
            Slider(
              activeColor: Color(0xFF000034),
              inactiveColor: Color(0xFF1a1aff),
              label: '${_leaves ?? courseData.leaves}',
              value:  (_leaves ?? courseData.leaves).toDouble(),
              min: 0.0,
              max: 16.0,
              divisions: 16,
              onChanged: (double value) => setState(() => _leaves = value.round()),
            ),
            SizedBox(height: 20.0,),
            RaisedButton(
              elevation: 4.0,
             color: Color(0xFF1a1aff),
              child: Text(
                'Update',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async{
                await DatabaseService(course:  widget.courseName, uid: user.uid, name: user.username, email: user.email ).updateCourseData(widget.courseName,_coursecode,_leaves,_courseType);
                Navigator.pop(context);
                Navigator.pop(context);

              },
            )
          ],
        );
    }
    else{
      return Loader();
    }
    },
    );
  }
}
