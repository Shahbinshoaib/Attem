import 'package:flutter/material.dart';
import 'package:ned/services/database.dart';
import 'package:provider/provider.dart';
import 'package:ned/models/user.dart';
import 'package:ned/screens/home/UserForAdminTile.dart';

class AdminPanel extends StatefulWidget {
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  @override
  Widget build(BuildContext context) {

    final adminData = Provider.of<List<UserBioData>>(context) ?? [];

    return StreamBuilder<List<UserBioData>>(
      stream: DatabaseService().userDataForAdmin,
      builder: (context, snapshot) {
        return ListView.builder(
            itemCount: adminData.length,
            itemBuilder: (context, index){
              return UserForAdminTile(user: adminData[index]);
            },
          );
      }
    );
  }
}
