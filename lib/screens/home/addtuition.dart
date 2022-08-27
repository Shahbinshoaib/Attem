import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ned/services/database.dart';
import 'package:jiffy/jiffy.dart';
import 'package:ned/services/loader.dart';
import 'package:provider/provider.dart';
import 'package:ned/models/user.dart';

class AddTuitions extends StatefulWidget {

  @override
  _AddTuitionsState createState() => _AddTuitionsState();
}

class _AddTuitionsState extends State<AddTuitions> {

  Future<void> _showlogoutDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Tuition Submitted'),
            content: SingleChildScrollView(
              child: Text('Your post has been submitted and is pending approval by an admin or moderator.'),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('OK', style: TextStyle(color: Colors.red),),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
      },
    );
  }
  final _formkey = GlobalKey<FormState>();

  final List<String> genderType = [
    'Male',
    'Female',
    'Male & Female',
  ];


  String _subjects;
  String _class;
  String _location;
  String _requirement;
  String _contact;
  String _gender;
  String _postCounter ;

  @override
  Widget build(BuildContext context) {



    final user = Provider.of<User>(context);

    var a = Jiffy().yMMMMd; // October 18, 2019
    print(a);

    if(user.email == 'shahbinshoaib@gmail.com' ){
      return StreamBuilder<List<TuitionData>>(
        stream: DatabaseService().tutorData,
        builder: (context, snapshot){
          if(snapshot.hasData){
            List<TuitionData> tuitionData = snapshot.data;

            _postCounter = (int.parse(tuitionData[83].postCounter)+1).toString();
            _postCounter = ('00'+_postCounter);

            return SingleChildScrollView(
              child: AlertDialog(
                title: Text('Post Tuition'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Form(
                        key: _formkey,
                        child: Column(
                          children: <Widget>[
                            const Text(
                              'Tutor Information',
                              style: TextStyle(fontSize: 18.0),
                            ),
                            // TextFormField(
                            //   validator: (val) => val.isEmpty ? 'Enter Post #' : null,
                            //   textCapitalization: TextCapitalization.words,
                            //   keyboardType: TextInputType.number,
                            //   onChanged: (val){
                            //     setState(() {
                            //       _postCounter = val;
                            //     });
                            //   },
                            //   decoration: InputDecoration(
                            //     labelText: 'Post #',
                            //   ),
                            // ),
                            TextFormField(
                              textCapitalization: TextCapitalization.words,
                              onChanged: (val){
                                setState(() {
                                  _subjects = val;
                                });
                              },
                              decoration: InputDecoration(
                                labelText: 'Subjects',
                              ),
                            ),
                            TextFormField(
                              textCapitalization: TextCapitalization.words,
                              onChanged: (val){
                                setState(() {
                                  _class = val;
                                });
                              },
                              decoration: InputDecoration(
                                labelText: 'Class',
                              ),
                            ),
                            TextFormField(
                              textCapitalization: TextCapitalization.words,
                              onChanged: (val){
                                setState(() {
                                  _location = val;
                                });
                              },
                              decoration: InputDecoration(
                                labelText: 'Location',
                              ),
                            ),
                            TextFormField(
                              textCapitalization: TextCapitalization.words,
                              onChanged: (val){
                                setState(() {
                                  _requirement = val;
                                });
                              },
                              decoration: InputDecoration(
                                labelText: 'Requirement',
                              ),
                            ),
                            TextFormField(
                              textCapitalization: TextCapitalization.words,
                              keyboardType: TextInputType.phone,
                              onChanged: (val){
                                setState(() {
                                  _contact = val;
                                });
                              },
                              decoration: InputDecoration(
                                labelText: 'Contact No. (92)',
                              ),
                            ),
                            DropdownButtonFormField(
                              decoration: const InputDecoration(
                                labelText: 'Required Gender',
                              ),
                              value: _gender,
                              items: genderType.map((courseName) {
                                return DropdownMenuItem(
                                  value: courseName,
                                  child: Text('$courseName'),
                                );
                              }).toList(),
                              onChanged: (val) {
                                setState(() {
                                  _gender = val;
                                });
                              },
                            ),
                          ],
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
                    child: Text('POST', style: TextStyle(color: Colors.red),),
                    onPressed: ()async {
                      if (_formkey.currentState.validate()){
                        await DatabaseService(datePosted: a,postCounter: _postCounter).updateTutorsData(_subjects, _class, _location, _requirement, _contact, _gender,);
                        await DatabaseService().delTutorDocument(tuitionData[0].postCounter);
                        print(tuitionData[0].postCounter);
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              ),
            );
          }else{
            return Loader();
          }
        },
      );
    } else{
      return SingleChildScrollView(
        child: AlertDialog(
          title: Text('Want a Tutor?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Form(
                  key: _formkey,
                  child: Column(
                    children: <Widget>[
                      const Text(
                        'Tutor Requirement',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      TextFormField(
                        textCapitalization: TextCapitalization.words,
                        onChanged: (val){
                          setState(() {
                            _subjects = val;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Subjects',
                        ),
                      ),
                      TextFormField(
                        textCapitalization: TextCapitalization.words,
                        onChanged: (val){
                          setState(() {
                            _class = val;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Class',
                        ),
                      ),
                      TextFormField(
                        textCapitalization: TextCapitalization.words,
                        onChanged: (val){
                          setState(() {
                            _location = val;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Location',
                        ),
                      ),
                      TextFormField(
                        textCapitalization: TextCapitalization.words,
                        onChanged: (val){
                          setState(() {
                            _requirement = val;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Fee',
                        ),
                      ),
                      TextFormField(
                        textCapitalization: TextCapitalization.words,
                        validator: (val) => val.isEmpty ? 'Enter your contact' : null,
                        onChanged: (val){
                          setState(() {
                            _contact = val;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Your Contact No.',
                        ),
                      ),
                      DropdownButtonFormField(
                        decoration: const InputDecoration(
                          labelText: 'Required Gender',
                        ),
                        value: _gender,
                        items: genderType.map((courseName) {
                          return DropdownMenuItem(
                            value: courseName,
                            child: Text('$courseName'),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            _gender = val;
                          });
                        },
                      ),
                    ],
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
              child: Text('POST', style: TextStyle(color: Colors.red),),
              onPressed: ()async {
                if (_formkey.currentState.validate()){
                  await DatabaseService(datePosted: a,email: user.email,name: user.username).updateParentPostData(_subjects, _class, _location, _requirement, _contact, _gender,);
                  Navigator.pop(context);
                  _showlogoutDialog();
                }
              },
            ),
          ],
        ),
      );
    }
  }
}


