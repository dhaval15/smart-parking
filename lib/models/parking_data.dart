import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';

class ParkingData {
  String id;
  String name;
  LatLng location;
  int vacantSlots;
  double rating;

  double get uiRating {
    final r = rating * 2;
    return r.roundToDouble() / 2;
  }

  Color get ratingColor {
    if (rating > 4)
      return Colors.green;
    else if (rating > 3)
      return Colors.orange;
    else if (rating > 2)
      return Colors.deepOrange;
    else
      return Colors.red;
  }

  ParkingData(
      {this.id, this.name, this.location, this.vacantSlots, this.rating = 4.2});
}
