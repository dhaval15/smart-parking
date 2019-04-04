import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_parking/pages/notifications.dart';
import 'package:smart_parking/pages/phone_login.dart';
import 'package:smart_parking/pages/prev_bookings.dart';
import 'package:smart_parking/ui/style.dart';
import 'package:smart_parking/ui/user_info.dart';

class SmartDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: midColor,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            UserHeader(),
            Expanded(
              child: Container(
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                      color: Colors.white,
                      child: DrawerItems(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          onTap: () => _notifications(context),
          title: Text('Notifications'),
          trailing: Icon(Icons.notifications),
        ),
        ListTile(
          onTap: () => _previousBookings(context),
          title: Text('Previous Bookings'),
          trailing: Icon(Icons.directions_car),
        ),
        ListTile(
          onTap: () => _logout(context),
          title: Text('Log Out'),
          trailing: Icon(Icons.power_settings_new),
        ),
      ],
    );
  }

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(PhoneAuth.builder);
  }

  _notifications(BuildContext context) {
    Navigator.of(context).push(Notifications.builder);
  }

  _previousBookings(BuildContext context) {
    Navigator.of(context).push(PreviousBookings.builder);
  }
}
