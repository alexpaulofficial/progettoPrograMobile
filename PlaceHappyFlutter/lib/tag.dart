class Tag {

  final String tagName;
  final String place;


  Tag ({

    required this.tagName,
    required this.place,


  });

  Map<String, dynamic> toMap() {
    return {

      'tagName': tagName,
      'place': place,


    };
  }


  @override
  String toString() {
    return 'Tag{tagName: $tagName, place: $place}';
  }
}