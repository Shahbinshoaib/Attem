import 'package:flutter/material.dart';
import 'package:ned/services/database.dart';
import 'package:provider/provider.dart';
import 'package:ned/models/leaves.dart';
import 'package:ned/models/user.dart';

class NewCourse extends StatefulWidget {


  @override
  _NewCourseState createState() => _NewCourseState();
}

class _NewCourseState extends State<NewCourse> {

  final _formkey = GlobalKey<FormState>();
  final List<String> courseName = [
    'Regular Course',
    'Improvement Course',
    'Backlog Course',
  ];
  final List<int> creditHours = [ 0, 1, 2, 3, 4,5,6,7,8,9,10,11,12,13,14,15,16];

  bool _isButtonDisabled = false;
  String _courseType;
  String _courseName;
  int _creditHours;
  String _courseCode;

  @override
  Widget build(BuildContext context) {
    final courses = Provider.of<List<Course>>(context) ?? [];
    final user = Provider.of<User>(context);


    if(courses.length >= 8){
      setState(() {
        _isButtonDisabled = true;
      });
    }
    return Form(
      key: _formkey,
      child: Column(
        children: <Widget>[
          Text(
            'Add a New Course',
            style: TextStyle(fontSize: 18.0),
          ),
//          SizedBox(height: 20.0,),
          DropdownButtonFormField(
            decoration: InputDecoration(
              labelText: 'Select Course Type',
            ),
            value: _courseType,
            items: courseName.map((courseName) {
              return DropdownMenuItem(
                value: courseName,
                child: Text('$courseName'),
              );
            }).toList(),
            onChanged: (val) {
              setState(() {
                _courseType = val;
              });
            },
          ),
          //dropdown
          TextFormField(
            validator: (val) => val.isEmpty ? 'Enter Course Name' : null,
            onChanged: (val){
              setState(() {
                _courseName = val;
              });
            },
            decoration: InputDecoration(
              labelText: 'Course Name',
            ),
          ),
          TextFormField(
            onChanged: (val){
              setState(() {
                _courseCode = val;
              });
            },
            decoration: InputDecoration(
              labelText: 'Course Code',
            ),
          ),
          DropdownButtonFormField(
            decoration: InputDecoration(
              labelText: 'Allowed Leaves',
            ),
            value: _creditHours,
            items: creditHours.map((creditHours) {
              return DropdownMenuItem(
                value: creditHours,
                child: Text('$creditHours'),

              );
            }).toList(),
            onChanged: (val) {
              setState(() {
                _creditHours = val;
              });
            },
          ),
          SizedBox(height: 10.0,),
          //slider
          RaisedButton(
            elevation: 4.0,
            color: Color(0xFF1a1aff),
            child: Text(
              'Add',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: _isButtonDisabled ? null : () async {
              if (_formkey.currentState.validate()){
                setState(() {
                  _isButtonDisabled = true;
                });
                await DatabaseService(course: _courseName, uid: user.uid, name: user.username, email: user.email ).updateCourseData(_courseName, _courseCode, _creditHours,_courseType,);
                Navigator.pop(context);

              }
            },
          )

        ],
      ),
    );
  }
}

