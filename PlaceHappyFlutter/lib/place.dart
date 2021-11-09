//classe che mappa nel db la tabelle dei luoghi
class Place {

  final String name;
  final String description;
  final String shortDescr;
  final String address;
  final double latitude;
  final double longitude;
  final String image;

  Place ({

    required this.name,
    required this.description,
    required this.shortDescr,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.image,

  });

  Map<String, dynamic> toMap() {
    return {

      'name': name,
      'description': description,
      'shortDescr': shortDescr,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'image': image,

    };
  }


  @override
  String toString() {
    return 'Place{name: $name, description: $description, shortDescr: $shortDescr, '
        'address: $address, latitude: $latitude, longitude: $longitude, image: $image}';
  }
}