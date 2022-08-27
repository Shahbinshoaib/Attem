import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ned/services/database.dart';
import 'package:provider/provider.dart';
import 'package:ned/models/user.dart';

class TextFormFieldExample extends StatefulWidget {
  const TextFormFieldExample({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TextFormFieldExampleState();
}

class _TextFormFieldExampleState extends State<TextFormFieldExample> {
  final _formkey = GlobalKey<FormState>();


  String _name;
  bool _maleGender;
  String _portalID;
  String _enroll;
  String _sem;
  String _criteria;
  String _dept;
  String _uni;
  bool _isButtonDisabled = false;
  bool _isGenderButtonDisabled = false;


  String _validateName(String value) {
    if (value.isEmpty)
      return 'Portal ID is required.';
  }

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);



    bool isEnabled = user.username == null ? true : false ;
    _name = user.username == null ? _name : user.username;

    return StreamBuilder<UserBioData>(
      stream: DatabaseService(uid: user.uid, email: user.email, photo: user.photo).userData,
      builder: (context, snapshot) {
          UserBioData userBioData = snapshot.data;
          _name = userBioData.name;
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(height: 24.0),
                  // "Name" form.
                  TextFormField(
                    enabled: isEnabled,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      icon: Icon(Icons.person),
                      hintText: userBioData.name ?? 'What do people call you?',
                    ),
                    onChanged: (value){
                      setState(() {
                        _name = value;
                      });
                    },
                  ),
                  SizedBox(height: 24.0),
                  // "Email" form.
                  TextFormField(
                    enabled: false,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      icon: Icon(Icons.email),
                      hintText: userBioData.email ?? 'Your email address',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      setState(() {
                      });
                    },
                  ),
                  SizedBox(height: 24.0),
                  // "Name" form.
                  TextFormField(
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      icon: Icon(Icons.assignment_ind),
                      hintText: 'Portal Id',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _portalID = value;
                      });
                    },
                    validator: _validateName,
                  ),
                  SizedBox(height: 24.0),
                  // "Name" form.
                  TextFormField(
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      icon: Icon(Icons.chrome_reader_mode),
                      hintText: 'Enrollment No.',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _enroll = value;
                      });
                    },
                  ),
                  SizedBox(height: 24.0),
                  TextFormField(
                    onChanged: (val){
                      setState(() {
                        _criteria = val;
                      });
                    },
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      icon: Icon(Icons.beenhere),
                      hintText: 'Minimum attendance criteria?',
                      suffixText: '%',
                    ),
                    keyboardType: TextInputType.datetime,

                  ),
                  SizedBox(height: 24.0),
                  TextFormField(
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      icon: Icon(Icons.bookmark),
                      hintText: 'You current Semester?',
                    ),
                    keyboardType: TextInputType.datetime,
                    onChanged: (value) {
                      setState(() {
                        _sem = value;
                      });
                    },
                  ),
                  SizedBox(height: 24.0),
                  TextFormField(
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      icon: Icon(Icons.assistant_photo),
                      hintText:  'Your Department Name?',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _dept = value;
                      });
                    },
                  ),
                  SizedBox(height: 24.0),
                  TextFormField(
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      icon: Icon(Icons.account_balance),
                      hintText: 'Your University Name?',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _uni = value;
                      });
                    },
                  ),
                  SizedBox(height: 24.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: RaisedButton(
                          elevation: 4.0,
                          color: Colors.blue[500],
                          child: Text(
                            'MALE',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: _isGenderButtonDisabled ? null : () async {
                            setState(() {
                              _isGenderButtonDisabled = true;
                              _maleGender = true;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: RaisedButton(
                          elevation: 4.0,
                          color: Colors.pinkAccent,
                          child: Text(
                            'FEMALE',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: _isGenderButtonDisabled ? null : () async {
                            setState(() {
                              _isGenderButtonDisabled = true;
                              _maleGender = false;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 24.0),
                  // "Life story" form.
                  RaisedButton(
                    elevation: 4.0,
                    color: Color(0xFF1a1aff),
                    child: Text(
                      'UPDATE',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: _isButtonDisabled ? null : () async {
                      if (_formkey.currentState.validate()){
                        setState(() {
                          _isButtonDisabled = true;
                        });
                        await DatabaseService(uid: user.uid,email: user.email,photo: user.photo).updateUserBioData(_name,_maleGender, _portalID, _enroll, _criteria, _sem, _dept, _uni);
                        Navigator.pop(context);
                      }
                    },
                  ),
                  SizedBox(height: 24.0),
                  // "Life story" form.
                ],
              ),
            ),
          );
        }
    );
  }
}

