import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class Item {
  String text;
  Image image;
  int key = Random().nextInt(1000000);

  Item(this.text, this.image);

  Item.fromJson(Map<String, dynamic> json)
      : text = json['text'],
        image = Image.memory(
            Uint8List.fromList(json['image'].toString().codeUnits));

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
  }
}
