import 'package:bottle_cap_gallery/src/views/utils/item.dart';
import 'package:flutter/material.dart';

class ViewItem extends StatelessWidget {
  final Item item;
  ViewItem(this.item);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListView(children: [
        AppBar(title: Text(item.brandName)),
        Container(
          color: Colors.black,
          child: Image.memory(item.image, fit: BoxFit.fill),
        ),
        Text("Bebida: " + item.type),
        Text("Descripción: " + item.description),
        Text("País: " + item.country),
        Text("Ciudad: " + item.city),
        Text("Año de emisión: " + item.releaseDate.toString()),
        Text("Fecha de creación: " + creationDateToString()),
      ]),
    );
  }

  String creationDateToString() {
    String date = item.creationDate.day.toString() +
        "-" +
        item.creationDate.month.toString() +
        "-" +
        item.creationDate.year.toString() +
        " " +
        item.creationDate.hour.toString() +
        ":" +
        item.creationDate.minute.toString();
    return date;
  }
}
