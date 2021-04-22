import 'dart:async';
import 'package:location/location.dart';
import 'package:mylocation/model/locModel.dart';

class LocationService {
  // Location location = Location();

  // LocationModel currentLocation;

  // StreamController<LocationModel> locationController =
  //     StreamController<LocationModel>.broadcast();

  // Stream<LocationModel> get getStreamDate => locationController.stream;

  // LocationService() {
  //   location.requestPermission().then((locationPermission) {
  //     if (locationPermission == PermissionStatus.granted) {
  //       location.onLocationChanged.listen((locationValue) {
  //         locationController.add(LocationModel(
  //             latitude: locationValue.latitude,
  //             longitude: locationValue.longitude));
  //       });
  //     }
  //   });
  // }
  //
  //
  var location = Location();
  // LocationModel _currentLocation;

  StreamController<LocationModel> _locationController =
      StreamController<LocationModel>.broadcast();
  Stream<LocationModel> get locationStream => _locationController.stream;

  LocationService() {
    location.requestPermission().then((locationPermission) {
      if (locationPermission == PermissionStatus.granted) {
        location.onLocationChanged.listen((locationData) {
          if (locationData != null) {
            _locationController.add(LocationModel(
                latitude: locationData.latitude,
                longitude: locationData.longitude,
                speed: locationData.speed));
          }
        });
      }
    });
  }

  // Future<LocationModel> getLocation() async {
  //   try {
  //     var userLocation = await location.getLocation();
  //     _currentLocation = LocationModel(
  //         latitude: userLocation.latitude, longitude: userLocation.longitude);
  //   } catch (e) {
  //     print("could not get location $e");
  //   }
  //   return _currentLocation;
  // }
}
