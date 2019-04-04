import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_parking/models/parking_data.dart';
import 'package:smart_parking/ui/brand.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class BookAParking extends StatefulWidget {
  static builder(ParkingData data) =>
      MaterialPageRoute(builder: (context) => BookAParking(data));
  final ParkingData data;

  const BookAParking(this.data);

  @override
  BookAParkingState createState() => BookAParkingState();
}

class BookAParkingState extends State<BookAParking> with ScaffoldMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: smartBar('Book'),
      body: Container(
        child: Column(
          children: <Widget>[
            Flexible(
              flex: 2,
              child: Card(
                elevation: 5,
                margin: EdgeInsets.all(0),
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: widget.data.location,
                    zoom: 15,
                  ),
                  markers: {
                    Marker(
                      markerId: MarkerId(widget.data.id),
                      position: widget.data.location,
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueOrange),
                    ),
                  },
                ),
              ),
            ),
            Flexible(
              flex: 3,
              child: Stack(
                children: <Widget>[
                  SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                widget.data.name,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  SmoothStarRating(
                                    size: 20,
                                    rating: widget.data.uiRating,
                                    allowHalfRating: true,
                                    borderColor: widget.data.ratingColor,
                                    color: widget.data.ratingColor,
                                  ),
                                  Text(
                                    '(${widget.data.rating})',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Vacant Slots (Four Wheel) : ${widget.data.vacantSlots}',
                            style: TextStyle(color: Colors.black54),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Vacant Slots (Two Wheel) : ${widget.data.vacantSlots - 4}',
                            style: TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Card(
                      elevation: 5,
                      margin: EdgeInsets.all(0),
                      child: Container(
                        color: Colors.green,
                        width: double.infinity,
                        child: FlatButton(
                          child: Text('BOOK NOW'),
                          textColor: Colors.white,
                          onPressed: () {
                            showSnackBar('Yet To Implement');
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

mixin ScaffoldMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void showSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }
}
