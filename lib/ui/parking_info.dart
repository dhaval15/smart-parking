import 'package:flutter/material.dart';
import 'package:smart_parking/models/parking_data.dart';
import 'package:smart_parking/pages/booking.dart';
import 'package:smart_parking/ui/style.dart';

class ParkingInfo extends StatefulWidget {
  final ParkingData data;

  const ParkingInfo(this.data);

  @override
  ParkingInfoState createState() => ParkingInfoState();
}

class ParkingInfoState extends State<ParkingInfo> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            leading: CircleAvatar(
              backgroundColor: midColor,
              child: Icon(
                Icons.directions_car,
                color: Colors.white,
              ),
            ),
            title: Text(widget.data.name),
            subtitle: Text('Vacant Slots : ${widget.data.vacantSlots}'),
            trailing: GradButton(
              onPressed: () {
                Navigator.of(context).push(BookAParking.builder(widget.data));
              },
              text: 'BOOK',
            ),
          ),
          /*SizedBox(height: 4),
          GradButton(
            onPressed: () {},
            text:'Directions',
          ),*/
        ],
      ),
    );
  }
}

class GradButton extends StatelessWidget {
  final String text;
  final GestureTapCallback onPressed;

  const GradButton({this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w700,
        ),
      ),
      onPressed: onPressed,
      textColor: midColor,
    );
  }
}
