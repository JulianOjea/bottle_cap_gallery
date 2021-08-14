import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class Item {
  int id;
  String text;
  Uint8List image;

  Item({required this.id, required this.text, required this.image});

/*
  Item.fromJson(Map<String, dynamic> json)
      : text = json['text'],
        image = Image.memory(
            Uint8List.fromList(json['image'].toString().codeUnits));
*/
/*
  Map<String, dynamic> toJson() => {
        'text': text,
        'image': image.toString(),
      };

  String base64String(Uint8List data) {
    return base64Encode(data);
  }

  Image imageFromBase64String(String base64String) {
    return Image.memory(
      base64Decode(base64String),
      fit: BoxFit.fill,
    );
  }*/

  Item.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        text = res["text"],
        image = res["image"];

  Map<String, dynamic> toMap() => {
        'text': text,
        'image': image,
      };
}
