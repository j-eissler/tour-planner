class Waypoint {
  final int? id;
  final String address;
  final String city;
  final double? lat;
  final double? long;

  const Waypoint({
    this.id,
    required this.address,
    required this.city,
    this.lat,
    this.long,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'address':address,
      'city': city,
      'lat': lat,
      'long': long
    };
  }

  @override
  String toString() {
    return 'Waypoint{id: $id, address: $address, city: $city, lat: $lat, long: $long}';
  }
}
