import 'dart:typed_data';

//Entity that represents each bottle cap managed on the collection
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
        brandName = res["brandname"],
        image = res["image"],
        type = res["type"],
        description = res["description"],
        country = res["country"],
        city = res["city"],
        releaseDate = int.parse(res["releasedate"]),
        folder = res["folder"],
        creationDate = DateTime.parse(res["creationdate"]);

  Map<String, dynamic> toMap() => {
        'brandname': brandName,
        'image': image,
        'type': type,
        'description': description,
        'country': country,
        'city': city,
        'releasedate': releaseDate,
        'folder': folder,
        'creationdate': creationDate.toString()
      };
}
