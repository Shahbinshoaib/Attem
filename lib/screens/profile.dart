import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ned/services/database.dart';
import 'package:provider/provider.dart';
import 'package:ned/models/user.dart';
import 'package:ned/screens/home/editProfile.dart';

class Profile1 extends StatefulWidget {


  @override
  _Profile1State createState() => _Profile1State();
}

class _Profile1State extends State<Profile1> {

  String _name;
  String _profilePic;
  String _profileMale = 'https://www.pinclipart.com/picdir/middle/355-3553881_stockvader-predicted-adig-user-profile-icon-png-clipart.png';
  String _profileFemale = 'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSNngF0RFPjyGl4ybo78-XYxxeap88Nvsyj1_txm6L4eheH8ZBu&usqp=CAU';
  String _bgPic;
  String _bgPicMale = 'assets/blue.jpg';
  String _bgPicFemale = 'assets/space1.jpg';

  @override
  Widget build(BuildContext context) {


    final user = Provider.of<User>(context);


    return StreamBuilder<UserBioData>(
      stream: DatabaseService(uid: user.uid, email: user.email).userData,
      builder: (context, snapshot) {
       if(snapshot.hasData){
          UserBioData userBioData = snapshot.data;
          _name = userBioData.name;
          _profilePic = userBioData.maleGender == true ? _profileMale : _profileFemale;
          _bgPic = userBioData.maleGender == true ? _bgPicMale : _bgPicFemale;
          return Scaffold(
            body: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(_bgPic),
                        fit: BoxFit.cover
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Padding(
                          padding:
                          const EdgeInsets.fromLTRB(20.0, 70.0, 20.0, 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Center(
                                child: GestureDetector(
                                  child: Hero(
                                    tag: 'my-hero-animation-tag',
                                    child: CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      radius: 70.0,
                                      backgroundImage:
                                      NetworkImage('${user.photo.replaceAll('s96-c', 's400-c')}'  ?? _profilePic),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                user.username ?? _name,
                                style: TextStyle(
                                  color: Colors.grey[200],
                                  letterSpacing: 3.0,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                user.email,
                                style: TextStyle(
                                  color: Colors.grey[200],
                                  letterSpacing: 1.0,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                userBioData.portalID ?? 'Portal id',
                                style: TextStyle(
                                  color: Colors.grey[200],
                                  letterSpacing: 1.0,
                                  fontSize: 16,
                                ),
                              ),

                              SizedBox(
                                height: 50,
                              ),
                              Container(
                                height: 0.8,
                                width: 400.0,
                                color: Colors.grey[700],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Enrollment No.:",
                                    style: TextStyle(
                                      color: Colors.grey[200],
                                      letterSpacing: 1.0,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,

                                    ),),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(5.0, 0, 16, 16),
                                    child: Text(userBioData.enroll ?? 'Enrollment',
                                      style: TextStyle(
                                        color: Colors.grey[200],
                                        fontSize: 16,
                                      ),),
                                  )
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Semester:",
                                    style: TextStyle(
                                      color: Colors.grey[200],
                                      letterSpacing: 1.0,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,

                                    ),),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(5.0, 0, 16, 16),
                                    child: Text(userBioData.sem ?? 'Semester',
                                      style: TextStyle(
                                        color: Colors.grey[200],
                                        fontSize: 16,
                                      ),),
                                  )
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                      "Department:",
                                    style: TextStyle(
                                      color: Colors.grey[200],
                                      letterSpacing: 1.0,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,

                                    ),),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(5.0, 0, 16, 16),
                                    child: Text(userBioData.dept ?? 'Department',
                                      style: TextStyle(
                                        color: Colors.grey[200],
                                        fontSize: 16,
                                      ),),
                                  )
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                      "University:",
                                    style: TextStyle(
                                      color: Colors.grey[200],
                                      letterSpacing: 1.0,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(5.0, 0, 16, 16),
                                    child: Text( userBioData.uni ?? "University",
                                      style: TextStyle(
                                      color: Colors.grey[200],
                                      fontSize: 16,
                                    ),),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.edit),
              elevation: 10.0,
              backgroundColor: Color(0xFF1a1aff),
              onPressed: (){
                Navigator.of(context).push(EditPage());
              },
            ),
          );
      }

       else{
         return Scaffold(
           body: Stack(
             children: <Widget>[
               Container(
                 decoration: BoxDecoration(
                   image: DecorationImage(
                       image: AssetImage('assets/blue.jpg'),
                       fit: BoxFit.cover
                   ),
                 ),
               ),
               SingleChildScrollView(
                 child: Column(
                   children: <Widget>[
                     Container(
                       child: Padding(
                         padding:
                         const EdgeInsets.fromLTRB(20.0, 70.0, 20.0, 10.0),
                         child: Column(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: <Widget>[
                             Center(
                               child: GestureDetector(
                                 child: Hero(
                                   tag: 'my-hero-animation-tag',
                                   child: CircleAvatar(
                                     backgroundColor: Colors.transparent,
                                     radius: 70.0,
                                     backgroundImage:
                                     NetworkImage(user.photo ?? _profileMale),
                                   ),
                                 ),
                               ),
                             ),
                             SizedBox(
                               height: 20,
                             ),
                             Text(
                               user.username ?? 'User Name',
                               style: TextStyle(
                                 color: Colors.grey[200],
                                 letterSpacing: 3.0,
                                 fontSize: 24,
                                 fontWeight: FontWeight.bold,
                               ),
                             ),
                             SizedBox(
                               height: 10,
                             ),
                             Text(
                               user.email,
                               style: TextStyle(
                                 color: Colors.grey[200],
                                 letterSpacing: 1.0,
                                 fontSize: 16,
                               ),
                             ),
                             SizedBox(
                               height: 10,
                             ),
                             Text(
                               'Portal Id',
                               style: TextStyle(
                                 color: Colors.white30,
                                 letterSpacing: 1.0,
                                 fontSize: 16,
                               ),
                             ),
                             SizedBox(
                               height: 50,
                             ),
                             Container(
                               height: 0.8,
                               width: 400.0,
                               color: Colors.grey[700],
                             ),
                             SizedBox(
                               height: 20,
                             ),
                             Row(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: <Widget>[
                                 Text(
                                   "Enrollment No.:",
                                   style: TextStyle(
                                     color: Colors.grey[200],
                                     letterSpacing: 1.0,
                                     fontSize: 17,
                                     fontWeight: FontWeight.bold,

                                   ),),
                                 Padding(
                                   padding: const EdgeInsets.fromLTRB(5.0, 0, 16, 16),
                                   child: Text('Enrollment No.',
                                     style: TextStyle(
                                       color: Colors.white30,
                                       fontSize: 16,
                                     ),),
                                 )
                               ],
                             ),
                             Row(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: <Widget>[
                                 Text(
                                   "Semester:",
                                   style: TextStyle(
                                     color: Colors.grey[200],
                                     letterSpacing: 1.0,
                                     fontSize: 17,
                                     fontWeight: FontWeight.bold,

                                   ),),
                                 Padding(
                                   padding: const EdgeInsets.fromLTRB(5.0, 0, 16, 16),
                                   child: Text('Semester',
                                     style: TextStyle(
                                       color: Colors.white30,
                                       fontSize: 16,
                                     ),),
                                 )
                               ],
                             ),
                             Row(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: <Widget>[
                                 Text(
                                   "Department:",
                                   style: TextStyle(
                                     color: Colors.grey[200],
                                     letterSpacing: 1.0,
                                     fontSize: 17,
                                     fontWeight: FontWeight.bold,

                                   ),),
                                 Padding(
                                   padding: const EdgeInsets.fromLTRB(5.0, 0, 16, 16),
                                   child: Text('Department',
                                     style: TextStyle(
                                       color: Colors.white30,
                                       fontSize: 16,
                                     ),),
                                 )
                               ],
                             ),
                             Row(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: <Widget>[
                                 Text(
                                   "University:",
                                   style: TextStyle(
                                     color: Colors.grey[200],
                                     letterSpacing: 1.0,
                                     fontWeight: FontWeight.bold,
                                     fontSize: 17,
                                   ),),
                                 Padding(
                                   padding: const EdgeInsets.fromLTRB(5.0, 0, 16, 16),
                                   child: Text("University",
                                     style: TextStyle(
                                       color: Colors.white30,
                                       fontSize: 16,
                                     ),),
                                 )
                               ],
                             ),
                           ],
                         ),
                       ),
                     ),
                   ],
                 ),
               ),
             ],
           ),
           floatingActionButton: FloatingActionButton(
             child: Icon(Icons.edit),
             elevation: 10.0,
             backgroundColor: Color(0xFF1a1aff),
             onPressed: (){
               Navigator.of(context).push(EditPage());
             },
           ),
         );
       }

      }
    );
  }
}


// <Null> means this route returns nothing.
class EditPage extends MaterialPageRoute<Null> {

  EditPage()
      : super(builder: (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Color(0xFF000034),
                    Color(0xFF1a1aff)
                  ])
          ),
        ),
        elevation: 5.0,
        title: Row(
          children: <Widget>[
            Text('Edit Profile'),
          ],
        ),
      ),
      body: TextFormFieldExample(),
    );
  });
}