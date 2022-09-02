class Hospital {
  final String name;
  final String type;
  final String placeName;
  final LatLng location;
  Hospital({
    required this.name,
    required this.type,
    required this.placeName,
    required this.location,
  });
}

class LatLng {
  final double lat;
  final double lon;
  LatLng({
    required this.lat,
    required this.lon,
  });
}
