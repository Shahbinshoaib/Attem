import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ned/models/user.dart';

class UserForAdminTile extends StatelessWidget {

  final UserBioData user;
  UserForAdminTile({this.user});



  @override
  Widget build(BuildContext context) {


    Future<void> _showDialog() async {
      return showDialog<void>(
        context: context,
        //barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: CircleAvatar(
              backgroundColor: Colors.transparent,
              minRadius: 160.0,
              backgroundImage:
              NetworkImage('${user.photo.replaceAll('s96-c', 's400-c')}' ?? 'https://www.pinclipart.com/picdir/middle/355-3553881_stockvader-predicted-adig-user-profile-icon-png-clipart.png',),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(user.name.toUpperCase(),textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold),),
                  SizedBox(height: 10.0,),
                  Text(user.email,textAlign: TextAlign.center,),
                  SizedBox(height: 10.0,),
                  Text(user.uid,textAlign: TextAlign.center,),
                  SizedBox(height: 10.0,),
                  Text('${user.sem}th Semester - ${user.dept}',textAlign: TextAlign.center,),
                  SizedBox(height: 10.0,),
                  Text(user.uni,textAlign: TextAlign.center,),
                ],
              ),
            ),
          );
        },
      );
    }
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 28.0,
            backgroundImage:
            NetworkImage('${user.photo}' ?? 'https://www.pinclipart.com/picdir/middle/355-3553881_stockvader-predicted-adig-user-profile-icon-png-clipart.png'),
          ),
          title: Text('${user.name.toUpperCase()} - ${user.portalID}'),
          subtitle: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text('${user.dept} - ${user.uni}'),
          ),
          trailing: Text('${user.sem}th'),
          isThreeLine: true,
          onTap: (){
            _showDialog();
          },
        ),
        Divider(height: 0.5,)
      ],
    );
  }
}
