import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  Future<Position> getCurrentLocation() async {
    var status = await Permission.location.status;
    if (status.isDenied) {
      await Permission.location.request();
      status = await Permission.location.status;
    }

    if (status.isPermanentlyDenied) {
      openAppSettings();
      return Future.error('Location permission is permanently denied.');
    }

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location Services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permission is denied.');
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<String> decodeCoordinates(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isEmpty) {
        return 'No location information found for these coordinates.';
      }

      Placemark place = placemarks[0];

      String address = '';
      if (place.thoroughfare != null) {
        address += '${place.thoroughfare}, ';
      }
      if (place.subLocality != null) {
        address += '${place.subLocality}, ';
      }
      if (place.locality != null) {
        address += '${place.locality}, ';
      }
      if (place.administrativeArea != null) {
        address += '${place.administrativeArea}, ';
      }
      if (place.country != null) {
        address += place.country!;
      }
      address = address.trimRight().replaceAll(RegExp(r',\s*$'), '');

      return address.isEmpty ? 'Unknown Location' : address;
    } catch (e) {
      print('Error: $e');
      return 'Error decoding coordinates.';
    }
  }

  Future<String> getCityNameFromCoordinates(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isEmpty) {
        return 'No location information found for these coordinates.';
      }

      Placemark place = placemarks[0];

      return place.locality ?? 'Unknown City';
    } catch (e) {
      print('Error: $e');
      return 'Error decoding coordinates.';
    }
  }
}
