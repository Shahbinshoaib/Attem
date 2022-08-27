import 'package:flutter/material.dart';
import 'package:ned/models/leaves.dart';
import 'package:ned/screens/home/slider.dart';
import 'package:provider/provider.dart';


class CoursePanel extends StatefulWidget {
  @override
  _CoursePanelState createState() => _CoursePanelState();
}

class _CoursePanelState extends State<CoursePanel> {

  final _formkey = GlobalKey<FormState>();
  String _validateName(String value) {
    String _validateName(String value) {
      if (value.isEmpty)
        return 'Portal ID is required.';
    }
  }

  String _courseName;

  @override
  Widget build(BuildContext context) {

    final courses = Provider.of<List<Course>>(context) ?? [];


    void _newCoursePanel(String courseName){
      showModalBottomSheet(context: context, builder: (context){
        return Container(
          height: 300,
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
          child: SliderBar(courseName: courseName,),
        );
      });
    }


          return AlertDialog(
            title: Text('Update Attendance'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Form(
                    key: _formkey,
                    child: DropdownButtonFormField(
                      validator: _validateName,
                      decoration: InputDecoration(
                        labelText: 'Select Course',
                      ),
                      value: _courseName,
                      items: courses.map((courseName) {
                        return DropdownMenuItem(
                          value: courseName.courseName,
                          child: Text('${courseName.courseName}'),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          _courseName = val;
                        });
                      },
                    ),
                  ),
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
                child: Text('CONFIRM', style: TextStyle(color: Colors.red),),
                onPressed: () {
                  if (_formkey.currentState.validate()){
                    _newCoursePanel(_courseName);
                  }

                },
              ),
            ],
          );

  }
}


