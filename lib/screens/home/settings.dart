import 'package:flutter/material.dart';
import 'package:ned/models/leaves.dart';
import 'package:ned/services/database.dart';
import 'package:provider/provider.dart';
import 'package:ned/models/user.dart';


class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String _courseName;
  final _formkey = GlobalKey<FormState>();


  String _validateName(String value) {
    if (value.isEmpty)
      return 'Portal ID is required.';
  }


  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    final courses = Provider.of<List<Course>>(context) ?? [];


    Future<void> _showDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {

          return AlertDialog(
                  title: Text('Course to remove'),
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
                      child: Text('REMOVE', style: TextStyle(color: Colors.red),),
                      onPressed: () async {
                        if (_formkey.currentState.validate()){
                          await DatabaseService(uid: user.uid, email: user.email).delCourseDocument(_courseName);
                          Navigator.of(context).pop();
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }

                      },
                    ),
                  ],
                );



        },
      );
    }

    return Container(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[

          Card(
            margin: EdgeInsets.all(8.0),
            elevation: 1.0,
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: ListTile(

                leading: Icon(Icons.book),
                title: Text('Remove Course'),
                onTap: () {
                  _showDialog();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
