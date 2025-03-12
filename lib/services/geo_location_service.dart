import 'package:batting_app/services/location_data.dart';
import 'package:batting_app/services/restricted_states.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class GeoLocationService {
  static final GeoLocationService _instance = GeoLocationService._internal();

  factory GeoLocationService() {
    return _instance;
  }

  GeoLocationService._internal();

  Future<bool> checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  Future<LocationData?> getCurrentLocation() async {
    try {
      if (!await checkLocationPermission()) {
        return await getLocationFromIP();
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      return await getLocationDetailsFromCoordinates(
        position.latitude,
        position.longitude,
      );
    } catch (e) {
      return await getLocationFromIP();
    }
  }

  Future<LocationData?> getLocationFromIP() async {
    try {
      final response = await http.get(
        Uri.parse('https://ipapi.co/json/'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return LocationData(
          state: data['region'],
          country: data['country_name'],
          latitude: data['latitude'].toDouble(),
          longitude: data['longitude'].toDouble(),
        );
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<LocationData?> getLocationDetailsFromCoordinates(
      double latitude,
      double longitude,
      ) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=$latitude&longitude=$longitude&localityLanguage=en',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return LocationData(
          state: data['principalSubdivision'],
          country: data['countryName'],
          latitude: latitude,
          longitude: longitude,
        );
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  bool isLocationRestricted(LocationData? locationData) {
    if (locationData == null) return true;

    if (locationData.country != 'India') return true;

    return RestrictedStates.restrictedStates.contains(locationData.state);
  }
}