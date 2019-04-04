import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_parking/models/parking_data.dart';
import 'package:location/location.dart';
import 'package:smart_parking/ui/brand.dart';
import 'package:smart_parking/ui/parking_info.dart';
import 'package:smart_parking/ui/reporter.dart';
import 'package:smart_parking/mock/mock_data.dart';
import 'package:smart_parking/ui/smart_drawer.dart';

class Home extends StatefulWidget {
  static final builder = MaterialPageRoute(builder: (context) => Home());

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  Future _initialLocation;

  @override
  void initState() {
    super.initState();
    var location = Location();
    _initialLocation = location.onLocationChanged().first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: smartBar('Smart Parking'),
      body: Container(
        color: Colors.white,
        child: FutureBuilder(
          future: _initialLocation,
          builder: (context, snapshot) => snapshot.hasData
              ? _maps(snapshot.data)
              : snapshot.hasError
                  ? Center(child: ErrorTap(error: snapshot.error.toString()))
                  : LoadingSpinner(),
        ),
      ),
      drawer: SmartDrawer(),
    );
  }

  double d = 0.005;

  Widget _maps(data) {
    LatLng location = fromData(data);
    final markers = generatesParking(location)
        .map((p) => Marker(
              markerId: MarkerId(p.id),
              position: p.location,
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueOrange),
              onTap: () {
                _showModal(p);
              },
            ))
        .toSet();
    return Stack(
      children: <Widget>[
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: location,
            zoom: 15.0,
          ),
          myLocationEnabled: true,
          markers: markers,
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _showModal(ParkingData data) {
    showModalBottomSheet(
      context: context,
      builder: (context) => BottomSheet(
            builder: (context) => Padding(
                  padding: EdgeInsets.all(8),
                  child: ParkingInfo(data),
                ),
            onClosing: () {},
          ),
    );
  }
}

LatLng fromData(data) => LatLng(data['latitude'], data['longitude']);
