import 'package:flutter/material.dart';
import 'package:smart_parking/ui/brand.dart';
import 'dart:math';

const RUPEE = '\u20B9';

bool _isBike() => Random().nextInt(10) % 3 == 0;

int get _randomNo => Random().nextInt(90) + 10;

int get randomId => Random().nextInt(100000) + 10000;

class PreviousBookings extends StatelessWidget {
  static final builder =
      MaterialPageRoute(builder: (context) => PreviousBookings());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: smartBar('Previous Bookings'),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          child: ListView.builder(
            itemCount: 12,
            itemBuilder: (context, index) => ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(
                      _isBike() ? Icons.directions_bike : Icons.directions_car),
                ),
                title: Text('Parking $_randomNo'),
                subtitle: Text('TransationId : $randomId'),
                trailing: Text('$_randomNo $RUPEE')),
          ),
        ),
      ),
    );
  }
}
