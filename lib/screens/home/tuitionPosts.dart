
//import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:ned/models/user.dart';
import 'package:provider/provider.dart';
import 'package:ned/services/database.dart';


class TuitionPostTile extends StatelessWidget {

  final TuitionData user;
  TuitionPostTile({this.user});





  @override
    Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown
    // ]);

    final users = Provider.of<User>(context);

    Future<void> _showlogoutDialog(String command) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          if(command == 'check'){
            return AlertDialog(
              title: Text('Mark Tuition as Assigned?'),
              content: SingleChildScrollView(
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
                  onPressed: () async {
                    await DatabaseService(datePosted: user.datePosted,postCounter: user.postCounter).updateTutorsData(user.subjects, user.classes, user.location, user.requirement, 'Tutor Assigned', user.gender,);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          } else{
            return AlertDialog(
              title: Text('Delete this Post?'),
              content: SingleChildScrollView(
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
                  onPressed: () async {
                    await DatabaseService().delTutorDocument(user.postCounter);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          }
        },
      );
    }

    double size = MediaQuery.of(context).size.height ;
    double sizew = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Container(
        alignment: Alignment.center,
        height: size*0.50,
        width: size*0.4,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image(image: AssetImage('assets/notes.jpg'),width: sizew*0.9,),
            Container(
              height: size*0.4,
              width: size*0.42,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, size*0.09, 0, 0),
                child: Column(
                  children: [
                    Align(child: Text('Tutor Needed', style: TextStyle(fontWeight: FontWeight.bold,fontSize: size*0.021),),alignment: Alignment.topCenter,),
                    SizedBox(height: size*0.017,),
                    Row(
                      children: [
                        Align(child: Text('Post #           ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: size*0.019),textAlign: TextAlign.left,),alignment: Alignment.topLeft,),
                        Align(child: Text(user.postCounter ?? '-', style: TextStyle(fontSize: size*0.019 )),alignment: Alignment.topLeft,),
                      ],
                    ),
                    SizedBox(height: size*0.009,),
                    Row(
                      children: [
                        Align(child: Text('Class:            ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: size*0.019),textAlign: TextAlign.left,),alignment: Alignment.topLeft,),
                        Align(child: Text(user.classes ?? '-', style: TextStyle(fontSize: size*0.019)),alignment: Alignment.topLeft,),
                      ],
                    ),
                    SizedBox(height: size*0.009,),
                    Row(
                      children: [
                        Align(child: Text('Subjects:      ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: size*0.019),textAlign: TextAlign.left,),alignment: Alignment.topLeft,),
                        Align(child: Text(user.subjects ?? '-', style: TextStyle(fontSize: size*0.019)),alignment: Alignment.topLeft,),
                      ],
                    ),
                    SizedBox(height: size*0.009,),
                    Row(
                      children: [
                        Align(child: Text('Requirement: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: size*0.017),textAlign: TextAlign.left,),alignment: Alignment.topLeft,),
                        Align(child: Text(user.requirement ?? '-', style: TextStyle(fontSize: size*0.017),overflow: TextOverflow.ellipsis,),alignment: Alignment.topLeft,),
                      ],
                    ),
                    SizedBox(height: size*0.009,),
                    Row(
                      children: [
                        Align(child: Text('Tutor:            ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: size*0.019),textAlign: TextAlign.left,),alignment: Alignment.topLeft,),
                        Align(child: Text(user.gender ?? '-', style: TextStyle(fontSize: size*0.019)),alignment: Alignment.topLeft,),
                      ],
                    ),
                    SizedBox(height: size*0.009,),
                    Row(
                      children: [
                        Align(child: Text('Location:      ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: size*0.019),textAlign: TextAlign.left,),alignment: Alignment.topLeft,),
                        Align(child: Text(user.location ?? '-', style: TextStyle(fontSize: size*0.019)),alignment: Alignment.topLeft,),
                      ],
                    ),
                    SizedBox(height: size*0.009,),
                    Row(
                      children: [
                        Align(child: Text('Date Posted: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: size*0.017),textAlign: TextAlign.left,),alignment: Alignment.topLeft,),
                        Align(child: Text(user.datePosted ?? '-', style: TextStyle(fontSize: size*0.019)),alignment: Alignment.topLeft,),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            users.email == 'shahbinshoaib@gmail.com' ?
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding:  EdgeInsets.fromLTRB(0, 0, sizew*0.14, size*0.06),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(Icons.check_box,color: Colors.green,size: size*0.05,),
                          onPressed: (){
                            _showlogoutDialog('check');
                          },
//                          onPressed: () async{
//                            await DatabaseService().delTutorDocument(user.postCounter);
//                          },
                        ),
//                         IconButton(
//                           icon: Icon(Icons.delete,color: Colors.red,size: size*0.05,),
//                           onPressed: (){
//                             _showlogoutDialog('Delete');
//                           },
// //                          onPressed: () async{
// //                            await DatabaseService().delTutorDocument(user.postCounter);
// //                          },
//                         ),
                      ],
                    ),
                  ),
                ) : Container(),
            user.contact == 'Tutor Assigned' ?
                Container(
                  alignment: Alignment.center,
                    height: size*0.3,
                    width: size*0.4,
                  child: Image(
                    image: AssetImage('assets/assign.png' ),
                  )
                )
          : Container(
              alignment: Alignment.bottomRight,
              height: size*0.35,
              width: size*0.41,
              child: FlatButton(
                onPressed: (){
                  FlutterOpenWhatsapp.sendSingleMessage("${user.contact}", "Hello, i am interested to teach ${user.classes} Class of Area ${user.location}");
                },
                splashColor: Colors.grey,
                child: Image.asset('assets/whatsapp.png',height: MediaQuery.of(context).size.height*0.07,),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
