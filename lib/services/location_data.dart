class LocationData {
  final String state;
  final String country;
  final double latitude;
  final double longitude;

  LocationData({
    required this.state,
    required this.country,
    required this.latitude,
    required this.longitude,
  });

  @override
  String toString() {
    return 'LocationData(state: $state, country: $country, latitude: $latitude, longitude: $longitude)';
  }
}