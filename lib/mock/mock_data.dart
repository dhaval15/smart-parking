import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_parking/models/parking_data.dart';
import 'package:smart_parking/ui/parking_info.dart';
import 'dart:math';

List<ParkingData> generatesParking(LatLng location) {
  return [
    ParkingData(
      id: '1',
      name: 'Parking 1',
      rating: 3.4,
      vacantSlots: Random().nextInt(30) + 10,
      location: LatLng(
          location.latitude + deviation(), location.longitude + deviation()),
    ),
    ParkingData(
      rating: 3.7,
      id: '2',
      name: 'Parking 2',
      vacantSlots: Random().nextInt(30) + 10,
      location: LatLng(
          location.latitude - deviation(), location.longitude + deviation()),
    ),
    ParkingData(
      rating: 4.2,
      id: '3',
      name: 'Parking 3',
      vacantSlots: Random().nextInt(30) + 10,
      location: LatLng(
          location.latitude + deviation(), location.longitude - deviation()),
    ),
    ParkingData(
      rating: 4.9,
      id: '4',
      name: 'Parking 4',
      vacantSlots: Random().nextInt(30) + 10,
      location: LatLng(
          location.latitude - deviation(), location.longitude - deviation()),
    ),
  ];
}

double deviation() => (Random().nextInt(3) + 2) / 500;
