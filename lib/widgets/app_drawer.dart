import '../screens/approval_request_screen.dart';
import '../screens/house_number_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/login_and_signup_screen.dart';
import '../screens/building_screen.dart';

class AppDrawer extends StatelessWidget {
  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      final prefs = await SharedPreferences.getInstance();
      prefs.clear();
      Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
    } catch (e) {
      //print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('ADMIN'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.approval),
            title: Text('Approval Request'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(ApprovalRequestScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              _logout(context);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Building'),
            onTap: () {
              Navigator.of(context).pushNamed(BuildingScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('House Number'),
            onTap: () {
              Navigator.of(context).pushNamed(HouseNumberScreen.routeName);
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}
