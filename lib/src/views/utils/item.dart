import 'dart:typed_data';

class Item {
  int id;

  String brandName;
  String type;
  String description;
  String country;
  String city;
  int releaseDate;

  Uint8List image;

  String folder;
  DateTime creationDate;

  Item(
      {required this.id,
      required this.brandName,
      required this.type,
      required this.description,
      required this.country,
      required this.city,
      required this.releaseDate,
      required this.image,
      required this.folder,
      required this.creationDate});

  Item.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        brandName = res["text"],
        image = res["image"],
        type = "",
        description = "",
        country = "",
        city = "",
        releaseDate = -1,
        folder = "",
        creationDate = DateTime.now();

  Map<String, dynamic> toMap() => {
        'text': brandName,
        'image': image,
      };
}
